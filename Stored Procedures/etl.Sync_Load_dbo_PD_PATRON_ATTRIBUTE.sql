SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[Sync_Load_dbo_PD_PATRON_ATTRIBUTE]
(
	@BatchId NVARCHAR(50) = null,
	@Client NVARCHAR(50) = null,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     svcETL
Date:     06/09/2016
Comments: Initial creation
*************************************************************************************/

SET @BatchId = ISNULL(@BatchId, CONVERT(NVARCHAR(50), NEWID()));

DECLARE @RunTime DATETIME = GETDATE();

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM src.Sync_TI_PD_PATRON_ATTRIBUTE),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0';

/*Load Options into a temp table*/
SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';');

DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true');

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId);

EXEC etl.CreateEventLogRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId;
EXEC etl.CreateEventLogRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId;
EXEC etl.CreateEventLogRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src DataSize', @SrcDataSize, @ExecutionId;

SELECT CAST(NULL AS BINARY(32)) ETL_Sync_DeltaHashKey
,  ETLSID, PATRON, VMC, ATTRIBUTE, NOTE, ATTRIBUTE_SOURCE, ZID, SOURCE_ID, EXPORT_DATETIME
INTO #SrcData
FROM (
	SELECT  ETLSID, PATRON, VMC, ATTRIBUTE, NOTE, ATTRIBUTE_SOURCE, ZID, SOURCE_ID, EXPORT_DATETIME
	, ROW_NUMBER() OVER(PARTITION BY ETLSID,PATRON,VMC ORDER BY ETL_Sync_ID) RowRank
	FROM src.Sync_TI_PD_PATRON_ATTRIBUTE
) a
WHERE RowRank = 1;

EXEC etl.CreateEventLogRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId;

UPDATE #SrcData
SET ETL_Sync_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(ATTRIBUTE),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ATTRIBUTE_SOURCE)),'DBNULL_BIGINT') + ISNULL(RTRIM(ETLSID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),EXPORT_DATETIME)),'DBNULL_DATETIME') + ISNULL(RTRIM(NOTE),'DBNULL_TEXT') + ISNULL(RTRIM(PATRON),'DBNULL_TEXT') + ISNULL(RTRIM(SOURCE_ID),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),VMC)),'DBNULL_BIGINT') + ISNULL(RTRIM(ZID),'DBNULL_TEXT'));

EXEC etl.CreateEventLogRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_Sync_DeltaHashKey Set', @ExecutionId;

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ETLSID,PATRON,VMC);
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL_Sync_DeltaHashKey);

EXEC etl.CreateEventLogRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId;
EXEC etl.CreateEventLogRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId;

MERGE dbo.PD_PATRON_ATTRIBUTE AS myTarget
USING (
	SELECT * FROM #SrcData
) AS mySource
ON myTarget.ETLSID = mySource.ETLSID and myTarget.PATRON = mySource.PATRON and myTarget.VMC = mySource.VMC

WHEN MATCHED AND (
     ISNULL(mySource.ETL_Sync_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_Sync_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETLSID] = mySource.[ETLSID]
     ,myTarget.[PATRON] = mySource.[PATRON]
     ,myTarget.[VMC] = mySource.[VMC]
     ,myTarget.[ATTRIBUTE] = mySource.[ATTRIBUTE]
     ,myTarget.[NOTE] = mySource.[NOTE]
     ,myTarget.[ATTRIBUTE_SOURCE] = mySource.[ATTRIBUTE_SOURCE]
     ,myTarget.[ZID] = mySource.[ZID]
     ,myTarget.[SOURCE_ID] = mySource.[SOURCE_ID]
     ,myTarget.[EXPORT_DATETIME] = mySource.[EXPORT_DATETIME]
     ,myTarget.[ETL_Sync_DeltaHashKey] = mySource.[ETL_Sync_DeltaHashKey]
     

--WHEN NOT MATCHED BY SOURCE AND @DisableDelete = 'false' THEN DELETE

WHEN NOT MATCHED BY Target
THEN INSERT
     ([ETLSID]
     ,[PATRON]
     ,[VMC]
     ,[ATTRIBUTE]
     ,[NOTE]
     ,[ATTRIBUTE_SOURCE]
     ,[ZID]
     ,[SOURCE_ID]
     ,[EXPORT_DATETIME]
     ,[ETL_Sync_DeltaHashKey]
     )
VALUES
     (mySource.[ETLSID]
     ,mySource.[PATRON]
     ,mySource.[VMC]
     ,mySource.[ATTRIBUTE]
     ,mySource.[NOTE]
     ,mySource.[ATTRIBUTE_SOURCE]
     ,mySource.[ZID]
     ,mySource.[SOURCE_ID]
     ,mySource.[EXPORT_DATETIME]
     ,mySource.[ETL_Sync_DeltaHashKey]
     )
;

EXEC etl.CreateEventLogRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.CreateEventLogRecord @Batchid, 'Error', @ProcedureName, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
	EXEC etl.CreateEventLogRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.CreateEventLogRecord @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId


END


GO
