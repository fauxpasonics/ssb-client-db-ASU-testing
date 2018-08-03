SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [pac12].[Load_Dims]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(max) = NULL
)

AS
BEGIN


/*
DimArena
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'pac12.DimArena', 'etl.vw_Load_DimArena', 'ETL__SSID_FACILITY', @Options

/*
DimSeason
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'pac12.DimSeason', 'etl.vw_Load_DimSeason', 'ETL__SSID_SEASON', @Options

/*
DimEvent
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'pac12.DimEvent', 'etl.vw_Load_DimEvent', 'ETL__SSID_SEASON, ETL__SSID_EVENT', @Options

/*
DimPlan
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'pac12.DimPlan', 'etl.vw_Load_DimPlan', 'ETL__SSID_SEASON, ETL__SSID_ITEM', @Options

/*
DimItem
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'pac12.DimItem', 'etl.vw_Load_DimItem', 'ETL__SSID_SEASON, ETL__SSID_ITEM', @Options

/*
DimPriceLevel
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'pac12.DimPriceLevel', 'etl.vw_Load_DimPriceLevel', 'ETL__SSID_SEASON,ETL__SSID_PTable,ETL__SSID_PL', @Options

/*
DimPriceType
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'pac12.DimPriceType', 'etl.vw_Load_DimPriceType', 'ETL__SSID_SEASON,ETL__SSID_PRTYPE', @Options

/*
DimPromo
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'pac12.DimPromo', 'etl.vw_Load_DimPromo', 'ETL__SSID_Promo', @Options

/*
DimRep
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'pac12.DimRep', 'etl.vw_Load_DimRep', 'ETL__SSID_MARK', @Options

/*
DimSalesCode
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'pac12.DimSalesCode', 'etl.vw_Load_DimSalesCode', 'ETL__SSID_SALECODE', @Options

/*
DimSeat
*/
--EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'dbo.DimSeat', 'etl.vw_Load_DimSeat', 'ETL__SSID_SEASON,ETL__SSID_LEVEL,ETL__SSID_SECTION,ETL__SSID_ROW,ETL__SSID_PacSeat', @Options

/*TO DO TO DO TO DO TO DO TO DO TO DO TO DO TO DO TO DO TO DO TO DO TO DO TO DO TO DO */
--EXEC etl.Cust_LoadDimSeat_NewOnly @BatchId, @Options

/*
DimSeatStatus
*/
EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'pac12.DimSeatStatus', 'etl.vw_Load_DimSeatStatus', 'ETL__SSID_SEASON,ETL__SSID_SSTAT', @Options


/*
DimTicketCustomer
*/
--EXEC [etl].[SSB_ProcessStandardMerge_SCD2] @BatchId, 'dbo.DimTicketCustomer', 'etl.vw_Load_DimTicketCustomer', 'ETL__SSID_PATRON', @Options

/*TO DO TO DO TO DO TO DO TO DO TO DO TO DO TO DO TO DO TO DO TO DO TO DO TO DO TO DO */
EXEC etl.Cust_LoadDimTicketCustomer_NewOnly @BatchId, @Options


END
GO
