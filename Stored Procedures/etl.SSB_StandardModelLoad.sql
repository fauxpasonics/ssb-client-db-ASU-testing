SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[SSB_StandardModelLoad]
(
	@BatchId NVARCHAR(50),
	@Target VARCHAR(255),
	@Source VARCHAR(255),
	@BusinessKey VARCHAR(255),
	@SourceSystem VARCHAR(255),
	@Options NVARCHAR(MAX) = NULL
)

AS
BEGIN

/**************************************Comments***************************************
**************************************************************************************
Mod #:		1
Name:		ssbcloud\zfrick
Date:		04/17/2016
Comments:	Dynamically generates and executes standard SSB Merge from source table to destination table.

*************************************************************************************/

DECLARE
     @SQL VARCHAR(MAX),
	 @SQL2 VARCHAR(MAX),
	 @SQL3 VARCHAR(MAX)

DECLARE @JoinString varchar(MAX)

DECLARE @ResetDeltaHashKey bit = 0
DECLARE @Debug bit = 0

DECLARE @OptionsXML XML = TRY_CAST(@Options AS XML)

SELECT @ResetDeltaHashKey = CAST(CASE WHEN t.x.value('ResetDeltaHashKey[1]','nvarchar(50)') = 'true' THEN 1 ELSE 0 END AS BIT)
, @Debug = CAST(CASE WHEN t.x.value('Debug[1]','nvarchar(50)') = 'true' THEN 1 ELSE 0 END AS BIT)
FROM @OptionsXML.nodes('options') t(x)

SELECT *
INTO #SourceColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = PARSENAME(@Source, 2) AND TABLE_NAME = PARSENAME(@Source, 1)

SELECT *
INTO #TargetColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = PARSENAME(@Target, 2) AND TABLE_NAME = PARSENAME(@Target, 1)


SELECT t.*
INTO #SharedColumns
FROM #SourceColumns s
INNER JOIN #TargetColumns t ON s.COLUMN_NAME = t.COLUMN_NAME
--WHERE ISNULL(s.COLUMN_NAME,'') NOT LIKE 'ETL__%'
--AND ISNULL(t.COLUMN_NAME,'') NOT LIKE 'ETL__%'


DECLARE @ColString AS VARCHAR(MAX) = ''

SELECT @ColString = @ColString + '' +
CASE
	WHEN DATA_TYPE IN ('bit') THEN 'TRY_CAST([' + COLUMN_NAME + '] AS ' + DATA_TYPE + ') [' + COLUMN_NAME + ']'
	WHEN DATA_TYPE like '%int%' THEN 'TRY_CAST([' + COLUMN_NAME + '] AS DECIMAL(19,0)) [' + COLUMN_NAME + ']'
	WHEN DATA_TYPE IN ('decimal', 'numeric') THEN 'TRY_CAST([' + COLUMN_NAME + '] AS ' + DATA_TYPE + '(18,6)) [' + COLUMN_NAME + ']'
	WHEN DATA_TYPE IN ('date', 'datetime', 'datetime2', 'time')	THEN 'TRY_CAST([' + COLUMN_NAME + '] AS ' + DATA_TYPE + ') [' + COLUMN_NAME + ']'
	ELSE '[' + COLUMN_NAME + ']'
END + ', '
FROM #SharedColumns

SET @ColString = left(@ColString, LEN(@ColString) - 1)


DECLARE @DeltaHashKeySyntax AS VARCHAR(MAX) = ''

	SELECT @DeltaHashKeySyntax = @DeltaHashKeySyntax +
	CASE DATA_TYPE 
	WHEN 'int' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),[' + COLUMN_NAME + '])),''DBNULL_INT'')'
	WHEN 'bigint' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),[' + COLUMN_NAME + '])),''DBNULL_BIGINT'')'
	WHEN 'datetime' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),[' + COLUMN_NAME + '])),''DBNULL_DATETIME'')'  
	WHEN 'datetime2' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),[' + COLUMN_NAME + '])),''DBNULL_DATETIME'')'
	WHEN 'date' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),[' + COLUMN_NAME + '],112)),''DBNULL_DATE'')' 
	WHEN 'bit' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),[' + COLUMN_NAME + '])),''DBNULL_BIT'')'  
	WHEN 'decimal' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),['+ COLUMN_NAME + '])),''DBNULL_NUMBER'')' 
	WHEN 'numeric' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),['+ COLUMN_NAME + '])),''DBNULL_NUMBER'')' 
	ELSE 'ISNULL(RTRIM([' + COLUMN_NAME + ']),''DBNULL_TEXT'')'
	END + ' COLLATE SQL_Latin1_General_CP1_CS_AS + '
	FROM #SharedColumns
	WHERE ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) >= 0
	ORDER BY COLUMN_NAME

SET @DeltaHashKeySyntax = 'HASHBYTES(''sha2_256'', ' + LEFT(@DeltaHashKeySyntax, (LEN(@DeltaHashKeySyntax) - 2)) + ')'


IF (ISNULL(@JoinString,'') = '')
BEGIN

SET @JoinString = 
	(
		SELECT STUFF ((
        SELECT ' AND ' + match  
        FROM
		(
			select 
			CASE 
				WHEN c.DATA_TYPE LIKE '%CHAR%' THEN 'ISNULL(t.[' + a.Item + '], ''DBNULL'') = ISNULL(s.[' + a.Item + '], ''DBNULL'')'
				WHEN c.NUMERIC_PRECISION IS NOT NULL THEN 'ISNULL(t.[' + a.Item + '], ''-987'') = ISNULL(s.[' + a.Item + '], ''-987'')'
				WHEN c.DATA_TYPE LIKE '%BIT%' THEN 'ISNULL(t.[' + a.Item + '], ''0'') = ISNULL(s.[' + a.Item + '], ''0'')'
				WHEN c.DATA_TYPE LIKE '%DATE%' THEN 'ISNULL(t.[' + a.Item + '], ''1900-01-01'') = ISNULL(s.[' + a.Item + '], ''1900-01-01'')'
				ELSE 't.[' + a.Item + '] = s.[' + a.Item + ']'
			END match
			from dbo.Split (@BusinessKey, ',') a 
			INNER JOIN INFORMATION_SCHEMA.COLUMNS c ON PARSENAME(@Target, 2) = c.TABLE_SCHEMA AND PARSENAME(@Target, 1) = c.TABLE_NAME
			AND a.Item = c.COLUMN_NAME
		)	x	
        FOR XML PATH('')), 1, 5, '')
	)


END


DECLARE @SqlStringMax AS VARCHAR(MAX) = ''
	
SELECT @SqlStringMax = @sqlStringMax + 'OR ISNULL(s.[' + COLUMN_NAME + '],'''') <> ' + 'ISNULL(t.[' + COLUMN_NAME + '],'''') '
FROM #SharedColumns	
WHERE ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) < 0

DECLARE @SchemaName  AS VARCHAR(255) = [dbo].[fnGetValueFromDelimitedString](@Source, '.' ,1)
DECLARE @Table AS VARCHAR(255) = [dbo].[fnGetValueFromDelimitedString](@Source, '.' ,2)


	
SELECT @SQL = 
'
DECLARE @RunTime DATETIME = GETDATE()

DECLARE @BatchId NVARCHAR(50) = ''' + @BatchId + ''';
DECLARE @SourceSystem NVARCHAR(50) = ''' + @SourceSystem + ''';
DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @EventSource nvarchar(255) = ''ProcessStandardMerge_' + @Target + '''
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ' + @Source + '),''0'');	
DECLARE @SrcDataSize NVARCHAR(255) = ''0'';
DECLARE @Client NVARCHAR(255) = (SELECT ISNULL(etl.fnGetClientSetting(''ClientName''), DB_NAME()));

/*Load Options into a temp table*/
--SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, ''='', '';'')

--DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = ''DisableDelete''),''true'')

BEGIN TRY 

PRINT ''Execution Id: '' + CONVERT(NVARCHAR(100),@ExecutionId)


SELECT ROW_NUMBER() OVER(ORDER BY ' + @BusinessKey + ') RowIndex
, * 
INTO #data
FROM ' + @Source + '

CREATE NONCLUSTERED INDEX IDX_RowIndex ON #data (RowIndex)

DECLARE @RecordCount INT = (SELECT COUNT(*) FROM #data)
DECLARE @StartIndex INT = 1, @PageCount INT = 1000000
DECLARE @EndIndex INT = (@StartIndex + @PageCount - 1)

WHILE @StartIndex <= @RecordCount
BEGIN

SELECT CAST(NULL AS BINARY(32)) ETL__DeltaHashKey
, ' + @ColString + '
INTO #SrcData
FROM #data
WHERE RowIndex BETWEEN @StartIndex AND @EndIndex


UPDATE #SrcData
SET ETL__DeltaHashKey = ' + @DeltaHashKeySyntax + '


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (' + @BusinessKey + ')
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL__DeltaHashKey)

'

 + CASE WHEN @ResetDeltaHashKey = 1 THEN '

UPDATE t
SET t.ETL__DeltaHashKey = s.ETL__DeltaHashKey
FROM ' + @Target + ' t
INNER JOIN #SrcData s ON ' + @JoinString + '

' ELSE '' END + '
';

-------------------------------------------------------------------------------------------------

SELECT @SQL2 = 
'
MERGE ' + @Target + ' AS t

USING #SrcData s
    
	ON t.ETL__SourceSystem = @SourceSystem AND ' + @JoinString + '

WHEN MATCHED AND (
		
		ISNULL(s.ETL__DeltaHashKey,-1) <> ISNULL(t.ETL__DeltaHashKey, -1)		
	 ' + @SqlStringMax + '
)
THEN UPDATE SET
     t.[ETL__UpdatedDate] = GETDATE()
	 , t.[ETL__IsDeleted] = 0
     , t.[ETL__DeltaHashKey] = s.[ETL__DeltaHashKey]
     , ' +
          STUFF ((
                    SELECT ',t.[' + COLUMN_NAME + '] = s.[' + COLUMN_NAME + ']' + CHAR(10) + '     '                           
						FROM #SharedColumns
						WHERE COLUMN_NAME NOT LIKE 'ETL__%'
						ORDER BY ORDINAL_POSITION
                    FOR XML PATH('')), 1, 1, '')  + '

';
-------------------------------------------------------------------------------------------------

SELECT @SQL3 = 
'WHEN NOT MATCHED BY Target
THEN INSERT
     (
		ETL__SourceSystem
		, ETL__CreatedDate
		, ETL__UpdatedDate
		, ETL__IsDeleted
		, ETL__DeltaHashKey
	 , ' + 
          STUFF ((
                    SELECT ',[' + COLUMN_NAME + ']' + CHAR(10) + '     '
					FROM #SharedColumns					
					ORDER BY ORDINAL_POSITION
                    FOR XML PATH('')), 1, 1, '') + ')
VALUES
     (
		@SourceSystem		
		, GETDATE() --ETL__CreatedDate
		, GETDATE() --ETL__UpdatedDate
		, 0 --ETL__IsDeleted
		, s.ETL__DeltaHashKey	
	 , ' + 
          STUFF ((
                    SELECT ',s.[' + COLUMN_NAME + ']' + CHAR(10) + '     '
					FROM #SharedColumns					
					ORDER BY ORDINAL_POSITION
                    FOR XML PATH('')), 1, 1, '') + ')
;

DROP TABLE #SrcData

SET @StartIndex = @EndIndex + 1
SET @EndIndex = @EndIndex + @PageCount

END --End Of Paging Loop


DROP TABLE #data

END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH


'
DECLARE @Full_SQL NVARCHAR(MAX) = @SQL + @SQL2 + @SQL3;


IF (@Debug = 1)
BEGIN

	SELECT @Full_SQL

END
ELSE BEGIN

	EXEC (@Full_SQL)

END


END


GO
