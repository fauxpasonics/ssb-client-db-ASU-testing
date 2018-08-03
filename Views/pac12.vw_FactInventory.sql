SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [pac12].[vw_FactInventory] as 
(
	SELECT  [FactInventoryId], [ETL__SourceSystem], [ETL__CreatedBy], [ETL__CreatedDate], [ETL__UpdatedDate], [ETL__SSID_PAC_SEASON], [ETL__SSID_PAC_EVENT], [ETL__SSID_PAC_LEVEL], [ETL__SSID_PAC_SECTION], [ETL__SSID_PAC_ROW], [ETL__SSID_PAC_SEAT], [ETL__SSID_TM_event_id], [ETL__SSID_TM_section_id], [ETL__SSID_TM_row_id], [ETL__SSID_TM_seat], [DimArenaId], [DimSeasonId], [DimEventId], [DimSeatId], [DimSeatStatusId], [SeatValue], [FactTicketSalesId], [FactAttendanceId], [FactTicketActivityId_Resold], [FactTicketActivityId_Tranferred], [FactOdetId], [ETL__SSID], [FactAvailSeatsId], [FactHeldSeatsId]
	FROM dbo.FactInventory_V2 (NOLOCK)
)
GO
