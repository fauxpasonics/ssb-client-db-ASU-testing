SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--exec dbo.rptCustFootballSalesDashboard_1_2_3_4_8
CREATE PROC [dbo].[rptCustFootballSalesDashboard_1_2_3_4_8] as 

begin 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--drop table #ReportBase, #A


SELECT * 
INTO #A
FROM TIPRICELEVELMAP2 (NOLOCK)	 
WHERE season IN ('F14' , 'F15')


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
	, CASE WHEN rb.SEASON = 'F14' AND rb.MINPAYMENTDATE <= '11/13/13' THEN '11/13/13' 
		WHEN rb.season = 'F15' AND rb.MINPAYMENTDATE <= '3/11/15' THEN '3/11/15' 
		ELSE rb.MINPAYMENTDATE END AS MINPAYMENTDATE
	, rb.PAIDTOTAL
	, don.DON_ITEM
	, don.I_PT DonI_PT
	, don.I_PL DonI_PL
	, don.DON_AMT
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
	or (rb.ITEM LIKE 'DON%'
	AND	rb.ITEM NOT LIKE 'DONSUITE%'
	AND rb.ITEM NOT LIKE 'DONCLUB%'))

--DROP table #paid_date
CREATE TABLE #paid_date
(
Season VARCHAR(20)
, Customer VARCHAR(20)
, Paid_Date DATETIME
)


INSERT INTO #paid_date (Season, Customer, Paid_Date)
SELECT * FROM (
SELECT SEASON, CUSTOMER, MIN(CASE WHEN MINPAYMENTDATE < '2015-03-11' THEN '2015-03-11' ELSE MINPAYMENTDATE END) AS Paid_Date 
FROM dbo.vwTIReportBase (NOLOCK)
WHERE SEASON IN ('F15')
AND (CUSTOMER IN (SELECT CUSTOMER FROM dbo.TK_BPLAN WHERE SEASON IN ('F15')) OR PAIDTOTAL > 0)
GROUP BY SEASON, CUSTOMER
)x --WHERE x.Paid_Date IS NOT NULL

/*
-----PY Donations
SELECT
	CASE grouping_id(SEASON, MINPAYMENTDATE) WHEN 3 THEN 'Total PY' ELSE 'Detail' END AS DataType
	,Season
	,rb.MINPAYMENTDATE
	, SUM(PaidTotal) Donation2014
FROM #ReportBase rb
WHERE rb.SEASON = 'F14'
	AND (I_PT NOT IN ('N%', 'BN%', '%A')
	OR ITEM LIKE 'DON%' )
GROUP BY GROUPING SETS((SEASON, MINPAYMENTDATE), ())


-----CY Donations
SELECT
	case DataType when 'Total CY' then NULL else RANK() OVER (ORDER BY MINPAYMENTDATE ASC)-1 end AS CY_Day_Of_Renewal_Cycle
	,x.DataType
	,x.Season
	,x.MINPAYMENTDATE
	,x.Donation2015
	,SUM(Donation2015) OVER (PARTITION BY Season) Donation2015_Total
INTO #DonationsCY
FROM
(
	SELECT 
		CASE grouping_id(SEASON, MINPAYMENTDATE ) WHEN 3 THEN 'Total CY' ELSE 'Detail' END AS DataType
		,Season
		,rb.MINPAYMENTDATE
		,SUM(PaidTotal) Donation2015
	--INTO #DonationsCY
	FROM #ReportBase rb
	WHERE rb.SEASON = 'F15'
		AND (I_PT NOT IN ('N%', 'BN%', '%A')
		OR ITEM LIKE 'DON%') 
		AND rb.MINPAYMENTDATE IS NOT null
	GROUP BY GROUPING SETS((SEASON, MINPAYMENTDATE), ())
)x
*/

------Results Set
----"Paid" below is the expected sales when paid >=$1

SELECT
 x.*,
 y.*
FROM
(
SELECT
	xx.DataType
	, CY_SEASON
	, xx.CY_MINPAYMENTDATE
	, CASE xx.DataType WHEN 'Total CY' THEN NULL ELSE RANK() OVER (ORDER BY xx.CY_MINPAYMENTDATE ASC)-1 END AS CY_Day_Of_Renewal_Cycle 
	, SUM(Total_Season_PatronTotal) OVER (PARTITION BY CY_Season) AS CY_Overall_Total_Season_Ticket_Patrons
	, SUM(Total_Season_Ticket_Qty) OVER (PARTITION BY CY_Season) AS  CY_Overall_Total_Season_Ticket_Qty
	, SUM(Total_Season_Ticket_Rev) OVER (PARTITION BY CY_Season) AS CY_Overall_Total_Season_Ticket_Rev
	, Total_SeasonQtyPaid CY_Total_Season_Paid_Qty
	, Total_Season_RevPaid CY_Total_Season_Paid_Rev
	, Total_Season_Don_RevPaid CY_Total_Season_Paid_Don_Rev
	, Total_Season_PatronTotal CY_Total_Season_Ticket_Patrons
	, Total_Season_PaidPatrons CY_Total_Season_Ticket_PatronsPaid
	, Total_Season_Ticket_Qty CY_Total_Season_Ticket_Qty
	, Total_Season_Ticket_Rev CY_Total_Season_Ticket_Rev
	, Total_Season_Don_Rev CY_Total_Season_Ticket_Don
	, Season_Renewal_PaidPatrons CY_Total_Renewal_Paid_Patrons
	, Season_Ticket_Renewal_Patrons CY_Season_Ticket_Renewal_Patrons
	, Season_Ticket_Renewal_Qty CY_Season_Ticket_Renewal_Qty
	, Season_RenewalQtyPaid CY_Season_Ticket_Renewal_QtyPaid
	, Season_Ticket_Renewal_Rev CY_Season_Ticket_Renewal_Rev 
	, Season_Renewal_RevPaid CY_Season_Ticket_Renewal_RevPaid
	, Season_Renewal_Don_Rev CY_Season_Ticket_Renewal_Don_Rev
	, Season_Renewal_Don_RevPaid CY_Season_Ticket_Renewal_Don_RevPaid
	--, Season_Additional_Ticket_Patrons CY_Season_Additional_Ticket_Patrons
	, Season_Additional_Ticket_PatronsPaid CY_Season_Additional_Ticket_PatronsPaid
	--, Season_Additional_Ticket_Qty CY_Season_Additional_Ticket_Qty
	, Season_Additional_Ticket_QtyPaid CY_Season_Additional_Ticket_QtyPaid
	--, Season_Additional_Ticket_Rev CY_Season_Additional_Ticket_Rev
	, Season_Additional_Ticket_RevPaid CY_Season_Additional_Ticket_RevPaid
	--, Season_Additional_Ticket_Don CY_Season_Additional_Ticket_Don
	, Season_Additional_Ticket_DonPaid CY_Season_Additional_Ticket_DonPaid
	--, Season_New_Ticket_Patrons CY_Season_New_Ticket_Patrons
	, Season_New_Ticket_PatronsPaid CY_Season_New_Ticket_PatronsPaid
	--, Season_New_Ticket_Qty CY_Season_New_Ticket_Qty
	, Season_New_Ticket_QtyPaid CY_Season_New_Ticket_QtyPaid
	--, Season_New_Ticket_Rev CY_Season_New_Ticket_Rev
	, Season_New_Ticket_RevPaid CY_Season_New_Ticket_RevPaid
	--, Season_New_Ticket_Don CY_Season_New_Ticket_Don
	, Season_New_Ticket_DonPaid CY_Season_New_Ticket_DonPaid																				
FROM 
(
	SELECT 
		CASE grouping_id(rb.SEASON, paid_date.Paid_Date) WHEN 3 THEN 'Total CY' ELSE 'Detail' END AS DataType
		, rb.SEASON AS CY_SEASON 
		, paid_date.Paid_Date CY_MINPAYMENTDATE
		-----All Tickets
		, COUNT(DISTINCT CASE WHEN rb.PAIDTOTAL >= 1 AND ITEM = 'FS' THEN rb.CUSTOMER 
			ELSE NULL END) Total_Season_PaidPatrons
		, COUNT(DISTINCT CASE WHEN ITEM = 'FS'  THEN rb.CUSTOMER 
			ELSE NULL END) Total_Season_PatronTotal
		, SUM(CASE WHEN rb.PAIDTOTAL >= 1 AND ITEM = 'FS' THEN rb.ORDQTY
			ELSE 0 END) Total_SeasonQtyPaid
		, SUM(CASE WHEN ITEM = 'FS' THEN rb.ORDQTY 
			ELSE 0 END) Total_Season_Ticket_Qty
		, SUM(CASE WHEN  rb.PAIDTOTAL >=1  AND ITEM = 'FS' THEN rb.ORDTOTAL
			ELSE 0 END) Total_Season_RevPaid
		, SUM(CASE WHEN item = 'FS' THEN rb.ORDTOTAL 
			ELSE 0 END) Total_Season_Ticket_Rev
		, SUM(CASE WHEN  rb.PAIDTOTAL >= 1 AND rb.Item LIKE 'DON%' THEN rb.ORDTOTAL
			ELSE 0 END) Total_Season_Don_RevPaid
		,SUM(CASE WHEN  rb.DON_Item LIKE 'DON%' THEN rb.ordqty*rb.DON_AMT 
			ELSE 0 END) Total_Season_Don_Rev
		-----Renewals
		, COUNT(DISTINCT CASE WHEN rb.PAIDTOTAL >= 1  AND ITEM = 'FS' AND rb.RENEWAL = 1 THEN rb.CUSTOMER 
			ELSE NULL END) Season_Renewal_PaidPatrons
		, COUNT(DISTINCT CASE WHEN Item = 'FS' AND  rb.RENEWAL = 1 THEN rb.CUSTOMER 
			ELSE NULL END) AS Season_Ticket_Renewal_Patrons 
		, SUM(CASE WHEN rb.PAIDTOTAL >= 1 AND ITEM = 'FS' AND rb.RENEWAL = 1 THEN rb.ORDQTY
			ELSE 0 END) Season_RenewalQtyPaid
		, SUM(CASE WHEN Item = 'FS' AND  rb.RENEWAL = 1 THEN rb.ORDQTY 
			ELSE 0 END) AS Season_Ticket_Renewal_Qty 
		, SUM(CASE WHEN  rb.PAIDTOTAL >= 1  AND ITEM = 'FS' AND  rb.RENEWAL = 1 THEN rb.ORDTOTAL 
			ELSE 0 END) Season_Renewal_RevPaid
		, SUM(CASE WHEN Item = 'FS' AND  rb.RENEWAL = 1 THEN rb.ORDTOTAL 
			ELSE 0 END) AS Season_Ticket_Renewal_Rev
		, SUM(CASE WHEN rb.DON_ITEM LIKE 'DON%' AND  rb.RENEWAL = 1 AND rb.paidtotal >=1 THEN rb.ordqty*rb.DON_AMT  --Updated to ordtotal for the season
			ELSE 0 END) Season_Renewal_Don_RevPaid
		, SUM(CASE WHEN rb.DON_ITEM LIKE 'DON%' AND  rb.RENEWAL = 1 THEN rb.ordqty*rb.DON_AMT  --Updated to ordtotal for the season
			ELSE 0 END) Season_Renewal_Don_Rev
		-----Additional
		--, COUNT(DISTINCT CASE WHEN Item = 'FS' AND rb.I_PT LIKE '%A' THEN rb.CUSTOMER 
		--	ELSE NULL end) AS Season_Additional_Ticket_Patrons
		, COUNT(DISTINCT CASE WHEN Item = 'FS' AND rb.I_PT LIKE '%A' AND rb.paidtotal >=1 THEN rb.CUSTOMER 
			ELSE NULL end) AS Season_Additional_Ticket_PatronsPaid
		--, SUM(CASE WHEN Item = 'FS' AND rb.I_PT LIKE '%A' THEN rb.ORDQTY 
		--	ELSE 0 END) AS Season_Additional_Ticket_Qty
		, SUM(CASE WHEN Item = 'FS' AND rb.I_PT LIKE '%A' AND rb.paidtotal >=1 THEN rb.ORDQTY 
			ELSE 0 END) AS Season_Additional_Ticket_QtyPaid
		--, SUM(CASE WHEN Item = 'FS' AND rb.I_PT LIKE '%A' THEN rb.ORDTOTAL
		--	ELSE 0 END) AS Season_Additional_Ticket_Rev
		, SUM(CASE WHEN Item = 'FS' AND rb.I_PT LIKE '%A' AND rb.paidtotal >=1 THEN rb.ORDTOTAL
			ELSE 0 END) AS Season_Additional_Ticket_RevPaid
		--, SUM(CASE WHEN rb.DON_ITEM LIKE 'DON%' AND rb.DonI_PT LIKE '%A' THEN rb.ordqty*rb.DON_AMT  
		--	ELSE 0 END) AS Season_Additional_Ticket_Don
		, SUM(CASE WHEN rb.DON_ITEM LIKE 'DON%' AND rb.DonI_PT LIKE '%A' AND rb.paidtotal >=1  THEN rb.ordqty*rb.DON_AMT 
			ELSE 0 END) AS Season_Additional_Ticket_DonPaid
		-----New Season Tickets
		--, COUNT(DISTINCT CASE WHEN Item = 'FS' AND (rb.I_PT LIKE 'N%' AND rb.I_PT LIKE 'BN%') THEN rb.CUSTOMER
		--	ELSE NULL END) AS Season_New_Ticket_Patrons
		, COUNT(DISTINCT CASE WHEN Item = 'FS' AND (rb.I_PT LIKE 'N%' OR rb.I_PT LIKE 'BN%') AND rb.paidtotal >= 1 THEN rb.CUSTOMER
			ELSE NULL END) AS Season_New_Ticket_PatronsPaid  
		--, SUM(CASE WHEN Item = 'FS' AND (rb.I_PT LIKE 'N%' AND rb.I_PT LIKE 'BN%') THEN rb.ORDQTY 
		--	ELSE 0 END) AS Season_New_Ticket_Qty 
		, SUM(CASE WHEN Item = 'FS' AND (rb.I_PT LIKE 'N%' OR rb.I_PT LIKE 'BN%')  AND rb.paidtotal >= 1 THEN rb.ORDQTY 
			ELSE 0 END) AS Season_New_Ticket_QtyPaid
		--, SUM(CASE WHEN Item = 'FS' AND (rb.I_PT LIKE 'N%' AND rb.I_PT LIKE 'BN%') THEN rb.ORDTOTAL
		--	ELSE 0 END) AS Season_New_Ticket_Rev
		, SUM(CASE WHEN Item = 'FS' AND (rb.I_PT LIKE 'N%' OR rb.I_PT LIKE 'BN%') AND rb.paidtotal >= 1 THEN rb.ORDTOTAL
			ELSE 0 END) AS Season_New_Ticket_RevPaid
		--, SUM(CASE WHEN rb.DON_ITEM LIKE 'DON%' AND (rb.DonI_PT LIKE 'N%' AND rb.DonI_PT LIKE 'BN%') THEN rb.ordqty*rb.DON_AMT 
		--	ELSE 0 END) AS Season_New_Ticket_Don
		, SUM(CASE WHEN rb.DON_ITEM LIKE 'DON%' AND (rb.DonI_PT LIKE 'N%' OR rb.DonI_PT LIKE 'BN%') AND rb.paidtotal >= 1 THEN rb.ordqty*rb.DON_AMT 
			ELSE 0 END) AS Season_New_Ticket_DonPaid
	FROM #ReportBase rb
	LEFT JOIN #paid_date paid_date
		ON paid_date.CUSTOMER = rb.CUSTOMER
		AND paid_date.SEASON COLLATE Latin1_General_CS_AS = rb.SEASON COLLATE Latin1_General_CS_AS  --AND rb.ITEM IN ('ANNUAL', 'FBS-ST', 'SB', 'LFANY')
	WHERE rb.SEASON = 'F15'
		--AND paid_date.Paid_Date IS null
	GROUP BY
		GROUPING SETS((rb.SEASON, paid_date.Paid_Date), ())
	) xx
) x	
LEFT JOIN
(
SELECT
	x.DataType
	, x.SEASON
	, MINPAYMENTDATE
	, CASE x.DataType WHEN 'Total PY' THEN NULL ELSE RANK() OVER (ORDER BY MINPAYMENTDATE ASC) END AS PY_Day_Of_Renewal_Cycle 
 	, SUM(Total_Season_PatronTotal) OVER (PARTITION BY x.Season) AS PY_Overall_Total_Season_Ticket_Patrons
 	, SUM(Total_Season_Ticket_Qty) OVER (PARTITION BY x.Season) AS  PY_Overall_Total_Season_Ticket_Qty
 	, SUM(Total_Season_Ticket_Rev) OVER (PARTITION BY x.Season) AS PY_Overall_Total_Season_Ticket_Rev
	, SUM(Total_Season_Don_Rev)  OVER (PARTITION BY x.Season) AS PY_Overall_Total_Season_Ticket_Don
	, SUM(Total_Season_Ticket_Rev) OVER (PARTITION BY x.Season) + SUM(Total_Season_Don_Rev)  OVER (PARTITION BY x.Season) AS PY_Overall_Total_Season_Ticket_RevDon
	, Total_Season_PaidPatrons PY_Total_Season_Paid_Patrons
	, Total_Season_PatronTotal PY_Total_Season_Ticket_Patrons
	, Total_SeasonQtyPaid PY_Total_Season_Paid_Qty
	, Total_Season_Ticket_Qty PY_Total_Season_Ticket_Qty
	, Total_Season_RevPaid PY_Total_Season_Paid_Rev
	, Total_Season_Ticket_Rev PY_Total_Season_Ticket_Rev
	, Total_Season_Don_RevPaid PY_Total_Season_Paid_Don_Rev
	, Total_Season_Don_Rev PY_Total_Season_Ticket_Don
	, Season_Ticket_Renewal_Patrons PY_Season_Ticket_Renewal_Patrons
	, Season_Renewal_PaidPatrons PY_Season_Ticket_Renewal_PatronsPaid
	, Season_Ticket_Renewal_Qty PY_Season_Ticket_Renewal_Qty
	, Season_RenewalQtyPaid PY_Season_Ticket_Renewal_QtyPaid
	, Season_Ticket_Renewal_Rev PY_Season_Ticket_Renewal_Rev 
	, Season_Renewal_RevPaid PY_Season_Ticket_Renewal_RevPaid 
	, Season_Renewal_Don_Rev PY_Season_Ticket_Renewal_Don
	, Season_Renewal_Don_RevPaid PY_Season_Ticket_Renewal_DonPaid
	--, Season_Additional_Ticket_Patrons PY_Season_Additional_Ticket_Patrons 
	, Season_Additional_Ticket_PatronsPaid PY_Season_Additional_Ticket_PatronsPaid
	--, Season_Additional_Ticket_Qty PY_Season_Additional_Ticket_Qty
	, Season_Additional_Ticket_QtyPaid PY_Season_Additional_Ticket_QtyPaid
	--, Season_Additional_Ticket_Rev PY_Season_Additional_Ticket_Rev
	, Season_Additional_Ticket_RevPaid PY_Season_Additional_Ticket_RevPaid
	--, Season_Additional_Ticket_Don PY_Season_Additional_Ticket_Don
	, Season_Additional_Ticket_DonPaid PY_Season_Additional_Ticket_DonPaid
	--, Season_New_Ticket_Patrons PY_Season_New_Ticket_Patrons
	, Season_New_Ticket_PatronsPaid PY_Season_New_Ticket_PatronsPaid
	--, Season_New_Ticket_Qty PY_Season_New_Ticket_Qty
	, Season_New_Ticket_QtyPaid PY_Season_New_Ticket_QtyPaid
	--, Season_New_Ticket_Rev PY_Season_New_Ticket_Rev
	, Season_New_Ticket_RevPaid PY_Season_New_Ticket_RevPaid
	--, Season_New_Ticket_Don PY_Season_New_Ticket_Don
	, Season_New_Ticket_DonPaid PY_Season_New_Ticket_DonPaid	
FROM 
	(
	SELECT 
		CASE grouping_id(rb.SEASON, MINPAYMENTDATE) WHEN 3 THEN 'Total PY' ELSE 'Detail' END AS DataType
		, rb.SEASON SEASON 
		, rb.minpaymentdate MINPAYMENTDATE
		-----All Tickets
		, COUNT(DISTINCT CASE WHEN rb.PAIDTOTAL >= 1 AND ITEM = 'FS' THEN rb.CUSTOMER 
			ELSE NULL END) Total_Season_PaidPatrons
		, COUNT(DISTINCT CASE WHEN ITEM = 'FS'  THEN rb.CUSTOMER 
			ELSE NULL END) Total_Season_PatronTotal
		, SUM(CASE WHEN rb.PAIDTOTAL >= 1 AND ITEM = 'FS' THEN rb.ORDQTY
			ELSE 0 END) Total_SeasonQtyPaid
		, SUM(CASE WHEN ITEM = 'FS' THEN rb.ORDQTY 
			ELSE 0 END) Total_Season_Ticket_Qty
		, SUM(CASE WHEN  rb.PAIDTOTAL >= 1 AND ITEM = 'FS' THEN rb.ORDTOTAL 
			ELSE 0 END) Total_Season_RevPaid
		, SUM(CASE WHEN item = 'FS' THEN rb.ORDTOTAL 
			ELSE 0 END) Total_Season_Ticket_Rev
		, SUM(CASE WHEN  rb.PAIDTOTAL >= 1  AND rb.Item LIKE 'DON%' THEN rb.ORDTOTAL 
			ELSE 0 END) Total_Season_Don_RevPaid
		,SUM(CASE WHEN rb.DON_Item LIKE 'DON%' THEN rb.ordqty*rb.DON_AMT 
			ELSE 0 END) Total_Season_Don_Rev
		-----Renewals
		, COUNT(DISTINCT CASE WHEN rb.PAIDTOTAL >= 1  AND ITEM = 'FS' AND rb.RENEWAL = 1 THEN rb.CUSTOMER 
			ELSE NULL END) Season_Renewal_PaidPatrons
		, COUNT(DISTINCT CASE WHEN Item = 'FS' AND  rb.RENEWAL = 1 THEN rb.CUSTOMER 
			ELSE NULL END) AS Season_Ticket_Renewal_Patrons 
		, SUM(CASE WHEN rb.PAIDTOTAL >= 1 AND ITEM = 'FS' AND rb.RENEWAL = 1 THEN rb.ORDQTY
			ELSE 0 END) Season_RenewalQtyPaid
		, SUM(CASE WHEN Item = 'FS' AND  rb.RENEWAL = 1 THEN rb.ORDQTY 
			ELSE 0 END) AS Season_Ticket_Renewal_Qty 
		, SUM(CASE WHEN  rb.PAIDTOTAL >= 1 AND ITEM = 'FS' AND rb.RENEWAL = 1 THEN rb.ORDTOTAL 
			ELSE 0 END) Season_Renewal_RevPaid
		, SUM(CASE WHEN Item = 'FS' AND  rb.RENEWAL = 1 THEN rb.ORDTOTAL 
			ELSE 0 END) AS Season_Ticket_Renewal_Rev
		, SUM(CASE WHEN rb.DON_ITEM LIKE 'DON%' AND rb.RENEWAL = 1 AND rb.PAIDTOTAL >=1 THEN rb.ordqty*rb.DON_AMT 
			ELSE 0 END) Season_Renewal_Don_RevPaid
		, SUM(CASE WHEN rb.DON_ITEM LIKE 'DON%' AND rb.RENEWAL = 1 THEN rb.ordqty*rb.DON_AMT 
			ELSE 0 END) Season_Renewal_Don_Rev
		-----Additional
		--, COUNT(DISTINCT CASE WHEN Item = 'FS' AND rb.I_PT LIKE '%A' THEN rb.CUSTOMER 
		--	ELSE NULL end) AS Season_Additional_Ticket_Patrons
		, COUNT(DISTINCT CASE WHEN Item = 'FS' AND rb.I_PT LIKE '%A' AND rb.paidtotal >=1 THEN rb.CUSTOMER 
			ELSE NULL end) AS Season_Additional_Ticket_PatronsPaid
		--, SUM(CASE WHEN Item = 'FS' AND rb.I_PT LIKE '%A' THEN rb.ORDQTY 
		--	ELSE 0 END) AS Season_Additional_Ticket_Qty
		, SUM(CASE WHEN Item = 'FS' AND rb.I_PT LIKE '%A' AND rb.paidtotal >=1 THEN rb.ORDQTY 
			ELSE 0 END) AS Season_Additional_Ticket_QtyPaid
		--, SUM(CASE WHEN Item = 'FS' AND rb.I_PT LIKE '%A' THEN rb.ORDTOTAL
		--	ELSE 0 END) AS Season_Additional_Ticket_Rev
		, SUM(CASE WHEN Item = 'FS' AND rb.I_PT LIKE '%A' AND rb.paidtotal >=1 THEN rb.ORDTOTAL
			ELSE 0 END) AS Season_Additional_Ticket_RevPaid
		--, SUM(CASE WHEN rb.DON_ITEM LIKE 'DON%' AND rb.DonI_PT LIKE '%A' THEN rb.ordqty*rb.DON_AMT  
		--	ELSE 0 END) AS Season_Additional_Ticket_Don
		, SUM(CASE WHEN rb.DON_ITEM LIKE 'DON%' AND rb.DonI_PT LIKE '%A' AND rb.paidtotal >=1  THEN rb.ordqty*rb.DON_AMT 
			ELSE 0 END) AS Season_Additional_Ticket_DonPaid
		-----New Season Tickets
		--, COUNT(DISTINCT CASE WHEN Item = 'FS' AND (rb.I_PT LIKE 'N%' AND rb.I_PT LIKE 'BN%') THEN rb.CUSTOMER
		--	ELSE NULL END) AS Season_New_Ticket_Patrons
		, COUNT(DISTINCT CASE WHEN Item = 'FS' AND (rb.I_PT LIKE 'N%' OR rb.I_PT LIKE 'BN%') AND rb.paidtotal >= 1 THEN rb.CUSTOMER
			ELSE NULL END) AS Season_New_Ticket_PatronsPaid  
		--, SUM(CASE WHEN Item = 'FS' AND (rb.I_PT LIKE 'N%' AND rb.I_PT LIKE 'BN%') THEN rb.ORDQTY 
		--	ELSE 0 END) AS Season_New_Ticket_Qty 
		, SUM(CASE WHEN Item = 'FS' AND (rb.I_PT LIKE 'N%' OR rb.I_PT LIKE 'BN%')  AND rb.paidtotal >= 1 THEN rb.ORDQTY 
			ELSE 0 END) AS Season_New_Ticket_QtyPaid
		--, SUM(CASE WHEN Item = 'FS' AND (rb.I_PT LIKE 'N%' AND rb.I_PT LIKE 'BN%') THEN rb.ORDTOTAL
		--	ELSE 0 END) AS Season_New_Ticket_Rev
		, SUM(CASE WHEN Item = 'FS' AND (rb.I_PT LIKE 'N%' OR rb.I_PT LIKE 'BN%') AND rb.paidtotal >= 1 THEN rb.ORDTOTAL
			ELSE 0 END) AS Season_New_Ticket_RevPaid
		--, SUM(CASE WHEN rb.DON_ITEM LIKE 'DON%' AND (rb.DonI_PT LIKE 'N%' AND rb.DonI_PT LIKE 'BN%') THEN rb.ordqty*rb.DON_AMT 
		--	ELSE 0 END) AS Season_New_Ticket_Don
		, SUM(CASE WHEN rb.DON_ITEM LIKE 'DON%' AND (rb.DonI_PT LIKE 'N%' OR rb.DonI_PT LIKE 'BN%') AND rb.paidtotal >= 1 THEN rb.ordqty*rb.DON_AMT 
			ELSE 0 END) AS Season_New_Ticket_DonPaid
	FROM #ReportBase rb
	WHERE 1=1
		AND rb.SEASON = 'F14'
		AND rb.PAIDTOTAL > 0
	GROUP BY
		GROUPING SETS((rb.SEASON, rb.MINPAYMENTDATE), ())
	)x
) y ON x.CY_Day_Of_Renewal_Cycle = y.PY_Day_Of_Renewal_Cycle OR  (x.DataType = 'Total CY' AND y.DataType = 'Total PY')
ORDER BY 
	x.CY_Day_Of_Renewal_Cycle ASC 

END	

	
GO
