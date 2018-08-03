SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[Cust_LoadDimSeat_NewOnly]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(max) = NULL
)

AS 
BEGIN

DECLARE @RunTime DATETIME = GETDATE()

--DECLARE @BatchId NVARCHAR(50) = '00000000-0000-0000-0000-000000000000';
DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @EventSource nvarchar(255) = 'ProcessStandardMerge_dbo.DimSeat'
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM etl.vw_Load_DimSeat),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0';
DECLARE @Client NVARCHAR(255) = (SELECT ISNULL(etl.fnGetClientSetting('ClientName'), DB_NAME()));

/*Load Options into a temp table*/
--SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, '=', ';')

--DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = 'DisableDelete'),'true')

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Src DataSize', @SrcDataSize, @ExecutionId


--SELECT ROW_NUMBER() OVER(ORDER BY ETL__SSID_SEASON,ETL__SSID_LEVEL,ETL__SSID_SECTION,ETL__SSID_ROW,ETL__SSID_PacSeat) RowIndex
--, * 
--INTO #data
--FROM etl.vw_Load_DimSeat


SELECT ROW_NUMBER() OVER(ORDER BY s.ETL__SSID_SEASON,s.ETL__SSID_LEVEL,s.ETL__SSID_SECTION,s.ETL__SSID_ROW,s.ETL__SSID_PacSeat) RowIndex
, s.* 
INTO #data
FROM etl.vw_Load_DimSeat s
LEFT OUTER JOIN dbo.DimSeat t ON 
	ISNULL(s.ETL__SSID_SEASON,'') = ISNULL(t.ETL__SSID_SEASON,'')
	AND ISNULL(s.ETL__SSID_LEVEL,'') = ISNULL(t.ETL__SSID_LEVEL,'')
	AND ISNULL(s.ETL__SSID_SECTION,'') = ISNULL(t.ETL__SSID_SECTION,'')
	AND ISNULL(s.ETL__SSID_ROW,'') = ISNULL(t.ETL__SSID_ROW,'')
	AND ISNULL(s.ETL__SSID_PacSeat,'') = ISNULL(t.ETL__SSID_PacSeat,'')
WHERE t.DimSeatId IS NULL


CREATE NONCLUSTERED INDEX IDX_RowIndex ON #data (RowIndex)

DECLARE @RecordCount INT = (SELECT COUNT(*) FROM #data)
DECLARE @StartIndex INT = 1, @PageCount INT = 25000
DECLARE @EndIndex INT = (@StartIndex + @PageCount - 1)

WHILE @StartIndex <= @RecordCount
BEGIN

SELECT CAST(NULL AS BINARY(32)) ETL__DeltaHashKey
,  ETL__SourceSystem, ETL__SSID, ETL__SSID_SEASON, ETL__SSID_LEVEL, ETL__SSID_SECTION, ETL__SSID_ROW, ETL__SSID_PacSeat, Season, LevelName, SectionName, RowName, Seat, DefaultPriceLevel
INTO #SrcData
FROM #data
WHERE RowIndex BETWEEN @StartIndex AND @EndIndex

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL__DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(DefaultPriceLevel),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(LevelName),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(RowName),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(Season),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(Seat),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS + ISNULL(RTRIM(SectionName),'DBNULL_TEXT') COLLATE SQL_Latin1_General_CP1_CS_AS)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Src Table Setup', 'ETL_Sync_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ETL__SSID_SEASON,ETL__SSID_LEVEL,ETL__SSID_SECTION,ETL__SSID_ROW,ETL__SSID_PacSeat)
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL__DeltaHashKey)

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE dbo.DimSeat AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.ETL__SSID_SEASON = mySource.ETL__SSID_SEASON and myTarget.ETL__SSID_LEVEL = mySource.ETL__SSID_LEVEL and myTarget.ETL__SSID_SECTION = mySource.ETL__SSID_SECTION and myTarget.ETL__SSID_ROW = mySource.ETL__SSID_ROW and myTarget.ETL__SSID_PacSeat = mySource.ETL__SSID_PacSeat

WHEN MATCHED AND (
     ISNULL(mySource.ETL__DeltaHashKey,-1) <> ISNULL(myTarget.ETL__DeltaHashKey, -1)
	 
)
THEN UPDATE SET
	ETL__EndDate = @RunTime
WHEN NOT MATCHED BY Target
THEN INSERT
     (
		ETL__CreatedBy
		, ETL__CreatedDate
		, ETL__StartDate
		, ETL__DeltaHashKey
	 , [ETL__SourceSystem]
     , [ETL__SSID]
     , [ETL__SSID_SEASON]
     , [ETL__SSID_LEVEL]
     , [ETL__SSID_SECTION]
     , [ETL__SSID_ROW]
     , [ETL__SSID_PacSeat]
     , [Season]
     , [LevelName]
     , [SectionName]
     , [RowName]
     , [Seat]
     , [DefaultPriceLevel]
     )
VALUES
     (
		SUSER_NAME() --ETL__CreatedBy
		, GETDATE() --ETL__CreatedDate
		, @RunTime	--ETL__StartDate
		, mySource.ETL__DeltaHashKey	
	 , mySource.[ETL__SourceSystem]
     , mySource.[ETL__SSID]
     , mySource.[ETL__SSID_SEASON]
     , mySource.[ETL__SSID_LEVEL]
     , mySource.[ETL__SSID_SECTION]
     , mySource.[ETL__SSID_ROW]
     , mySource.[ETL__SSID_PacSeat]
     , mySource.[Season]
     , mySource.[LevelName]
     , mySource.[SectionName]
     , mySource.[RowName]
     , mySource.[Seat]
     , mySource.[DefaultPriceLevel]
     )
;

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

INSERT INTO dbo.DimSeat (
		ETL__CreatedBy
		, ETL__CreatedDate
		, ETL__StartDate
		, ETL__DeltaHashKey
	 , [ETL__SourceSystem]
     , [ETL__SSID]
     , [ETL__SSID_SEASON]
     , [ETL__SSID_LEVEL]
     , [ETL__SSID_SECTION]
     , [ETL__SSID_ROW]
     , [ETL__SSID_PacSeat]
     , [Season]
     , [LevelName]
     , [SectionName]
     , [RowName]
     , [Seat]
     , [DefaultPriceLevel]
     )

SELECT 
	SUSER_NAME() --ETL__CreatedBy
	, GETDATE() --ETL__CreatedDate
	, @RunTime	--ETL__StartDate
	, mySource.*
FROM #SrcData mySource
INNER JOIN dbo.DimSeat myTarget ON myTarget.ETL__SSID_SEASON = mySource.ETL__SSID_SEASON and myTarget.ETL__SSID_LEVEL = mySource.ETL__SSID_LEVEL and myTarget.ETL__SSID_SECTION = mySource.ETL__SSID_SECTION and myTarget.ETL__SSID_ROW = mySource.ETL__SSID_ROW and myTarget.ETL__SSID_PacSeat = mySource.ETL__SSID_PacSeat
WHERE myTarget.ETL__EndDate = @RunTime


DROP TABLE #SrcData

SET @StartIndex = @EndIndex + 1
SET @EndIndex = @EndIndex + @PageCount

END --End Of Paging Loop


DROP TABLE #data

END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Error', @EventSource, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
	EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.CreateEventLogRecord @Batchid, @Client, 'Info', @EventSource, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId

END

GO
