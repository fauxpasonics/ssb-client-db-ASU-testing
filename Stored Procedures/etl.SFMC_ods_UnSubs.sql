SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[SFMC_ods_UnSubs]
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
Date:     07/26/2016
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM stg.SFMC_UnSubs),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src DataSize', @SrcDataSize, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, *
INTO #SrcData
FROM (
SELECT ETL_SourceFileName, ClientID, SendID, SubscriberKey, EmailAddress, SubscriberID, ListID, EventDate, EventType, BatchID, TriggeredSendExternalKey, UnsubReason
, ROW_NUMBER() OVER	(PARTITION BY ClientId, SendId, SubscriberId, EventDate ORDER BY ETL_ID DESC) RowRank
FROM stg.SFMC_UnSubs
) a
WHERE a.RowRank = 1


EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(BatchID),'DBNULL_TEXT') + ISNULL(RTRIM(ClientID),'DBNULL_TEXT') + ISNULL(RTRIM(EmailAddress),'DBNULL_TEXT') + ISNULL(RTRIM(ETL_SourceFileName),'DBNULL_TEXT') + ISNULL(RTRIM(EventDate),'DBNULL_TEXT') + ISNULL(RTRIM(EventType),'DBNULL_TEXT') + ISNULL(RTRIM(ListID),'DBNULL_TEXT') + ISNULL(RTRIM(SendID),'DBNULL_TEXT') + ISNULL(RTRIM(SubscriberID),'DBNULL_TEXT') + ISNULL(RTRIM(SubscriberKey),'DBNULL_TEXT') + ISNULL(RTRIM(TriggeredSendExternalKey),'DBNULL_TEXT') + ISNULL(RTRIM(UnsubReason),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ClientId,SendId,SubscriberId,EventDate)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.SFMC_UnSubs AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.ClientId = mySource.ClientId and myTarget.SendId = mySource.SendId and myTarget.SubscriberId = mySource.SubscriberId and myTarget.EventDate = mySource.EventDate

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETL_UpdatedDate] = @RunTime
     ,myTarget.[ETL_IsDeleted] = 0
     ,myTarget.[ETL_DeletedDate] = null
     ,myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     ,myTarget.[ETL_SourceFileName] = mySource.[ETL_SourceFileName]
     ,myTarget.[ClientID] = mySource.[ClientID]
     ,myTarget.[SendID] = mySource.[SendID]
     ,myTarget.[SubscriberKey] = mySource.[SubscriberKey]
     ,myTarget.[EmailAddress] = mySource.[EmailAddress]
     ,myTarget.[SubscriberID] = mySource.[SubscriberID]
     ,myTarget.[ListID] = mySource.[ListID]
     ,myTarget.[EventDate] = mySource.[EventDate]
     ,myTarget.[EventType] = mySource.[EventType]
     ,myTarget.[BatchID] = mySource.[BatchID]
     ,myTarget.[TriggeredSendExternalKey] = mySource.[TriggeredSendExternalKey]
     ,myTarget.[UnsubReason] = mySource.[UnsubReason]
     
WHEN NOT MATCHED BY Target
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ETL_SourceFileName]
     ,[ClientID]
     ,[SendID]
     ,[SubscriberKey]
     ,[EmailAddress]
     ,[SubscriberID]
     ,[ListID]
     ,[EventDate]
     ,[EventType]
     ,[BatchID]
     ,[TriggeredSendExternalKey]
     ,[UnsubReason]
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
     ,mySource.[SubscriberKey]
     ,mySource.[EmailAddress]
     ,mySource.[SubscriberID]
     ,mySource.[ListID]
     ,mySource.[EventDate]
     ,mySource.[EventType]
     ,mySource.[BatchID]
     ,mySource.[TriggeredSendExternalKey]
     ,mySource.[UnsubReason]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.SFMC_UnSubs WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.SFMC_UnSubs WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

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
