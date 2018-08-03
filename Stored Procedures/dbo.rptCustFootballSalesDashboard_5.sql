SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--exec dbo.rptCustFootballSalesDashboard_5
CREATE PROC [dbo].[rptCustFootballSalesDashboard_5] as 

begin 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


--DROP TABLE #ReportBase
--DROP TABLE #Seat
--DROP TABLE #FSPT
--DROP TABLE #A

SELECT * 
INTO #A
FROM TIPRICELEVELMAP2 (NOLOCK)	 
WHERE season IN ('F14' , 'F15')

select*into #FSPT from 
(
select prtype
FROM tk_prtype where season in ('F14', 'F15')  and class ='FS'

union all

SELECT 'SH'+prtype  as prtype   
from tk_prtype where season in ('F14', 'F15')  and class= 'FS'

UNION ALL
 
SELECT 'T'+ prtype  as prtype   
from tk_prtype where season in ('F14', 'F15')  and class= 'FS'
)a
SELECT
	s.CUSTOMER,
	s.SEASON,
	s.LEVEL,
	s.SECTION,
	s.I_PL,
	s.I_PT,
	COUNT(seat) SeatQty
INTO #Seat
FROM dbo.TK_SEAT_SEAT s (NOLOCK) 
WHERE s.ITEM = 'FS'
AND ((season = 'F14' AND s.EVENT ='F01')
OR (s.SEASON = 'F15' AND s.EVENT = 'F07'))
AND I_PT IN (select prtype COLLATE SQL_Latin1_General_CP1_CS_AS from #FSPT) AND I_PL NOT IN ('11','10')
GROUP BY s.CUSTOMER,
	s.SEASON,
	s.LEVEL,
	s.SECTION,
	s.I_PL,
	s.I_PT


SELECT 
	b.SEASON
	,b.CUSTOMER 
	,b.ITEM
	,b.E_PL 
	,b.I_PT 
	,I_PRICE  
	,ORDQTY
	,ORDTOTAL
	,PAIDCUSTOMER  
	,MINPAYMENTDATE  
	,PAIDTOTAL
	,s.LEVEL
	,s.SECTION
	,s.seatqty
	,(s.seatqty)*(b.I_PRICE) SeatPriceTotal
	, CASE WHEN b.i_PT like 'N%' THEN 0 WHEN b.I_PT like 'BN%' then 0  
      WHEN b.I_PT LIKE '%A' THEN 0 WHEN b.I_PT IS NULL THEN NULL
      ELSE 1 END as Renewal
	,CASE WHEN b.PAIDTOTAL >=1 THEN 1 ELSE 0 END AS paidrow
	, don.DON_ITEM
	, don.I_PT DonI_PT
	, don.I_PL DonI_PL
	, don.DON_AMT
	,(don.DON_AMT*s.SeatQty) DonTotal
INTO #ReportBase
FROM vwTIReportBase b (NOLOCK)
LEFT JOIN #A don
	ON b.season = don.season COLLATE SQL_Latin1_General_CP1_CS_AS 
	AND b.I_PT = don.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
	AND b.E_PL = don.I_PL COLLATE SQL_Latin1_General_CP1_CS_AS 
LEFT JOIN #Seat s
    ON b.CUSTOMER = s.CUSTOMER COLLATE SQL_Latin1_General_CP1_CS_AS
    AND b.SEASON = s.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS
    --AND b.ITEM = s.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS
    AND b.E_PL = s.I_PL COLLATE SQL_Latin1_General_CP1_CS_AS
    AND b.I_PT = s.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS
WHERE b.SEASON in ('F14', 'F15') AND b.PAIDTOTAL > 0
	AND (b.ITEM = 'FS' 
	OR (b.ITEM LIKE 'DON%'
	AND	b.ITEM NOT LIKE 'DONSUITE%'
	AND b.ITEM NOT LIKE 'DONCLUB%'))
	
	

	   

SELECT
	--RANK()  OVER (ORDER BY ISNULL(COALESCE(PY.Section, CY.section),'None')) RowOrder,
	case IsNumeric(ISNULL(COALESCE(PY.Section, CY.Section),'None')) 
        when 1 then Replicate('0', 4 - Len(ISNULL(COALESCE(PY.Section, CY.Section),'None'))) + ISNULL(COALESCE(PY.Section, CY.Section),'None')
        else ISNULL(COALESCE(PY.Section, CY.Section),'None')
    END RowOrder,
	ISNULL(COALESCE(PY.Level, CY.Level),'None') Level,
	ISNULL(COALESCE(PY.Section, CY.Section),'None') Section,
	ISNULL(py.ORDQTY,0) PYOrdQty,
	ISNULL(cy.ORDQTY,0) CYOrdQty,
	--ISNULL(py.ORDQTY,0) + ISNULL(cy.ORDQTY,0) TotalOrdQty,
	ISNULL(py.ORDTOTAL,0) PYOrdRev,
	ISNULL(cy.ORDTOTAL,0) CYOrdRev,
	--ISNULL(PY.ORDTOTAL,0) + ISNULL(CY.ORDTOTAL,0) TotalOrderRev,
	ISNULL(py.PaidDonRev,0) PYPaidDonRev,
	ISNULL(cy.PaidTixQty,0) CYPaidTixQty,
	ISNULL(cy.PaidTixRev,0) CYPaidTixRev,
	ISNULL(cy.PaidDonRev,0) CYPaidDonRev,
	COALESCE(py.E_PL, CY.E_PL) I_PL
FROM
(
	SELECT
		rb.Level,
		rb.Section,
		rb.E_PL,
		SUM(rb.SeatQty) ORDQTY,
		sum(rb.SeatPriceTotal) ORDTOTAL,
	    SUM(rb.DonTotal) PaidDonRev
	FROM #ReportBase rb (NOLOCK)
	WHERE rb.SEASON = 'F14'
		AND rb.ITEM = 'FS'
		AND (rb.paidrow = 1 OR CUSTOMER in ('152760','164043','186078'))
	GROUP BY rb.Level,
		rb.Section,
		rb.E_PL,
		rb.paidrow
)PY
FULL JOIN
(
	SELECT 
		rb.Level,
		rb.Section,
		rb.E_PL,
		SUM(rb.SeatQty) ORDQTY,
		sum(rb.SeatPriceTotal) ORDTOTAL,
		CASE --WHEN level IS NULL AND rb.paidrow = 1 THEN SUM(rb.ORDQTY)
			WHEN rb.paidrow = 1 THEN SUM(rb.SeatQTY) ELSE 0 END PaidTixQty,
		CASE --WHEN rb.level IS NULL AND rb.paidrow = 1 THEN SUM(rb.ordqty*rb.Don_Amt)
			WHEN rb.paidrow = 1 THEN SUM(rb.DonTotal) ELSE 0 END PaidDonRev,
		CASE --WHEN rb.paidrow = 1 AND rb.level IS NULL THEN SUM(ORDTOTAL)
			WHEN rb.paidrow = 1 THEN SUM(rb.SeatPriceTotal) ELSE 0 END PaidTixRev
	FROM #ReportBase rb (NOLOCK)
	WHERE rb.SEASON = 'F15'
		AND rb.ITEM = 'FS' 
		AND rb.Renewal = 1
	GROUP BY rb.Level,
		rb.Section,
		rb.E_PL,
		rb.paidrow 
)CY
ON	py.Section = cy.Section
AND py.E_PL = cy.E_PL
ORDER BY 
	Level,
	RowOrder,
	I_PL

END	


GO
