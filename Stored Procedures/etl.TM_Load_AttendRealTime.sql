SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE PROCEDURE [etl].[TM_Load_AttendRealTime]  
( 
	@EventCode VARCHAR(50) 
) 
AS  
BEGIN 
	 
	DECLARE @sourceSystem NVARCHAR(50) = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
	 
	DECLARE @DimEventId INT, @event_id INT, @EventDate DATE, @ManifestId INT, @DimDateId INT, @DimArenaId INT, @DimSeasonId INT
 
	SELECT  
		@DimEventId = DimEventId 
		, @event_id = ETL__SSID_TM_event_id 
		, @EventDate = EventDate 
		, @ManifestId = TM_manifest_id
		, @DimDateId = CONVERT(VARCHAR, EventDate, 112)
		, @DimArenaId = ISNULL(DimArenaId, -1)
		, @DimSeasonId = ISNULL(DimSeasonId, -1)
	FROM etl.vw_DimEvent 
	WHERE EventCode = @EventCode 


	SELECT a.acct_id, a.event_name, a.section_name, a.row_name, a.seat_num, a.gate, a.action_time, a.channel_ind, a.ScanDateTime
	INTO #seat 
	FROM ( 
		SELECT acct_id, event_name, section_name, row_name, seat_num, gate, action_time, channel_ind
	, CAST(@EventDate AS DATETIME) + ISNULL(TRY_CAST(action_time AS DATETIME), '00:00') ScanDateTime 
		, ROW_NUMBER() OVER(PARTITION BY event_name, section_name, row_name, seat_num ORDER BY CAST(action_time AS TIME) desc) AS RowRank		 
		FROM stg.TM_AttendRealTime 
		WHERE result_code = 0 AND event_name = @EventCode 
	) a  
	WHERE RowRank = 1 
	
	CREATE NONCLUSTERED INDEX IX_seat ON #seat (section_name, row_name, seat_num) 
	CREATE NONCLUSTERED INDEX IX_acct_id ON #seat (acct_id) 


	SELECT DISTINCT a.acct_id, dTicketCustomer.DimTicketCustomerId
	INTO #Lkp_DimTicketCustomerId
	FROM #seat a
	INNER JOIN etl.vw_DimTicketCustomer (nolock) dTicketCustomer ON a.acct_id = dTicketCustomer.ETL__SSID_TM_acct_id AND dTicketCustomer.ETL__SourceSystem = @sourceSystem

	CREATE NONCLUSTERED INDEX IX_acct_id ON #Lkp_DimTicketCustomerId (acct_id)



	SELECT 
		@DimArenaId DimArenaId
		, @DimSeasonId DimSeasonId
		, @DimEventId DimEventId
		, ISNULL(ldc.DimTicketCustomerId, -1) DimTicketCustomerId
		, -1 DimTicketCustomerId_Attended
		, ISNULL(dSeat.DimSeatId, -1) DimSeatId
		, @DimDateId DimDateId
		, datediff(second, cast(a.ScanDateTime as date), a.ScanDateTime) DimTimeId
		, ISNULL(dScanGate.DimScanGateId, -1) DimScanGateId
		, ISNULL(dScanType.DimScanTypeId, -1) DimScanTypeId
		, 1 ScanCount
		, 0 ScanCountFailed
		, a. ScanDateTime		
		, CAST(NULL AS NVARCHAR(255)) Barcode
		, CAST(NULL AS NVARCHAR(255)) IsMobile
		, @event_id ETL__SSID_TM_event_id
		, a.acct_id ETL__SSID_TM_acct_id
		, dSeat.ETL__SSID_TM_section_id
		, dSeat.ETL__SSID_TM_row_id
		, a.seat_num ETL__SSID_TM_seat_num
		, @sourceSystem ETL__SourceSystem
		, GETDATE() ETL__CreatedDate
		, GETDATE() ETL__UpdatedDate
	
	INTO #AttendTM
	FROM #seat a

	LEFT OUTER JOIN #Lkp_DimTicketCustomerId ldc ON ldc.acct_id = a.acct_id 	

	LEFT OUTER JOIN etl.vw_DimScanGate (nolock) dScanGate ON a.gate = dScanGate.ETL__SSID_TM_gate
		AND dScanGate.ETL__SourceSystem = @sourceSystem AND dScanGate.DimScanGateId > 0 AND dScanGate.ETL__IsDeleted = 0

	LEFT OUTER JOIN etl.vw_DimScanType (nolock) dScanType ON a.channel_ind = dScanType.ETL__SSID_TM_channel_ind
		AND dScanType.ETL__SourceSystem = @sourceSystem AND dScanType.DimScanTypeId > 0 AND dScanType.ETL__IsDeleted = 0

	LEFT OUTER JOIN etl.vw_DimSeat (nolock) dSeat ON @ManifestId = dSeat.ETL__SSID_TM_Manifest_Id AND a.section_name = dSeat.SectionName AND a.row_name = dSeat.RowName AND a.seat_num = dSeat.ETL__SSID_TM_Seat
		AND dSeat.ETL__SourceSystem = @sourceSystem AND dSeat.DimSeatId > 0 AND dSeat.ETL__IsDeleted = 0
	

	CREATE NONCLUSTERED INDEX IX_LoadKey ON #AttendTM (DimEventId, DimSeatId) 
 

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
	INNER JOIN #AttendTM a ON fi.DimEventId = a.DimEventId and fi.DimSeatId = a.DimSeatId
	INNER JOIN etl.vw_FactAttendance fa ON fi.DimEventId = fa.DimEventId and fi.DimSeatId = fa.DimSeatId
	WHERE ISNULL(fi.FactAttendanceId, -987) <> ISNULL(fa.FactAttendanceId, -987)
	 
 
 
END 
 
 
 
 
GO
