SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [pac12].[vw_DimPromo] as 
(
	SELECT  [DimPromoId], [ETL__SourceSystem], [ETL__CreatedDate], [ETL__UpdatedDate], [ETL__IsDeleted], [ETL__DeltaHashKey], [ETL__SSID], [ETL__SSID_PAC_PROMO], [ETL__SSID_TM_promo_code], [PromoCode], [PromoName], [PromoDesc], [PromoClass], [Config_Category1], [Config_Category2], [Config_Category3], [Config_Category4], [Config_Category5], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate], [Custom_Int_1], [Custom_Int_2], [Custom_Int_3], [Custom_Int_4], [Custom_Int_5], [Custom_Dec_1], [Custom_Dec_2], [Custom_Dec_3], [Custom_Dec_4], [Custom_Dec_5], [Custom_DateTime_1], [Custom_DateTime_2], [Custom_DateTime_3], [Custom_DateTime_4], [Custom_DateTime_5], [Custom_Bit_1], [Custom_Bit_2], [Custom_Bit_3], [Custom_Bit_4], [Custom_Bit_5], [Custom_nVarChar_1], [Custom_nVarChar_2], [Custom_nVarChar_3], [Custom_nVarChar_4], [Custom_nVarChar_5], [TM_promo_inet_name], [TM_promo_inet_desc], [TM_promo_type], [TM_promo_group_sell_flag], [TM_promo_active_flag], [TM_inet_start_datetime], [TM_inet_end_datetime], [TM_archtics_start_datetime], [TM_archtics_end_datetime], [TM_event_id]
	FROM dbo.DimPromo_V2 (NOLOCK)
)
GO
