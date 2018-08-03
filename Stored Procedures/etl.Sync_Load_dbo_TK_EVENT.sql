SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[Sync_Load_dbo_TK_EVENT]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Sync_TI_TK_EVENT),'0');	

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_Sync_DeltaHashKey
,  ETLSID, SEASON, EVENT, NAME, ETYPE, PRINT_LINES, CODE, MSG, CLASS, BASIS, EGROUP, DATE, TIME, KEYWORD, TAG, ITEM, SMAP_TS, FACILITY, CONFIG, HOLD_OK, CAPACITY, NREMAIN, NALLOC, NPRINT, NHELD, NKILL, NCOMP, FFEE, XMIT, RECEIVED, EVENT_LOGO, AP_ALLOW, AP_LIMIT, AP_REENTRY, DATE_END, TIME_END, ALLOCATED, EXT, ORDERED, PRINTED, LAST_USER, LAST_DATETIME, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
INTO #SrcData
FROM (
	SELECT  ETLSID, SEASON, EVENT, NAME, ETYPE, PRINT_LINES, CODE, MSG, CLASS, BASIS, EGROUP, DATE, TIME, KEYWORD, TAG, ITEM, SMAP_TS, FACILITY, CONFIG, HOLD_OK, CAPACITY, NREMAIN, NALLOC, NPRINT, NHELD, NKILL, NCOMP, FFEE, XMIT, RECEIVED, EVENT_LOGO, AP_ALLOW, AP_LIMIT, AP_REENTRY, DATE_END, TIME_END, ALLOCATED, EXT, ORDERED, PRINTED, LAST_USER, LAST_DATETIME, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
	, ROW_NUMBER() OVER(PARTITION BY SEASON,EVENT ORDER BY ETL_Sync_Id) RowRank
	FROM src.Sync_TI_TK_EVENT
) a
WHERE RowRank = 1

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_Sync_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),ALLOCATED)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(AP_ALLOW),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),AP_LIMIT)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),AP_REENTRY)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(BASIS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),CAPACITY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CLASS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CODE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONFIG),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),DATE)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),DATE_END)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(EGROUP),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),ETL_Sync_Id)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ETLSID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ETYPE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(EVENT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(EVENT_LOGO),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),EXPORT_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),EXT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(FACILITY),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(FFEE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(HOLD_OK),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ITEM),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(KEYWORD),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),LAST_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(LAST_USER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MSG),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),NALLOC)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(NAME),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),NCOMP)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),NHELD)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),NKILL)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),NPRINT)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),NREMAIN)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),ORDERED)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(PRINT_LINES),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),PRINTED)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(RECEIVED),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SMAP_TS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SOURCE_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(TAG),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(TIME),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(TIME_END),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(XMIT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ZID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_Sync_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (SEASON,EVENT)
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL_Sync_DeltaHashKey)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE dbo.TK_EVENT AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.EVENT = mySource.EVENT and myTarget.SEASON = mySource.SEASON

WHEN MATCHED AND (
     ISNULL(mySource.ETL_Sync_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_Sync_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETLSID] = mySource.[ETLSID]
     ,myTarget.[SEASON] = mySource.[SEASON]
     ,myTarget.[EVENT] = mySource.[EVENT]
     ,myTarget.[NAME] = mySource.[NAME]
     ,myTarget.[ETYPE] = mySource.[ETYPE]
     ,myTarget.[PRINT_LINES] = mySource.[PRINT_LINES]
     ,myTarget.[CODE] = mySource.[CODE]
     ,myTarget.[MSG] = mySource.[MSG]
     ,myTarget.[CLASS] = mySource.[CLASS]
     ,myTarget.[BASIS] = mySource.[BASIS]
     ,myTarget.[EGROUP] = mySource.[EGROUP]
     ,myTarget.[DATE] = mySource.[DATE]
     ,myTarget.[TIME] = mySource.[TIME]
     ,myTarget.[KEYWORD] = mySource.[KEYWORD]
     ,myTarget.[TAG] = mySource.[TAG]
     ,myTarget.[ITEM] = mySource.[ITEM]
     ,myTarget.[SMAP_TS] = mySource.[SMAP_TS]
     ,myTarget.[FACILITY] = mySource.[FACILITY]
     ,myTarget.[CONFIG] = mySource.[CONFIG]
     ,myTarget.[HOLD_OK] = mySource.[HOLD_OK]
     ,myTarget.[CAPACITY] = mySource.[CAPACITY]
     ,myTarget.[NREMAIN] = mySource.[NREMAIN]
     ,myTarget.[NALLOC] = mySource.[NALLOC]
     ,myTarget.[NPRINT] = mySource.[NPRINT]
     ,myTarget.[NHELD] = mySource.[NHELD]
     ,myTarget.[NKILL] = mySource.[NKILL]
     ,myTarget.[NCOMP] = mySource.[NCOMP]
     ,myTarget.[FFEE] = mySource.[FFEE]
     ,myTarget.[XMIT] = mySource.[XMIT]
     ,myTarget.[RECEIVED] = mySource.[RECEIVED]
     ,myTarget.[EVENT_LOGO] = mySource.[EVENT_LOGO]
     ,myTarget.[AP_ALLOW] = mySource.[AP_ALLOW]
     ,myTarget.[AP_LIMIT] = mySource.[AP_LIMIT]
     ,myTarget.[AP_REENTRY] = mySource.[AP_REENTRY]
     ,myTarget.[DATE_END] = mySource.[DATE_END]
     ,myTarget.[TIME_END] = mySource.[TIME_END]
     ,myTarget.[ALLOCATED] = mySource.[ALLOCATED]
     ,myTarget.[EXT] = mySource.[EXT]
     ,myTarget.[ORDERED] = mySource.[ORDERED]
     ,myTarget.[PRINTED] = mySource.[PRINTED]
     ,myTarget.[LAST_USER] = mySource.[LAST_USER]
     ,myTarget.[LAST_DATETIME] = mySource.[LAST_DATETIME]
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
     ,[NAME]
     ,[ETYPE]
     ,[PRINT_LINES]
     ,[CODE]
     ,[MSG]
     ,[CLASS]
     ,[BASIS]
     ,[EGROUP]
     ,[DATE]
     ,[TIME]
     ,[KEYWORD]
     ,[TAG]
     ,[ITEM]
     ,[SMAP_TS]
     ,[FACILITY]
     ,[CONFIG]
     ,[HOLD_OK]
     ,[CAPACITY]
     ,[NREMAIN]
     ,[NALLOC]
     ,[NPRINT]
     ,[NHELD]
     ,[NKILL]
     ,[NCOMP]
     ,[FFEE]
     ,[XMIT]
     ,[RECEIVED]
     ,[EVENT_LOGO]
     ,[AP_ALLOW]
     ,[AP_LIMIT]
     ,[AP_REENTRY]
     ,[DATE_END]
     ,[TIME_END]
     ,[ALLOCATED]
     ,[EXT]
     ,[ORDERED]
     ,[PRINTED]
     ,[LAST_USER]
     ,[LAST_DATETIME]
     ,[ZID]
     ,[SOURCE_ID]
     ,[EXPORT_DATETIME]
     ,[ETL_Sync_DeltaHashKey]
     )
VALUES
     (mySource.[ETLSID]
     ,mySource.[SEASON]
     ,mySource.[EVENT]
     ,mySource.[NAME]
     ,mySource.[ETYPE]
     ,mySource.[PRINT_LINES]
     ,mySource.[CODE]
     ,mySource.[MSG]
     ,mySource.[CLASS]
     ,mySource.[BASIS]
     ,mySource.[EGROUP]
     ,mySource.[DATE]
     ,mySource.[TIME]
     ,mySource.[KEYWORD]
     ,mySource.[TAG]
     ,mySource.[ITEM]
     ,mySource.[SMAP_TS]
     ,mySource.[FACILITY]
     ,mySource.[CONFIG]
     ,mySource.[HOLD_OK]
     ,mySource.[CAPACITY]
     ,mySource.[NREMAIN]
     ,mySource.[NALLOC]
     ,mySource.[NPRINT]
     ,mySource.[NHELD]
     ,mySource.[NKILL]
     ,mySource.[NCOMP]
     ,mySource.[FFEE]
     ,mySource.[XMIT]
     ,mySource.[RECEIVED]
     ,mySource.[EVENT_LOGO]
     ,mySource.[AP_ALLOW]
     ,mySource.[AP_LIMIT]
     ,mySource.[AP_REENTRY]
     ,mySource.[DATE_END]
     ,mySource.[TIME_END]
     ,mySource.[ALLOCATED]
     ,mySource.[EXT]
     ,mySource.[ORDERED]
     ,mySource.[PRINTED]
     ,mySource.[LAST_USER]
     ,mySource.[LAST_DATETIME]
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
