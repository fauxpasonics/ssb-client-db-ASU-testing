SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[PAC_LoadFacts]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(MAX) = null
)

AS
BEGIN

	EXEC etl.Load_stg_FactTicketSalesBaseEvents

	EXEC etl.PAC_Stage_FactTicketSales_Events

	EXEC [etl].[PAC_FactTicketSales_DeleteReturns] 

	EXEC etl.Cust_FactTicketSalesProcessing

	EXEC [etl].[SSB_ProcessStandardMerge_Dev_20170730] @BatchId = '00000000-0000-0000-0000-000000000000', @Target = 'dbo.FactTicketSales_V2', @Source = 'etl.vw_Load_PAC_FactTicketSales', @BusinessKey = 'ETL__SSID_PAC_CUSTOMER, ETL__SSID_PAC_SEASON, ETL__SSID_PAC_ITEM, ETL__SSID_PAC_EVENT, ETL__SSID_PAC_E_PL, ETL__SSID_PAC_E_PT, ETL__SSID_PAC_E_STAT, ETL__SSID_PAC_E_PRICE, ETL__SSID_PAC_E_DAMT', @SourceSystem = 'PAC'
	
	EXEC [etl].[Load_PAC_FactOdet_V2_Events] 	

	EXEC etl.PAC_LoadFactAttendance

	EXEC etl.PAC_LoadFactInventory	

	UPDATE fi
	SET fi.ETL__UpdatedDate = GETDATE()
	, fi.FactAttendanceId = fa.FactAttendanceId
	--SELECT TOP 1000 *
	FROM etl.vw_FactInventory fi
	INNER JOIN etl.vw_FactAttendance fa ON fi.DimEventId = fa.DimEventId AND fi.DimSeatId = fa.DimSeatId
	WHERE ISNULL(fi.FactAttendanceId, 0) <> ISNULL(fa.FactAttendanceId, 0)


END





GO
