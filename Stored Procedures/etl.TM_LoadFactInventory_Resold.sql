SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[TM_LoadFactInventory_Resold]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(MAX) = null
)

AS
BEGIN


	UPDATE fi
	SET fi.ETL__UpdatedDate = GETUTCDATE()	
	, fi.FactTicketActivityId_Resold = NULL
	FROM etl.vw_FactInventory fi
	LEFT OUTER JOIN etl.vw_FactTicketActivity (NOLOCK) fta ON fi.FactTicketActivityId_Resold = fta.FactTicketActivityId
	WHERE fi.FactTicketActivityId_Resold IS NOT NULL
	AND fta.FactTicketActivityId IS NULL


	SELECT f.DimEventId, dSeat.DimSeatId, f.FactTicketActivityId FactTicketActivityId_Resold
	INTO #FactActivity

	FROM etl.vw_FactTicketActivity (NOLOCK) f
	INNER JOIN etl.vw_DimActivity (NOLOCK) dActivity ON f.DimActivityId = dActivity.DimActivityId
	INNER JOIN etl.vw_DimEvent (NOLOCK) dEvent on f.ETL__SSID_TM_event_id = dEvent.ETL__SSID_TM_event_id AND f.ETL__SourceSystem = dEvent.ETL__SourceSystem
	INNER JOIN etl.vw_DimSeat (NOLOCK) dSeat 
		ON f.ETL__SourceSystem = dSeat.ETL__SourceSystem
		AND f.ETL__SSID_TM_section_id = dSeat.ETL__SSID_TM_section_id 
		AND f.ETL__SSID_TM_row_id = dSeat.ETL__SSID_TM_row_id 
		AND dSeat.ETL__SSID_TM_seat between f.ETL__SSID_TM_seat_num and (f.ETL__SSID_TM_seat_num + f.QtySeat - 1)

	WHERE f.ETL__SourceSystem = 'TM'
	AND dActivity.ActivityCode = 'ES'
	AND dEvent.Config_IsFactInventoryEligible = 1


	CREATE NONCLUSTERED INDEX [IDX_BusinessKey] ON #FactActivity (DimEventId, DimSeatId)


	UPDATE fi
	SET fi.ETL__UpdatedDate = GETUTCDATE()	
	, fi.FactTicketActivityId_Resold = s.FactTicketActivityId_Resold
	FROM etl.vw_FactInventory fi
	INNER JOIN #FactActivity s ON fi.DimEventId = s.DimEventId AND fi.DimSeatId = s.DimSeatId
	WHERE ISNULL(fi.FactTicketActivityId_Resold, -987) = ISNULL(s.FactTicketActivityId_Resold, -987)


	DROP TABLE #FactActivity


END









GO
