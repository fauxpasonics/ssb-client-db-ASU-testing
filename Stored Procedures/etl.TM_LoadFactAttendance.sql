SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[TM_LoadFactAttendance]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(MAX) = null
)

AS
BEGIN

	
	SELECT acct_id, event_id, section_id, row_id, seat_num, gate, scan_date, channel_ind, access_type, mobile
	INTO #AttendData
	FROM (
		SELECT acct_id, event_id, section_id, row_id, seat_num, gate, a.channel_ind, a.access_type, a.mobile
		, (CAST(a.event_date AS DATETIME) + CAST(ISNULL(TRY_CAST(a.action_time AS TIME), '00:00') AS DATETIME) ) scan_date
		, ROW_NUMBER() OVER(PARTITION BY event_id, section_id, row_id, seat_num ORDER BY a.event_date DESC, a.action_time) AS RowRank		
		FROM ods.TM_AttendApi (NOLOCK) a
		WHERE a.result_code = 0 and a.action_time IS NOT NULL
		AND a.ETL__UpdatedDate > (GETDATE() - 3)
	) a 
	WHERE RowRank = 1
	
	CREATE NONCLUSTERED INDEX IX_seat ON #AttendData (event_id, section_id, row_id, seat_num)
	CREATE NONCLUSTERED INDEX IX_acct_id ON #AttendData (acct_id)


	SELECT DISTINCT a.acct_id, dTicketCustomer.DimTicketCustomerId
	INTO #Lkp_DimTicketCustomerId
	FROM #AttendData a
	INNER JOIN etl.vw_DimTicketCustomer (nolock) dTicketCustomer ON a.acct_id = dTicketCustomer.ETL__SSID_TM_acct_id AND dTicketCustomer.ETL__SourceSystem = 'TM'

	CREATE NONCLUSTERED INDEX IX_acct_id ON #Lkp_DimTicketCustomerId (acct_id)

	SELECT
		isnull(dArena.DimArenaId, -1) DimArenaId
		, isnull(dSeason.DimSeasonId, -1) DimSeasonId
		, ISNULL(dEvent.DimEventId, -1) AS DimEventId
		, ISNULL(ldc.DimTicketCustomerId, -1) DimTicketCustomerId
		, -1 DimTicketCustomerId_Attended
		, ISNULL(dSeat.DimSeatId, -1) DimSeatId
		, CONVERT(VARCHAR, a.scan_date, 112) DimDateId
		, datediff(second, cast(a.scan_date as date), a.scan_date) DimTimeId
		, ISNULL(dScanGate.DimScanGateId, -1) DimScanGateId
		, ISNULL(dScanType.DimScanTypeId, -1) DimScanTypeId
		, 1 ScanCount
		, 0 ScanCountFailed
		, a.scan_date ScanDateTime		
		, CAST(NULL AS NVARCHAR(255)) Barcode
		, a.mobile IsMobile
		, a.event_id ETL__SSID_TM_event_id
		, a.acct_id ETL__SSID_TM_acct_id
		, a.section_id ETL__SSID_TM_section_id
		, a.row_id ETL__SSID_TM_row_id
		, a.seat_num ETL__SSID_TM_seat_num
		, 'TM' ETL__SourceSystem
		, GETDATE() ETL__CreatedDate
		, GETDATE() ETL__UpdatedDate
	INTO #AttendTM
	FROM #AttendData a

	LEFT OUTER JOIN #Lkp_DimTicketCustomerId ldc ON ldc.acct_id = a.acct_id 	

	LEFT OUTER JOIN etl.vw_DimEvent (nolock) dEvent ON a.event_id = dEvent.ETL__SSID_TM_event_id
		AND dEvent.ETL__SourceSystem = 'TM' AND dEvent.DimEventId > 0 AND dEvent.ETL__IsDeleted = 0

	LEFT OUTER JOIN etl.vw_DimSeason (nolock) dSeason ON devent.TM_season_id = dSeason.ETL__SSID_TM_season_Id
		AND dSeason.ETL__SourceSystem = 'TM' AND dSeason.DimSeasonId > 0 AND dSeason.ETL__IsDeleted = 0

	LEFT OUTER JOIN etl.vw_DimArena (nolock) dArena ON dEvent.TM_arena_id = dArena.ETL__SSID_TM_arena_id
		AND dArena.ETL__SourceSystem = 'TM' AND dArena.DimArenaId > 0 AND dArena.ETL__IsDeleted = 0	

	LEFT OUTER JOIN etl.vw_DimScanGate (nolock) dScanGate ON a.gate = dScanGate.ETL__SSID_TM_gate
		AND dScanGate.ETL__SourceSystem = 'TM' AND dScanGate.DimScanGateId > 0 AND dScanGate.ETL__IsDeleted = 0

	LEFT OUTER JOIN etl.vw_DimScanType (nolock) dScanType ON a.channel_ind = dScanType.ETL__SSID_TM_channel_ind
		AND dScanType.ETL__SourceSystem = 'TM' AND dScanType.DimScanTypeId > 0 AND dScanType.ETL__IsDeleted = 0

	LEFT OUTER JOIN etl.vw_DimSeat (nolock) dSeat ON dEvent.TM_manifest_id = dSeat.ETL__SSID_TM_Manifest_Id AND a.section_id = dSeat.ETL__SSID_TM_Section_Id AND a.row_id = dSeat.ETL__SSID_TM_Row_Id AND a.seat_num = dSeat.ETL__SSID_TM_Seat
		AND dSeat.ETL__SourceSystem = 'TM' AND dSeat.DimSeatId > 0 AND dSeat.ETL__IsDeleted = 0
	

	CREATE NONCLUSTERED INDEX IDX_LoadKey ON #AttendTM (DimEventId, DimSeatId)


	INSERT INTO etl.vw_FactAttendance 
	(
		DimArenaId, DimSeasonId, DimEventId, DimTicketCustomerId, DimTicketCustomerId_Attended, DimSeatId, DimDateId, DimTimeId, DimScanGateId, DimScanTypeId, ScanCount, ScanCountFailed, ScanDateTime, Barcode, IsMobile
		, ETL__SSID_TM_event_id, ETL__SSID_TM_acct_id, ETL__SSID_TM_section_id, ETL__SSID_TM_row_id, ETL__SSID_TM_seat_num, ETL__SourceSystem, ETL__CreatedDate, ETL__UpdatedDate, ETL__SSID
	)
	SELECT 
		a.DimArenaId, a.DimSeasonId, a.DimEventId, a.DimTicketCustomerId, a.DimTicketCustomerId_Attended, a.DimSeatId, a.DimDateId, a.DimTimeId, a.DimScanGateId, a.DimScanTypeid, a.ScanCount, a.ScanCountFailed, a.ScanDateTime, a.Barcode, a.IsMobile
		, a.ETL__SSID_TM_event_id, a.ETL__SSID_TM_acct_id, a.ETL__SSID_TM_section_id, a.ETL__SSID_TM_row_id, a.ETL__SSID_TM_seat_num, a.ETL__SourceSystem, a.ETL__CreatedDate, a.ETL__UpdatedDate
		, CONCAT(a.ETL__SSID_TM_event_id, ':', a.ETL__SSID_TM_section_id, ':', a.ETL__SSID_TM_row_id, ':', a.ETL__SSID_TM_seat_num)
	FROM #AttendTM a
	LEFT OUTER JOIN etl.vw_FactAttendance f ON f.DimEventId = a.DimEventId AND f.DimSeatId = a.DimSeatId 
	WHERE f.FactAttendanceId IS NULL


	UPDATE fi
	SET fi.ETL__UpdatedDate = GETDATE()
	, fi.FactAttendanceId = fa.FactAttendanceId
	FROM etl.vw_FactInventory fi
	INNER JOIN etl.vw_FactAttendance fa ON fi.DimEventId = fa.DimEventId and fi.DimSeatId = fa.DimSeatId
	WHERE ISNULL(fi.FactAttendanceId, -987) <> ISNULL(fa.FactAttendanceId, -987)


END








GO
