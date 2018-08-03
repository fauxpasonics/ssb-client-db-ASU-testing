SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[TM_Load_ods_ListCode]
(
	@BatchId NVARCHAR(50) = '00000000-0000-0000-0000-000000000000',
	@Target VARCHAR(256) = null,
	@Source VARCHAR(256) = null,
	@BusinessKey VARCHAR(256) = null,
	@Options NVARCHAR(MAX) = null
)

AS
BEGIN


DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @EventSource nvarchar(255) = 'TM_StandardMerge - ods.TM_ListCode'
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM stg.TM_ListCode),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0';
DECLARE @Client NVARCHAR(255) = (SELECT ISNULL(etl.fnGetClientSetting('ClientName'), DB_NAME()));

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

UPDATE stg.TM_ListCode
SET ETL__Source = '06D91BC4-4654-426B-98CB-115B1A323340'
WHERE ETL__Source IS NULL




INSERT INTO archive.TM_ListCode
(
	ETL__CreatedDate, ETL__Source, ETL__BatchId, ETL__ExecutionId
	,  [acct_id], [code], [value], [seq_num]
)

SELECT 
GETDATE() ETL__CreatedDate, ETL__Source
, @BatchId ETL__BatchId, @ExecutionId ETL__ExecutionId
,  [acct_id], [code], [value], [seq_num]
FROM stg.TM_ListCode



DECLARE @RecordCount INT = (SELECT COUNT(*) FROM stg.TM_ListCode)
DECLARE @StartIndex INT = 1, @PageCount INT = 1000000
DECLARE @EndIndex INT = (@StartIndex + @PageCount - 1)



IF EXISTS (
	SELECT COUNT(*)
	FROM stg.TM_ListCode
	GROUP BY acct_id, code, value
	HAVING COUNT(*) > 1
)
BEGIN 
	DELETE a
	FROM stg.TM_ListCode a
	INNER JOIN (
	SELECT ETL__ID
	, ROW_NUMBER() OVER(PARTITION BY acct_id, code, value ORDER BY ETL__ID) RowRank
	FROM stg.TM_ListCode
	) b ON a.ETL__ID = b.ETL__ID
	WHERE b.RowRank > 1
END

UPDATE stg.TM_ListCode SET acct_id = NULL WHERE acct_id = '';

UPDATE stg.TM_ListCode SET value = NULL WHERE value = '';


delete t
FROM ods.TM_ListCode t
INNER JOIN (
SELECT CAST(1 AS BIT) ForceExists, acct_id, code, value
FROM stg.TM_ListCode 
) s ON t.[acct_id] = s.[acct_id] and t.[code] = s.[code] and ISNULL(t.[value],'') = ISNULL(s.[value],'')
WHERE s.ForceExists IS NULL


DECLARE @MaxId INT = (SELECT MAX(ETL__ID) FROM stg.TM_ListCode)

WHILE @StartIndex <= @MaxId
BEGIN

SELECT ETL__Source
, CAST(HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),[acct_id])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM([code]),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),[value])),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS) as binary(32)) ETL__DeltaHashKey
, TRY_CAST([acct_id] AS DECIMAL(19,0)) [acct_id], [code], TRY_CAST([value] AS DECIMAL(19,0)) [value]
INTO #SrcData
FROM stg.TM_ListCode
WHERE ETL__ID BETWEEN @StartIndex AND @EndIndex

CREATE NONCLUSTERED INDEX IDX_Key ON #SrcData (acct_id, code, value)
CREATE NONCLUSTERED INDEX IDX_ETL__DeltaHashKey ON #SrcData (ETL__DeltaHashKey)


MERGE ods.TM_ListCode AS t

USING #SrcData s
    
	ON t.[acct_id] = s.[acct_id] and t.[code] = s.[code] and ISNULL(t.[value],-987) = ISNULL(s.[value],-987)

WHEN MATCHED AND (
     ISNULL(s.[ETL__DeltaHashKey],-1) <> ISNULL(t.[HashKey], -1)
	 
)
THEN UPDATE SET
     t.[UpdateDate] = GETDATE()
     , t.[SourceFileName] = s.[ETL__Source]
     , t.[HashKey] = s.[ETL__DeltaHashKey]
     , t.[acct_id] = s.[acct_id]
     ,t.[code] = s.[code]
     ,t.[value] = s.[value]
     

WHEN NOT MATCHED BY Target
THEN INSERT
     (
     [InsertDate]
     , [UpdateDate]
     , [SourceFileName]
     , [HashKey]
	 , [acct_id]
     ,[code]
     ,[value]
     )
VALUES
     (
     GETDATE() --s.[InsertDate]
     , GETDATE() --s.[[UpdateDate]]
     , s.[ETL__Source]
     , s.[ETL__DeltaHashKey]
	 , s.[acct_id]
     ,s.[code]
     ,s.[value]
     )
;


DROP TABLE #SrcData

SET @StartIndex = @EndIndex + 1
SET @EndIndex = @EndIndex + @PageCount

END --End Of Paging Loop

END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH


END









GO
