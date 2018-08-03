SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[Sync_Load_dbo_TK_ODET]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Sync_TI_TK_ODET),'0');	

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_Sync_DeltaHashKey
,  ETLSID, SEASON, CUSTOMER, SEQ, ITEM, I_DATE, I_OQTY, I_PT, I_PRICE, I_DISC, I_DAMT, I_PAY_MODE, ITEM_DELIVERY_ID, I_GCDOC, I_PRQTY, I_PL, I_BAL, I_PAY, I_PAYQ, LOCATION_PREF, I_SPECIAL, I_MARK, I_DISP, I_GROUP, I_ACUST, I_PRI, I_DMETH, I_FPRICE, I_NOTE, I_ATYPE, I_BPTYPE, PROMO, ITEM_PREF, TAG, I_CHG, I_CPRICE, I_CPAY, I_FPAY, INREFSOURCE, INREFDATA, I_SCHG, I_SCAMT, I_SCPAY, ORIG_SALECODE, ORIGTS_USER, ORIGTS_DATETIME, I_PKG, E_SBLS_1, LAST_USER, LAST_DATETIME, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
INTO #SrcData
FROM (
	SELECT  ETLSID, SEASON, CUSTOMER, SEQ, ITEM, I_DATE, I_OQTY, I_PT, I_PRICE, I_DISC, I_DAMT, I_PAY_MODE, ITEM_DELIVERY_ID, I_GCDOC, I_PRQTY, I_PL, I_BAL, I_PAY, I_PAYQ, LOCATION_PREF, I_SPECIAL, I_MARK, I_DISP, I_GROUP, I_ACUST, I_PRI, I_DMETH, I_FPRICE, I_NOTE, I_ATYPE, I_BPTYPE, PROMO, ITEM_PREF, TAG, I_CHG, I_CPRICE, I_CPAY, I_FPAY, INREFSOURCE, INREFDATA, I_SCHG, I_SCAMT, I_SCPAY, ORIG_SALECODE, ORIGTS_USER, ORIGTS_DATETIME, I_PKG, E_SBLS_1, LAST_USER, LAST_DATETIME, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
	, ROW_NUMBER() OVER(PARTITION BY SEASON,CUSTOMER,SEQ ORDER BY ETL_Sync_Id) RowRank
	FROM src.Sync_TI_TK_ODET
) a
WHERE RowRank = 1

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_Sync_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CUSTOMER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(E_SBLS_1),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),ETL_Sync_Id)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ETLSID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),EXPORT_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_ACUST),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_ATYPE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_BAL)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_BPTYPE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_CHG),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_CPAY)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_CPRICE)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_DAMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_DATE)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_DISC),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_DISP),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_DMETH),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_FPAY)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_FPRICE)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_GCDOC),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_GROUP),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_MARK),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_NOTE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),I_OQTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_PAY)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_PAY_MODE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),I_PAYQ)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_PKG),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_PL),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_PRI),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_PRICE)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),I_PRQTY)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_PT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_SCAMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_SCHG),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),I_SCPAY)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(I_SPECIAL),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(INREFDATA),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(INREFSOURCE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ITEM),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ITEM_DELIVERY_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ITEM_PREF),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),LAST_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(LAST_USER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(LOCATION_PREF),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ORIG_SALECODE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),ORIGTS_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ORIGTS_USER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(PROMO),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),SEQ)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SOURCE_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(TAG),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ZID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_Sync_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (SEASON,CUSTOMER,SEQ)
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL_Sync_DeltaHashKey)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE dbo.TK_ODET AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.CUSTOMER = mySource.CUSTOMER and myTarget.SEASON = mySource.SEASON and myTarget.SEQ = mySource.SEQ

WHEN MATCHED AND (
     ISNULL(mySource.ETL_Sync_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_Sync_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETLSID] = mySource.[ETLSID]
     ,myTarget.[SEASON] = mySource.[SEASON]
     ,myTarget.[CUSTOMER] = mySource.[CUSTOMER]
     ,myTarget.[SEQ] = mySource.[SEQ]
     ,myTarget.[ITEM] = mySource.[ITEM]
     ,myTarget.[I_DATE] = mySource.[I_DATE]
     ,myTarget.[I_OQTY] = mySource.[I_OQTY]
     ,myTarget.[I_PT] = mySource.[I_PT]
     ,myTarget.[I_PRICE] = mySource.[I_PRICE]
     ,myTarget.[I_DISC] = mySource.[I_DISC]
     ,myTarget.[I_DAMT] = mySource.[I_DAMT]
     ,myTarget.[I_PAY_MODE] = mySource.[I_PAY_MODE]
     ,myTarget.[ITEM_DELIVERY_ID] = mySource.[ITEM_DELIVERY_ID]
     ,myTarget.[I_GCDOC] = mySource.[I_GCDOC]
     ,myTarget.[I_PRQTY] = mySource.[I_PRQTY]
     ,myTarget.[I_PL] = mySource.[I_PL]
     ,myTarget.[I_BAL] = mySource.[I_BAL]
     ,myTarget.[I_PAY] = mySource.[I_PAY]
     ,myTarget.[I_PAYQ] = mySource.[I_PAYQ]
     ,myTarget.[LOCATION_PREF] = mySource.[LOCATION_PREF]
     ,myTarget.[I_SPECIAL] = mySource.[I_SPECIAL]
     ,myTarget.[I_MARK] = mySource.[I_MARK]
     ,myTarget.[I_DISP] = mySource.[I_DISP]
     ,myTarget.[I_GROUP] = mySource.[I_GROUP]
     ,myTarget.[I_ACUST] = mySource.[I_ACUST]
     ,myTarget.[I_PRI] = mySource.[I_PRI]
     ,myTarget.[I_DMETH] = mySource.[I_DMETH]
     ,myTarget.[I_FPRICE] = mySource.[I_FPRICE]
     ,myTarget.[I_NOTE] = mySource.[I_NOTE]
     ,myTarget.[I_ATYPE] = mySource.[I_ATYPE]
     ,myTarget.[I_BPTYPE] = mySource.[I_BPTYPE]
     ,myTarget.[PROMO] = mySource.[PROMO]
     ,myTarget.[ITEM_PREF] = mySource.[ITEM_PREF]
     ,myTarget.[TAG] = mySource.[TAG]
     ,myTarget.[I_CHG] = mySource.[I_CHG]
     ,myTarget.[I_CPRICE] = mySource.[I_CPRICE]
     ,myTarget.[I_CPAY] = mySource.[I_CPAY]
     ,myTarget.[I_FPAY] = mySource.[I_FPAY]
     ,myTarget.[INREFSOURCE] = mySource.[INREFSOURCE]
     ,myTarget.[INREFDATA] = mySource.[INREFDATA]
     ,myTarget.[I_SCHG] = mySource.[I_SCHG]
     ,myTarget.[I_SCAMT] = mySource.[I_SCAMT]
     ,myTarget.[I_SCPAY] = mySource.[I_SCPAY]
     ,myTarget.[ORIG_SALECODE] = mySource.[ORIG_SALECODE]
     ,myTarget.[ORIGTS_USER] = mySource.[ORIGTS_USER]
     ,myTarget.[ORIGTS_DATETIME] = mySource.[ORIGTS_DATETIME]
     ,myTarget.[I_PKG] = mySource.[I_PKG]
     ,myTarget.[E_SBLS_1] = mySource.[E_SBLS_1]
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
     ,[CUSTOMER]
     ,[SEQ]
     ,[ITEM]
     ,[I_DATE]
     ,[I_OQTY]
     ,[I_PT]
     ,[I_PRICE]
     ,[I_DISC]
     ,[I_DAMT]
     ,[I_PAY_MODE]
     ,[ITEM_DELIVERY_ID]
     ,[I_GCDOC]
     ,[I_PRQTY]
     ,[I_PL]
     ,[I_BAL]
     ,[I_PAY]
     ,[I_PAYQ]
     ,[LOCATION_PREF]
     ,[I_SPECIAL]
     ,[I_MARK]
     ,[I_DISP]
     ,[I_GROUP]
     ,[I_ACUST]
     ,[I_PRI]
     ,[I_DMETH]
     ,[I_FPRICE]
     ,[I_NOTE]
     ,[I_ATYPE]
     ,[I_BPTYPE]
     ,[PROMO]
     ,[ITEM_PREF]
     ,[TAG]
     ,[I_CHG]
     ,[I_CPRICE]
     ,[I_CPAY]
     ,[I_FPAY]
     ,[INREFSOURCE]
     ,[INREFDATA]
     ,[I_SCHG]
     ,[I_SCAMT]
     ,[I_SCPAY]
     ,[ORIG_SALECODE]
     ,[ORIGTS_USER]
     ,[ORIGTS_DATETIME]
     ,[I_PKG]
     ,[E_SBLS_1]
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
     ,mySource.[CUSTOMER]
     ,mySource.[SEQ]
     ,mySource.[ITEM]
     ,mySource.[I_DATE]
     ,mySource.[I_OQTY]
     ,mySource.[I_PT]
     ,mySource.[I_PRICE]
     ,mySource.[I_DISC]
     ,mySource.[I_DAMT]
     ,mySource.[I_PAY_MODE]
     ,mySource.[ITEM_DELIVERY_ID]
     ,mySource.[I_GCDOC]
     ,mySource.[I_PRQTY]
     ,mySource.[I_PL]
     ,mySource.[I_BAL]
     ,mySource.[I_PAY]
     ,mySource.[I_PAYQ]
     ,mySource.[LOCATION_PREF]
     ,mySource.[I_SPECIAL]
     ,mySource.[I_MARK]
     ,mySource.[I_DISP]
     ,mySource.[I_GROUP]
     ,mySource.[I_ACUST]
     ,mySource.[I_PRI]
     ,mySource.[I_DMETH]
     ,mySource.[I_FPRICE]
     ,mySource.[I_NOTE]
     ,mySource.[I_ATYPE]
     ,mySource.[I_BPTYPE]
     ,mySource.[PROMO]
     ,mySource.[ITEM_PREF]
     ,mySource.[TAG]
     ,mySource.[I_CHG]
     ,mySource.[I_CPRICE]
     ,mySource.[I_CPAY]
     ,mySource.[I_FPAY]
     ,mySource.[INREFSOURCE]
     ,mySource.[INREFDATA]
     ,mySource.[I_SCHG]
     ,mySource.[I_SCAMT]
     ,mySource.[I_SCPAY]
     ,mySource.[ORIG_SALECODE]
     ,mySource.[ORIGTS_USER]
     ,mySource.[ORIGTS_DATETIME]
     ,mySource.[I_PKG]
     ,mySource.[E_SBLS_1]
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
