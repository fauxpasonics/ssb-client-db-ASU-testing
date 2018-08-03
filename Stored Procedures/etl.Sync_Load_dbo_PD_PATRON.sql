SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[Sync_Load_dbo_PD_PATRON]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Sync_TI_PD_PATRON),'0');	

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_Sync_DeltaHashKey
,  ETLSID, PATRON, NAME, SUFFIX, TITLE, NAME2, SUFFIX2, TITLE2, STATUS, MAIL_NAME, VIP, EXTERNAL_NUMBER, COMMENTS, TAG, RELEASE, SOURCE, MARITAL_STATUS, INTERNET_PROFILE, MAGSTRIPE_ID, ENTRY_USER, ENTRY_DATETIME, HOUSEHOLD_INCOME, NICKNAME1, NICKNAME2, MAIDEN1, MAIDEN2, GENDER1, GENDER2, ETHNIC1, ETHNIC2, RELIGION1, RELIGION2, BIRTH_DATE1, BIRTH_DATE2, BIRTH_PLACE1, BIRTH_PLACE2, EV_EMAIL, LANGUAGE1, LANGUAGE2, KEYWORDS, UD1, UD2, UD3, UD4, UD5, UD6, UD7, UD8, UD9, UD10, UD11, UD12, UD13, UD14, UD15, UD16, EMAIL_OK, MERGED, LAST_USER, LAST_DATETIME, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
INTO #SrcData
FROM (
	SELECT  ETLSID, PATRON, NAME, SUFFIX, TITLE, NAME2, SUFFIX2, TITLE2, STATUS, MAIL_NAME, VIP, EXTERNAL_NUMBER, COMMENTS, TAG, RELEASE, SOURCE, MARITAL_STATUS, INTERNET_PROFILE, MAGSTRIPE_ID, ENTRY_USER, ENTRY_DATETIME, HOUSEHOLD_INCOME, NICKNAME1, NICKNAME2, MAIDEN1, MAIDEN2, GENDER1, GENDER2, ETHNIC1, ETHNIC2, RELIGION1, RELIGION2, BIRTH_DATE1, BIRTH_DATE2, BIRTH_PLACE1, BIRTH_PLACE2, EV_EMAIL, LANGUAGE1, LANGUAGE2, KEYWORDS, UD1, UD2, UD3, UD4, UD5, UD6, UD7, UD8, UD9, UD10, UD11, UD12, UD13, UD14, UD15, UD16, EMAIL_OK, MERGED, LAST_USER, LAST_DATETIME, ZID, SOURCE_ID, EXPORT_DATETIME, ETL_Sync_Id
	, ROW_NUMBER() OVER(PARTITION BY PATRON ORDER BY ETL_Sync_Id) RowRank
	FROM src.Sync_TI_PD_PATRON
) a
WHERE RowRank = 1

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_Sync_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(25),BIRTH_DATE1)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),BIRTH_DATE2)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(BIRTH_PLACE1),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(BIRTH_PLACE2),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(COMMENTS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(EMAIL_OK),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),ENTRY_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ENTRY_USER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ETHNIC1),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ETHNIC2),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(10),ETL_Sync_Id)),'DBNULL_INT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ETLSID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(EV_EMAIL),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),EXPORT_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(EXTERNAL_NUMBER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(GENDER1),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(GENDER2),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(HOUSEHOLD_INCOME),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(INTERNET_PROFILE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(KEYWORDS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(LANGUAGE1),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(LANGUAGE2),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(CONVERT(varchar(25),LAST_DATETIME)),'DBNULL_DATETIME') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(LAST_USER),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MAGSTRIPE_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MAIDEN1),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MAIDEN2),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MAIL_NAME),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MARITAL_STATUS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(MERGED),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(NAME),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(NAME2),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(NICKNAME1),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(NICKNAME2),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(PATRON),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(RELEASE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(RELIGION1),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(RELIGION2),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SOURCE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SOURCE_ID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(STATUS),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SUFFIX),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SUFFIX2),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(TAG),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(TITLE),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(TITLE2),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD1),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD10),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD11),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD12),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD13),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD14),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD15),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD16),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD2),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD3),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD4),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD5),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD6),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD7),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD8),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(UD9),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(VIP),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(ZID),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_Sync_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (PATRON)
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL_Sync_DeltaHashKey)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE dbo.PD_PATRON AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.PATRON = mySource.PATRON

WHEN MATCHED AND (
     ISNULL(mySource.ETL_Sync_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_Sync_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETLSID] = mySource.[ETLSID]
     ,myTarget.[PATRON] = mySource.[PATRON]
     ,myTarget.[NAME] = mySource.[NAME]
     ,myTarget.[SUFFIX] = mySource.[SUFFIX]
     ,myTarget.[TITLE] = mySource.[TITLE]
     ,myTarget.[NAME2] = mySource.[NAME2]
     ,myTarget.[SUFFIX2] = mySource.[SUFFIX2]
     ,myTarget.[TITLE2] = mySource.[TITLE2]
     ,myTarget.[STATUS] = mySource.[STATUS]
     ,myTarget.[MAIL_NAME] = mySource.[MAIL_NAME]
     ,myTarget.[VIP] = mySource.[VIP]
     ,myTarget.[EXTERNAL_NUMBER] = mySource.[EXTERNAL_NUMBER]
     ,myTarget.[COMMENTS] = mySource.[COMMENTS]
     ,myTarget.[TAG] = mySource.[TAG]
     ,myTarget.[RELEASE] = mySource.[RELEASE]
     ,myTarget.[SOURCE] = mySource.[SOURCE]
     ,myTarget.[MARITAL_STATUS] = mySource.[MARITAL_STATUS]
     ,myTarget.[INTERNET_PROFILE] = mySource.[INTERNET_PROFILE]
     ,myTarget.[MAGSTRIPE_ID] = mySource.[MAGSTRIPE_ID]
     ,myTarget.[ENTRY_USER] = mySource.[ENTRY_USER]
     ,myTarget.[ENTRY_DATETIME] = mySource.[ENTRY_DATETIME]
     ,myTarget.[HOUSEHOLD_INCOME] = mySource.[HOUSEHOLD_INCOME]
     ,myTarget.[NICKNAME1] = mySource.[NICKNAME1]
     ,myTarget.[NICKNAME2] = mySource.[NICKNAME2]
     ,myTarget.[MAIDEN1] = mySource.[MAIDEN1]
     ,myTarget.[MAIDEN2] = mySource.[MAIDEN2]
     ,myTarget.[GENDER1] = mySource.[GENDER1]
     ,myTarget.[GENDER2] = mySource.[GENDER2]
     ,myTarget.[ETHNIC1] = mySource.[ETHNIC1]
     ,myTarget.[ETHNIC2] = mySource.[ETHNIC2]
     ,myTarget.[RELIGION1] = mySource.[RELIGION1]
     ,myTarget.[RELIGION2] = mySource.[RELIGION2]
     ,myTarget.[BIRTH_DATE1] = mySource.[BIRTH_DATE1]
     ,myTarget.[BIRTH_DATE2] = mySource.[BIRTH_DATE2]
     ,myTarget.[BIRTH_PLACE1] = mySource.[BIRTH_PLACE1]
     ,myTarget.[BIRTH_PLACE2] = mySource.[BIRTH_PLACE2]
     ,myTarget.[EV_EMAIL] = mySource.[EV_EMAIL]
     ,myTarget.[LANGUAGE1] = mySource.[LANGUAGE1]
     ,myTarget.[LANGUAGE2] = mySource.[LANGUAGE2]
     ,myTarget.[KEYWORDS] = mySource.[KEYWORDS]
     ,myTarget.[UD1] = mySource.[UD1]
     ,myTarget.[UD2] = mySource.[UD2]
     ,myTarget.[UD3] = mySource.[UD3]
     ,myTarget.[UD4] = mySource.[UD4]
     ,myTarget.[UD5] = mySource.[UD5]
     ,myTarget.[UD6] = mySource.[UD6]
     ,myTarget.[UD7] = mySource.[UD7]
     ,myTarget.[UD8] = mySource.[UD8]
     ,myTarget.[UD9] = mySource.[UD9]
     ,myTarget.[UD10] = mySource.[UD10]
     ,myTarget.[UD11] = mySource.[UD11]
     ,myTarget.[UD12] = mySource.[UD12]
     ,myTarget.[UD13] = mySource.[UD13]
     ,myTarget.[UD14] = mySource.[UD14]
     ,myTarget.[UD15] = mySource.[UD15]
     ,myTarget.[UD16] = mySource.[UD16]
     ,myTarget.[EMAIL_OK] = mySource.[EMAIL_OK]
     ,myTarget.[MERGED] = mySource.[MERGED]
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
     ,[PATRON]
     ,[NAME]
     ,[SUFFIX]
     ,[TITLE]
     ,[NAME2]
     ,[SUFFIX2]
     ,[TITLE2]
     ,[STATUS]
     ,[MAIL_NAME]
     ,[VIP]
     ,[EXTERNAL_NUMBER]
     ,[COMMENTS]
     ,[TAG]
     ,[RELEASE]
     ,[SOURCE]
     ,[MARITAL_STATUS]
     ,[INTERNET_PROFILE]
     ,[MAGSTRIPE_ID]
     ,[ENTRY_USER]
     ,[ENTRY_DATETIME]
     ,[HOUSEHOLD_INCOME]
     ,[NICKNAME1]
     ,[NICKNAME2]
     ,[MAIDEN1]
     ,[MAIDEN2]
     ,[GENDER1]
     ,[GENDER2]
     ,[ETHNIC1]
     ,[ETHNIC2]
     ,[RELIGION1]
     ,[RELIGION2]
     ,[BIRTH_DATE1]
     ,[BIRTH_DATE2]
     ,[BIRTH_PLACE1]
     ,[BIRTH_PLACE2]
     ,[EV_EMAIL]
     ,[LANGUAGE1]
     ,[LANGUAGE2]
     ,[KEYWORDS]
     ,[UD1]
     ,[UD2]
     ,[UD3]
     ,[UD4]
     ,[UD5]
     ,[UD6]
     ,[UD7]
     ,[UD8]
     ,[UD9]
     ,[UD10]
     ,[UD11]
     ,[UD12]
     ,[UD13]
     ,[UD14]
     ,[UD15]
     ,[UD16]
     ,[EMAIL_OK]
     ,[MERGED]
     ,[LAST_USER]
     ,[LAST_DATETIME]
     ,[ZID]
     ,[SOURCE_ID]
     ,[EXPORT_DATETIME]
     ,[ETL_Sync_DeltaHashKey]
     )
VALUES
     (mySource.[ETLSID]
     ,mySource.[PATRON]
     ,mySource.[NAME]
     ,mySource.[SUFFIX]
     ,mySource.[TITLE]
     ,mySource.[NAME2]
     ,mySource.[SUFFIX2]
     ,mySource.[TITLE2]
     ,mySource.[STATUS]
     ,mySource.[MAIL_NAME]
     ,mySource.[VIP]
     ,mySource.[EXTERNAL_NUMBER]
     ,mySource.[COMMENTS]
     ,mySource.[TAG]
     ,mySource.[RELEASE]
     ,mySource.[SOURCE]
     ,mySource.[MARITAL_STATUS]
     ,mySource.[INTERNET_PROFILE]
     ,mySource.[MAGSTRIPE_ID]
     ,mySource.[ENTRY_USER]
     ,mySource.[ENTRY_DATETIME]
     ,mySource.[HOUSEHOLD_INCOME]
     ,mySource.[NICKNAME1]
     ,mySource.[NICKNAME2]
     ,mySource.[MAIDEN1]
     ,mySource.[MAIDEN2]
     ,mySource.[GENDER1]
     ,mySource.[GENDER2]
     ,mySource.[ETHNIC1]
     ,mySource.[ETHNIC2]
     ,mySource.[RELIGION1]
     ,mySource.[RELIGION2]
     ,mySource.[BIRTH_DATE1]
     ,mySource.[BIRTH_DATE2]
     ,mySource.[BIRTH_PLACE1]
     ,mySource.[BIRTH_PLACE2]
     ,mySource.[EV_EMAIL]
     ,mySource.[LANGUAGE1]
     ,mySource.[LANGUAGE2]
     ,mySource.[KEYWORDS]
     ,mySource.[UD1]
     ,mySource.[UD2]
     ,mySource.[UD3]
     ,mySource.[UD4]
     ,mySource.[UD5]
     ,mySource.[UD6]
     ,mySource.[UD7]
     ,mySource.[UD8]
     ,mySource.[UD9]
     ,mySource.[UD10]
     ,mySource.[UD11]
     ,mySource.[UD12]
     ,mySource.[UD13]
     ,mySource.[UD14]
     ,mySource.[UD15]
     ,mySource.[UD16]
     ,mySource.[EMAIL_OK]
     ,mySource.[MERGED]
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
