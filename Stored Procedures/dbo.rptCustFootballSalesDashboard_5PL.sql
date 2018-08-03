SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--exec dbo.rptCustFootballSalesDashboard_5PL
CREATE PROC [dbo].[rptCustFootballSalesDashboard_5PL] as 
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @curSeason varchar(50) = 'F15'
declare @prevSeason varchar(50)= 'F14'


-----Price Levels
--DROP TABLE #detPriceLevel
CREATE TABLE #detPriceLevel
(
Season VARCHAR(5), 
E_PL INT, 
PL_Class VARCHAR(50), 
PLID INT
)
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F14','1','$1929/$1999/$2099','1')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F14','2','$524/$544/$564','4')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F14','3','$899/$919/$939','3')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F14','4','$1459/$1499/$1575','2')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F14','7','$120','12')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F14','8','$279/$289/$299','6')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F14','9','$179/$189/$199','8')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F14','10','MidFirst Bank Stadium Club','11')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F15','1','Black','1')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F15','2','Dark Gray','2')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F15','3','Gold','3')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F15','4','Light Green','4')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F15','5','Copper','5')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F15','6','Maroon','6')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F15','7','Light Gray','7')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F15','8','Dark Green ','8')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F15','9','Students','9')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F15','10','Suites','10')
INSERT INTO #detPriceLevel (Season, E_PL, PL_Class, PLID) VALUES ('F15','11','Stadium Club','11')


-----ReportBase
--DROP TABLE #A
SELECT * 
INTO #A
FROM TIPRICELEVELMAP2 (NOLOCK)	 
WHERE season IN ('F14' , 'F15')


--DROP TABLE #ReportBase
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
	, MINPAYMENTDATE
	, rb.PAIDTOTAL
	,CASE WHEN rb.PAIDTOTAL >=1 THEN 1 ELSE 0 END AS paidrow
	, don.DON_ITEM
	, don.I_PT DonI_PT
	, don.I_PL DonI_PL
	, don.DON_AMT
	,(don.DON_AMT*rb.ORDQTY) DonTotal
	, CASE WHEN rb.I_PT like 'N%' THEN 0 WHEN rb.I_PT like 'BN%' then 0  
    WHEN rb.I_PT LIKE '%A' THEN 0 WHEN rb.I_PT IS NULL THEN NULL
    ELSE 1 END as  RENEWAL
INTO  #ReportBase
FROM dbo.vwTIReportBase rb (NOLOCK)
LEFT JOIN #A don
ON rb.season = don.season COLLATE SQL_Latin1_General_CP1_CS_AS 
AND rb.I_PT = don.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
AND rb.E_PL = don.I_PL COLLATE SQL_Latin1_General_CP1_CS_AS 
--AND rb.item = don.DON_ITEM COLLATE SQL_Latin1_General_CP1_CS_AS 
WHERE rb.season IN ( 'F14', 'F15')
	AND (rb.ITEM = 'FS' 
	OR (rb.ITEM LIKE 'DON%'
	AND	rb.ITEM NOT LIKE 'DONSUITE%'
	AND rb.ITEM NOT LIKE 'DONCLUB%'))

--DROP TABLE #SeasonSummary
SELECT 
	rb.SEASON
    --,'Season' SALETYPENAME
	,CASE WHEN rb.E_PL = dpl.E_PL THEN dpl.PL_Class
	ELSE 'Not Classified' END AS PL_CLASS
	--,dpl.PL_Class PL_CLASS
	,dpl.PLID
	,rb.E_PL
	,rb.I_PT
	,rb.RENEWAL
	,rb.paidrow
    ,SUM(rb.ORDQTY) QTY 
    ,SUM(rb.ORDTOTAL) AMT
	,SUM(rb.DON_AMT*rb.ORDQTY) DON_AMT
	,SUM(rb.DonTotal) DonTotal
	,SUM(rb.PAIDTOTAL) PAID
into #SeasonSummary
FROM #ReportBase rb
left JOIN #detPriceLevel dpl
ON rb.E_PL = dpl.E_PL
AND rb.SEASON = dpl.Season 
where item = 'FS'  --and  rb.CUSTOMER= '261270'
	AND (rb.E_PL not in ('10','11')  
	OR (rb.SEASON = 'F15' AND rb.E_PL != '9'))
	AND (rb.PAIDTOTAL>0 or CUSTOMER in ('152760','164043','186078'))
	AND CUSTOMER <> '137398' 
GROUP BY rb.SEASON, rb.I_PT , rb.E_PL, dpl.PLID, dpl.E_PL, dpl.pl_class, rb.RENEWAL, rb.paidrow


SELECT
CASE WHEN cy.PL_CLASS IS NULL THEN '2014 $120' ELSE cy.PL_CLASS END AS PL_CLASS,
--ISNULL(cy.CYTotalQty,0) CYTotalQty,
--ISNULL(cy.CYTotalRev,0) CYTotalRev,
--ISNULL(cy.DonationRev,0) DonationRev,
ISNULL(cy.CYTotalPaidRev,0) CYTotalPaidRev,
ISNULL(cy.CYRenewalPaidQty,0) CYRenewalPaidQty,
ISNULL(cy.CYRenewalRev,0) CYRenewalRev,
ISNULL(cy.CYRenewalPaidRev,0) CYRenewalPaidRev,
ISNULL(cy.CYRenewalDonPaidRev,0) CYRenewalDonPaidRev,
ISNULL(cy.CYRenewalPaidRev+cy.CYRenewalDonPaidRev,0) CYTotalPaidTixDonRev,
ISNULL(py.PYTotalQty,0) PYTotalQty,
ISNULL(py.PYTotalRev,0) PYTotalRev,
ISNULL(py.DonAmt,0) DonAmt,
ISNULL(py.PYTotalPaid,0) PYTotalPaid,
ISNULL(py.PYTotalTixDonPaid,0) PYTotalTixDonPaid

FROM
(
	SELECT 
		s.PL_CLASS
		--, sum(QTY) as CYTotalQty 
		--, SUM(AMT) as CYTotalRev  
		--, SUM(s.DonTotal) DonationRev
		, SUM(Paid) CYTotalPaidRev
		, SUM(CASE WHEN s.paidrow=1 AND s.RENEWAL = 1 THEN s.QTY ELSE 0 END) CYRenewalPaidQty
		, SUM(CASE WHEN s.RENEWAL = 1 THEN s.AMT ELSE 0 END) CYRenewalRev
		, SUM(CASE WHEN s.PAID>=1 AND s.RENEWAL = 1 THEN AMT ELSE 0 END) CYRenewalPaidRev  
		, SUM(CASE WHEN s.paid>=1 AND s.RENEWAL = 1 THEN DON_AMT ELSE 0 END) CYRenewalDonPaidRev
		,PLID
		,s.E_PL
	from #seasonsummary s
	where SEASON in (@curSeason)	  
	group by s.PL_CLASS,PLID,s.E_PL
)CY
FULL OUTER JOIN
(
SELECT 
		s.PL_CLASS
		, sum(QTY) as PYTotalQty
		, SUM(AMT) as PYTotalRev
		, SUM(don_amt) DonAmt
		, SUM(Paid) PYTotalPaid
		,(SUM(don_amt) + SUM(Paid)) PYTotalTixDonPaid
		,PLID
		,s.E_PL
	from #seasonsummary s
	where SEASON = @prevSeason
	--AND s.paidrow = 1
	group by s.PL_CLASS,PLID,s.E_PL
)PY  ON cy.PLID = py.PLID
END
GO
