SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [etl].[Sync_Load_dbo_TK_TRANS_ITEM]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Sync_TI_TK_TRANS_ITEM),'0');	

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_Sync_DeltaHashKey
,  ETLSID, SEASON, TRANS_NO, VMC, ITEM, I_OQTY, I_CQTY, I_OTT_QTY, I_OTF_QTY, I_OQTY_TOT, I_PT, I_PRICE, I_DISC, I_DAMT, I_CHG, I_CPRICE, I_CPAYQ, I_DATE, I_DISP, I_ACUST, I_BPTYPE, E_STAT, I_STOCK, TOTAL_IPAY, TOTAL_CPAY, TOTAL_FPAY, SALECODE, I_O_ITEM, I_O_PT, INREFSOURCE, INREFDATA, I_PROMO, I_SCHG, I_SCAMT, TOTAL_SPAY, I_PKG, I_OLID, DATE, CUSTOMER, I_FPRICE, I_PL, ORIG_QTY, ORIG_AMT, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
INTO #SrcData
FROM (
	SELECT  ETLSID, SEASON, TRANS_NO, VMC, ITEM, I_OQTY, I_CQTY, I_OTT_QTY, I_OTF_QTY, I_OQTY_TOT, I_PT, I_PRICE, I_DISC, I_DAMT, I_CHG, I_CPRICE, I_CPAYQ, I_DATE, I_DISP, I_ACUST, I_BPTYPE, E_STAT, I_STOCK, TOTAL_IPAY, TOTAL_CPAY, TOTAL_FPAY, SALECODE, I_O_ITEM, I_O_PT, INREFSOURCE, INREFDATA, I_PROMO, I_SCHG, I_SCAMT, TOTAL_SPAY, I_PKG, I_OLID, DATE, CUSTOMER, I_FPRICE, I_PL, ORIG_QTY, ORIG_AMT, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
	, ROW_NUMBER() OVER(PARTITION BY SEASON,TRANS_NO,VMC ORDER BY ETL_Sync_Id) RowRank
	FROM src.Sync_TI_TK_TRANS_ITEM
) a
WHERE RowRank = 1

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_Sync_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CUSTOMER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),DATE)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(E_STAT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),ETL_Sync_Id)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ETLSID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),EXPORT_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_ACUST),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_BPTYPE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_CHG),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),I_CPAYQ)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_CPRICE)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),I_CQTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_DAMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_DATE)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_DISC),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_DISP),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_FPRICE)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_O_ITEM),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_O_PT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_OLID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),I_OQTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),I_OQTY_TOT)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),I_OTF_QTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),I_OTT_QTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_PKG),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_PL),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_PRICE)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_PROMO),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_PT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_SCAMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_SCHG),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_STOCK),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(INREFDATA),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(INREFSOURCE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ITEM),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),ORIG_AMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),ORIG_QTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SALECODE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SOURCE_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),TOTAL_CPAY)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),TOTAL_FPAY)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),TOTAL_IPAY)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),TOTAL_SPAY)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),VMC)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ZID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_Sync_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (SEASON,TRANS_NO,VMC)
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL_Sync_DeltaHashKey)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE dbo.TK_TRANS_ITEM AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.SEASON = mySource.SEASON and myTarget.TRANS_NO = mySource.TRANS_NO and myTarget.VMC = mySource.VMC

WHEN MATCHED AND (
     ISNULL(mySource.ETL_Sync_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_Sync_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETLSID] = mySource.[ETLSID]
     ,myTarget.[SEASON] = mySource.[SEASON]
     ,myTarget.[TRANS_NO] = mySource.[TRANS_NO]
     ,myTarget.[VMC] = mySource.[VMC]
     ,myTarget.[ITEM] = mySource.[ITEM]
     ,myTarget.[I_OQTY] = mySource.[I_OQTY]
     ,myTarget.[I_CQTY] = mySource.[I_CQTY]
     ,myTarget.[I_OTT_QTY] = mySource.[I_OTT_QTY]
     ,myTarget.[I_OTF_QTY] = mySource.[I_OTF_QTY]
     ,myTarget.[I_OQTY_TOT] = mySource.[I_OQTY_TOT]
     ,myTarget.[I_PT] = mySource.[I_PT]
     ,myTarget.[I_PRICE] = mySource.[I_PRICE]
     ,myTarget.[I_DISC] = mySource.[I_DISC]
     ,myTarget.[I_DAMT] = mySource.[I_DAMT]
     ,myTarget.[I_CHG] = mySource.[I_CHG]
     ,myTarget.[I_CPRICE] = mySource.[I_CPRICE]
     ,myTarget.[I_CPAYQ] = mySource.[I_CPAYQ]
     ,myTarget.[I_DATE] = mySource.[I_DATE]
     ,myTarget.[I_DISP] = mySource.[I_DISP]
     ,myTarget.[I_ACUST] = mySource.[I_ACUST]
     ,myTarget.[I_BPTYPE] = mySource.[I_BPTYPE]
     ,myTarget.[E_STAT] = mySource.[E_STAT]
     ,myTarget.[I_STOCK] = mySource.[I_STOCK]
     ,myTarget.[TOTAL_IPAY] = mySource.[TOTAL_IPAY]
     ,myTarget.[TOTAL_CPAY] = mySource.[TOTAL_CPAY]
     ,myTarget.[TOTAL_FPAY] = mySource.[TOTAL_FPAY]
     ,myTarget.[SALECODE] = mySource.[SALECODE]
     ,myTarget.[I_O_ITEM] = mySource.[I_O_ITEM]
     ,myTarget.[I_O_PT] = mySource.[I_O_PT]
     ,myTarget.[INREFSOURCE] = mySource.[INREFSOURCE]
     ,myTarget.[INREFDATA] = mySource.[INREFDATA]
     ,myTarget.[I_PROMO] = mySource.[I_PROMO]
     ,myTarget.[I_SCHG] = mySource.[I_SCHG]
     ,myTarget.[I_SCAMT] = mySource.[I_SCAMT]
     ,myTarget.[TOTAL_SPAY] = mySource.[TOTAL_SPAY]
     ,myTarget.[I_PKG] = mySource.[I_PKG]
     ,myTarget.[I_OLID] = mySource.[I_OLID]
     ,myTarget.[DATE] = mySource.[DATE]
     ,myTarget.[CUSTOMER] = mySource.[CUSTOMER]
     ,myTarget.[I_FPRICE] = mySource.[I_FPRICE]
     ,myTarget.[I_PL] = mySource.[I_PL]
     ,myTarget.[ORIG_QTY] = mySource.[ORIG_QTY]
     ,myTarget.[ORIG_AMT] = mySource.[ORIG_AMT]
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
     ,[ITEM]
     ,[I_OQTY]
     ,[I_CQTY]
     ,[I_OTT_QTY]
     ,[I_OTF_QTY]
     ,[I_OQTY_TOT]
     ,[I_PT]
     ,[I_PRICE]
     ,[I_DISC]
     ,[I_DAMT]
     ,[I_CHG]
     ,[I_CPRICE]
     ,[I_CPAYQ]
     ,[I_DATE]
     ,[I_DISP]
     ,[I_ACUST]
     ,[I_BPTYPE]
     ,[E_STAT]
     ,[I_STOCK]
     ,[TOTAL_IPAY]
     ,[TOTAL_CPAY]
     ,[TOTAL_FPAY]
     ,[SALECODE]
     ,[I_O_ITEM]
     ,[I_O_PT]
     ,[INREFSOURCE]
     ,[INREFDATA]
     ,[I_PROMO]
     ,[I_SCHG]
     ,[I_SCAMT]
     ,[TOTAL_SPAY]
     ,[I_PKG]
     ,[I_OLID]
     ,[DATE]
     ,[CUSTOMER]
     ,[I_FPRICE]
     ,[I_PL]
     ,[ORIG_QTY]
     ,[ORIG_AMT]
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
     ,mySource.[ITEM]
     ,mySource.[I_OQTY]
     ,mySource.[I_CQTY]
     ,mySource.[I_OTT_QTY]
     ,mySource.[I_OTF_QTY]
     ,mySource.[I_OQTY_TOT]
     ,mySource.[I_PT]
     ,mySource.[I_PRICE]
     ,mySource.[I_DISC]
     ,mySource.[I_DAMT]
     ,mySource.[I_CHG]
     ,mySource.[I_CPRICE]
     ,mySource.[I_CPAYQ]
     ,mySource.[I_DATE]
     ,mySource.[I_DISP]
     ,mySource.[I_ACUST]
     ,mySource.[I_BPTYPE]
     ,mySource.[E_STAT]
     ,mySource.[I_STOCK]
     ,mySource.[TOTAL_IPAY]
     ,mySource.[TOTAL_CPAY]
     ,mySource.[TOTAL_FPAY]
     ,mySource.[SALECODE]
     ,mySource.[I_O_ITEM]
     ,mySource.[I_O_PT]
     ,mySource.[INREFSOURCE]
     ,mySource.[INREFDATA]
     ,mySource.[I_PROMO]
     ,mySource.[I_SCHG]
     ,mySource.[I_SCAMT]
     ,mySource.[TOTAL_SPAY]
     ,mySource.[I_PKG]
     ,mySource.[I_OLID]
     ,mySource.[DATE]
     ,mySource.[CUSTOMER]
     ,mySource.[I_FPRICE]
     ,mySource.[I_PL]
     ,mySource.[ORIG_QTY]
     ,mySource.[ORIG_AMT]
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
