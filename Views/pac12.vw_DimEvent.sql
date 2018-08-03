SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [pac12].[vw_DimEvent] as 
(
	SELECT  [DimEventId], [ETL__SourceSystem], [ETL__CreatedDate], [ETL__UpdatedDate], [ETL__IsDeleted], [ETL__DeltaHashKey], [ETL__SSID], [ETL__SSID_PAC_SEASON], [ETL__SSID_PAC_EVENT], [ETL__SSID_TM_event_id], [EventCode], [EventName], [EventDesc], [EventClass], [EventDate], [EventTime], [EventDateTime], [EventOnSaleDateTime], [Arena], [Season], [PAC_ETYPE], [PAC_BASIS], [PAC_EGROUP], [PAC_KEYWORDS], [PAC_Tag], [TM_manifest_id], [TM_arena_id], [TM_season_id], [TM_major_category], [TM_minor_category], [EventStatus], [TM_retail_event_id], [TM_host_event_id], [TM_host_event_code], [Config_Category1], [Config_Category2], [Config_Category3], [Config_Category4], [Config_Category5], [EventOpenDateTime], [EventCloseDateTime], [Config_EventDateTime], [Config_EventOnSaleDateTime], [Config_IsRealtimeAttendanceEnabled], [Config_EventOpenDateTime], [Config_EventCloseDateTime], [Config_Capacity], [Config_IsFseEligible], [EventType], [Config_IsFactInventoryEligible], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate], [Custom_Int_1], [Custom_Int_2], [Custom_Int_3], [Custom_Int_4], [Custom_Int_5], [Custom_Dec_1], [Custom_Dec_2], [Custom_Dec_3], [Custom_Dec_4], [Custom_Dec_5], [Custom_DateTime_1], [Custom_DateTime_2], [Custom_DateTime_3], [Custom_DateTime_4], [Custom_DateTime_5], [Custom_Bit_1], [Custom_Bit_2], [Custom_Bit_3], [Custom_Bit_4], [Custom_Bit_5], [Custom_nVarChar_1], [Custom_nVarChar_2], [Custom_nVarChar_3], [Custom_nVarChar_4], [Custom_nVarChar_5], [TM_event_name], [TM_Team], [TM_event_name_long], [TM__host_event_name], [TM_event_report_group], [TM_plan_type], [TM_Event_Type], [TM_plan_abv], [TM_Enabled], [TM_Returnable], [TM_Barcode_Status], [TM_Print_Ticket_Ind], [TM_exchange_price_opt], [DimEventHeaderId]
	FROM dbo.DimEvent_V2 (NOLOCK)
)
GO
