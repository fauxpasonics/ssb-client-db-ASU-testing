SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[Sync_Load_dbo_TK_SEAT]
(
	@BatchId NVARCHAR(50) = null,
	@Client NVARCHAR(255) = null,
	@Options nvarchar(MAX) = NULL,
	@OptionsFormat nvarchar(50) = 'KeyValue'
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     dbo
Date:     02/02/2016
Comments: Initial creation
*************************************************************************************/

SET @BatchId = ISNULL(@BatchId, CONVERT(NVARCHAR(50), NEWID()))

SET @Client = ISNULL(@Client, DB_NAME())

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Sync_TI_TK_SEAT),'0');	

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_Sync_DeltaHashKey
,  ETLSID, SEASON, EVENT, LEVEL, SECTION, ROW, NREMAIN, NALLOC, NPRINT, NHELD, NKILL, SEQ, CAPACITY, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
INTO #SrcData
FROM (
	SELECT  ETLSID, SEASON, EVENT, LEVEL, SECTION, ROW, NREMAIN, NALLOC, NPRINT, NHELD, NKILL, SEQ, CAPACITY, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
	, ROW_NUMBER() OVER(PARTITION BY SEASON,EVENT,LEVEL,SECTION,ROW ORDER BY ETL_Sync_Id) RowRank
	FROM src.Sync_TI_TK_SEAT
) a
WHERE RowRank = 1

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_Sync_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),CAPACITY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),ETL_Sync_Id)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ETLSID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(EVENT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),EXPORT_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(LEVEL),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),NALLOC)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),NHELD)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),NKILL)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),NPRINT)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),NREMAIN)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ROW),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SECTION),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),SEQ)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SOURCE_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ZID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_Sync_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (SEASON,EVENT,LEVEL,SECTION,ROW)
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL_Sync_DeltaHashKey)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE dbo.TK_SEAT AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.EVENT = mySource.EVENT and myTarget.LEVEL = mySource.LEVEL and myTarget.ROW = mySource.ROW and myTarget.SEASON = mySource.SEASON and myTarget.SECTION = mySource.SECTION

WHEN MATCHED AND (
     ISNULL(mySource.ETL_Sync_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_Sync_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETLSID] = mySource.[ETLSID]
     ,myTarget.[SEASON] = mySource.[SEASON]
     ,myTarget.[EVENT] = mySource.[EVENT]
     ,myTarget.[LEVEL] = mySource.[LEVEL]
     ,myTarget.[SECTION] = mySource.[SECTION]
     ,myTarget.[ROW] = mySource.[ROW]
     ,myTarget.[NREMAIN] = mySource.[NREMAIN]
     ,myTarget.[NALLOC] = mySource.[NALLOC]
     ,myTarget.[NPRINT] = mySource.[NPRINT]
     ,myTarget.[NHELD] = mySource.[NHELD]
     ,myTarget.[NKILL] = mySource.[NKILL]
     ,myTarget.[SEQ] = mySource.[SEQ]
     ,myTarget.[CAPACITY] = mySource.[CAPACITY]
     ,myTarget.[ZID] = mySource.[ZID]
     ,myTarget.[SOURCE_ID] = mySource.[SOURCE_ID]
     ,myTarget.[EXPORT_DATETIME] = mySource.[EXPORT_DATETIME]
     ,myTarget.[ETL_Sync_DeltaHashKey] = mySource.[ETL_Sync_DeltaHashKey]
     

--WHEN NOT MATCHED BY SOURCE AND @DisableDelete = 'false' THEN DELETE

WHEN NOT MATCHED BY Target
THEN INSERT
     ([ETLSID]
     ,[SEASON]
     ,[EVENT]
     ,[LEVEL]
     ,[SECTION]
     ,[ROW]
     ,[NREMAIN]
     ,[NALLOC]
     ,[NPRINT]
     ,[NHELD]
     ,[NKILL]
     ,[SEQ]
     ,[CAPACITY]
     ,[ZID]
     ,[SOURCE_ID]
     ,[EXPORT_DATETIME]
     ,[ETL_Sync_DeltaHashKey]
     )
VALUES
     (mySource.[ETLSID]
     ,mySource.[SEASON]
     ,mySource.[EVENT]
     ,mySource.[LEVEL]
     ,mySource.[SECTION]
     ,mySource.[ROW]
     ,mySource.[NREMAIN]
     ,mySource.[NALLOC]
     ,mySource.[NPRINT]
     ,mySource.[NHELD]
     ,mySource.[NKILL]
     ,mySource.[SEQ]
     ,mySource.[CAPACITY]
     ,mySource.[ZID]
     ,mySource.[SOURCE_ID]
     ,mySource.[EXPORT_DATETIME]
     ,mySource.[ETL_Sync_DeltaHashKey]
     )
;

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Error', @ProcedureName, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
	EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId


END


GO
