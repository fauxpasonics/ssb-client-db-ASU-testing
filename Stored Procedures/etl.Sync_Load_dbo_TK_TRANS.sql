SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[Sync_Load_dbo_TK_TRANS]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Sync_TI_TK_TRANS),'0');	

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_Sync_DeltaHashKey
,  ETLSID, SEASON, TRANS_NO, BATCH, TYPE, REF, DATE, DOCUMENT, CUSTOMER, O_AMT, PR_AMT, P_AMT, R_AMT, W_AMT, C_AMT, RR_AMT, P_DATE, PAYMODE, BALANCE, TERMINAL_ID, SOURCE, E_STAT, XFER_TO_SEASON, XFER_TO_TRANS_NO, XFER_FROM_SEASON, XFER_FROM_TRANS_NO, EXCH_OUT_SEASON, EXCH_OUT_TRANS_NO, EXCH_IN_SEASON, EXCH_IN_TRANS_NO, SALECODE, CONTROL, MP_FROM_SEASON, MP_FROM_TRANS_NO, MP_TO_SEASON, MP_TO_TRANS_NO, SH_OWNER_SEASON, SH_OWNER_TRANS_NO, SH_SELLER_SEASON, SH_SELLER_TRANS_NO, LAST_TIME, LAST_USER, LAST_DATETIME, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
INTO #SrcData
FROM (
	SELECT  ETLSID, SEASON, TRANS_NO, BATCH, TYPE, REF, DATE, DOCUMENT, CUSTOMER, O_AMT, PR_AMT, P_AMT, R_AMT, W_AMT, C_AMT, RR_AMT, P_DATE, PAYMODE, BALANCE, TERMINAL_ID, SOURCE, E_STAT, XFER_TO_SEASON, XFER_TO_TRANS_NO, XFER_FROM_SEASON, XFER_FROM_TRANS_NO, EXCH_OUT_SEASON, EXCH_OUT_TRANS_NO, EXCH_IN_SEASON, EXCH_IN_TRANS_NO, SALECODE, CONTROL, MP_FROM_SEASON, MP_FROM_TRANS_NO, MP_TO_SEASON, MP_TO_TRANS_NO, SH_OWNER_SEASON, SH_OWNER_TRANS_NO, SH_SELLER_SEASON, SH_SELLER_TRANS_NO, LAST_TIME, LAST_USER, LAST_DATETIME, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
	, ROW_NUMBER() OVER(PARTITION BY SEASON,TRANS_NO ORDER BY ETL_Sync_Id) RowRank
	FROM src.Sync_TI_TK_TRANS
) a
WHERE RowRank = 1

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_Sync_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(25),BALANCE)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(BATCH),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),C_AMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONTROL),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CUSTOMER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),DATE)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(DOCUMENT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(E_STAT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),ETL_Sync_Id)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ETLSID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(EXCH_IN_SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),EXCH_IN_TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(EXCH_OUT_SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),EXCH_OUT_TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),EXPORT_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),LAST_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),LAST_TIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(LAST_USER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MP_FROM_SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),MP_FROM_TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MP_TO_SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),MP_TO_TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),O_AMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),P_AMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),P_DATE)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(PAYMODE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),PR_AMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),R_AMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(REF),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),RR_AMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SALECODE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SH_OWNER_SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),SH_OWNER_TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SH_SELLER_SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),SH_SELLER_TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SOURCE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SOURCE_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(TERMINAL_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(TYPE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),W_AMT)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(XFER_FROM_SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),XFER_FROM_TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(XFER_TO_SEASON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),XFER_TO_TRANS_NO)),'DBNULL_BIGINT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ZID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_Sync_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (SEASON,TRANS_NO)
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL_Sync_DeltaHashKey)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE dbo.TK_TRANS AS myTarget

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
     ,myTarget.[BATCH] = mySource.[BATCH]
     ,myTarget.[TYPE] = mySource.[TYPE]
     ,myTarget.[REF] = mySource.[REF]
     ,myTarget.[DATE] = mySource.[DATE]
     ,myTarget.[DOCUMENT] = mySource.[DOCUMENT]
     ,myTarget.[CUSTOMER] = mySource.[CUSTOMER]
     ,myTarget.[O_AMT] = mySource.[O_AMT]
     ,myTarget.[PR_AMT] = mySource.[PR_AMT]
     ,myTarget.[P_AMT] = mySource.[P_AMT]
     ,myTarget.[R_AMT] = mySource.[R_AMT]
     ,myTarget.[W_AMT] = mySource.[W_AMT]
     ,myTarget.[C_AMT] = mySource.[C_AMT]
     ,myTarget.[RR_AMT] = mySource.[RR_AMT]
     ,myTarget.[P_DATE] = mySource.[P_DATE]
     ,myTarget.[PAYMODE] = mySource.[PAYMODE]
     ,myTarget.[BALANCE] = mySource.[BALANCE]
     ,myTarget.[TERMINAL_ID] = mySource.[TERMINAL_ID]
     ,myTarget.[SOURCE] = mySource.[SOURCE]
     ,myTarget.[E_STAT] = mySource.[E_STAT]
     ,myTarget.[XFER_TO_SEASON] = mySource.[XFER_TO_SEASON]
     ,myTarget.[XFER_TO_TRANS_NO] = mySource.[XFER_TO_TRANS_NO]
     ,myTarget.[XFER_FROM_SEASON] = mySource.[XFER_FROM_SEASON]
     ,myTarget.[XFER_FROM_TRANS_NO] = mySource.[XFER_FROM_TRANS_NO]
     ,myTarget.[EXCH_OUT_SEASON] = mySource.[EXCH_OUT_SEASON]
     ,myTarget.[EXCH_OUT_TRANS_NO] = mySource.[EXCH_OUT_TRANS_NO]
     ,myTarget.[EXCH_IN_SEASON] = mySource.[EXCH_IN_SEASON]
     ,myTarget.[EXCH_IN_TRANS_NO] = mySource.[EXCH_IN_TRANS_NO]
     ,myTarget.[SALECODE] = mySource.[SALECODE]
     ,myTarget.[CONTROL] = mySource.[CONTROL]
     ,myTarget.[MP_FROM_SEASON] = mySource.[MP_FROM_SEASON]
     ,myTarget.[MP_FROM_TRANS_NO] = mySource.[MP_FROM_TRANS_NO]
     ,myTarget.[MP_TO_SEASON] = mySource.[MP_TO_SEASON]
     ,myTarget.[MP_TO_TRANS_NO] = mySource.[MP_TO_TRANS_NO]
     ,myTarget.[SH_OWNER_SEASON] = mySource.[SH_OWNER_SEASON]
     ,myTarget.[SH_OWNER_TRANS_NO] = mySource.[SH_OWNER_TRANS_NO]
     ,myTarget.[SH_SELLER_SEASON] = mySource.[SH_SELLER_SEASON]
     ,myTarget.[SH_SELLER_TRANS_NO] = mySource.[SH_SELLER_TRANS_NO]
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
     ,[BATCH]
     ,[TYPE]
     ,[REF]
     ,[DATE]
     ,[DOCUMENT]
     ,[CUSTOMER]
     ,[O_AMT]
     ,[PR_AMT]
     ,[P_AMT]
     ,[R_AMT]
     ,[W_AMT]
     ,[C_AMT]
     ,[RR_AMT]
     ,[P_DATE]
     ,[PAYMODE]
     ,[BALANCE]
     ,[TERMINAL_ID]
     ,[SOURCE]
     ,[E_STAT]
     ,[XFER_TO_SEASON]
     ,[XFER_TO_TRANS_NO]
     ,[XFER_FROM_SEASON]
     ,[XFER_FROM_TRANS_NO]
     ,[EXCH_OUT_SEASON]
     ,[EXCH_OUT_TRANS_NO]
     ,[EXCH_IN_SEASON]
     ,[EXCH_IN_TRANS_NO]
     ,[SALECODE]
     ,[CONTROL]
     ,[MP_FROM_SEASON]
     ,[MP_FROM_TRANS_NO]
     ,[MP_TO_SEASON]
     ,[MP_TO_TRANS_NO]
     ,[SH_OWNER_SEASON]
     ,[SH_OWNER_TRANS_NO]
     ,[SH_SELLER_SEASON]
     ,[SH_SELLER_TRANS_NO]
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
     ,mySource.[BATCH]
     ,mySource.[TYPE]
     ,mySource.[REF]
     ,mySource.[DATE]
     ,mySource.[DOCUMENT]
     ,mySource.[CUSTOMER]
     ,mySource.[O_AMT]
     ,mySource.[PR_AMT]
     ,mySource.[P_AMT]
     ,mySource.[R_AMT]
     ,mySource.[W_AMT]
     ,mySource.[C_AMT]
     ,mySource.[RR_AMT]
     ,mySource.[P_DATE]
     ,mySource.[PAYMODE]
     ,mySource.[BALANCE]
     ,mySource.[TERMINAL_ID]
     ,mySource.[SOURCE]
     ,mySource.[E_STAT]
     ,mySource.[XFER_TO_SEASON]
     ,mySource.[XFER_TO_TRANS_NO]
     ,mySource.[XFER_FROM_SEASON]
     ,mySource.[XFER_FROM_TRANS_NO]
     ,mySource.[EXCH_OUT_SEASON]
     ,mySource.[EXCH_OUT_TRANS_NO]
     ,mySource.[EXCH_IN_SEASON]
     ,mySource.[EXCH_IN_TRANS_NO]
     ,mySource.[SALECODE]
     ,mySource.[CONTROL]
     ,mySource.[MP_FROM_SEASON]
     ,mySource.[MP_FROM_TRANS_NO]
     ,mySource.[MP_TO_SEASON]
     ,mySource.[MP_TO_TRANS_NO]
     ,mySource.[SH_OWNER_SEASON]
     ,mySource.[SH_OWNER_TRANS_NO]
     ,mySource.[SH_SELLER_SEASON]
     ,mySource.[SH_SELLER_TRANS_NO]
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
