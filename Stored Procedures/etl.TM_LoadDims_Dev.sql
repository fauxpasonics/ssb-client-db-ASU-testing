SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[TM_LoadDims_Dev]
AS

BEGIN 

--TRUNCATE TABLE dbo.DimArena

--SELECT * FROM dbo.DimArena

EXEC [etl].[SSB_ProcessStandardMerge_SCD] '00000000-0000-0000-0000-000000000000', 'dbo.DimArena', 'etl.vw_Load_TM_DimArena', 'ETL__SSID_TM_arena_id', 'TM'


--TRUNCATE TABLE dbo.DimSeason

--SELECT * FROM dbo.DimSeason

EXEC [etl].[SSB_ProcessStandardMerge_SCD] '00000000-0000-0000-0000-000000000000', 'dbo.DimSeason', 'etl.vw_Load_TM_DimSeason', 'ETL__SSID_TM_season_id', 'TM'


--TRUNCATE TABLE dbo.DimItem

--SELECT * FROM dbo.DimItem

EXEC [etl].[SSB_ProcessStandardMerge_SCD] '00000000-0000-0000-0000-000000000000', 'dbo.DimItem', 'etl.vw_Load_TM_DimItem', 'ETL__SSID_TM_Event_id', 'TM'


--TRUNCATE TABLE dbo.DimEvent

--SELECT * FROM dbo.DimEvent

EXEC [etl].[SSB_ProcessStandardMerge_SCD] '00000000-0000-0000-0000-000000000000', 'dbo.DimEvent', 'etl.vw_Load_TM_DimEvent', 'ETL__SSID_TM_Event_id', 'TM'
--, '<options><Debug>true</Debug></options>'


--TRUNCATE TABLE dbo.DimPlan

--SELECT * FROM dbo.DimPlan

EXEC [etl].[SSB_ProcessStandardMerge_SCD] '00000000-0000-0000-0000-000000000000', 'dbo.DimPlan', 'etl.vw_Load_TM_DimPlan', 'ETL__SSID_TM_event_id', 'TM'


--TRUNCATE TABLE dbo.DimPromo

--SELECT * FROM dbo.DimPromo

EXEC [etl].[SSB_ProcessStandardMerge_SCD] '00000000-0000-0000-0000-000000000000', 'dbo.DimPromo', 'etl.vw_Load_TM_DimPromo', 'ETL__SSID_TM_promo_code', 'TM'


--TRUNCATE TABLE dbo.DimSalesCode

--SELECT * FROM dbo.DimSalesCode

EXEC [etl].[SSB_ProcessStandardMerge_SCD] '00000000-0000-0000-0000-000000000000', 'dbo.DimSalesCode', 'etl.vw_Load_TM_DimSalesCode', 'ETL__SSID_TM_sell_location_id', 'TM'


--TRUNCATE TABLE dbo.DimPriceCode

--SELECT * FROM dbo.DimPriceCode

EXEC [etl].[TM_LoadDimPriceCodeMaster] 

EXEC [etl].[SSB_ProcessStandardMerge_SCD] '00000000-0000-0000-0000-000000000000', 'dbo.DimPriceCode', 'etl.vw_Load_TM_DimPriceCode', 'ETL__SSID_TM_event_id, ETL__SSID_TM_price_code', 'TM'
--, '<options><ResetDeltaHashKey>true</ResetDeltaHashKey><Debug>false</Debug></options>'


--TRUNCATE TABLE dbo.DimRep

--SELECT * FROM dbo.DimRep

EXEC [etl].[SSB_ProcessStandardMerge_SCD] '00000000-0000-0000-0000-000000000000', 'dbo.DimRep', 'etl.vw_Load_TM_DimRep', 'ETL__SSID_TM_acct_id', 'TM'



--TRUNCATE TABLE dbo.DimSeatStatus

--SELECT * FROM dbo.DimSeatStatus

EXEC [etl].[SSB_ProcessStandardMerge_SCD] '00000000-0000-0000-0000-000000000000', 'dbo.DimSeatStatus', 'etl.vw_Load_TM_DimSeatStatus', 'ETL__SSID_TM_class_id', 'TM'


--TRUNCATE TABLE dbo.DimLedger

--SELECT * FROM dbo.DimLedger

EXEC [etl].[SSB_ProcessStandardMerge_SCD] '00000000-0000-0000-0000-000000000000', 'dbo.DimLedger', 'etl.vw_Load_TM_DimLedger', 'ETL__SSID_TM_ledger_id', 'TM'


--TRUNCATE TABLE dbo.DimSeat

--SELECT * FROM dbo.DimSeat

EXEC [etl].[SSB_ProcessStandardMerge_SCD] '00000000-0000-0000-0000-000000000000', 'dbo.DimSeat', 'etl.vw_Load_TM_DimSeat', 'ETL__SSID_TM_manifest_id, ETL__SSID_TM_section_id, ETL__SSID_TM_row_id, ETL__SSID_TM_seat', 'TM'


--TRUNCATE TABLE dbo.DimTicketCustomer

--SELECT * FROM dbo.DimTicketCustomer

EXEC [etl].[SSB_ProcessStandardMerge_SCD] '00000000-0000-0000-0000-000000000000', 'dbo.DimTicketCustomer', 'etl.vw_Load_TM_DimTicketCustomer', 'ETL__SSID_TM_acct_id', 'TM'




END















GO
