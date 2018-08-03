SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[TM_LoadFactInventory_Avail]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(MAX) = null
)

AS
BEGIN


	UPDATE fi
	SET fi.ETL__UpdatedDate = GETUTCDATE()	
	, fi.FactAvailSeatsId = NULL
	, fi.DimSeatStatusId = 0
	FROM etl.vw_FactInventory fi
	LEFT OUTER JOIN etl.vw_FactAvailSeats (NOLOCK) fas ON fi.FactAvailSeatsId = fas.FactAvailSeatsId
	WHERE fi.FactAvailSeatsId IS NOT NULL
	AND fas.FactAvailSeatsId IS NULL
	

	SELECT f.DimEventId, dSeat.DimSeatId, f.FactAvailSeatsId, f.DimSeatStatusId
	INTO #FactAvailSeats

	FROM etl.vw_FactAvailSeats (NOLOCK) f
	INNER JOIN etl.vw_DimEvent (NOLOCK) dEvent on f.ETL__SSID_TM_event_id = dEvent.ETL__SSID_TM_event_id AND f.ETL__SourceSystem = dEvent.ETL__SourceSystem
	INNER JOIN etl.vw_DimSeat (NOLOCK) dSeat 
		ON f.ETL__SourceSystem = dSeat.ETL__SourceSystem
		AND f.ETL__SSID_TM_section_id = dSeat.ETL__SSID_TM_section_id 
		AND f.ETL__SSID_TM_row_id = dSeat.ETL__SSID_TM_row_id 
		AND dSeat.ETL__SSID_TM_seat between f.ETL__SSID_TM_seat_num and (f.ETL__SSID_TM_seat_num + f.QtySeat - 1)

	WHERE f.ETL__SourceSystem = 'TM'
		AND dEvent.Config_IsFactInventoryEligible = 1
		AND f.DimEventId > 0
		AND f.DimSeatId_Start > 0


	CREATE NONCLUSTERED INDEX [IDX_BusinessKey] ON #FactAvailSeats (DimEventId, DimSeatId)


	UPDATE fi
	SET fi.ETL__UpdatedDate = GETUTCDATE()	
	, fi.FactAvailSeatsId = s.FactAvailSeatsId
	, fi.DimSeatStatusId = s.DimSeatStatusId
	FROM etl.vw_FactInventory fi
	INNER JOIN #FactAvailSeats s ON fi.DimEventId = s.DimEventId AND fi.DimSeatId = s.DimSeatId
	WHERE ISNULL(fi.FactAvailSeatsId, -987) <> ISNULL(s.FactAvailSeatsId, -987) OR ISNULL(fi.DimSeatStatusId, -987) <> ISNULL(s.DimSeatStatusId, -987)


	DROP TABLE #FactAvailSeats


END










GO
