SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[Sync_Load_dbo_TK_SEAT_SEAT]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Sync_TI_TK_SEAT_SEAT),'0');	

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_Sync_DeltaHashKey
,  ETLSID, SEASON, EVENT, LEVEL, SECTION, ROW, VMC, SEAT, STAT, DKEY, CUSTOMER, SEQ, ITEM, I_PT, I_PL, PREV_STATUS, PL, GATE, AREA, AISLE, BARCODE, MP_RESERVE, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
INTO #SrcData
FROM (
	SELECT  ETLSID, SEASON, EVENT, LEVEL, SECTION, ROW, VMC, SEAT, STAT, DKEY, CUSTOMER, SEQ, ITEM, I_PT, I_PL, PREV_STATUS, PL, GATE, AREA, AISLE, BARCODE, MP_RESERVE, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
	, ROW_NUMBER() OVER(PARTITION BY SEASON,EVENT,LEVEL,SECTION,ROW,VMC ORDER BY ETL_Sync_Id) RowRank
	FROM src.Sync_TI_TK_SEAT_SEAT
) a
WHERE RowRank = 1

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_Sync_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(AISLE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(AREA),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(BARCODE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CUSTOMER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(DKEY),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),ETL_Sync_Id)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ETLSID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(EVENT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),EXPORT_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(GATE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_PL),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_PT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ITEM),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(LEVEL),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MP_RESERVE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(PL),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(PREV_STATUS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ROW),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SEAT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SECTION),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),SEQ)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SOURCE_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(STAT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),VMC)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ZID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_Sync_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (SEASON,EVENT,LEVEL,SECTION,ROW,VMC)
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL_Sync_DeltaHashKey)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE dbo.TK_SEAT_SEAT AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.EVENT = mySource.EVENT and myTarget.LEVEL = mySource.LEVEL and myTarget.ROW = mySource.ROW and myTarget.SEASON = mySource.SEASON and myTarget.SECTION = mySource.SECTION and myTarget.VMC = mySource.VMC

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
     ,myTarget.[VMC] = mySource.[VMC]
     ,myTarget.[SEAT] = mySource.[SEAT]
     ,myTarget.[STAT] = mySource.[STAT]
     ,myTarget.[DKEY] = mySource.[DKEY]
     ,myTarget.[CUSTOMER] = mySource.[CUSTOMER]
     ,myTarget.[SEQ] = mySource.[SEQ]
     ,myTarget.[ITEM] = mySource.[ITEM]
     ,myTarget.[I_PT] = mySource.[I_PT]
     ,myTarget.[I_PL] = mySource.[I_PL]
     ,myTarget.[PREV_STATUS] = mySource.[PREV_STATUS]
     ,myTarget.[PL] = mySource.[PL]
     ,myTarget.[GATE] = mySource.[GATE]
     ,myTarget.[AREA] = mySource.[AREA]
     ,myTarget.[AISLE] = mySource.[AISLE]
     ,myTarget.[BARCODE] = mySource.[BARCODE]
     ,myTarget.[MP_RESERVE] = mySource.[MP_RESERVE]
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
     ,[VMC]
     ,[SEAT]
     ,[STAT]
     ,[DKEY]
     ,[CUSTOMER]
     ,[SEQ]
     ,[ITEM]
     ,[I_PT]
     ,[I_PL]
     ,[PREV_STATUS]
     ,[PL]
     ,[GATE]
     ,[AREA]
     ,[AISLE]
     ,[BARCODE]
     ,[MP_RESERVE]
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
     ,mySource.[VMC]
     ,mySource.[SEAT]
     ,mySource.[STAT]
     ,mySource.[DKEY]
     ,mySource.[CUSTOMER]
     ,mySource.[SEQ]
     ,mySource.[ITEM]
     ,mySource.[I_PT]
     ,mySource.[I_PL]
     ,mySource.[PREV_STATUS]
     ,mySource.[PL]
     ,mySource.[GATE]
     ,mySource.[AREA]
     ,mySource.[AISLE]
     ,mySource.[BARCODE]
     ,mySource.[MP_RESERVE]
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
