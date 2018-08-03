SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[Sync_Load_dbo_TK_BC]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Sync_TI_TK_BC),'0');	

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_Sync_DeltaHashKey
,  ETLSID, BC_ID, STATUS, SEASON, CUSTOMER, SEQ, ITEM, I_PT, EVENT, LEVEL, SECTION, ROW, SEAT, SCAN_DATE, SCAN_TIME, SCAN_LOC, SCAN_CLUSTER, SCAN_GATE, SCAN_RESPONSE, REDEEMED, DELIVERY_ID, ATTENDED, STC, BC_TYPE, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
INTO #SrcData
FROM (
	SELECT  ETLSID, BC_ID, STATUS, SEASON, CUSTOMER, SEQ, ITEM, I_PT, EVENT, LEVEL, SECTION, ROW, SEAT, SCAN_DATE, SCAN_TIME, SCAN_LOC, SCAN_CLUSTER, SCAN_GATE, SCAN_RESPONSE, REDEEMED, DELIVERY_ID, ATTENDED, STC, BC_TYPE, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
	, ROW_NUMBER() OVER(PARTITION BY BC_ID ORDER BY ETL_Sync_Id) RowRank
	FROM src.Sync_TI_TK_BC
) a
WHERE RowRank = 1

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_Sync_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(ATTENDED),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(BC_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(BC_TYPE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CUSTOMER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(DELIVERY_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),ETL_Sync_Id)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ETLSID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(EVENT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),EXPORT_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_PT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ITEM),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(LEVEL),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(REDEEMED),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ROW),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SCAN_CLUSTER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),SCAN_DATE)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SCAN_GATE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SCAN_LOC),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SCAN_RESPONSE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SCAN_TIME),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SEAT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SECTION),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),SEQ)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SOURCE_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(STATUS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(STC),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ZID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_Sync_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (BC_ID)
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL_Sync_DeltaHashKey)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE dbo.TK_BC AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.BC_ID = mySource.BC_ID

WHEN MATCHED AND (
     ISNULL(mySource.ETL_Sync_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_Sync_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETLSID] = mySource.[ETLSID]
     ,myTarget.[BC_ID] = mySource.[BC_ID]
     ,myTarget.[STATUS] = mySource.[STATUS]
     ,myTarget.[SEASON] = mySource.[SEASON]
     ,myTarget.[CUSTOMER] = mySource.[CUSTOMER]
     ,myTarget.[SEQ] = mySource.[SEQ]
     ,myTarget.[ITEM] = mySource.[ITEM]
     ,myTarget.[I_PT] = mySource.[I_PT]
     ,myTarget.[EVENT] = mySource.[EVENT]
     ,myTarget.[LEVEL] = mySource.[LEVEL]
     ,myTarget.[SECTION] = mySource.[SECTION]
     ,myTarget.[ROW] = mySource.[ROW]
     ,myTarget.[SEAT] = mySource.[SEAT]
     ,myTarget.[SCAN_DATE] = mySource.[SCAN_DATE]
     ,myTarget.[SCAN_TIME] = mySource.[SCAN_TIME]
     ,myTarget.[SCAN_LOC] = mySource.[SCAN_LOC]
     ,myTarget.[SCAN_CLUSTER] = mySource.[SCAN_CLUSTER]
     ,myTarget.[SCAN_GATE] = mySource.[SCAN_GATE]
     ,myTarget.[SCAN_RESPONSE] = mySource.[SCAN_RESPONSE]
     ,myTarget.[REDEEMED] = mySource.[REDEEMED]
     ,myTarget.[DELIVERY_ID] = mySource.[DELIVERY_ID]
     ,myTarget.[ATTENDED] = mySource.[ATTENDED]
     ,myTarget.[STC] = mySource.[STC]
     ,myTarget.[BC_TYPE] = mySource.[BC_TYPE]
     ,myTarget.[ZID] = mySource.[ZID]
     ,myTarget.[SOURCE_ID] = mySource.[SOURCE_ID]
     ,myTarget.[EXPORT_DATETIME] = mySource.[EXPORT_DATETIME]
     ,myTarget.[ETL_Sync_DeltaHashKey] = mySource.[ETL_Sync_DeltaHashKey]
     

--WHEN NOT MATCHED BY SOURCE AND @DisableDelete = 'false' THEN DELETE

WHEN NOT MATCHED BY Target
THEN INSERT
     ([ETLSID]
     ,[BC_ID]
     ,[STATUS]
     ,[SEASON]
     ,[CUSTOMER]
     ,[SEQ]
     ,[ITEM]
     ,[I_PT]
     ,[EVENT]
     ,[LEVEL]
     ,[SECTION]
     ,[ROW]
     ,[SEAT]
     ,[SCAN_DATE]
     ,[SCAN_TIME]
     ,[SCAN_LOC]
     ,[SCAN_CLUSTER]
     ,[SCAN_GATE]
     ,[SCAN_RESPONSE]
     ,[REDEEMED]
     ,[DELIVERY_ID]
     ,[ATTENDED]
     ,[STC]
     ,[BC_TYPE]
     ,[ZID]
     ,[SOURCE_ID]
     ,[EXPORT_DATETIME]
     ,[ETL_Sync_DeltaHashKey]
     )
VALUES
     (mySource.[ETLSID]
     ,mySource.[BC_ID]
     ,mySource.[STATUS]
     ,mySource.[SEASON]
     ,mySource.[CUSTOMER]
     ,mySource.[SEQ]
     ,mySource.[ITEM]
     ,mySource.[I_PT]
     ,mySource.[EVENT]
     ,mySource.[LEVEL]
     ,mySource.[SECTION]
     ,mySource.[ROW]
     ,mySource.[SEAT]
     ,mySource.[SCAN_DATE]
     ,mySource.[SCAN_TIME]
     ,mySource.[SCAN_LOC]
     ,mySource.[SCAN_CLUSTER]
     ,mySource.[SCAN_GATE]
     ,mySource.[SCAN_RESPONSE]
     ,mySource.[REDEEMED]
     ,mySource.[DELIVERY_ID]
     ,mySource.[ATTENDED]
     ,mySource.[STC]
     ,mySource.[BC_TYPE]
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
