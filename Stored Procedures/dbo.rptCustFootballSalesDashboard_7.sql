SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--exec dbo.rptCustFootballSalesDashboard_7
CREATE PROC [dbo].[rptCustFootballSalesDashboard_7] as 

begin 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED



--DROP TABLE #ReportBase
--Drop Table #A

SELECT *
INTO #A
FROM [dbo].[ASU_AffectedCustomers_2014]

SELECT 
	rb.SEASON
	, rb.CUSTOMER
	, rb.ITEM
	, rb.E_PL
	, rb.I_PT
	, rb.I_PRICE
	, rb.I_DAMT
	, rb.ORDQTY
	, rb.ORDTOTAL
	, rb.MINPAYMENTDATE
	, rb.PAIDTOTAL
	, aff.Affected
	, CASE WHEN rb.I_PT like 'N%' THEN 0 WHEN rb.I_PT like 'BN%' then 0  
    WHEN rb.I_PT LIKE '%A' THEN 0 WHEN rb.I_PT IS NULL THEN NULL
    ELSE 1 END as  RENEWAL
INTO  #ReportBase
FROM dbo.vwTIReportBase rb (NOLOCK)
INNER JOIN #A aff
	ON aff.customer = rb.CUSTOMER
WHERE rb.season IN ( 'F14', 'F15')
	AND rb.ITEM = 'FS' 


SELECT 
SUM(CASE WHEN rb.Affected = 1 AND Season = 'F14' THEN rb.ORDQTY ELSE 0 END) PYAffSeats,
COUNT(DISTINCT CASE WHEN Affected = 1 AND Season = 'F14' THEN rb.customer ELSE 0 END) PYAffPatrons,
SUM(CASE WHEN rb.Affected = 0 THEN rb.ORDQTY ELSE 0 END)  PYUnffSeats,
COUNT(DISTINCT CASE WHEN Affected = 0 AND Season = 'F14' THEN CUSTOMER ELSE 0 END)  PYUnaffPatrons,
SUM(CASE WHEN rb.Affected = 1 AND Season = 'F15' AND rb.RENEWAL = 1 THEN rb.ORDQTY ELSE 0 END) CYAffSecRenewal,
COUNT(DISTINCT CASE WHEN Affected = 1 AND Season = 'F15' AND rb.RENEWAL = 1 THEN rb.customer ELSE 0 END) CYAffPatronRenewal,
SUM(CASE WHEN Affected = 0 AND Season = 'F15' AND rb.RENEWAL = 1 THEN rb.ORDQTY ELSE 0 END) CYUnaffSeatRenewal,
COUNT(DISTINCT CASE WHEN Affected = 0 AND Season = 'F15' AND rb.RENEWAL = 1 THEN rb.customer ELSE 0 END) CYUnaffPatronRenewal,
COUNT(DISTINCT CASE WHEN  Season = 'F14' THEN rb.customer ELSE 0 END) PYTotPatrons,
COUNT(DISTINCT CASE WHEN  Season = 'F15' THEN rb.customer ELSE 0 END) CYTotPatrons
FROM #ReportBase rb
WHERE rb.PAIDTOTAL >0



END
/*
SELECT
SUM(CASE WHEN AffectedSec = 1 THEN SeatQty ELSE 0 END) PYAffSeats,
COUNT(DISTINCT CASE WHEN AffectedSec = 1 THEN  customer ELSE 0 END) PYAffPatrons,
SUM(CASE WHEN AffectedSec = 0 THEN SeatQty ELSE 0 END)  PYUnffSeats,
COUNT(DISTINCT CASE WHEN AffectedSec = 0 THEN ase.CUSTOMER ELSE 0 END)  PYUnaffPatrons,
--(SELECT ISNULL(SUM(SeatQty),0) FROM #2015Seat WHERE customer IN (SELECT DISTINCT customer FROM #2014Seat WHERE AffectedSec = 1) AND AffectedSec = 1 AND Renewal = 1) CYAffSeats,
(SELECT SUM(seatqty) FROM #2015Seat WHERE CUSTOMER IN (SELECT DISTINCT customer FROM #2014Seat WHERE AffectedSec = 1)AND Renewal = 1) AS CYAffSecRenewal,
(SELECT COUNT(DISTINCT CUSTOMER) FROM #2015Seat WHERE CUSTOMER IN (SELECT DISTINCT customer FROM #2014Seat WHERE AffectedSec = 1)AND Renewal = 1) AS CYAffPatronRenewal,
(SELECT SUM(SeatQty) FROM #2015Seat WHERE CUSTOMER IN (SELECT DISTINCT customer FROM #2014Seat WHERE AffectedSec = 0) AND Renewal = 1) AS CYUnaffRenewal,
(SELECT COUNT(DISTINCT CUSTOMER) FROM #2015Seat WHERE CUSTOMER IN (SELECT DISTINCT customer FROM #2014Seat WHERE AffectedSec = 0) AND Renewal = 1) AS CYUnaffPatronRenewal
FROM #2014Seat ase  --Affected Sections
*/
GO
