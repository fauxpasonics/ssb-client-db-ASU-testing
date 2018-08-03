SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[PAC_FactTicketSales_DeleteReturns] 
AS 

BEGIN


	--DECLARE @TMSourceSystem NVARCHAR(255) = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))

	/* Get Ods Values */
	SELECT stg.ETL__SSID_PAC_CUSTOMER, stg.ETL__SSID_PAC_SEASON, stg.ETL__SSID_PAC_ITEM, stg.ETL__SSID_PAC_EVENT, stg.ETL__SSID_PAC_E_PL, stg.ETL__SSID_PAC_E_PT, stg.ETL__SSID_PAC_E_STAT, stg.ETL__SSID_PAC_E_PRICE, stg.ETL__SSID_PAC_E_DAMT
	INTO #stg
	FROM stg.FactTicketSales_V2 stg
	--LEFT OUTER JOIN dbo.DimItem dItem ON CASE WHEN tkt.plan_event_id = 0 THEN tkt.event_id ELSE tkt.plan_event_id END = dItem.SSID_event_id AND dItem.SourceSystem = @TMSourceSystem AND dItem.DimItemId > 0
	--WHERE ISNULL(dItem.Config_IsFactSalesEligible,1) = 1 AND ISNULL(dItem.Config_IsClosed,0) = 0

	
	/* Get Facts */
	SELECT f.FactTicketSalesId, f.ETL__SSID_PAC_CUSTOMER, f.ETL__SSID_PAC_SEASON, f.ETL__SSID_PAC_ITEM, f.ETL__SSID_PAC_EVENT, f.ETL__SSID_PAC_E_PL, f.ETL__SSID_PAC_E_PT, f.ETL__SSID_PAC_E_STAT, f.ETL__SSID_PAC_E_PRICE, f.ETL__SSID_PAC_E_DAMT
	INTO #fact
	FROM etl.vw_FactTicketSales f
	--INNER JOIN dbo.DimItem di ON f.DimItemId = di.DimItemId
	WHERE f.ETL__SourceSystem = 'PAC'
	--AND ISNULL(di.Config_IsClosed,0) = 0


	/* Compare 2 sets for records only in fact */
	SELECT f.* 
	INTO #ToDelete
	FROM #fact f
	LEFT OUTER JOIN #stg stg
		ON 
		ISNULL(f.[ETL__SSID_PAC_CUSTOMER], 'DBNULL') = ISNULL(stg.[ETL__SSID_PAC_CUSTOMER], 'DBNULL') 
		AND ISNULL(f.[ETL__SSID_PAC_SEASON], 'DBNULL') = ISNULL(stg.[ETL__SSID_PAC_SEASON], 'DBNULL') 
		AND ISNULL(f.[ETL__SSID_PAC_ITEM], 'DBNULL') = ISNULL(stg.[ETL__SSID_PAC_ITEM], 'DBNULL') 
		AND ISNULL(f.[ETL__SSID_PAC_EVENT], 'DBNULL') = ISNULL(stg.[ETL__SSID_PAC_EVENT], 'DBNULL') 
		AND ISNULL(f.[ETL__SSID_PAC_E_PL], 'DBNULL') = ISNULL(stg.[ETL__SSID_PAC_E_PL], 'DBNULL') 
		AND ISNULL(f.[ETL__SSID_PAC_E_PT], 'DBNULL') = ISNULL(stg.[ETL__SSID_PAC_E_PT], 'DBNULL') 
		AND ISNULL(f.[ETL__SSID_PAC_E_STAT], 'DBNULL') = ISNULL(stg.[ETL__SSID_PAC_E_STAT], 'DBNULL') 
		AND ISNULL(f.[ETL__SSID_PAC_E_PRICE], -987) = ISNULL(stg.[ETL__SSID_PAC_E_PRICE], -987)
		AND ISNULL(f.[ETL__SSID_PAC_E_DAMT], -987) = ISNULL(stg.[ETL__SSID_PAC_E_DAMT], -987)
	WHERE stg.ETL__SSID_PAC_CUSTOMER IS NULL


	DELETE f
	FROM etl.vw_FactTicketSales f
	INNER JOIN #ToDelete td ON f.FactTicketSalesId = td.FactTicketSalesId




END





GO
