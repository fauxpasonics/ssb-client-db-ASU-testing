SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [pac12].[vw_DimSeat] as 
(
	SELECT  [DimSeatId], [ETL__SourceSystem], [ETL__CreatedDate], [ETL__UpdatedDate], [ETL__IsDeleted], [ETL__DeltaHashKey], [ETL__SSID], [ETL__SSID_PAC_SEASON], [ETL__SSID_PAC_LEVEL], [ETL__SSID_PAC_SECTION], [ETL__SSID_PAC_ROW], [ETL__SSID_PAC_SEAT], [ETL__SSID_TM_manifest_id], [ETL__SSID_TM_section_id], [ETL__SSID_TM_row_id], [ETL__SSID_TM_seat], [Season], [LevelName], [SectionName], [RowName], [Seat], [DefaultPriceLevel], [Config_Location], [DefaultClass], [DefaultPriceCode], [SortOrderLevel], [SortOrderSection], [SortOrderRow], [SortOrderSeat], [LevelDesc], [SectionDesc], [RowDesc], [Config_ClosestDimGateId], [Config_IsCapacityEligible], [Config_LevelName], [Config_SectionName], [Config_RowName], [Config_Category1], [Config_Category2], [Config_Category3], [Config_Category4], [Config_Category5], [Config_IsFactInventoryEligible], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate], [Custom_Int_1], [Custom_Int_2], [Custom_Int_3], [Custom_Int_4], [Custom_Int_5], [Custom_Dec_1], [Custom_Dec_2], [Custom_Dec_3], [Custom_Dec_4], [Custom_Dec_5], [Custom_DateTime_1], [Custom_DateTime_2], [Custom_DateTime_3], [Custom_DateTime_4], [Custom_DateTime_5], [Custom_Bit_1], [Custom_Bit_2], [Custom_Bit_3], [Custom_Bit_4], [Custom_Bit_5], [Custom_nVarChar_1], [Custom_nVarChar_2], [Custom_nVarChar_3], [Custom_nVarChar_4], [Custom_nVarChar_5], [TM_section_name], [TM_section_desc], [TM_section_type], [TM_section_type_name], [TM_gate], [TM_ga], [TM_row_id], [TM_row_name], [TM_row_desc], [TM_default_class], [TM_class_name], [TM_def_price_code], [TM_tm_section_name], [TM_tm_row_name], [TM_section_info1], [TM_section_info2], [TM_section_info3], [TM_section_info4], [TM_section_info5], [TM_row_info1], [TM_row_info2], [TM_row_info3], [TM_row_info4], [TM_row_info5], [TM_manifest_name], [TM_aisle]
	FROM dbo.DimSeat_V2 (NOLOCK)
)
GO
