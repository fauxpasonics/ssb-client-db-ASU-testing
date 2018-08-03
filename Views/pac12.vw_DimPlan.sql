SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [pac12].[vw_DimPlan] as 
(
	SELECT  [DimPlanId], [ETL__SourceSystem], [ETL__CreatedDate], [ETL__UpdatedDate], [ETL__IsDeleted], [ETL__DeltaHashKey], [ETL__SSID], [ETL__SSID_PAC_SEASON], [ETL__SSID_PAC_ITEM], [ETL__SSID_TM_event_id], [PlanCode], [PlanName], [PlanDesc], [PlanClass], [Season], [PlanFSE], [PlanType], [PlanEventCnt], [Config_PlanName], [Config_PlanRenewableDimEventId], [Config_PlanFSE], [Config_PlanType], [Config_IsExpanded], [TM_season_id], [PlanRenewableDimEventId], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate], [Custom_Int_1], [Custom_Int_2], [Custom_Int_3], [Custom_Int_4], [Custom_Int_5], [Custom_Dec_1], [Custom_Dec_2], [Custom_Dec_3], [Custom_Dec_4], [Custom_Dec_5], [Custom_DateTime_1], [Custom_DateTime_2], [Custom_DateTime_3], [Custom_DateTime_4], [Custom_DateTime_5], [Custom_Bit_1], [Custom_Bit_2], [Custom_Bit_3], [Custom_Bit_4], [Custom_Bit_5], [Custom_nVarChar_1], [Custom_nVarChar_2], [Custom_nVarChar_3], [Custom_nVarChar_4], [Custom_nVarChar_5], [TM_event_name], [TM_Team], [TM_event_name_long], [TM__host_event_name], [TM_event_report_group], [TM_plan_type], [TM_Event_Type], [TM_Major_Category], [TM_Minor_Category], [TM_Enabled], [TM_Returnable], [TM_Barcode_Status], [TM_Print_Ticket_Ind], [TM_exchange_price_opt], [TM_plan_abv], [TM_Min_events], [TM_total_events], [TM_FSE], [TM_Dsps_allowed], [TM_MaxEventDate], [IsExpanded]
	FROM dbo.DimPlan_V2 (NOLOCK)
)
GO
