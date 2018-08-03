SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [etl].[OdetEventBaseItems] AS (

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

, tkPtablePrlev.PTABLE
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


--SELECT COUNT(*)
FROM dbo.TK_ODET tkODet 
INNER JOIN dbo.TK_ITEM tkItem ON tkODet.SEASON = tkItem.SEASON AND tkODet.ITEM = tkItem.ITEM 
LEFT OUTER JOIN dbo.TK_ODET_EVENT_ASSOC tkODetEventAssoc ON tkODet.SEASON = tkODetEventAssoc.SEASON AND tkODet.ZID = tkODetEventAssoc.ZID
LEFT OUTER JOIN dbo.TK_PTABLE_PRLEV tkPtablePrlev ON tkODet.SEASON = tkPtablePrlev.SEASON AND tkItem.ptable = tkPTablePRLev.ptable AND tkodet.I_PL = tkPtablePrlev.PL
WHERE tkODetEventAssoc.SEASON IS NULL

)


GO
