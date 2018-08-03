SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[PAC_LoadFactInventory]
AS
BEGIN

	INSERT INTO etl.vw_FactInventory
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

	--SELECT COUNT(*)
	FROM etl.vw_DimEvent (NOLOCK) dEvent
	
	INNER JOIN etl.vw_DimSeat (NOLOCK) dSeat ON dEvent.ETL__SSID_PAC_SEASON = dSeat.ETL__SSID_PAC_SEASON AND devent.ETL__SourceSystem = dSeat.ETL__SourceSystem
	
	LEFT OUTER JOIN etl.vw_DimSeason (NOLOCK) dSeason ON dEvent.ETL__SSID_PAC_SEASON = dSeason.ETL__SSID_PAC_SEASON AND devent.ETL__SourceSystem = dSeason.ETL__SourceSystem
	
	LEFT OUTER JOIN etl.vw_DimArena (NOLOCK) dArena ON dEvent.Arena COLLATE SQL_Latin1_General_CP1_CS_AS = dArena.ETL__SSID_PAC_FACILITY AND devent.ETL__SourceSystem = dArena.ETL__SourceSystem
	
	LEFT OUTER JOIN etl.vw_FactInventory f 
		ON dEvent.ETL__SourceSystem = f.ETL__SourceSystem 
		AND dEvent.ETL__SSID_PAC_SEASON = f.ETL__SSID_PAC_SEASON AND dEvent.ETL__SSID_PAC_EVENT = f.ETL__SSID_PAC_EVENT
		AND dSeat.ETL__SSID_PAC_LEVEL = f.ETL__SSID_PAC_LEVEL AND dSeat.ETL__SSID_PAC_SECTION = f.ETL__SSID_PAC_SECTION AND dSeat.ETL__SSID_PAC_ROW = f.ETL__SSID_PAC_ROW AND dSeat.ETL__SSID_PAC_SEAT = f.ETL__SSID_PAC_SEAT
	
	WHERE dEvent.ETL__SourceSystem = 'PAC'
	AND dEvent.Config_IsFactInventoryEligible = 1
	AND dSeat.Config_IsFactInventoryEligible = 1
	AND f.FactInventoryId IS NULL

	ORDER BY dEvent.Season, dEvent.EventCode
		

END


GO
