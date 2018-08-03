SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--exec  [dbo].[rptCustFootballSalesDashboard_6]
CREATE proc [dbo].[rptCustFootballSalesDashboard_6] as 

BEGIN 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--DROP TABLE #A
--DROP TABLE #ReportBase
SELECT * 
INTO #A
FROM TIPRICELEVELMAP2 
WHERE season IN ('F15')

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


SELECT
	a.Total_Renewal_Cash
	,a.Total_Don_Cash
	,a.Total_Renewal_Cash+a.Total_Don_Cash TotalCash
	,a.Total_Renewal_Expected
	,a.Total_Don_Expected
	,a.Total_Renewal_Expected+a.Total_Don_Expected TotalExpected
FROM
(
SELECT 
	SUM(CASE WHEN rb.PAIDTOTAL > 0 AND ITEM = 'FS' THEN rb.PAIDTOTAL
		ELSE 0 END) Total_Renewal_Cash,
	SUM(CASE WHEN rb.PAIDTOTAL > 0 AND rb.ITEM LIKE 'FS%' THEN rb.ORDTOTAL
		ELSE 0 END) Total_Renewal_Expected,
	--SUM(CASE WHEN rb.PAIDTOTAL > 0 AND Item LIKE 'DON%' AND rb.DonI_PT NOT LIKE 'N%' AND rb.DonI_PT NOT LIKE 'BN%' AND rb.DonI_PT NOT LIKE '%A' THEN rb.PAIDTOTAL
	--	ELSE 0 END) AS Total_Renewal_Don_Cash,
	SUM(CASE WHEN rb.PAIDTOTAL > 0 AND rb.ITEM LIKE 'DON%'  THEN rb.PAIDTOTAL
		ELSE 0 END) AS Total_Don_Cash,
	SUM(CASE WHEN rb.PAIDTOTAL > 0 AND rb.ITEM LIKE 'DON%' THEN rb.ORDTOTAL
		ELSE 0 END) AS Total_Don_Expected
FROM #ReportBase rb
WHERE 1=1
	AND rb.SEASON = 'F15'
)a
END


GO
