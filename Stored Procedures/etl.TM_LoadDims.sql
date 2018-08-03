SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[TM_LoadDims]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(MAX) = null
)
AS

BEGIN 


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimArena', 'etl.vw_Load_TM_DimArena', 'ETL__SSID_TM_arena_id', 'TM'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimSeason', 'etl.vw_Load_TM_DimSeason', 'ETL__SSID_TM_season_id', 'TM'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimItem', 'etl.vw_Load_TM_DimItem', 'ETL__SSID_TM_Event_id', 'TM'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimEvent', 'etl.vw_Load_TM_DimEvent', 'ETL__SSID_TM_Event_id', 'TM'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimPlan', 'etl.vw_Load_TM_DimPlan', 'ETL__SSID_TM_event_id', 'TM'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimPromo', 'etl.vw_Load_TM_DimPromo', 'ETL__SSID_TM_promo_code', 'TM'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimSalesCode', 'etl.vw_Load_TM_DimSalesCode', 'ETL__SSID_TM_sell_location_id', 'TM'


	EXEC [etl].[TM_LoadDimPriceCodeMaster] 


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimPriceCode', 'etl.vw_Load_TM_DimPriceCode', 'ETL__SSID_TM_event_id, ETL__SSID_TM_price_code', 'TM'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimRep', 'etl.vw_Load_TM_DimRep', 'ETL__SSID_TM_acct_id', 'TM'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimSeatStatus', 'etl.vw_Load_TM_DimSeatStatus', 'ETL__SSID_TM_class_id', 'TM'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimLedger', 'etl.vw_Load_TM_DimLedger', 'ETL__SSID_TM_ledger_id', 'TM'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimSeat', 'etl.vw_Load_TM_DimSeat', 'ETL__SSID_TM_manifest_id, ETL__SSID_TM_section_id, ETL__SSID_TM_row_id, ETL__SSID_TM_seat', 'TM'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimTicketCustomer', 'etl.vw_Load_TM_DimTicketCustomer', 'ETL__SSID_TM_acct_id', 'TM'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimScanGate', 'etl.vw_Load_TM_DimScanGate', 'ETL__SSID_TM_gate', 'TM'


	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170728] '00000000-0000-0000-0000-000000000000', 'etl.vw_DimScanType', 'etl.vw_Load_TM_DimScanType', 'ETL__SSID_TM_channel_ind', 'TM'


END



















GO
