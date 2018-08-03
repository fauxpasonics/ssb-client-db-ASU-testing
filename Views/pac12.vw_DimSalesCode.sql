SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [pac12].[vw_DimSalesCode] as 
(
	SELECT  [DimSalesCodeId], [ETL__SourceSystem], [ETL__CreatedDate], [ETL__UpdatedDate], [ETL__IsDeleted], [ETL__DeltaHashKey], [ETL__SSID], [ETL__SSID_PAC_SALECODE], [ETL__SSID_TM_sell_location_id], [SalesCode], [SalesCodeName], [SalesCodeDesc], [SalesCodeClass], [Config_Category1], [Config_Category2], [Config_Category3], [Config_Category4], [Config_Category5], [CreatedBy], [UpdatedBy], [CreatedDate], [UpdatedDate], [Custom_Int_1], [Custom_Int_2], [Custom_Int_3], [Custom_Int_4], [Custom_Int_5], [Custom_Dec_1], [Custom_Dec_2], [Custom_Dec_3], [Custom_Dec_4], [Custom_Dec_5], [Custom_DateTime_1], [Custom_DateTime_2], [Custom_DateTime_3], [Custom_DateTime_4], [Custom_DateTime_5], [Custom_Bit_1], [Custom_Bit_2], [Custom_Bit_3], [Custom_Bit_4], [Custom_Bit_5], [Custom_nVarChar_1], [Custom_nVarChar_2], [Custom_nVarChar_3], [Custom_nVarChar_4], [Custom_nVarChar_5], [TM_outlet_code], [TM_active], [TM_protected], [TM_sort_order]
	FROM dbo.DimSalesCode_V2 (NOLOCK)
)
GO
