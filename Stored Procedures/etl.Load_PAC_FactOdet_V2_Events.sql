SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_PAC_FactOdet_V2_Events] 
( 
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000', 
	@Options NVARCHAR(max) = NULL 
) 
 
AS 
BEGIN 

TRUNCATE TABLE dbo.FactOdet_V2

INSERT INTO etl.vw_FactOdet 
(  
	ETL__SourceSystem, ETL__CreatedBy, ETL__CreatedDate, ETL__UpdatedDate, ETL__DeltaHashKey, ETL__SSID_PAC_CUSTOMER, ETL__SSID_PAC_SEASON, ETL__SSID_PAC_SEQ, ETL__SSID_PAC_VMC, ETL__SSID_PAC_SVMC
	, DimDateId, DimTimeId, DimTicketCustomerId, DimArenaId
	, DimSeasonId, DimItemId, DimEventId, DimPlanId, DimPriceLevelId, DimPriceTypeId, DimPriceCodeId, DimSeatId_Start, DimRepId, DimSalesCodeId, DimPromoId, DimPlanTypeId, DimTicketTypeId, DimSeatTypeId, DimTicketClassId
	, QtySeat, QtySeatFSE, QtySeatRenewable
	, RevenueTicket, RevenueFees, RevenueSurcharge, RevenueTax, RevenueTotal
	, FullPrice, Discount, PaidStatus, PaidAmount, OwedAmount, PaymentDateFirst, PaymentDateLast
	, IsSold, IsReserved, IsReturned, IsPremium, IsDiscount, IsComp, IsHost, IsPlan, IsPartial, IsSingleEvent, IsGroup, IsBroker, IsRenewal, IsExpanded, InRefSource, InRefData
	
) 
 
SELECT  

	'PAC' ETL__SourceSystem , SUSER_NAME() ETL__CreatedBy, GETDATE() ETL__CreatedDate, GETDATE() ETL__UpdatedDate
	, CAST(NULL AS BINARY(32)) ETL__DeltaHashKey

	, tkt.CUSTOMER [ETL__SSID_PAC_CUSTOMER]
	, tkt.SEASON [ETL__SSID_PAC_SEASON] 
	, tkt.SEQ [ETL__SSID_PAC_SEQ] 
	, tkt.VMC [ETL__SSID_PAC_VMC] 
	, tkt.SVMC [ETL__SSID_PAC_SVMC] 
	 
	, CASE WHEN tkt.I_DATE IS NULL THEN 0 ELSE CONVERT(NVARCHAR(8), tkt.I_DATE, 112) END DimDateId 
	, CASE WHEN tkt.ORIGTS_DATETIME IS NULL THEN 0 ELSE datediff(second, cast(tkt.ORIGTS_DATETIME as date), tkt.ORIGTS_DATETIME) END DimTimeId 
	, ISNULL(dTicketCustomer.DimTicketCustomerId, -1) DimTicketCustomerId 
	, ISNULL(dArena.DimArenaId, -1) DimArenaId 
	, ISNULL(dSeason.DimSeasonId, -1)  DimSeasonId 
	, ISNULL(dItem.DimItemId, -1)  DimItemId 
	, ISNULL(dEvent.DimEventId, -1)  DimEventId 
	, CASE WHEN ISNULL(tkt.ITEM,'') = ISNULL(tkt.[EVENT],'') THEN 0 ELSE ISNULL(dplan.DimPlanId, -1) END DimPlanId 
	, ISNULL(dPriceLevel.DimPriceLevelId, -1)  DimPriceLevelId 
	, ISNULL(dPriceType.DimPriceTypeId, -1)  DimPriceTypeId 

	, -1 DimPriceCodeId 
	, ISNULL(tkt.DimSeatId, -1) DimSeatId_Start 
	, ISNULL(dRep.DimRepId, -1) DimRepId 
	, ISNULL(dSalesCode.DimSalesCodeId, -1) DimSalesCodeId 
	, ISNULL(dPromo.DimPromoId, -1) DimPromoId

	, -1 DimPlanTypeId 
	, -1 DimTicketTypeId 
	, -1 DimSeatTypeId 
	, -1 DimTicketClassId 
 
	, tkt.QtySeat
	, CAST(0 AS DECIMAL(18,6)) QtySeatFSE
	, CAST(0 AS INT) QtySeatRenewable

	--, ISNULL(tkt.RevenueTicket,0) RevenueTicket
	--, ISNULL(tkt.RevenueFees, 0) RevenueFees
	--, ISNULL(tkt.RevenueSurcharge,0) RevenueSurcharge
	--, CAST(0 AS DECIMAL(18,6)) RevenueTax	
	--, ISNULL(tkt.RevenueTotal,0) RevenueTotal  

	--, tkt.FullPrice 
	--, tkt.Discount

	--, CASE 
	--	WHEN ISNULL(tkt.PaidAmount,0) >= tkt.RevenueTotal THEN 'Y'
	--	WHEN ISNULL(tkt.OwedAmount,0) > 0 THEN 'P'		
	--	ELSE 'N' 
	--END  PaidStatus

	--, tkt.PaidAmount 
	--, tkt.OwedAmount
	
	, (ISNULL(tkt.RevenueTicket,0) * tkt.QtySeat) RevenueTicket
	, (ISNULL(tkt.RevenueFees, 0) * tkt.QtySeat) RevenueFees
	, (ISNULL(tkt.RevenueSurcharge,0) * tkt.QtySeat) RevenueSurcharge
	, (CAST(0 AS DECIMAL(18,6)) * tkt.QtySeat) RevenueTax	
	, (ISNULL(tkt.RevenueTotal,0) * tkt.QtySeat) RevenueTotal  

	, (tkt.FullPrice * tkt.QtySeat)
	, (tkt.Discount * tkt.QtySeat)

	, CASE 
		WHEN ISNULL(tkt.PaidAmount,0) >= tkt.RevenueTotal THEN 'Y'
		WHEN ISNULL(tkt.PaidAmount,0) > 0 THEN 'P'		
		ELSE 'N' 
	END  PaidStatus

	, (tkt.PaidAmount * tkt.QtySeat) PaidAmount
	, ((tkt.FullPrice - tkt.PaidAmount) * tkt.QtySeat) OwedAmount
		 
	, NULL PaymentDateFirst
	, CAST(NULL AS DATETIME) PaymentDateLast
 
	, CAST(1 AS BIT) IsSold
	, CAST(0 AS BIT) IsReserved
	, CAST(0 AS BIT)  IsReturned
	, CAST(NULL AS BIT) IsPremium
	, CAST(NULL AS BIT)  IsDiscount
	, CAST(CASE WHEN tkt.RevenueTotal > 0 THEN 0 ELSE 1 END AS bit) IsComp
	, CAST(0 AS BIT) IsHost
	, CAST(CASE WHEN dplan.DimPlanId IS NULL THEN 0 ELSE 1 END AS bit) IsPlan
	, CAST(NULL AS BIT) IsPartial
	, CAST(CASE WHEN dplan.DimPlanId IS NULL THEN 1 ELSE 0 END AS bit) IsSingleEvent
	, CAST(NULL AS BIT) IsGroup
	, CAST(NULL AS BIT)  IsBroker
	, CAST(NULL AS BIT)  IsRenewal
	, CAST(NULL AS BIT)  IsExpanded
 
	, tkt.INREFSOURCE InRefSource 
	, tkt.INREFDATA InRefData 

 
--SELECT COUNT(*)
FROM etl.vw_Load_PAC_FactOdet_EventsBase (NOLOCK) tkt

LEFT OUTER JOIN etl.vw_DimSeason (NOLOCK) dSeason ON tkt.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = dSeason.ETL__SSID_PAC_SEASON
	 AND dSeason.ETL__SourceSystem = 'PAC' AND dSeason.DimSeasonId > 0 AND dSeason.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimTicketCustomer (NOLOCK) dTicketCustomer ON tkt.CUSTOMER = dTicketCustomer.ETL__SSID_PAC_PATRON
	AND dTicketCustomer.ETL__SourceSystem = 'PAC' AND dTicketCustomer.DimTicketCustomerId > 0 AND dTicketCustomer.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimItem (NOLOCK) dItem ON tkt.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = dItem.ETL__SSID_PAC_SEASON AND tkt.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS = dItem.ETL__SSID_PAC_ITEM
	AND dItem.ETL__SourceSystem = 'PAC' AND dItem.DimItemId > 0 AND dItem.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimEvent (NOLOCK) dEvent ON tkt.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = dEvent.ETL__SSID_PAC_SEASON AND tkt.[EVENT] COLLATE SQL_Latin1_General_CP1_CS_AS = dEvent.ETL__SSID_PAC_EVENT
	AND dEvent.ETL__SourceSystem = 'PAC' AND dEvent.DimEventId > 0 AND dEvent.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimPlan (NOLOCK) dplan ON tkt.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = dplan.ETL__SSID_PAC_SEASON AND tkt.[ITEM] COLLATE SQL_Latin1_General_CP1_CS_AS = dplan.ETL__SSID_PAC_ITEM
	AND dplan.ETL__SourceSystem = 'PAC' AND dplan.DimPlanId > 0 AND dplan.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimArena (NOLOCK) dArena ON dEvent.Arena COLLATE SQL_Latin1_General_CP1_CS_AS = dArena.ETL__SSID_PAC_FACILITY
	AND dArena.ETL__SourceSystem = 'PAC' AND dArena.DimArenaId > 0 AND dArena.ETL__IsDeleted = 0

LEFT OUTER JOIN dbo.TK_ITEM (NOLOCK) tkItem ON tkt.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = tkItem.SEASON AND tkt.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS  = tkItem.ITEM

LEFT OUTER JOIN etl.vw_DimPriceLevel (NOLOCK) dPriceLevel ON tkt.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = dPriceLevel.ETL__SSID_PAC_SEASON AND tkItem.PTABLE COLLATE SQL_Latin1_General_CP1_CS_AS = dPriceLevel.ETL__SSID_PAC_PTable AND tkt.I_PL COLLATE SQL_Latin1_General_CP1_CS_AS = dPriceLevel.ETL__SSID_PAC_PL
	AND dPriceLevel.ETL__SourceSystem = 'PAC' AND dPriceLevel.DimPriceLevelId > 0 AND dPriceLevel.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimPriceType (NOLOCK) dPriceType ON tkt.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = dPriceType.ETL__SSID_PAC_SEASON and tkt.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS = dPriceType.ETL__SSID_PAC_PRTYPE
	AND dPriceType.ETL__SourceSystem = 'PAC' AND dPriceType.DimPriceTypeId > 0 AND dPriceType.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimRep (NOLOCK) dRep ON tkt.I_MARK = dRep.ETL__SSID_PAC_MARK
	AND dRep.ETL__SourceSystem = 'PAC' AND dRep.DimRepId > 0 AND dRep.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimSalesCode (NOLOCK) dSalesCode ON tkt.ORIG_SALECODE = dSalesCode.ETL__SSID_PAC_SALECODE
	AND dSalesCode.ETL__SourceSystem = 'PAC' AND dSalesCode.DimSalesCodeId > 0 AND dSalesCode.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimPromo (NOLOCK) dPromo ON tkt.PROMO = dPromo.ETL__SSID_PAC_PROMO
	AND dPromo.ETL__SourceSystem = 'PAC' AND dPromo.DimPromoId > 0 AND dPromo.ETL__IsDeleted = 0

--WHERE tkt.SEASON = 'F17' AND tkt.EVENT = 'F06'



END
GO
