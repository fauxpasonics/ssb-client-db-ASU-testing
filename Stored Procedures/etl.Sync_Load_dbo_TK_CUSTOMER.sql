SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [etl].[Sync_Load_dbo_TK_CUSTOMER]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Sync_TI_TK_CUSTOMER),'0');	

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_Sync_DeltaHashKey
,  ETLSID, CUSTOMER, M_ADTYPE, B_ADTYPE, SEASONS, COMMENTS, C_PRIORITY, TYPE, DEPARTMENT, SG_NUMBER, STATUS, AR_NUMBER, BALANCE, EXTERNAL_NUMBER, TAGS, BASIS, MP_ACCESS, UD1, UD2, UD3, UD4, UD5, UD6, UD7, UD8, LAST_USER, LAST_DATETIME, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
INTO #SrcData
FROM (
	SELECT  ETLSID, CUSTOMER, M_ADTYPE, B_ADTYPE, SEASONS, COMMENTS, C_PRIORITY, TYPE, DEPARTMENT, SG_NUMBER, STATUS, AR_NUMBER, BALANCE, EXTERNAL_NUMBER, TAGS, BASIS, MP_ACCESS, UD1, UD2, UD3, UD4, UD5, UD6, UD7, UD8, LAST_USER, LAST_DATETIME, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
	, ROW_NUMBER() OVER(PARTITION BY CUSTOMER ORDER BY ETL_Sync_Id) RowRank
	FROM src.Sync_TI_TK_CUSTOMER
) a
WHERE RowRank = 1

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_Sync_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(AR_NUMBER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(B_ADTYPE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),BALANCE)),'DBNULL_NUMBER') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(BASIS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(C_PRIORITY),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(COMMENTS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CUSTOMER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(DEPARTMENT),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),ETL_Sync_Id)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ETLSID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),EXPORT_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(EXTERNAL_NUMBER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),LAST_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(LAST_USER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(M_ADTYPE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MP_ACCESS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SEASONS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SG_NUMBER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SOURCE_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(STATUS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(TAGS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(TYPE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD1),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD2),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD3),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD4),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD5),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD6),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD7),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD8),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ZID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_Sync_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (CUSTOMER)
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL_Sync_DeltaHashKey)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE dbo.TK_CUSTOMER AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.CUSTOMER = mySource.CUSTOMER

WHEN MATCHED AND (
     ISNULL(mySource.ETL_Sync_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_Sync_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETLSID] = mySource.[ETLSID]
     ,myTarget.[CUSTOMER] = mySource.[CUSTOMER]
     ,myTarget.[M_ADTYPE] = mySource.[M_ADTYPE]
     ,myTarget.[B_ADTYPE] = mySource.[B_ADTYPE]
     ,myTarget.[SEASONS] = mySource.[SEASONS]
     ,myTarget.[COMMENTS] = mySource.[COMMENTS]
     ,myTarget.[C_PRIORITY] = mySource.[C_PRIORITY]
     ,myTarget.[TYPE] = mySource.[TYPE]
     ,myTarget.[DEPARTMENT] = mySource.[DEPARTMENT]
     ,myTarget.[SG_NUMBER] = mySource.[SG_NUMBER]
     ,myTarget.[STATUS] = mySource.[STATUS]
     ,myTarget.[AR_NUMBER] = mySource.[AR_NUMBER]
     ,myTarget.[BALANCE] = mySource.[BALANCE]
     ,myTarget.[EXTERNAL_NUMBER] = mySource.[EXTERNAL_NUMBER]
     ,myTarget.[TAGS] = mySource.[TAGS]
     ,myTarget.[BASIS] = mySource.[BASIS]
     ,myTarget.[MP_ACCESS] = mySource.[MP_ACCESS]
     ,myTarget.[UD1] = mySource.[UD1]
     ,myTarget.[UD2] = mySource.[UD2]
     ,myTarget.[UD3] = mySource.[UD3]
     ,myTarget.[UD4] = mySource.[UD4]
     ,myTarget.[UD5] = mySource.[UD5]
     ,myTarget.[UD6] = mySource.[UD6]
     ,myTarget.[UD7] = mySource.[UD7]
     ,myTarget.[UD8] = mySource.[UD8]
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
     ,[CUSTOMER]
     ,[M_ADTYPE]
     ,[B_ADTYPE]
     ,[SEASONS]
     ,[COMMENTS]
     ,[C_PRIORITY]
     ,[TYPE]
     ,[DEPARTMENT]
     ,[SG_NUMBER]
     ,[STATUS]
     ,[AR_NUMBER]
     ,[BALANCE]
     ,[EXTERNAL_NUMBER]
     ,[TAGS]
     ,[BASIS]
     ,[MP_ACCESS]
     ,[UD1]
     ,[UD2]
     ,[UD3]
     ,[UD4]
     ,[UD5]
     ,[UD6]
     ,[UD7]
     ,[UD8]
     ,[LAST_USER]
     ,[LAST_DATETIME]
     ,[ZID]
     ,[SOURCE_ID]
     ,[EXPORT_DATETIME]
     ,[ETL_Sync_DeltaHashKey]
     )
VALUES
     (mySource.[ETLSID]
     ,mySource.[CUSTOMER]
     ,mySource.[M_ADTYPE]
     ,mySource.[B_ADTYPE]
     ,mySource.[SEASONS]
     ,mySource.[COMMENTS]
     ,mySource.[C_PRIORITY]
     ,mySource.[TYPE]
     ,mySource.[DEPARTMENT]
     ,mySource.[SG_NUMBER]
     ,mySource.[STATUS]
     ,mySource.[AR_NUMBER]
     ,mySource.[BALANCE]
     ,mySource.[EXTERNAL_NUMBER]
     ,mySource.[TAGS]
     ,mySource.[BASIS]
     ,mySource.[MP_ACCESS]
     ,mySource.[UD1]
     ,mySource.[UD2]
     ,mySource.[UD3]
     ,mySource.[UD4]
     ,mySource.[UD5]
     ,mySource.[UD6]
     ,mySource.[UD7]
     ,mySource.[UD8]
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
