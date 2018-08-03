SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
 
CREATE PROCEDURE [etl].[Load_FactOdetItems] 
( 
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000', 
	@Options NVARCHAR(max) = NULL 
) 
 
AS 
BEGIN 
 
 
 
SELECT CAST(1 AS BIT) RecordExists, SEASON, ZID 
INTO #Event_Assoc_IDs 
FROM dbo.TK_ODET_EVENT_ASSOC 
 
CREATE NONCLUSTERED INDEX IDX_Key ON #Event_Assoc_IDs (ZID, SEASON) 
 
 
SELECT 
tkODet.SEASON, tkODet.CUSTOMER, tkODet.SEQ, tkODet.ITEM, tkODet.I_DATE, tkODet.I_OQTY, tkODet.I_PT, tkODet.I_DISC, tkODet.INREFSOURCE, tkODet.INREFDATA, tkODet.ORIG_SALECODE 
, tkODet.ORIGTS_USER, tkODet.ORIGTS_DATETIME, tkODet.I_PKG, tkODet.E_SBLS_1, tkODet.LAST_USER, tkODet.I_PL, tkODet.I_FPRICE, tkODet.SOURCE_ID, tkODet.I_PRICE,  tkODet.I_DAMT, tkODet.I_CPRICE 
 
INTO #OdetItems 
FROM dbo.TK_ODET tkODet  
LEFT OUTER JOIN #Event_Assoc_IDs tkODetEventAssoc ON tkODet.SEASON = tkODetEventAssoc.SEASON AND tkODet.ZID = tkODetEventAssoc.ZID 
WHERE tkODetEventAssoc.RecordExists IS NULL 
 
--CREATE CLUSTERED COLUMNSTORE INDEX CCI_OdetItems ON #OdetItems 
 
CREATE NONCLUSTERED INDEX IDX_SEASON ON #OdetItems (SEASON) 
CREATE NONCLUSTERED INDEX IDX_ITEM ON #OdetItems (ITEM) 
 
 
 
SELECT  
 
tkODet.SEASON, tkODet.CUSTOMER, tkODet.SEQ, tkODet.ITEM, tkODet.I_DATE 
, tkODet.I_OQTY, tkODet.I_PT, tkODet.I_PRICE, tkODet.I_DISC 
, tkODet.i_OQTY QtySeat 
 
--tkODet.I_DAMT, tkODet.I_PAY_MODE, tkODet.ITEM_DELIVERY_ID, tkODet.I_GCDOC, tkODet.I_PRQTY, tkODet.I_PL, tkODet.I_BAL, tkODet.I_PAY, tkODet.I_PAYQ, 
--tkODet.LOCATION_PREF, tkODet.I_SPECIAL, tkODet.I_MARK, tkODet.I_DISP, tkODet.I_ACUST, tkODet.I_PRI, tkODet.I_DMETH, tkODet.I_FPRICE, tkODet.I_BPTYPE, 
--tkODet.PROMO, tkODet.ITEM_PREF, tkODet.TAG, tkODet.I_CHG, tkODet.I_CPRICE, tkODet.I_CPAY, tkODet.I_FPAY 
, tkODet.INREFSOURCE, tkODet.INREFDATA 
--, tkODet.I_SCHG, 
--tkODet.I_SCAMT, tkODet.I_SCPAY 
, tkODet.ORIG_SALECODE, tkODet.ORIGTS_USER, tkODet.ORIGTS_DATETIME 
, tkODet.I_PKG, tkODet.E_SBLS_1, tkODet.LAST_USER 
--, tkODet.LAST_DATETIME, tkODet.ZID, tkODet.SOURCE_ID 
 
, tkItem.PTABLE 
, tkODet.I_PL 
--, tkODet.I_PRICE 
, tkODet.I_DAMT 
--, tkODet.E_stat 
--, tkODet.E_PQTY, tkODet.E_ADATE 
--, tkODet.E_SBLS 
--, tkODet.I_CPRICE 
--, tkODet.E_FEE 
, tkODet.I_FPRICE 
--, tkODet.E_SCAMT 
--, tkODet.ZID 
, tkODet.SOURCE_ID 
 
, ((tkODet.I_PRICE - tkODet.I_DAMT) * tkODet.I_OQTY) OrderRevenue 
, (tkODet.I_CPRICE * tkODet.I_OQTY) OrderConvenienceFee 
, (tkODet.I_FPRICE * tkODet.I_OQTY) OrderFee 
, ((tkODet.I_PRICE - tkODet.I_DAMT) * tkODet.I_OQTY)  TotalRevenue 
 
, 0 [PaidAmount] 
, 0 [OwedAmount] 
, (tkODet.i_OQTY * tkODet.I_PRICE) FullPrice 
, (tkODet.i_OQTY * tkODet.I_DAMT) Discount 
 
INTO #Stg 
--SELECT COUNT(*) 
FROM #OdetItems tkODet  
INNER JOIN dbo.TK_ITEM tkItem ON tkODet.SEASON = tkItem.SEASON AND tkODet.ITEM = tkItem.ITEM  
 
--CREATE CLUSTERED COLUMNSTORE INDEX CCI_OdetItems ON #Stg 
 
CREATE NONCLUSTERED INDEX IDX_SEASON ON #Stg (SEASON) 
CREATE NONCLUSTERED INDEX IDX_CUSTOMER ON #Stg (CUSTOMER) 
CREATE NONCLUSTERED INDEX IDX_ITEM ON #Stg (ITEM) 
CREATE NONCLUSTERED INDEX IDX_I_PL ON #Stg (I_PL) 
CREATE NONCLUSTERED INDEX IDX_PTABLE ON #Stg (PTABLE) 
CREATE NONCLUSTERED INDEX IDX_I_PT ON #Stg (I_PT) 
 
 
DECLARE @RunTime datetime = GETDATE() 
 
 
INSERT INTO dbo.FactOdet 
(  
	ETL__SourceSystem, ETL__CreatedBy, ETL__CreatedDate, ETL__UpdatedDate, ETL__DeltaHashKey 
	, DimDateId, DimTimeId, DimTicketCustomerId, DimArenaId, 
	DimSeasonId, DimItemId, DimEventId, DimPlanId, DimPriceLevelId, DimPriceTypeId, DimPriceCodeId, DimSeatId_Start, DimRepId, DimSalesCodeId, DimPromoId, 
	DimPlanTypeId, DimTicketTypeId, DimSeatTypeId, DimTicketClassId, DimTicketClassId2, DimTicketClassId3, DimTicketClassId4, DimTicketClassId5, QtySeat, 
	OrderRevenue, OrderConvenienceFee, OrderFee, TotalRevenue, MinPaymentDate, PaidAmount, OwedAmount, FullPrice, Discount, IsSold, IsPremium, IsDiscount, IsComp, IsHost, 
	IsPlan, IsPartial, IsSingleEvent, IsGroup, IsBroker, IsRenewal, IsExpanded, InRefSource, InRefData  
) 
 
SELECT 
'PAC' ETL__SourceSystem 
, SUSER_NAME() ETL__CreatedBy, @RunTime ETL__CreatedDate, @RunTime ETL__UpdatedDate, NULL ETL__DeltaHashKey 
 
, CASE WHEN a.I_DATE IS NULL THEN 0 ELSE CONVERT(NVARCHAR(8), a.I_DATE, 112) END DimDateId 
, CASE WHEN a.ORIGTS_DATETIME IS NULL THEN 0 ELSE datediff(second, cast(a.ORIGTS_DATETIME as date), a.ORIGTS_DATETIME) END DimTimeId 
 
, ISNULL(dtc.DimTicketCustomerId, -1) DimTicketCustomerId 
, 0 DimArenaId 
, ISNULL(ds.DimSeasonId, -1)  DimSeasonId 
, ISNULL(di.DimItemId, -1)  DimItemId 
, 0  DimEventId 
--, CASE WHEN ISNULL(a.ITEM,'') = ISNULL(a.[EVENT],'') THEN 0 ELSE ISNULL(dplan.DimPlanId, -1) END DimPlanId 
, CASE WHEN ISNULL(di.BASIS,'') <> 'C' THEN 0 ELSE ISNULL(dplan.DimPlanId, -1) END DimPlanId 
, ISNULL(dpl.DimPriceLevelId, -1) DimPriceLevelId 
, ISNULL(dpt.DimPriceTypeId, -1)  DimPriceTypeId 
 
, -1 DimPriceCodeId 
, -1 DimSeatId_Start 
, -1 DimRepId 
, -1 DimSalesCodeId 
, -1 DimPromoId 
, -1 DimPlanTypeId 
, -1 DimTicketTypeId 
, -1 DimSeatTypeId 
, -1 DimTicketClassId 
, -1 DimTicketClassId2 
, -1 DimTicketClassId3 
, -1 DimTicketClassId4 
, -1 DimTicketClassId5 
 
, a.QtySeat QtySeat 
, a.OrderRevenue 
, a.OrderConvenienceFee  
, a.OrderFee 
, a.TotalRevenue TotalRevenue 
, NULL MinPaymentDate 
, a.PaidAmount 
, a.OwedAmount 
, a.FullPrice 
, a.Discount 
 
, 0 IsSold 
, 0 IsPremium 
, 0 IsDiscount 
, 0 IsComp 
, 0 IsHost 
, 0 IsPlan 
, 0 IsPartial 
, 0 IsSingleEvent 
, 0 IsGroup 
, 0 IsBroker 
, 0 IsRenewal 
, 0 IsExpanded 
 
, a.INREFSOURCE InRefSource 
, a.INREFDATA InRefData 
 
--SELECT COUNT(*) 
--FROM etl.OdetEventBaseItems (NOLOCK) a 
FROM #Stg (NOLOCK) a 
LEFT OUTER JOIN dbo.DimSeason (NOLOCK) ds ON a.SEASON = ds.ETL__SSID_SEASON AND ds.ETL__EndDate IS NULL 
LEFT OUTER JOIN dbo.DimTicketCustomer (NOLOCK) dtc ON a.CUSTOMER = dtc.ETL__SSID_PATRON AND dtc.ETL__EndDate IS NULL 
LEFT OUTER JOIN dbo.DimItem (NOLOCK) di ON a.SEASON = di.ETL__SSID_SEASON and a.ITEM = di.ETL__SSID_ITEM AND di.ETL__EndDate IS NULL 
LEFT OUTER JOIN dbo.DimPlan (NOLOCK) dplan ON a.SEASON = dplan.ETL__SSID_SEASON AND a.[ITEM] = dplan.ETL__SSID_ITEM AND dplan.ETL__EndDate IS NULL 
LEFT OUTER JOIN dbo.TK_ITEM (NOLOCK) tkItem ON a.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = tkItem.SEASON AND a.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS  = tkItem.ITEM 
LEFT OUTER JOIN dbo.DimPriceLevel (NOLOCK) dpl ON a.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = dpl.ETL__SSID_SEASON AND tkItem.PTABLE COLLATE SQL_Latin1_General_CP1_CS_AS = dpl.ETL__SSID_PTable AND a.[I_PL] COLLATE SQL_Latin1_General_CP1_CS_AS = dpl.ETL__SSID_PL AND dpl.ETL__EndDate IS null 
--LEFT OUTER JOIN dbo.DimPriceLevel (NOLOCK) dpl ON a.SEASON = dpl.ETL__SSID_SEASON AND a.PTABLE = dpl.ETL__SSID_PTable AND a.[E_PL] = dpl.ETL__SSID_PL AND dpl.ETL__EndDate IS NULL 
LEFT OUTER JOIN dbo.DimPriceType (NOLOCK) dpt ON a.SEASON = dpt.ETL__SSID_SEASON and a.I_PT = dpt.ETL__SSID_PRTYPE AND dpt.ETL__EndDate IS NULL 
 
 
DROP TABLE #Event_Assoc_IDs 
DROP TABLE #OdetItems 
DROP TABLE #Stg 
 
 
END 
 
 
 
 
 
 
 
 
GO
