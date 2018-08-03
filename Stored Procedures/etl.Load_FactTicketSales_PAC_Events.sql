SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_FactTicketSales_PAC_Events] 
( 
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000', 
	@Options NVARCHAR(max) = NULL 
) 
 
AS 
BEGIN 
 
--DECLARE @RunTime datetime = GETDATE() 
 
 
INSERT INTO dbo.FactTicketSales_V2
( 
	ETL__SourceSystem, ETL__CreatedBy, ETL__CreatedDate, ETL__UpdatedDate, 
	ETL__SSID, ETL__SSID_PAC_CUSTOMER, ETL__SSID_PAC_SEASON, ETL__SSID_PAC_ITEM, ETL__SSID_PAC_EVENT, ETL__SSID_PAC_E_PL, ETL__SSID_PAC_E_PT, ETL__SSID_PAC_E_STAT, ETL__SSID_PAC_E_PRICE, ETL__SSID_PAC_E_DAMT,
	DimDateId, DimTimeId, DimTicketCustomerId, DimArenaId, DimSeasonId, DimItemId,
	DimEventId, DimPlanId, DimPriceLevelId, DimPriceTypeId, DimPriceCodeId, DimLedgerId, DimSeatId_Start, DimSeatStatusId, DimRepId, DimSalesCodeId,
	DimPromoId, DimPlanTypeId, DimTicketTypeId, DimSeatTypeId, DimTicketClassId, OrderDate, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate,
	QtySeat, QtySeatFSE, QtySeatRenewable, RevenueTicket, RevenueFees, RevenueSurcharge, RevenueTax, RevenueTotal, FullPrice, Discount, PaidStatus,
	PaidAmount, OwedAmount, PaymentDateFirst, PaymentDateLast, IsSold, IsReserved, IsReturned, IsPremium, IsDiscount, IsComp, IsHost, IsPlan, IsPartial,
	IsSingleEvent, IsGroup, IsBroker, IsRenewal, IsExpanded, IsAutoRenewalNextSeason
)

 
SELECT 
	'PAC' ETL__SourceSystem, SUSER_NAME() ETL__CreatedBy, GETDATE() ETL__CreatedDate, GETDATE() ETL__UpdatedDate

	, CONCAT(tkt.CUSTOMER, ':', tkt.SEASON, ':', tkt.ITEM, ':', tkt.EVENT, ':', tkt.E_PL, ':', tkt.E_PT, ':', tkt.E_STAT, ':', tkt.E_PRICE, ':', tkt.E_DAMT) SSID

	, tkt.CUSTOMER ETL__SSID_PAC_CUSTOMER
	, tkt.SEASON ETL__SSID_PAC_SEASON
	, tkt.ITEM ETL__SSID_PAC_ITEM
	, tkt.EVENT ETL__SSID_PAC_EVENT
	, tkt.E_PL ETL__SSID_PAC_E_PL
	, tkt.E_PT ETL__SSID_PAC_E_PT
	, tkt.E_STAT ETL__SSID_PAC_E_STAT
	, tkt.E_PRICE ETL__SSID_PAC_E_PRICE
	, tkt.E_DAMT ETL__SSID_PAC_E_DAMT
 
	, CASE WHEN tkt.MINPAYMENTDATE IS NULL THEN 0 ELSE CONVERT(NVARCHAR(8), tkt.MINPAYMENTDATE, 112) END DimDateId 
	, CASE WHEN tkt.MINPAYMENTDATE IS NULL THEN 0 ELSE datediff(second, cast(tkt.MINPAYMENTDATE as date), tkt.MINPAYMENTDATE) END DimTimeId 
	, ISNULL(dTicketCustomer.DimTicketCustomerId, -1) DimTicketCustomerId 
	, ISNULL(dArena.DimArenaId, -1) DimArenaId 
	, ISNULL(dSeason.DimSeasonId, -1)  DimSeasonId 
	, ISNULL(dItem.DimItemId, -1)  DimItemId 
	, ISNULL(dEvent.DimEventId, -1)  DimEventId 
	, CASE WHEN ISNULL(tkt.ITEM,'') = ISNULL(tkt.[EVENT],'') THEN 0 ELSE ISNULL(dplan.DimPlanId, -1) END DimPlanId 
	, ISNULL(dPriceLevel.DimPriceLevelId, -1)  DimPriceLevelId 
	, ISNULL(dPriceType.DimPriceTypeId, -1)  DimPriceTypeId 

	, 0 DimPriceCodeId 
	, 0 DimLedgerId
	, -1 DimSeatId_Start 
	, -1 DimSeatStatusId
	, -1 DimRepId 
	, -1 DimSalesCodeId 
	, -1 DimPromoId
 
	, -1 DimPlanTypeId
	, -1 DimTicketTypeId
	, -1 DimSeatTypeId
	, -1 DimTicketClassId

	, tkt.MINPAYMENTDATE OrderDate
	, CAST(NULL AS NVARCHAR(255)) SSCreatedBy
	, CAST(NULL AS NVARCHAR(255)) SSUpdatedBy
	, CAST(NULL AS DATETIME) SSCreatedDate
	, CAST(NULL AS DATETIME) SSUpdatedDate
 
	, ISNULL(tkt.ORDQTY,0) QtySeat 
	, CAST(0 AS DECIMAL(18,6)) QtySeatFSE
	, CAST(0 AS INT) QtySeatRenewable

	, ISNULL(tkt.ORDTOTAL,0) RevenueTicket
	, ISNULL(tkt.OrderConvenienceFee,0) RevenueFees
	, ISNULL(tkt.ORDFEE,0) RevenueSurcharge
	, CAST(0 AS DECIMAL(18,6)) RevenueTax	
	, ( ISNULL(tkt.ORDTOTAL,0) + ISNULL(tkt.OrderConvenienceFee,0) + ISNULL(tkt.ORDFEE,0) ) RevenueTotal 

	, ( ISNULL(tkt.ORDTOTAL,0) + ISNULL(tkt.OrderConvenienceFee,0) + ISNULL(tkt.ORDFEE,0) ) + ( ISNULL(tkt.ORDQTY,0) * ISNULL(tkt.E_DAMT,0) ) FullPrice 
	, ( ISNULL(tkt.ORDQTY,0) * ISNULL(tkt.E_DAMT,0) ) Discount 

	, CASE 
		WHEN ISNULL(tkt.PAIDTOTAL,0) >= tkt.ORDTOTAL THEN 'Y'
		WHEN ISNULL(tkt.PAIDTOTAL,0) > 0 THEN 'P'		
		ELSE 'N' 
	END  PaidStatus
	, ISNULL(tkt.PAIDTOTAL,0) PaidAmount 
	, ( ISNULL(tkt.ORDTOTAL,0) - ISNULL(tkt.PAIDTOTAL,0)) OwedAmount 
	, tkt.MINPAYMENTDATE PaymentDateFirst
	, CAST(NULL AS DATETIME) PaymentDateLast

	, CAST(1 AS BIT) IsSold
	, CAST(0 AS BIT) IsReserved
	, CAST(0 AS BIT)  IsReturned
	, CAST(NULL AS BIT) IsPremium
	, CAST(NULL AS BIT)  IsDiscount
	, CAST(CASE WHEN tkt.ORDTOTAL > 0 THEN 0 ELSE 1 END AS bit) IsComp
	, CAST(0 AS BIT) IsHost
	, CAST(CASE WHEN dplan.DimPlanId IS NULL THEN 0 ELSE 1 END AS bit) IsPlan
	, CAST(NULL AS BIT) IsPartial
	, CAST(CASE WHEN dplan.DimPlanId IS NULL THEN 1 ELSE 0 END AS bit) IsSingleEvent
	, CAST(NULL AS BIT) IsGroup
	, CAST(NULL AS BIT)  IsBroker
	, CAST(NULL AS BIT)  IsRenewal
	, CAST(NULL AS BIT)  IsExpanded
	, CAST(NULL AS BIT) IsAutoRenewalNextSeason	
 

 --6082


--SELECT COUNT(*)
FROM stg.FactTicketSalesBase (NOLOCK) tkt

LEFT OUTER JOIN dbo.DimSeason (NOLOCK) dSeason ON tkt.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = dSeason.ETL__SSID_PAC_SEASON
	 AND dSeason.ETL__SourceSystem = 'PAC' AND dSeason.DimSeasonId > 0 AND ISNULL(tkt.MINPAYMENTDATE, GETDATE()) BETWEEN dSeason.ETL__StartDate AND ISNULL(dSeason.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimTicketCustomer (NOLOCK) dTicketCustomer ON tkt.CUSTOMER = dTicketCustomer.ETL__SSID_PAC_PATRON
	AND dTicketCustomer.ETL__SourceSystem = 'PAC' AND dTicketCustomer.DimTicketCustomerId > 0 AND ISNULL(tkt.MINPAYMENTDATE, GETDATE()) BETWEEN dTicketCustomer.ETL__StartDate AND ISNULL(dTicketCustomer.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimItem (NOLOCK) dItem ON tkt.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = dItem.ETL__SSID_PAC_SEASON AND tkt.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS = dItem.ETL__SSID_PAC_ITEM
	AND dItem.ETL__SourceSystem = 'PAC' AND dItem.DimItemId > 0 AND ISNULL(tkt.MINPAYMENTDATE, GETDATE()) BETWEEN dItem.ETL__StartDate AND ISNULL(dItem.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimEvent (NOLOCK) dEvent ON tkt.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = dEvent.ETL__SSID_PAC_SEASON AND tkt.[EVENT] COLLATE SQL_Latin1_General_CP1_CS_AS = dEvent.ETL__SSID_PAC_EVENT
	AND dEvent.ETL__SourceSystem = 'PAC' AND dEvent.DimEventId > 0 AND ISNULL(tkt.MINPAYMENTDATE, GETDATE()) BETWEEN dEvent.ETL__StartDate AND ISNULL(dEvent.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimPlan (NOLOCK) dplan ON tkt.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = dplan.ETL__SSID_PAC_SEASON AND tkt.[ITEM] COLLATE SQL_Latin1_General_CP1_CS_AS = dplan.ETL__SSID_PAC_ITEM
	AND dplan.ETL__SourceSystem = 'PAC' AND dplan.DimPlanId > 0 AND ISNULL(tkt.MINPAYMENTDATE, GETDATE()) BETWEEN dplan.ETL__StartDate AND ISNULL(dplan.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimArena (NOLOCK) dArena ON dEvent.Arena COLLATE SQL_Latin1_General_CP1_CS_AS = dArena.ETL__SSID_PAC_FACILITY
	AND dArena.ETL__SourceSystem = 'PAC' AND dArena.DimArenaId > 0 AND ISNULL(tkt.MINPAYMENTDATE, GETDATE()) BETWEEN dArena.ETL__StartDate AND ISNULL(dArena.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.TK_ITEM (NOLOCK) tkItem ON tkt.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = tkItem.SEASON AND tkt.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS  = tkItem.ITEM

LEFT OUTER JOIN dbo.DimPriceLevel (NOLOCK) dPriceLevel ON tkt.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = dPriceLevel.ETL__SSID_PAC_SEASON AND tkItem.PTABLE COLLATE SQL_Latin1_General_CP1_CS_AS = dPriceLevel.ETL__SSID_PAC_PTable AND tkt.[E_PL] COLLATE SQL_Latin1_General_CP1_CS_AS = dPriceLevel.ETL__SSID_PAC_PL
	AND dPriceLevel.ETL__SourceSystem = 'PAC' AND dPriceLevel.DimPriceLevelId > 0 AND ISNULL(tkt.MINPAYMENTDATE, GETDATE()) BETWEEN dPriceLevel.ETL__StartDate AND ISNULL(dPriceLevel.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimPriceType (NOLOCK) dPriceType ON tkt.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = dPriceType.ETL__SSID_PAC_SEASON and tkt.[E_PT] COLLATE SQL_Latin1_General_CP1_CS_AS = dPriceType.ETL__SSID_PAC_PRTYPE
	AND dPriceType.ETL__SourceSystem = 'PAC' AND dPriceType.DimPriceTypeId > 0 AND ISNULL(tkt.MINPAYMENTDATE, GETDATE()) BETWEEN dPriceType.ETL__StartDate AND ISNULL(dPriceType.ETL__EndDate, '3000-01-01')

--WHERE tkt.SEASON = 'F17' AND tkt.EVENT = 'F06'
--AND tkt.E_PL = 16
--AND tkt.MINPAYMENTDATE  IS NULL
 
 
END 
 
 
 
 


GO
