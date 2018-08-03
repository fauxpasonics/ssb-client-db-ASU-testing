SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_Dims]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(max) = NULL
)

AS
BEGIN


/*
DimArena
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'dbo.DimArena', 'etl.vw_Load_DimArena', 'ETL__SSID_FACILITY', @Options

/*
DimSeason
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'dbo.DimSeason', 'etl.vw_Load_DimSeason', 'ETL__SSID_SEASON', @Options

/*
DimEvent
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'dbo.DimEvent', 'etl.vw_Load_DimEvent', 'ETL__SSID_SEASON, ETL__SSID_EVENT', @Options

/*
DimPlan
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'dbo.DimPlan', 'etl.vw_Load_DimPlan', 'ETL__SSID_SEASON, ETL__SSID_ITEM', @Options

/*
DimItem
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'dbo.DimItem', 'etl.vw_Load_DimItem', 'ETL__SSID_SEASON, ETL__SSID_ITEM', @Options

/*
DimPriceLevel
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'dbo.DimPriceLevel', 'etl.vw_Load_DimPriceLevel', 'ETL__SSID_SEASON,ETL__SSID_PTable,ETL__SSID_PL', @Options

/*
DimPriceType
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'dbo.DimPriceType', 'etl.vw_Load_DimPriceType', 'ETL__SSID_SEASON,ETL__SSID_PRTYPE', @Options

/*
DimPromo
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'dbo.DimPromo', 'etl.vw_Load_DimPromo', 'ETL__SSID_Promo', @Options

/*
DimRep
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'dbo.DimRep', 'etl.vw_Load_DimRep', 'ETL__SSID_MARK', @Options

/*
DimSalesCode
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'dbo.DimSalesCode', 'etl.vw_Load_DimSalesCode', 'ETL__SSID_SALECODE', @Options

/*
DimSeat
*/
--EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'dbo.DimSeat', 'etl.vw_Load_DimSeat', 'ETL__SSID_SEASON,ETL__SSID_LEVEL,ETL__SSID_SECTION,ETL__SSID_ROW,ETL__SSID_PacSeat', @Options

EXEC etl.Cust_LoadDimSeat_NewOnly @BatchId, @Options

/*
DimSeatStatus
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'dbo.DimSeatStatus', 'etl.vw_Load_DimSeatStatus', 'ETL__SSID_SEASON,ETL__SSID_SSTAT', @Options


/*
DimTicketCustomer
*/
--EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'dbo.DimTicketCustomer', 'etl.vw_Load_DimTicketCustomer', 'ETL__SSID_PATRON', @Options

EXEC etl.Cust_LoadDimTicketCustomer_NewOnly @BatchId, @Options


END
GO
