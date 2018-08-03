SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [pac12].[vw_DimSeatStatus] as 
(
	SELECT  [DimSeatStatusId], [ETL__SourceSystem], [ETL__CreatedDate], [ETL__UpdatedDate], [ETL__IsDeleted], [ETL__DeltaHashKey], [ETL__SSID], [ETL__SSID_PAC_SEASON], [ETL__SSID_PAC_SSTAT], [ETL__SSID_TM_class_id], [SeatStatusCode], [SeatStatusName], [SeatStatusDesc], [SeatStatusClass], [IsKill], [Season], [IsCustomStatus], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate], [Custom_Int_1], [Custom_Int_2], [Custom_Int_3], [Custom_Int_4], [Custom_Int_5], [Custom_Dec_1], [Custom_Dec_2], [Custom_Dec_3], [Custom_Dec_4], [Custom_Dec_5], [Custom_DateTime_1], [Custom_DateTime_2], [Custom_DateTime_3], [Custom_DateTime_4], [Custom_DateTime_5], [Custom_Bit_1], [Custom_Bit_2], [Custom_Bit_3], [Custom_Bit_4], [Custom_Bit_5], [Custom_nVarChar_1], [Custom_nVarChar_2], [Custom_nVarChar_3], [Custom_nVarChar_4], [Custom_nVarChar_5], [TM_matrix_char], [TM_color], [TM_return_class_id], [TM_valid_for_reclass], [TM_dist_status], [TM_dist_name], [TM_dist_ett], [TM_ism_class_id], [TM_qualifier_state_names], [TM_system_class], [TM_qualifier_template], [TM_unsold_type], [TM_unsold_qual_id], [TM_attrib_type], [TM_attrib_code], [TM_qualifier_state_name]
	FROM dbo.DimSeatStatus_V2 (NOLOCK)
)
GO
