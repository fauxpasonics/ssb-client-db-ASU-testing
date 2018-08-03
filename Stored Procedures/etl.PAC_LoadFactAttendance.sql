SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[PAC_LoadFactAttendance]
AS
BEGIN

EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimScanGate', 'etl.vw_Load_PAC_DimScanGate', 'ETL__SSID_PAC_SEASON, ETL__SSID_PAC_SCAN_GATE', 'PAC'
	
INSERT INTO etl.vw_FactAttendance 
(
	ETL__SourceSystem, ETL__CreatedDate, ETL__UpdatedDate
	, ETL__SSID, ETL__SSID_PAC_CUSTOMER, ETL__SSID_PAC_SEASON, ETL__SSID_PAC_EVENT, ETL__SSID_PAC_LEVEL, ETL__SSID_PAC_SECTION, ETL__SSID_PAC_ROW, ETL__SSID_PAC_SEAT
	, DimArenaId, DimSeasonId, DimEventId, DimSeatId, DimDateId, DimTimeId, DimTicketCustomerId, DimTicketCustomerId_Attended, DimScanGateId, DimScanTypeId
	, ScanCount, ScanCountFailed, ScanDateTime, Barcode
)

	SELECT 

	'PAC' ETL__SourceSystem, GETDATE() ETL__CreatedDate, GETDATE() ETL__UpdatedDate

	, CONCAT(tkBC.CUSTOMER COLLATE SQL_Latin1_General_CP1_CI_AS, ':', tkBC.SEASON COLLATE SQL_Latin1_General_CP1_CI_AS, ':', tkBC.[EVENT] COLLATE SQL_Latin1_General_CP1_CI_AS, ':', tkBC.[LEVEL] COLLATE SQL_Latin1_General_CP1_CI_AS, ':', tkBC.SECTION COLLATE SQL_Latin1_General_CP1_CI_AS, ':', tkBC.[ROW] COLLATE SQL_Latin1_General_CP1_CI_AS, ':', tkBC.SEAT COLLATE SQL_Latin1_General_CP1_CI_AS) ETL__SSID
	, tkBC.CUSTOMER ETL__SSID_PAC_CUSTOMER
	, tkBC.SEASON ETL__SSID_PAC_SEASON
	, tkBC.[EVENT] ETL__SSID_PAC_EVENT
	, tkBC.[LEVEL] ETL__SSID_PAC_LEVEL
	, tkBC.SECTION ETL__SSID_PAC_SECTION
	, tkBC.[ROW] ETL__SSID_PAC_ROW
	, tkBC.SEAT ETL__SSID_PAC_SEAT

	, ISNULL(dArena.DimArenaId, -1) DimArenaId 
	, ISNULL(dSeason.DimSeasonId, -1)  DimSeasonId 
	, ISNULL(dEvent.DimEventId, -1)  DimEventId 
	, ISNULL(dSeat.DimSeatId, -1) DimSeatId 

	, CASE WHEN tkBC.SCAN_DATE IS NULL THEN 0 ELSE CONVERT(NVARCHAR(8), tkBC.SCAN_DATE, 112) END DimDateId 
	, CASE WHEN tkBC.SCAN_TIME IS NULL THEN 0 ELSE datediff(second, cast(tkBC.SCAN_TIME as date), tkBC.SCAN_TIME) END DimTimeId 

	, ISNULL(dTicketCustomer.DimTicketCustomerId, -1) DimTicketCustomerId 
	, -1 DimTicketCustomerId_Attended
	, ISNULL(dScanGate.DimScanGateId, -1) DimScanGateId
	, -1 DimScanTypeId

	, 1 ScanCount
	, 0 ScanCountFailed
	, CAST(tkBC.SCAN_DATE AS DATETIME) + CAST(tkBC.SCAN_TIME AS DATETIME) ScanDateTime

	, tkBC.BC_ID Barcode

	--SELECT COUNT(*)
	FROM dbo.TK_BC (NOLOCK) tkBC

	LEFT OUTER JOIN etl.vw_DimSeason (NOLOCK) dSeason ON tkBC.SEASON = dSeason.ETL__SSID_PAC_SEASON
		 AND dSeason.ETL__SourceSystem = 'PAC' AND dSeason.DimSeasonId > 0 AND dSeason.ETL__IsDeleted = 0

	LEFT OUTER JOIN etl.vw_DimEvent (NOLOCK) dEvent ON tkBC.SEASON = dEvent.ETL__SSID_PAC_SEASON AND tkBC.[EVENT] = dEvent.ETL__SSID_PAC_EVENT
		AND dEvent.ETL__SourceSystem = 'PAC' AND dEvent.DimEventId > 0 AND dEvent.ETL__IsDeleted = 0

	LEFT OUTER JOIN etl.vw_DimArena (NOLOCK) dArena ON dEvent.Arena COLLATE SQL_Latin1_General_CP1_CS_AS = dArena.ETL__SSID_PAC_FACILITY
		AND dArena.ETL__SourceSystem = 'PAC' AND dArena.DimArenaId > 0 AND dArena.ETL__IsDeleted = 0

	LEFT OUTER JOIN etl.vw_DimTicketCustomer (NOLOCK) dTicketCustomer ON tkBC.CUSTOMER = dTicketCustomer.ETL__SSID_PAC_PATRON
		AND dTicketCustomer.ETL__SourceSystem = 'PAC' AND dTicketCustomer.DimTicketCustomerId > 0 AND dTicketCustomer.ETL__IsDeleted = 0

	LEFT OUTER JOIN etl.vw_DimScanGate (nolock) dScanGate ON tkBC.SEASON = dScanGate.ETL__SSID_PAC_SEASON AND tkBC.SCAN_GATE = dScanGate.ETL__SSID_PAC_SCAN_GATE
		AND dScanGate.ETL__SourceSystem = 'PAC' AND dScanGate.DimScanGateId > 0 AND dScanGate.ETL__IsDeleted = 0

	LEFT OUTER JOIN etl.vw_DimSeat (NOLOCK) dSeat 
		ON tkBC.SEASON = dSeat.ETL__SSID_PAC_SEASON
		AND tkbc.[LEVEL] = dSeat.ETL__SSID_PAC_LEVEL AND tkBC.SECTION = dSeat.ETL__SSID_PAC_SECTION AND tkBC.[ROW] = dSeat.ETL__SSID_PAC_ROW AND tkBC.SEAT = dSeat.ETL__SSID_PAC_SEAT
		AND dSeat.ETL__SourceSystem = 'PAC' AND dSeat.DimSeatId > 0 AND dSeat.ETL__IsDeleted = 0

	LEFT OUTER JOIN etl.vw_FactAttendance fa
		ON tkBC.SEASON = fa.ETL__SSID_PAC_SEASON
		AND tkBC.[EVENT] = fa.ETL__SSID_PAC_EVENT
		AND tkBC.[LEVEL] = fa.ETL__SSID_PAC_LEVEL
		AND tkBC.SECTION = fa.ETL__SSID_PAC_SECTION
		AND tkBC.[ROW] = fa.ETL__SSID_PAC_ROW
		AND tkBC.SEAT = fa.ETL__SSID_PAC_SEAT
	
	WHERE tkBC.ATTENDED = 'Y' AND fa.FactAttendanceId IS NULL
		AND tkBC.SCAN_DATE > GETDATE() - 3  

	ORDER BY tkBC.SEASON, tkBC.[EVENT], tkBC.[LEVEL], tkBC.SECTION, tkBC.[ROW], tkBC.SEAT


		

END





GO
