SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_ods_Turnkey_Models]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     SSBCLOUD\dhorstman
Date:     08/16/2016
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM stg.Turnkey_Models),'0');	
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
,  ETL_FileName, PersonID, FootballCapacity, FootballCapacityDate, FootballPriority, FootballPriorityDate, BasketballCapacity, BasketballCapacityDate, BaseballCapacity, BaseballCapacityDate, BasketballPriority, BasketballPriorityDate, BaseballPriority, BaseballPriorityDate, TicketingSystemAccountID
INTO #SrcData
FROM (
	SELECT  ETL_FileName, PersonID, FootballCapacity, FootballCapacityDate, FootballPriority, FootballPriorityDate, BasketballCapacity, BasketballCapacityDate, BaseballCapacity, BaseballCapacityDate, BasketballPriority, BasketballPriorityDate, BaseballPriority, BaseballPriorityDate, TicketingSystemAccountID
	, ROW_NUMBER() OVER(PARTITION BY PersonID, TicketingSystemAccountID ORDER BY ETL_ID) RowRank
	FROM stg.Turnkey_Models
) a
WHERE RowRank = 1

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(BaseballCapacity),'DBNULL_TEXT') + ISNULL(RTRIM(BaseballCapacityDate),'DBNULL_TEXT') + ISNULL(RTRIM(BaseballPriority),'DBNULL_TEXT') + ISNULL(RTRIM(BaseballPriorityDate),'DBNULL_TEXT') + ISNULL(RTRIM(BasketballCapacity),'DBNULL_TEXT') + ISNULL(RTRIM(BasketballCapacityDate),'DBNULL_TEXT') + ISNULL(RTRIM(BasketballPriority),'DBNULL_TEXT') + ISNULL(RTRIM(BasketballPriorityDate),'DBNULL_TEXT') + ISNULL(RTRIM(FootballCapacity),'DBNULL_TEXT') + ISNULL(RTRIM(FootballCapacityDate),'DBNULL_TEXT') + ISNULL(RTRIM(FootballPriority),'DBNULL_TEXT') + ISNULL(RTRIM(FootballPriorityDate),'DBNULL_TEXT') + ISNULL(RTRIM(PersonID),'DBNULL_TEXT') + ISNULL(RTRIM(TicketingSystemAccountID),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (PersonID, TicketingSystemAccountID)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Turnkey_Models AS myTarget
USING #SrcData AS mySource
ON myTarget.PersonID = mySource.PersonID and myTarget.TicketingSystemAccountID = mySource.TicketingSystemAccountID

WHEN MATCHED AND @DisableUpdate = 'false' AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
       myTarget.[ETL_UpdatedDate] = @RunTime
     , myTarget.[ETL_IsDeleted] = 0
     , myTarget.[ETL_DeletedDate] = NULL
     , myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
	 , myTarget.[ETL_FileName] = mySource.[ETL_FileName]
     , myTarget.[PersonID] = mySource.[PersonID]
     , myTarget.[FootballCapacity] = mySource.[FootballCapacity]
     , myTarget.[FootballCapacityDate] = mySource.[FootballCapacityDate]
     , myTarget.[FootballPriority] = mySource.[FootballPriority]
     , myTarget.[FootballPriorityDate] = mySource.[FootballPriorityDate]
     , myTarget.[BasketballCapacity] = mySource.[BasketballCapacity]
     , myTarget.[BasketballCapacityDate] = mySource.[BasketballCapacityDate]
     , myTarget.[BaseballCapacity] = mySource.[BaseballCapacity]
     , myTarget.[BaseballCapacityDate] = mySource.[BaseballCapacityDate]
     , myTarget.[BasketballPriority] = mySource.[BasketballPriority]
     , myTarget.[BasketballPriorityDate] = mySource.[BasketballPriorityDate]
     , myTarget.[BaseballPriority] = mySource.[BaseballPriority]
     , myTarget.[BaseballPriorityDate] = mySource.[BaseballPriorityDate]
     , myTarget.[TicketingSystemAccountID] = mySource.[TicketingSystemAccountID]
     


WHEN NOT MATCHED BY Target
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ETL_FileName]
     ,[PersonID]
     ,[FootballCapacity]
     ,[FootballCapacityDate]
     ,[FootballPriority]
     ,[FootballPriorityDate]
     ,[BasketballCapacity]
     ,[BasketballCapacityDate]
     ,[BaseballCapacity]
     ,[BaseballCapacityDate]
     ,[BasketballPriority]
     ,[BasketballPriorityDate]
     ,[BaseballPriority]
     ,[BaseballPriorityDate]
     ,[TicketingSystemAccountID]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
	 ,mySource.[ETL_FileName]
     ,mySource.[PersonID]
     ,mySource.[FootballCapacity]
     ,mySource.[FootballCapacityDate]
     ,mySource.[FootballPriority]
     ,mySource.[FootballPriorityDate]
     ,mySource.[BasketballCapacity]
     ,mySource.[BasketballCapacityDate]
     ,mySource.[BaseballCapacity]
     ,mySource.[BaseballCapacityDate]
     ,mySource.[BasketballPriority]
     ,mySource.[BasketballPriorityDate]
     ,mySource.[BaseballPriority]
     ,mySource.[BaseballPriorityDate]
     ,mySource.[TicketingSystemAccountID]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Turnkey_Models WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Turnkey_Models WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	

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
