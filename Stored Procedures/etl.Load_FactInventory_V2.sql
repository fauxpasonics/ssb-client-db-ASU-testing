SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_FactInventory_V2] 
( 
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000', 
	@Options NVARCHAR(max) = NULL 
) 
 
AS 
BEGIN 

TRUNCATE TABLE dbo.FactInventory_V2

DECLARE @RunTime datetime = GETDATE()

INSERT INTO dbo.FactInventory_V2
( 
	ETL__SourceSystem, ETL__CreatedBy, ETL__CreatedDate, ETL__UpdatedDate
, ETL__SSID_PAC_SEASON, ETL__SSID_PAC_EVENT, ETL__SSID_PAC_LEVEL, ETL__SSID_PAC_SECTION, ETL__SSID_PAC_ROW, ETL__SSID_PAC_SEAT

, DimArenaId, DimSeasonId, DimEventId, DimSeatId, DimSeatStatusid

)

SELECT 
'PAC' ETL__SourceSystem
, SUSER_NAME() ETL__CreatedBy, GETDATE() ETL__CreatedDate, GETDATE() ETL__UpdatedDate

, dEvent.ETL__SSID_PAC_SEASON
, dEvent.ETL__SSID_PAC_EVENT
, dSeat.ETL__SSID_PAC_LEVEL
, dSeat.ETL__SSID_PAC_SECTION
, dSeat.ETL__SSID_PAC_ROW
, dSeat.ETL__SSID_PAC_SEAT

, ISNULL(dArena.DimArenaId, -1) DimArenaId
, ISNULL(dSeason.DimSeasonId, -1) DimSeasonId
, ISNULL(dEvent.DimEventId, -1) DimEventId
, ISNULL(dSeat.DimSeatId, -1) DimSeatId

, -1 [DimSeatStatusid]
--, [SeatValue],
--, [FactTicketSalesId],
--, [FactAttendanceId],
--, [FactSecondaryId]

--2,987,658
--SELECT COUNT(*)
FROM dbo.DimEvent (NOLOCK) dEvent
INNER JOIN dbo.DimSeat (NOLOCK) dSeat ON dEvent.ETL__SSID_PAC_SEASON = dSeat.ETL__SSID_PAC_SEASON AND dSeat.ETL__SourceSystem = 'PAC'
LEFT OUTER JOIN dbo.DimSeason (NOLOCK) dSeason ON dEvent.ETL__SSID_PAC_SEASON = dSeason.ETL__SSID_PAC_SEASON AND dSeason.ETL__SourceSystem = 'PAC'
LEFT OUTER JOIN dbo.DimArena (NOLOCK) dArena ON dEvent.Arena COLLATE SQL_Latin1_General_CP1_CS_AS = dArena.ETL__SSID_PAC_FACILITY AND dArena.ETL__SourceSystem = 'PAC'

WHERE dEvent.ETL__SourceSystem = 'PAC'
AND dEvent.SEASON IN ('F17') 
--AND dEvent.EventCode LIKE 'FB[0-9][0-9]'
--AND dEvent.EventCode = 'FB01'

ORDER BY dEvent.Season, dEvent.EventCode

END

GO
