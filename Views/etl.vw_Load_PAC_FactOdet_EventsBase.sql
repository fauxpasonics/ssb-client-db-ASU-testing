SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [etl].[vw_Load_PAC_FactOdet_EventsBase] AS (

SELECT  

tkODet.SEASON, tkODet.CUSTOMER, tkODet.SEQ, tkODetEventAssoc.VMC, tkOdetEventSbls.SVMC

, tkODet.ITEM, tkODet.I_DATE, tkODet.I_OQTY, tkODet.I_PT, tkODet.I_PRICE, tkODet.I_DISC
, tkODet.I_DAMT, tkODet.I_PAY_MODE, tkODet.ITEM_DELIVERY_ID, tkODet.I_GCDOC, tkODet.I_PRQTY, tkODet.I_PL, tkODet.I_BAL, tkODet.I_PAY, tkODet.I_PAYQ
, tkODet.LOCATION_PREF, tkODet.I_SPECIAL, tkODet.I_MARK, tkODet.I_DISP, tkODet.I_GROUP, tkODet.I_ACUST, tkODet.I_PRI, tkODet.I_DMETH, tkODet.I_FPRICE
, tkODet.I_NOTE, tkODet.I_ATYPE, tkODet.I_BPTYPE, tkODet.PROMO, tkODet.ITEM_PREF, tkODet.TAG, tkODet.I_CHG, tkODet.I_CPRICE, tkODet.I_CPAY, tkODet.I_FPAY
, tkODet.INREFSOURCE, tkODet.INREFDATA, tkODet.I_SCHG, tkODet.I_SCAMT, tkODet.I_SCPAY, tkODet.ORIG_SALECODE, tkODet.ORIGTS_USER, tkODet.ORIGTS_DATETIME
, tkODet.I_PKG, tkODet.E_SBLS_1, tkODet.LAST_USER, tkODet.LAST_DATETIME, tkODet.ZID, tkODet.SOURCE_ID
, tkODet.EXPORT_DATETIME EXPORT_DATETIME_TK_ODET

, tkODetEventAssoc.EVENT, tkODetEventAssoc.E_PRICE, tkODetEventAssoc.E_DAMT, tkODetEventAssoc.E_STAT, tkODetEventAssoc.E_AQTY, tkODetEventAssoc.E_PQTY, tkODetEventAssoc.E_ADATE, tkODetEventAssoc.E_SBLS, tkODetEventAssoc.E_CPRICE
, tkODetEventAssoc.E_FEE, tkODetEventAssoc.E_FPRICE, tkODetEventAssoc.TOT_EPAY, tkODetEventAssoc.TOT_CPAY, tkODetEventAssoc.TOT_FPAY, tkODetEventAssoc.E_SCAMT, tkODetEventAssoc.TOT_SCPAY
, tkODetEventAssoc.EXPORT_DATETIME EXPORT_DATETIME_TK_ODET_EVENT_ASSOC
--, tkODetEventAssoc.E_PL

, tkOdetEventSbls.SEATBLOCKS, tkOdetEventSbls.LEVEL, tkOdetEventSbls.SECTION, tkOdetEventSbls.ROW, tkOdetEventSbls.FIRST_SEAT, tkOdetEventSbls.LAST_SEAT
, tkOdetEventSbls.EXPORT_DATETIME EXPORT_DATETIME_TK_ODET_EVENT_SBLS

, tkPtablePrlev.PTABLE, tkPtablePrlev.PL, tkPtablePrlev.PL_NAME
, tkPtablePrlev.EXPORT_DATETIME EXPORT_DATETIME_TK_PTABLE_PRLEV

, dSeatFirst.DimSeatId
, dSeatFirst.SortOrderSeat StartSortOrderSeat, dSeatLast.SortOrderSeat EndSortOrderSeat
--, tkOdetEventSbls.LEVEL, tkOdetEventSbls.SECTION, tkOdetEventSbls.ROW, dSeatFirst.Seat StartSeat, dSeatLast.Seat EndSeat

, CASE WHEN dSeatFirst.DimSeatId IS NULL THEN tkODet.I_OQTY ELSE (dSeatLast.SortOrderSeat - dSeatFirst.SortOrderSeat + 1) END QtySeat

--, ((tkODetEventAssoc.E_PRICE - tkODetEventAssoc.E_DAMT) * tkODet.i_OQTY) RevenueTicket
--, (tkODetEventAssoc.E_FPRICE * tkODet.i_OQTY) RevenueFees
--, (tkODetEventAssoc.E_CPRICE * tkODet.i_OQTY) RevenueSurcharge
--, ((tkODetEventAssoc.E_PRICE - tkODetEventAssoc.E_DAMT) * tkODet.i_OQTY)  RevenueTotal

--, (tkODet.i_OQTY * tkODetEventAssoc.E_PRICE) FullPrice
--, (tkODet.i_OQTY * tkODetEventAssoc.E_DAMT) Discount

--, (tkODet.i_OQTY * tkODetEventAssoc.TOT_EPAY) PaidAmount
--, tkODet.i_OQTY * (tkODetEventAssoc.E_PRICE - tkODetEventAssoc.TOT_EPAY) OwedAmount

, (tkODetEventAssoc.E_PRICE - tkODetEventAssoc.E_DAMT) RevenueTicket
, tkODetEventAssoc.E_FPRICE RevenueFees
, tkODetEventAssoc.E_CPRICE RevenueSurcharge
, (tkODetEventAssoc.E_PRICE - tkODetEventAssoc.E_DAMT)  RevenueTotal

, tkODetEventAssoc.E_PRICE FullPrice
, tkODetEventAssoc.E_DAMT Discount

, CASE WHEN tkODet.I_OQTY > 0 then (tkODetEventAssoc.TOT_EPAY / CAST(tkODet.I_OQTY AS DECIMAL(18,6))) ELSE 0 END PaidAmount
--, (tkODetEventAssoc.E_PRICE - tkODetEventAssoc.TOT_EPAY) OwedAmount



--SELECT COUNT(*)
FROM dbo.TK_ODET tkODet 
INNER JOIN dbo.TK_ITEM tkItem ON tkODet.SEASON = tkItem.SEASON AND tkODet.ITEM = tkItem.ITEM 
INNER JOIN dbo.TK_ODET_EVENT_ASSOC tkODetEventAssoc ON tkODet.SEASON = tkODetEventAssoc.SEASON AND tkODet.ZID = tkODetEventAssoc.ZID
LEFT OUTER JOIN dbo.TK_ODET_EVENT_SBLS (NOLOCK) tkOdetEventSbls ON tkODet.SEASON = tkOdetEventSbls.SEASON AND tkODet.CUSTOMER = tkOdetEventSbls.CUSTOMER AND tkODet.SEQ = tkOdetEventSbls.SEQ AND tkODetEventAssoc.VMC = tkOdetEventSbls.VMC
LEFT OUTER JOIN dbo.TK_PTABLE_PRLEV tkPtablePrlev ON tkODet.SEASON = tkPtablePrlev.SEASON AND tkItem.ptable = tkPTablePRLev.ptable AND tkODetEventAssoc.E_PL = tkPtablePrlev.PL
LEFT OUTER JOIN etl.vw_DimSeat dSeatFirst ON tkODet.SEASON = dSeatFirst.ETL__SSID_PAC_SEASON AND tkOdetEventSbls.LEVEL = dSeatFirst.ETL__SSID_PAC_LEVEL AND tkOdetEventSbls.SECTION = dSeatFirst.ETL__SSID_PAC_SECTION AND tkOdetEventSbls.ROW = dSeatFirst.ETL__SSID_PAC_ROW AND tkOdetEventSbls.FIRST_SEAT = dSeatFirst.ETL__SSID_PAC_SEAT
LEFT OUTER JOIN etl.vw_DimSeat dSeatLast ON tkODet.SEASON = dSeatLast.ETL__SSID_PAC_SEASON AND tkOdetEventSbls.LEVEL = dSeatLast.ETL__SSID_PAC_LEVEL AND tkOdetEventSbls.SECTION = dSeatLast.ETL__SSID_PAC_SECTION AND tkOdetEventSbls.ROW = dSeatLast.ETL__SSID_PAC_ROW AND tkOdetEventSbls.LAST_SEAT = dSeatLast.ETL__SSID_PAC_SEAT

--WHERE tkODetEventAssoc.SEASON = 'F17' AND tkODetEventAssoc.EVENT = 'F04'

)



GO
