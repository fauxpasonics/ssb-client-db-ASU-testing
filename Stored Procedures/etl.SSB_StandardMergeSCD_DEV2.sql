SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[SSB_StandardMergeSCD_DEV2]
(
	@BatchId NVARCHAR(50) = '00000000-0000-0000-0000-000000000000',
	@Target VARCHAR(256),
	@Source VARCHAR(256),
	@BusinessKey VARCHAR(256),
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
	 @SQL3 VARCHAR(MAX),
	 @SQL4 VARCHAR(MAX)


DECLARE @JoinString varchar(2000)

DECLARE @Debug bit = 0
DECLARE @ConvertBlanksToNull bit = 0
DECLARE @LoadArchiveTable bit = 0
DECLARE @ArchiveTableName NVARCHAR(255)
DECLARE @DedupeStage bit = 0
DECLARE @DedupeSortPriority NVARCHAR(255)
DECLARE @PartitionedKeyDelete bit = 0
DECLARE @PartitionedKey NVARCHAR(255)
DECLARE @FullLoadWithDelete bit = 0
DECLARE @ManualMapping varchar(2000)
DECLARE @SourceFilter varchar(2000)


DECLARE @OptionsXML XML = TRY_CAST(@Options AS XML)

SELECT @LoadArchiveTable = CAST(CASE WHEN t.x.value('LoadArchiveTable[1]','nvarchar(50)') = 'true' THEN 1 ELSE 0 END AS BIT)
, @ArchiveTableName = t.x.value('ArchiveTableName[1]','nvarchar(255)')
, @DedupeStage = CAST(CASE WHEN t.x.value('DedupeStage[1]','nvarchar(50)') = 'true' THEN 1 ELSE 0 END AS BIT)
, @DedupeSortPriority = t.x.value('DedupeSortPriority[1]','nvarchar(255)')
, @PartitionedKeyDelete = CAST(CASE WHEN t.x.value('PartitionedKeyDelete[1]','nvarchar(50)') = 'true' THEN 1 ELSE 0 END AS BIT)
, @PartitionedKey = t.x.value('PartitionedKey[1]','nvarchar(255)')
, @FullLoadWithDelete = CAST(CASE WHEN t.x.value('FullLoadWithDelete[1]','nvarchar(50)') = 'true' THEN 1 ELSE 0 END AS BIT)
, @JoinString = t.x.value('JoinString[1]','nvarchar(2000)')
, @Debug = CAST(CASE WHEN t.x.value('Debug[1]','nvarchar(50)') = 'true' THEN 1 ELSE 0 END AS BIT)
, @ManualMapping = t.x.value('ManualMapping[1]','nvarchar(2000)')
, @SourceFilter = t.x.value('SourceFilter[1]','nvarchar(2000)')
FROM @OptionsXML.nodes('options') t(x)

PRINT @SourceFilter

SELECT *
INTO #SourceColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = PARSENAME(@Source, 2) AND TABLE_NAME = PARSENAME(@Source, 1)

SELECT *
INTO #TargetColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = PARSENAME(@Target, 2) AND TABLE_NAME = PARSENAME(@Target, 1)

SELECT *
INTO #ArchiveColumns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = PARSENAME(@ArchiveTableName, 2) AND TABLE_NAME = PARSENAME(@ArchiveTableName, 1)


SELECT t.*
INTO #SharedColumns
FROM #SourceColumns s
INNER JOIN #TargetColumns t ON s.COLUMN_NAME = t.COLUMN_NAME
WHERE ISNULL(s.COLUMN_NAME,'') NOT IN ('ETL__ID', 'ETL__CreatedDate', 'ETL__StartDate', 'ETL__EndDate', 'ETL__DeltaHashKey')
AND ISNULL(t.COLUMN_NAME,'') NOT IN ('ETL__ID', 'ETL__CreatedDate', 'ETL__StartDate', 'ETL__EndDate', 'ETL__DeltaHashKey')


SELECT t.*
INTO #SharedColumnsArchive
FROM #SourceColumns s
INNER JOIN #ArchiveColumns t ON s.COLUMN_NAME = t.COLUMN_NAME
WHERE ISNULL(s.COLUMN_NAME,'') NOT IN ('ETL__ID', 'ETL__CreatedDate', 'ETL__StartDate', 'ETL__EndDate', 'ETL__DeltaHashKey')
AND ISNULL(t.COLUMN_NAME,'') NOT IN ('ETL__ID', 'ETL__CreatedDate', 'ETL__StartDate', 'ETL__EndDate', 'ETL__DeltaHashKey')


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
	AND COLUMN_NAME NOT LIKE 'ETL__%'
	ORDER BY COLUMN_NAME

SET @DeltaHashKeySyntax = 'HASHBYTES(''sha2_256'', ' + LEFT(@DeltaHashKeySyntax, (LEN(@DeltaHashKeySyntax) - 2)) + ')'



IF (ISNULL(@JoinString,'') = '')
BEGIN

SET @JoinString = 
	(
		SELECT STUFF ((
        SELECT ' and ' + match  
        FROM
		(
			select 't.[' + a.Item + '] = s.[' + a.Item + ']' as match
			from dbo.Split (@BusinessKey, ',') a 
		)	x	
        FOR XML PATH('')), 1, 5, '')
	)


END

	DECLARE @SqlStringMax AS VARCHAR(MAX) = ''
	
	SELECT @SqlStringMax = @sqlStringMax + 'OR ISNULL(s.[' + COLUMN_NAME + '],'''') <> ' + 'ISNULL(t.[' + COLUMN_NAME + '],'''') '
	FROM #SharedColumns	
	WHERE ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) < 0



DECLARE @ColumnListArchive NVARCHAR(max) = ''

SET @ColumnListArchive = (
select STUFF ((
    SELECT ', [' + COLUMN_NAME + ']' 
	FROM #SharedColumnsArchive
	ORDER BY ORDINAL_POSITION
    FOR XML PATH('')), 1, 1, ''
))

DECLARE @DeleteLogXMLColumns AS VARCHAR(MAX) = ''

SELECT @DeleteLogXMLColumns = @DeleteLogXMLColumns + 't.[' + COLUMN_NAME + '], '
FROM #TargetColumns
WHERE DATA_TYPE NOT LIKE '%binary'

SET @DeleteLogXMLColumns = LEFT(@DeleteLogXMLColumns, LEN(@DeleteLogXMLColumns) - 1)


DECLARE @SqlUpdateToNull NVARCHAR(MAX) = ''

SELECT @SqlUpdateToNull = @SqlUpdateToNull + '
UPDATE ' + @Source + ' SET [' + COLUMN_NAME + '] = NULL WHERE [' + COLUMN_NAME + '] = '''';
'
--, *
FROM #SharedColumns
WHERE DATA_TYPE NOT LIKE '%char%'
	

SELECT @SQL = 
'
DECLARE @RunTime DATETIME = GETDATE()

DECLARE @BatchId NVARCHAR(50) = ''' + @BatchId + ''';
DECLARE @ExecutionId uniqueidentifier = newid();

BEGIN TRY 

PRINT ''Execution Id: '' + CONVERT(NVARCHAR(100),@ExecutionId)

' + CASE WHEN @LoadArchiveTable = 1 THEN '

INSERT INTO archive.' + PARSENAME(@Source,1) + '
(
	ETL__CreatedDate, ETL__Source, ETL__BatchId, ETL__ExecutionId
	, ' + @ColumnListArchive + '
)

SELECT 
GETDATE() ETL__CreatedDate, ETL__Source
, @BatchId ETL__BatchId, @ExecutionId ETL__ExecutionId
, ' + @ColumnListArchive + '
FROM ' + PARSENAME(@Source,2) + '.' + PARSENAME(@Source,1) + '

' ELSE '' END + '

' + CASE WHEN @DedupeStage = 1 THEN '

IF EXISTS (
	SELECT COUNT(*)
	FROM ' + @Source + '
	GROUP BY ' + @BusinessKey + '
	HAVING COUNT(*) > 1
)
BEGIN 
	DELETE a
	FROM ' + @Source + ' a
	INNER JOIN (
	SELECT ETL__ID
	, ROW_NUMBER() OVER(PARTITION BY ' + @BusinessKey + ' ORDER BY ' + ISNULL(@DedupeSortPriority, 'ETL__ID') + ') RowRank
	FROM ' + @Source + '
	) b ON a.ETL__ID = b.ETL__ID
	WHERE b.RowRank > 1
END

' ELSE '' END + '

' + '

' + CASE WHEN @ConvertBlanksToNull = 1 THEN @SqlUpdateToNull ELSE '' END + '

' + CASE WHEN @FullLoadWithDelete = 1 THEN '

delete t
FROM ' + @Target + ' t
INNER JOIN (
SELECT CAST(1 AS BIT) ForceExists, ' + @BusinessKey + '
FROM stg.TM_ListCode 
) s ON ' + @JoinString + '
WHERE s.ForceExists IS NULL

' ELSE '' END + '


' + CASE WHEN @PartitionedKeyDelete = 1 THEN '

SELECT ' + @DeleteLogXMLColumns + '
INTO #ToDelete
FROM ' + @Target + ' t
INNER JOIN (
	SELECT DISTINCT ' + @PartitionedKey + '
	FROM ' + @Source + '
) p ON t.' + @PartitionedKey + ' = p.' + @PartitionedKey + '
LEFT OUTER JOIN (
	SELECT CAST(1 AS BIT) ForceExists, ' + @BusinessKey + '
	FROM ' + @Source + ' 
) s ON ' + @JoinString + '
WHERE s.ForceExists IS NULL

INSERT INTO etl.TM_DeleteLog ( ETL__CreatedDate, SourceTable, RowDataXML )
SELECT GETDATE() ETL__CreatedDate, ''' + @Target + ''' SourceTable
, (SELECT a.* FOR XML RAW)
FROM #ToDelete a

DELETE t
FROM ' + @Target + ' t
INNER JOIN #ToDelete s ON ' + @JoinString + '

' ELSE '' END

SELECT @SQL2 = '


SELECT
	CAST(' + @DeltaHashKeySyntax + ' as binary(32)) ETL__DeltaHashKey
	, ' + @ColString + '
INTO #SrcData
FROM ' + @Source + '
' + CASE WHEN ISNULL(@SourceFilter,'') <> '' THEN ' WHERE (' + @SourceFilter + ')' ELSE '' END + '

CREATE NONCLUSTERED INDEX IDX_Key ON #SrcData (' + @BusinessKey + ')
CREATE NONCLUSTERED INDEX IDX_ETL__DeltaHashKey ON #SrcData (ETL__DeltaHashKey)

';

-------------------------------------------------------------------------------------------------

SELECT @SQL3 = 
'
MERGE ' + @Target + ' AS t

USING #SrcData s
    
	ON ' + @JoinString + '

WHEN MATCHED AND (
     (	
		ISNULL(s.ETL__DeltaHashKey,-1) <> ISNULL(t.ETL__DeltaHashKey, -1)
		AND t.ETL__EndDate IS NULL
	)
	 ' + @SqlStringMax + '
)
THEN UPDATE SET
	ETL__EndDate = @RunTime
';

-------------------------------------------------------------------------------------------------

SELECT @SQL4 = 
'WHEN NOT MATCHED BY Target
THEN INSERT
     (
     [ETL__CreatedDate]
     , [ETL__StartDate]
     , [ETL__DeltaHashKey]
	 , ' + 
          STUFF ((
                    SELECT ',[' + COLUMN_NAME + ']' + CHAR(10) + '     '
					FROM #SharedColumns
					ORDER BY ORDINAL_POSITION
                    FOR XML PATH('')), 1, 1, '') + ')
VALUES
     (
     GETDATE() --s.[ETL__CreatedDate]
     , GETDATE() --s.[[ETL__StartDate]]
     , s.[ETL__DeltaHashKey]
	 , ' +
          STUFF ((
                    SELECT ',s.[' + COLUMN_NAME + ']' + CHAR(10) + '     '
					FROM #SharedColumns					
					ORDER BY ORDINAL_POSITION
                    FOR XML PATH('')), 1, 1, '') + ')
;


INSERT INTO ' + @Target + ' (
		ETL__CreatedDate
		, ETL__StartDate
		, ETL__DeltaHashKey
	 , ' + 
          STUFF ((
                    SELECT ',[' + COLUMN_NAME + ']' + CHAR(10) + '     '
					FROM #SharedColumns
					ORDER BY ORDINAL_POSITION
                    FOR XML PATH('')), 1, 1, '') + ')

SELECT 
	GETDATE() --ETL__CreatedDate
	, @RunTime	--ETL__StartDate
	, s.[ETL__DeltaHashKey]
	 , ' + 
          STUFF ((
                    SELECT ',s.[' + COLUMN_NAME + ']' + CHAR(10) + '     '
					FROM #SharedColumns					
					ORDER BY ORDINAL_POSITION
                    FOR XML PATH('')), 1, 1, '') + '
FROM #SrcData s
INNER JOIN ' + @Target + ' t ON ' + @JoinString + '
WHERE t.ETL__EndDate = @RunTime


DROP TABLE #SrcData


END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

'

--PRINT @SQL
--PRINT @SQL2 
--PRINT @SQL3
--PRINT @SQL4

DECLARE @Full_SQL NVARCHAR(MAX) = @SQL + @SQL2 + @SQL3 + @SQL4;


IF (@Debug = 1)
BEGIN

	SELECT @Full_SQL

END
ELSE BEGIN

	EXEC (@Full_SQL)

END

END
























GO
