SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[PAC_LoadDims_V2]
AS

BEGIN 


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimArena', 'etl.vw_Load_PAC_DimArena', 'ETL__SSID_PAC_FACILITY', 'PAC'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimEvent', 'etl.vw_Load_PAC_DimEvent', 'ETL__SSID_PAC_SEASON, ETL__SSID_PAC_EVENT', 'PAC'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimItem', 'etl.vw_Load_PAC_DimItem', 'ETL__SSID_PAC_SEASON, ETL__SSID_PAC_ITEM', 'PAC'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimPlan', 'etl.vw_Load_PAC_DimPlan', 'ETL__SSID_PAC_SEASON, ETL__SSID_PAC_ITEM', 'PAC'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimPromo', 'etl.vw_Load_PAC_DimPromo', 'ETL__SSID_PAC_PROMO', 'PAC'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimSalesCode', 'etl.vw_Load_PAC_DimSalesCode', 'ETL__SSID_PAC_SALECODE', 'PAC'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimSeason', 'etl.vw_Load_PAC_DimSeason', 'ETL__SSID_PAC_SEASON', 'PAC'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimPriceLevel', 'etl.vw_Load_PAC_DimPriceLevel', 'ETL__SSID_PAC_SEASON, ETL__SSID_PAC_PTABLE, ETL__SSID_PAC_PL', 'PAC'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimPriceType', 'etl.vw_Load_PAC_DimPriceType', 'ETL__SSID_PAC_SEASON, ETL__SSID_PAC_PRTYPE', 'PAC'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimRep', 'etl.vw_Load_PAC_DimRep', 'ETL__SSID_PAC_MARK', 'PAC'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimSeatStatus', 'etl.vw_Load_PAC_DimSeatStatus', 'ETL__SSID_PAC_SEASON, ETL__SSID_PAC_SSTAT', 'PAC'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimSeat', 'etl.vw_Load_PAC_DimSeat', 'ETL__SSID_PAC_SEASON, ETL__SSID_PAC_LEVEL, ETL__SSID_PAC_SECTION, ETL__SSID_PAC_ROW, ETL__SSID_PAC_SEAT', 'PAC'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimTicketCustomer', 'etl.vw_Load_PAC_DimTicketCustomer', 'ETL__SSID_PAC_PATRON', 'PAC'


END
















GO
