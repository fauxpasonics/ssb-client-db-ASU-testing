SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [pac12].[vw_FactAttendance] as 
(
	SELECT  [FactAttendanceId], [ETL__SourceSystem], [ETL__CreatedDate], [ETL__UpdatedDate], [ETL__SSID], [ETL__SSID_PAC_CUSTOMER], [ETL__SSID_PAC_SEASON], [ETL__SSID_PAC_EVENT], [ETL__SSID_PAC_LEVEL], [ETL__SSID_PAC_SECTION], [ETL__SSID_PAC_ROW], [ETL__SSID_PAC_SEAT], [ETL__SSID_TM_event_id], [ETL__SSID_TM_section_id], [ETL__SSID_TM_row_id], [ETL__SSID_TM_seat_num], [ETL__SSID_TM_acct_id], [DimArenaId], [DimSeasonId], [DimEventId], [DimSeatId], [DimDateId], [DimTimeId], [DimTicketCustomerId], [DimTicketCustomerId_Attended], [DimScanGateId], [DimScanTypeId], [ScanCount], [ScanCountFailed], [ScanDateTime], [Barcode], [IsMobile], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate], [Custom_Int_1], [Custom_Int_2], [Custom_Int_3], [Custom_Int_4], [Custom_Int_5], [Custom_Dec_1], [Custom_Dec_2], [Custom_Dec_3], [Custom_Dec_4], [Custom_Dec_5], [Custom_DateTime_1], [Custom_DateTime_2], [Custom_DateTime_3], [Custom_DateTime_4], [Custom_DateTime_5], [Custom_Bit_1], [Custom_Bit_2], [Custom_Bit_3], [Custom_Bit_4], [Custom_Bit_5], [Custom_nVarChar_1], [Custom_nVarChar_2], [Custom_nVarChar_3], [Custom_nVarChar_4], [Custom_nVarChar_5]
	FROM dbo.FactAttendance_V2 (NOLOCK)
)
GO
