SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[Sync_Load_dbo_TK_TRANS_MP]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Sync_TI_TK_TRANS_MP),'0');	

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_Sync_DeltaHashKey
,  ETLSID, SEASON, TRANS_NO, DATE, CUSTOMER, SALECODE, MP_FROM_SEASON, MP_FROM_TRANS_NO, MP_TO_SEASON, MP_TO_TRANS_NO, SH_OWNER_SEASON, SH_OWNER_TRANS_NO, SH_SELLER_SEASON, SH_SELLER_TRANS_NO, MP_BOCHG, MP_BUY_AMT, MP_BUY_NET, MP_BUYER, MP_DIFF, MP_DMETH_TYPE, MP_EVENT, MP_NETITEM, MP_OWNER, MP_QTY, MP_SBLS, MP_SELLCR, MP_SELLER, MP_SELLTIXAMT, MP_SHPAID, MP_SOCHG, MP_TIXAMT, MP_PL, LAST_TIME, LAST_USER, LAST_DATETIME, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
INTO #SrcData
FROM (
	SELECT  ETLSID, SEASON, TRANS_NO, DATE, CUSTOMER, SALECODE, MP_FROM_SEASON, MP_FROM_TRANS_NO, MP_TO_SEASON, MP_TO_TRANS_NO, SH_OWNER_SEASON, SH_OWNER_TRANS_NO, SH_SELLER_SEASON, SH_SELLER_TRANS_NO, MP_BOCHG, MP_BUY_AMT, MP_BUY_NET, MP_BUYER, MP_DIFF, MP_DMETH_TYPE, MP_EVENT, MP_NETITEM, MP_OWNER, MP_QTY, MP_SBLS, MP_SELLCR, MP_SELLER, MP_SELLTIXAMT, MP_SHPAID, MP_SOCHG, MP_TIXAMT, MP_PL, LAST_TIME, LAST_USER, LAST_DATETIME, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
	, ROW_NUMBER() OVER(PARTITION BY SEASON,TRANS_NO ORDER BY ETL_Sync_Id) RowRank
	FROM src.Sync_TI_TK_TRANS_MP
) a
WHERE RowRank = 1

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_Sync_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CUSTOMER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),DATE)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),ETL_Sync_Id)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ETLSID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),EXPORT_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),LAST_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),LAST_TIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(LAST_USER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),MP_BOCHG)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),MP_BUY_AMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),MP_BUY_NET)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MP_BUYER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),MP_DIFF)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MP_DMETH_TYPE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MP_EVENT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MP_FROM_SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),MP_FROM_TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MP_NETITEM),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MP_OWNER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MP_PL),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),MP_QTY)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MP_SBLS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),MP_SELLCR)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MP_SELLER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),MP_SELLTIXAMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MP_SHPAID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),MP_SOCHG)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),MP_TIXAMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MP_TO_SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),MP_TO_TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SALECODE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SH_OWNER_SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),SH_OWNER_TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SH_SELLER_SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),SH_SELLER_TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SOURCE_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ZID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_Sync_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (SEASON,TRANS_NO)
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL_Sync_DeltaHashKey)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE dbo.TK_TRANS_MP AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.SEASON = mySource.SEASON and myTarget.TRANS_NO = mySource.TRANS_NO

WHEN MATCHED AND (
     ISNULL(mySource.ETL_Sync_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_Sync_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETLSID] = mySource.[ETLSID]
     ,myTarget.[SEASON] = mySource.[SEASON]
     ,myTarget.[TRANS_NO] = mySource.[TRANS_NO]
     ,myTarget.[DATE] = mySource.[DATE]
     ,myTarget.[CUSTOMER] = mySource.[CUSTOMER]
     ,myTarget.[SALECODE] = mySource.[SALECODE]
     ,myTarget.[MP_FROM_SEASON] = mySource.[MP_FROM_SEASON]
     ,myTarget.[MP_FROM_TRANS_NO] = mySource.[MP_FROM_TRANS_NO]
     ,myTarget.[MP_TO_SEASON] = mySource.[MP_TO_SEASON]
     ,myTarget.[MP_TO_TRANS_NO] = mySource.[MP_TO_TRANS_NO]
     ,myTarget.[SH_OWNER_SEASON] = mySource.[SH_OWNER_SEASON]
     ,myTarget.[SH_OWNER_TRANS_NO] = mySource.[SH_OWNER_TRANS_NO]
     ,myTarget.[SH_SELLER_SEASON] = mySource.[SH_SELLER_SEASON]
     ,myTarget.[SH_SELLER_TRANS_NO] = mySource.[SH_SELLER_TRANS_NO]
     ,myTarget.[MP_BOCHG] = mySource.[MP_BOCHG]
     ,myTarget.[MP_BUY_AMT] = mySource.[MP_BUY_AMT]
     ,myTarget.[MP_BUY_NET] = mySource.[MP_BUY_NET]
     ,myTarget.[MP_BUYER] = mySource.[MP_BUYER]
     ,myTarget.[MP_DIFF] = mySource.[MP_DIFF]
     ,myTarget.[MP_DMETH_TYPE] = mySource.[MP_DMETH_TYPE]
     ,myTarget.[MP_EVENT] = mySource.[MP_EVENT]
     ,myTarget.[MP_NETITEM] = mySource.[MP_NETITEM]
     ,myTarget.[MP_OWNER] = mySource.[MP_OWNER]
     ,myTarget.[MP_QTY] = mySource.[MP_QTY]
     ,myTarget.[MP_SBLS] = mySource.[MP_SBLS]
     ,myTarget.[MP_SELLCR] = mySource.[MP_SELLCR]
     ,myTarget.[MP_SELLER] = mySource.[MP_SELLER]
     ,myTarget.[MP_SELLTIXAMT] = mySource.[MP_SELLTIXAMT]
     ,myTarget.[MP_SHPAID] = mySource.[MP_SHPAID]
     ,myTarget.[MP_SOCHG] = mySource.[MP_SOCHG]
     ,myTarget.[MP_TIXAMT] = mySource.[MP_TIXAMT]
     ,myTarget.[MP_PL] = mySource.[MP_PL]
     ,myTarget.[LAST_TIME] = mySource.[LAST_TIME]
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
     ,[TRANS_NO]
     ,[DATE]
     ,[CUSTOMER]
     ,[SALECODE]
     ,[MP_FROM_SEASON]
     ,[MP_FROM_TRANS_NO]
     ,[MP_TO_SEASON]
     ,[MP_TO_TRANS_NO]
     ,[SH_OWNER_SEASON]
     ,[SH_OWNER_TRANS_NO]
     ,[SH_SELLER_SEASON]
     ,[SH_SELLER_TRANS_NO]
     ,[MP_BOCHG]
     ,[MP_BUY_AMT]
     ,[MP_BUY_NET]
     ,[MP_BUYER]
     ,[MP_DIFF]
     ,[MP_DMETH_TYPE]
     ,[MP_EVENT]
     ,[MP_NETITEM]
     ,[MP_OWNER]
     ,[MP_QTY]
     ,[MP_SBLS]
     ,[MP_SELLCR]
     ,[MP_SELLER]
     ,[MP_SELLTIXAMT]
     ,[MP_SHPAID]
     ,[MP_SOCHG]
     ,[MP_TIXAMT]
     ,[MP_PL]
     ,[LAST_TIME]
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
     ,mySource.[TRANS_NO]
     ,mySource.[DATE]
     ,mySource.[CUSTOMER]
     ,mySource.[SALECODE]
     ,mySource.[MP_FROM_SEASON]
     ,mySource.[MP_FROM_TRANS_NO]
     ,mySource.[MP_TO_SEASON]
     ,mySource.[MP_TO_TRANS_NO]
     ,mySource.[SH_OWNER_SEASON]
     ,mySource.[SH_OWNER_TRANS_NO]
     ,mySource.[SH_SELLER_SEASON]
     ,mySource.[SH_SELLER_TRANS_NO]
     ,mySource.[MP_BOCHG]
     ,mySource.[MP_BUY_AMT]
     ,mySource.[MP_BUY_NET]
     ,mySource.[MP_BUYER]
     ,mySource.[MP_DIFF]
     ,mySource.[MP_DMETH_TYPE]
     ,mySource.[MP_EVENT]
     ,mySource.[MP_NETITEM]
     ,mySource.[MP_OWNER]
     ,mySource.[MP_QTY]
     ,mySource.[MP_SBLS]
     ,mySource.[MP_SELLCR]
     ,mySource.[MP_SELLER]
     ,mySource.[MP_SELLTIXAMT]
     ,mySource.[MP_SHPAID]
     ,mySource.[MP_SOCHG]
     ,mySource.[MP_TIXAMT]
     ,mySource.[MP_PL]
     ,mySource.[LAST_TIME]
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
