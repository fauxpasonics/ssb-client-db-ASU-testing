SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[Sync_Load_dbo_TK_TRANS_ITEM_EVENT]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Sync_TI_TK_TRANS_ITEM_EVENT),'0');	

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_Sync_DeltaHashKey
,  ETLSID, SEASON, TRANS_NO, VMC, SVMC, EVENT, E_PL, E_PRICE, E_DAMT, E_PQTY, E_VQTY, E_PTT_QTY, E_PTF_QTY, E_ITEM, E_OQTY, E_CQTY, E_OTT_QTY, E_OTF_QTY, E_OQTY_TOT, E_PT, E_STAT, E_QTY, E_CPRICE, E_FEE, E_FPRICE, TOTAL_EPAY, TOTAL_CPAY, TOTAL_FPAY, SALECODE, E_SCAMT, TOTAL_SPAY, DATE, CUSTOMER, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
INTO #SrcData
FROM (
	SELECT  ETLSID, SEASON, TRANS_NO, VMC, SVMC, EVENT, E_PL, E_PRICE, E_DAMT, E_PQTY, E_VQTY, E_PTT_QTY, E_PTF_QTY, E_ITEM, E_OQTY, E_CQTY, E_OTT_QTY, E_OTF_QTY, E_OQTY_TOT, E_PT, E_STAT, E_QTY, E_CPRICE, E_FEE, E_FPRICE, TOTAL_EPAY, TOTAL_CPAY, TOTAL_FPAY, SALECODE, E_SCAMT, TOTAL_SPAY, DATE, CUSTOMER, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
	, ROW_NUMBER() OVER(PARTITION BY SEASON,TRANS_NO,VMC,SVMC ORDER BY ETL_Sync_Id) RowRank
	FROM src.Sync_TI_TK_TRANS_ITEM_EVENT
) a
WHERE RowRank = 1

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_Sync_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CUSTOMER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),DATE)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),E_CPRICE)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),E_CQTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),E_DAMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(E_FEE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),E_FPRICE)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(E_ITEM),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),E_OQTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),E_OQTY_TOT)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),E_OTF_QTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),E_OTT_QTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(E_PL),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),E_PQTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),E_PRICE)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(E_PT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),E_PTF_QTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),E_PTT_QTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),E_QTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),E_SCAMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(E_STAT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),E_VQTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),ETL_Sync_Id)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ETLSID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(EVENT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),EXPORT_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SALECODE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SOURCE_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),SVMC)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),TOTAL_CPAY)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),TOTAL_EPAY)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),TOTAL_FPAY)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),TOTAL_SPAY)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),VMC)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ZID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_Sync_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (SEASON,TRANS_NO,VMC,SVMC)
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL_Sync_DeltaHashKey)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE dbo.TK_TRANS_ITEM_EVENT AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.SEASON = mySource.SEASON and myTarget.SVMC = mySource.SVMC and myTarget.TRANS_NO = mySource.TRANS_NO and myTarget.VMC = mySource.VMC

WHEN MATCHED AND (
     ISNULL(mySource.ETL_Sync_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_Sync_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETLSID] = mySource.[ETLSID]
     ,myTarget.[SEASON] = mySource.[SEASON]
     ,myTarget.[TRANS_NO] = mySource.[TRANS_NO]
     ,myTarget.[VMC] = mySource.[VMC]
     ,myTarget.[SVMC] = mySource.[SVMC]
     ,myTarget.[EVENT] = mySource.[EVENT]
     ,myTarget.[E_PL] = mySource.[E_PL]
     ,myTarget.[E_PRICE] = mySource.[E_PRICE]
     ,myTarget.[E_DAMT] = mySource.[E_DAMT]
     ,myTarget.[E_PQTY] = mySource.[E_PQTY]
     ,myTarget.[E_VQTY] = mySource.[E_VQTY]
     ,myTarget.[E_PTT_QTY] = mySource.[E_PTT_QTY]
     ,myTarget.[E_PTF_QTY] = mySource.[E_PTF_QTY]
     ,myTarget.[E_ITEM] = mySource.[E_ITEM]
     ,myTarget.[E_OQTY] = mySource.[E_OQTY]
     ,myTarget.[E_CQTY] = mySource.[E_CQTY]
     ,myTarget.[E_OTT_QTY] = mySource.[E_OTT_QTY]
     ,myTarget.[E_OTF_QTY] = mySource.[E_OTF_QTY]
     ,myTarget.[E_OQTY_TOT] = mySource.[E_OQTY_TOT]
     ,myTarget.[E_PT] = mySource.[E_PT]
     ,myTarget.[E_STAT] = mySource.[E_STAT]
     ,myTarget.[E_QTY] = mySource.[E_QTY]
     ,myTarget.[E_CPRICE] = mySource.[E_CPRICE]
     ,myTarget.[E_FEE] = mySource.[E_FEE]
     ,myTarget.[E_FPRICE] = mySource.[E_FPRICE]
     ,myTarget.[TOTAL_EPAY] = mySource.[TOTAL_EPAY]
     ,myTarget.[TOTAL_CPAY] = mySource.[TOTAL_CPAY]
     ,myTarget.[TOTAL_FPAY] = mySource.[TOTAL_FPAY]
     ,myTarget.[SALECODE] = mySource.[SALECODE]
     ,myTarget.[E_SCAMT] = mySource.[E_SCAMT]
     ,myTarget.[TOTAL_SPAY] = mySource.[TOTAL_SPAY]
     ,myTarget.[DATE] = mySource.[DATE]
     ,myTarget.[CUSTOMER] = mySource.[CUSTOMER]
     ,myTarget.[ZID] = mySource.[ZID]
     ,myTarget.[SOURCE_ID] = mySource.[SOURCE_ID]
     ,myTarget.[EXPORT_DATETIME] = mySource.[EXPORT_DATETIME]
     ,myTarget.[ETL_Sync_DeltaHashKey] = mySource.[ETL_Sync_DeltaHashKey]
     

--WHEN NOT MATCHED BY SOURCE AND @DisableDelete = 'false' THEN DELETE

WHEN NOT MATCHED BY Target
THEN INSERT
     ([ETLSID]
     ,[SEASON]
     ,[TRANS_NO]
     ,[VMC]
     ,[SVMC]
     ,[EVENT]
     ,[E_PL]
     ,[E_PRICE]
     ,[E_DAMT]
     ,[E_PQTY]
     ,[E_VQTY]
     ,[E_PTT_QTY]
     ,[E_PTF_QTY]
     ,[E_ITEM]
     ,[E_OQTY]
     ,[E_CQTY]
     ,[E_OTT_QTY]
     ,[E_OTF_QTY]
     ,[E_OQTY_TOT]
     ,[E_PT]
     ,[E_STAT]
     ,[E_QTY]
     ,[E_CPRICE]
     ,[E_FEE]
     ,[E_FPRICE]
     ,[TOTAL_EPAY]
     ,[TOTAL_CPAY]
     ,[TOTAL_FPAY]
     ,[SALECODE]
     ,[E_SCAMT]
     ,[TOTAL_SPAY]
     ,[DATE]
     ,[CUSTOMER]
     ,[ZID]
     ,[SOURCE_ID]
     ,[EXPORT_DATETIME]
     ,[ETL_Sync_DeltaHashKey]
     )
VALUES
     (mySource.[ETLSID]
     ,mySource.[SEASON]
     ,mySource.[TRANS_NO]
     ,mySource.[VMC]
     ,mySource.[SVMC]
     ,mySource.[EVENT]
     ,mySource.[E_PL]
     ,mySource.[E_PRICE]
     ,mySource.[E_DAMT]
     ,mySource.[E_PQTY]
     ,mySource.[E_VQTY]
     ,mySource.[E_PTT_QTY]
     ,mySource.[E_PTF_QTY]
     ,mySource.[E_ITEM]
     ,mySource.[E_OQTY]
     ,mySource.[E_CQTY]
     ,mySource.[E_OTT_QTY]
     ,mySource.[E_OTF_QTY]
     ,mySource.[E_OQTY_TOT]
     ,mySource.[E_PT]
     ,mySource.[E_STAT]
     ,mySource.[E_QTY]
     ,mySource.[E_CPRICE]
     ,mySource.[E_FEE]
     ,mySource.[E_FPRICE]
     ,mySource.[TOTAL_EPAY]
     ,mySource.[TOTAL_CPAY]
     ,mySource.[TOTAL_FPAY]
     ,mySource.[SALECODE]
     ,mySource.[E_SCAMT]
     ,mySource.[TOTAL_SPAY]
     ,mySource.[DATE]
     ,mySource.[CUSTOMER]
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
