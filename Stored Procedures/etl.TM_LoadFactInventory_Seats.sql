SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[TM_LoadFactInventory_Seats]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(MAX) = null
)

AS
BEGIN


	INSERT INTO etl.vw_FactInventory 
	(
		ETL__SourceSystem, ETL__CreatedBy, ETL__CreatedDate, ETL__UpdatedDate
		, ETL__SSID_TM_event_id, ETL__SSID_TM_section_id, ETL__SSID_TM_row_id, ETL__SSID_TM_seat
		, DimArenaId, DimSeasonId, DimEventId, DimSeatId, DimSeatStatusid
	)

	SELECT 
		dEvent.ETL__SourceSystem
		, SUSER_NAME() ETL__CreatedBy, GETUTCDATE() ETL__CreatedDate, GETUTCDATE() ETL__UpdatedDate
		, dEvent.ETL__SSID_TM_event_id, dSeat.ETL__SSID_TM_section_id , dSeat.ETL__SSID_TM_row_id, dSeat.ETL__SSID_TM_seat
		, ISNULL(dArena.DimArenaId, -1) DimArenaId, ISNULL(dSeason.DimSeasonId, -1) DimSeasonId, ISNULL(dEvent.DimEventId, -1) DimEventId, ISNULL(dSeat.DimSeatId, -1) DimSeatId
		, -1 DimSeatStatusid
	--SELECT COUNT(*)

	FROM etl.vw_DimEvent dEvent
	INNER JOIN etl.vw_DimSeason dSeason ON dEvent.TM_season_id = dSeason.ETL__SSID_TM_season_Id AND dEvent.ETL__SourceSystem = dSeason.ETL__SourceSystem
	INNER JOIN etl.vw_DimArena dArena ON devent.TM_arena_id = dArena.ETL__SSID_TM_arena_id AND dEvent.ETL__SourceSystem = dArena.ETL__SourceSystem
	INNER JOIN etl.vw_DimSeat dSeat ON dEvent.TM_manifest_id = dSeat.ETL__SSID_TM_manifest_id	AND dSeat.ETL__SourceSystem = dSeat.ETL__SourceSystem
	LEFT OUTER JOIN etl.vw_FactInventory fi ON fi.DimEventId = dEvent.DimEventId AND fi.DimSeatId = dSeat.DimSeatId

	WHERE 1=1
		AND dEvent.ETL__SourceSystem = 'TM'
		AND dEvent.Config_IsFactInventoryEligible = 1 			
		AND ISNULL(dSeat.Config_IsFactInventoryEligible,1) <> 0
		AND fi.FactInventoryId IS NULL
		--AND de.IsClosed = 0				
		
	ORDER BY
		dEvent.DimEventId, dSeat.DimSeatId


END









GO
