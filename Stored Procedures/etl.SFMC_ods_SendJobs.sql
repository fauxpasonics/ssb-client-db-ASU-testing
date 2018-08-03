SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[SFMC_ods_SendJobs]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     dbo
Date:     10/13/2016
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM stg.SFMC_SendJobs),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

/*Extract Options, default values set if the option is not specified*/	
DECLARE @DisableInsert nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableInsert'),'false')
DECLARE @DisableUpdate nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableUpdate'),'false')
DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')


BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src DataSize', @SrcDataSize, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey
,  ETL_SourceFileName, ClientID, SendID, FromName, FromEmail, SchedTime, SentTime, Subject, EmailName, TriggeredSendExternalKey, SendDefinitionExternalKey, JobStatus, PreviewURL, IsMultipart, Additional
INTO #SrcData
FROM (
	SELECT  ETL_SourceFileName, ClientID, SendID, FromName, FromEmail, SchedTime, SentTime, Subject, EmailName, TriggeredSendExternalKey, SendDefinitionExternalKey, JobStatus, PreviewURL, IsMultipart, Additional
	, ROW_NUMBER() OVER(PARTITION BY SendID ORDER BY ETL_ID) RowRank
	FROM stg.SFMC_SendJobs
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(Additional),'DBNULL_TEXT') + ISNULL(RTRIM(ClientID),'DBNULL_TEXT') + ISNULL(RTRIM(EmailName),'DBNULL_TEXT') + ISNULL(RTRIM(ETL_SourceFileName),'DBNULL_TEXT') + ISNULL(RTRIM(FromEmail),'DBNULL_TEXT') + ISNULL(RTRIM(FromName),'DBNULL_TEXT') + ISNULL(RTRIM(IsMultipart),'DBNULL_TEXT') + ISNULL(RTRIM(JobStatus),'DBNULL_TEXT') + ISNULL(RTRIM(PreviewURL),'DBNULL_TEXT') + ISNULL(RTRIM(SchedTime),'DBNULL_TEXT') + ISNULL(RTRIM(SendDefinitionExternalKey),'DBNULL_TEXT') + ISNULL(RTRIM(SendID),'DBNULL_TEXT') + ISNULL(RTRIM(SentTime),'DBNULL_TEXT') + ISNULL(RTRIM(Subject),'DBNULL_TEXT') + ISNULL(RTRIM(TriggeredSendExternalKey),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (SendID)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.SFMC_SendJobs AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.SendID = mySource.SendID

WHEN MATCHED AND @DisableUpdate = 'false' AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     , myTarget.[ETL_SourceFileName] = mySource.[ETL_SourceFileName]
     , myTarget.[ClientID] = mySource.[ClientID]
     , myTarget.[SendID] = mySource.[SendID]
     , myTarget.[FromName] = mySource.[FromName]
     , myTarget.[FromEmail] = mySource.[FromEmail]
     , myTarget.[SchedTime] = mySource.[SchedTime]
     , myTarget.[SentTime] = mySource.[SentTime]
     , myTarget.[Subject] = mySource.[Subject]
     , myTarget.[EmailName] = mySource.[EmailName]
     , myTarget.[TriggeredSendExternalKey] = mySource.[TriggeredSendExternalKey]
     , myTarget.[SendDefinitionExternalKey] = mySource.[SendDefinitionExternalKey]
     , myTarget.[JobStatus] = mySource.[JobStatus]
     , myTarget.[PreviewURL] = mySource.[PreviewURL]
     , myTarget.[IsMultipart] = mySource.[IsMultipart]
     , myTarget.[Additional] = mySource.[Additional]
     
WHEN NOT MATCHED BY SOURCE AND @DisableDelete = 'false' THEN DELETE

WHEN NOT MATCHED BY Target AND @DisableInsert = 'false'
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ETL_SourceFileName]
     ,[ClientID]
     ,[SendID]
     ,[FromName]
     ,[FromEmail]
     ,[SchedTime]
     ,[SentTime]
     ,[Subject]
     ,[EmailName]
     ,[TriggeredSendExternalKey]
     ,[SendDefinitionExternalKey]
     ,[JobStatus]
     ,[PreviewURL]
     ,[IsMultipart]
     ,[Additional]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ETL_SourceFileName]
     ,mySource.[ClientID]
     ,mySource.[SendID]
     ,mySource.[FromName]
     ,mySource.[FromEmail]
     ,mySource.[SchedTime]
     ,mySource.[SentTime]
     ,mySource.[Subject]
     ,mySource.[EmailName]
     ,mySource.[TriggeredSendExternalKey]
     ,mySource.[SendDefinitionExternalKey]
     ,mySource.[JobStatus]
     ,mySource.[PreviewURL]
     ,mySource.[IsMultipart]
     ,mySource.[Additional]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.SFMC_SendJobs WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.SFMC_SendJobs WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Insert Row Count', @MergeInsertRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Update Row Count', @MergeUpdateRowCount, @ExecutionId


END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.LogEventRecordDB @Batchid, 'Error', @ProcedureName, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId


END



GO
