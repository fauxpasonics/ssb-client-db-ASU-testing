SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









--exec rptCustSeasonTicketMBBRenew1_2016Prod


CREATE  PROCEDURE [dbo].[rptCustSeasonTicketMBBRenew1_2017_bkpPacVersion] 
    (
      @startDate DATE
    , @endDate DATE
    , @dateRange VARCHAR(20)
    )
AS 

/*
DROP TABLE #budget
DROP TABLE #ReportBase
*/
 
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @prevSeason varchar(50)
declare @curSeason varchar(50)
declare @prevHomeGames as numeric
declare @curHomeGames as numeric

Set @prevSeason = 'BB16'
Set @curSeason = 'BB17'
Set @prevHomeGames = 16
Set @curHomeGames = 16

--DECLARE @daterange varchar(20)= 'alldata'
--DECLARE @startdate date = dateadd(month,-1,getdate())
--DECLARE @enddate DATE = GETDATE()

----------------------------------------------------------------------------------

--BEGIN

IF OBJECT_ID ('tempdb..#budget') IS NOT NULL
	DROP TABLE #budget

IF OBJECT_ID ('tempdb..#ReportBase') IS NOT NULL
	DROP TABLE #ReportBase

Create table #budget (
	saleTypeName varchar(100)
	,amount int
)

insert into #budget
--Budget and Prior Year Revenue
Select 'Mini Plans FSE', '142500'  UNION ALL
Select 'Season', '507500' UNION ALL
Select 'Single Game Tickets', '529800'   

---- Build Report --------------------------------------------------------------------------------------------------

Create table #ReportBase (
	SEASON varchar (15)
	,CUSTOMER varchar (20)
	,ITEM varchar (32) 
	,E_PL varchar (10)
	,I_PT  varchar (32)
	,I_PRICE  numeric (18,2)
	,I_DAMT  numeric (18,2)
	,ORDQTY bigint 
	,ORDTOTAL numeric (18,2) 
	,PAIDCUSTOMER  varchar (20)
	,MINPAYMENTDATE datetime  
	,PAIDTOTAL numeric (18,2)
)

INSERT INTO #ReportBase (
	SEASON
	,CUSTOMER 
	,ITEM 
	,E_PL 
	,I_PT 
	,I_PRICE  
	,I_DAMT  
	,ORDQTY
	,ORDTOTAL
	,PAIDCUSTOMER  
	,MINPAYMENTDATE  
	,PAIDTOTAL 
) 
SELECT 
	SEASON
	,CUSTOMER 
	,ITEM 
	,E_PL 
	,I_PT 
	,I_PRICE  
	,I_DAMT  
	,ORDQTY
	,ORDTOTAL
	,PAIDCUSTOMER  
	,MINPAYMENTDATE  
	,PAIDTOTAL 
FROM dbo.vwTIReportBase rb 
WHERE rb.SEASON = @prevSeason 
	OR (@dateRange = 'AllData' 
		AND rb.season = @curseason)
	OR (@dateRange <> 'AllData' 
		AND rb.season = @curSeason 
		AND rb.MINPAYMENTDATE BETWEEN @startDate AND @endDate)

-----------------------------------------------------------------------------------------
Declare @SeasonSummary table (
	season varchar(100)
	,saleTypeName  varchar(50)
	,qty  int
	,amt money
)

INSERT INTO @SeasonSummary (
	season
	,saleTypeName
	,qty
	,amt
)

-----------------------------------------------------------------------------
--SEASON 
--Previous SEASON  
SELECT 
	SEASON 
	,'Season'
	,SUM(ORDQTY) QTY
	,SUM(ORDTOTAL) AMT
FROM #ReportBase 
WHERE ITEM = 'FS' 
	AND SEASON IN ( @prevSeason)
	AND (PAIDTOTAL > 0  OR I_PT = 'BNYALC') 
	AND CUSTOMER <> '137398'
GROUP BY CUSTOMER , SEASON 

UNION ALL 

--CURRENT SEASON 
SELECT 
	SEASON 
	,'Season'
	,SUM(ORDQTY) QTY
	,SUM(ORDTOTAL) AMT
FROM #ReportBase 
WHERE ITEM = 'FS' 
	AND SEASON IN ( @curSeason)
	AND (PAIDTOTAL > 0  OR I_PT = 'BNYALC') 
	AND CUSTOMER <> '137398'
GROUP BY CUSTOMER , SEASON 

------------------------------------------------------------------------------------------------------
--MINI Plans 
UNION ALL 

SELECT 
	 SEASON 
	 ,'Mini Plans FSE'
	 ,CASE WHEN ITEM LIKE '2%' THEN SUM(ORDQTY) * 2/@curHomeGames
	       WHEN ITEM LIKE '3%' THEN SUM(ORDQTY) * 3/@curHomeGames
	       WHEN ITEM LIKE '4%' THEN SUM(ORDQTY) * 4/@curHomeGames
	       WHEN ITEM LIKE '5%' THEN SUM(ORDQTY) * 5/@curHomeGames
	       WHEN ITEM LIKE '6%' THEN SUM(ORDQTY) * 6/@curHomeGames
	       WHEN ITEM LIKE '7%' THEN SUM(ORDQTY) * 7/@curHomeGames
	       WHEN ITEM LIKE '8%' THEN SUM(ORDQTY) * 8/@curHomeGames
	       WHEN ITEM LIKE '9%' THEN SUM(ORDQTY) * 9/@curHomeGames
	       WHEN ITEM LIKE '10%' THEN SUM(ORDQTY)* 10/@curHomeGames
	       WHEN ITEM LIKE '11%' THEN SUM(ORDQTY)* 11/@curHomeGames
		END AS QTY
	,SUM(ORDTOTAL) AMT
FROM #ReportBase 
WHERE ITEM LIKE '[1-9]%'  
	AND SEASON IN (@curSeason)
	AND ( PAIDTOTAL > 0 )
GROUP BY SEASON , ITEM   

UNION ALL 

SELECT 
	 SEASON 
	 ,'Mini Plans FSE'
	 ,CASE WHEN ITEM LIKE '2%' THEN SUM(ORDQTY) * 2/@prevHomeGames
	       WHEN ITEM LIKE '3%' THEN SUM(ORDQTY) * 3/@prevHomeGames
	       WHEN ITEM LIKE '4%' THEN SUM(ORDQTY) * 4/@prevHomeGames
	       WHEN ITEM LIKE '5%' THEN SUM(ORDQTY) * 5/@prevHomeGames
	       WHEN ITEM LIKE '6%' THEN SUM(ORDQTY) * 6/@prevHomeGames
	       WHEN ITEM LIKE '7%' THEN SUM(ORDQTY) * 7/@prevHomeGames
	       WHEN ITEM LIKE '8%' THEN SUM(ORDQTY) * 8/@prevHomeGames
	       WHEN ITEM LIKE '9%' THEN SUM(ORDQTY) * 9/@prevHomeGames
	       WHEN ITEM LIKE '10%' THEN SUM(ORDQTY)* 10/@prevHomeGames
	       WHEN ITEM LIKE '11%' THEN SUM(ORDQTY)* 11/@prevHomeGames
		END AS QTY
	,SUM(ORDTOTAL) AMT
FROM #ReportBase 
WHERE ITEM LIKE '[1-9]%'  
	AND SEASON IN (@prevSeason)
	AND ( PAIDTOTAL > 0 )
GROUP BY SEASON , ITEM   

--------------------------------------------------------------------------------------------------------
UNION ALL 

SELECT 
	 rb.SEASON 
	,'Single Game Tickets'
	,SUM(ORDQTY) AS Qty
	,SUM(ORDTOTAL) AS Amt
FROM #ReportBase rb 
WHERE ITEM LIKE 'MB%'
    --AND ITEM <> 'MB18' 
	AND rb.SEASON = @prevSeason
	AND rb.I_PT NOT LIKE 'V%'
	AND rb.I_PRICE > 0
	AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.Season, rb.I_PT

UNION ALL

SELECT 
	 rb.SEASON 
	,'Single Game Tickets'
	,SUM(ORDQTY) AS Qty
	,SUM(ORDTOTAL) AS Amt
FROM #ReportBase rb 
WHERE ITEM LIKE 'MB%'
	--AND ITEM <> 'MB18' 
	AND rb.SEASON = @prevSeason
	AND rb.I_PT = 'V'
	AND rb.I_PRICE > 0
GROUP BY rb.Season, rb.I_PT

UNION ALL 

SELECT 
	 rb.SEASON 
	,'Single Game Tickets'
	,SUM(ORDQTY) AS Qty
	,SUM(ORDTOTAL) AS Amt
FROM #ReportBase rb 
 WHERE ITEM LIKE 'MB%'
	AND rb.I_PT NOT LIKE 'V%'
	AND rb.SEASON = @curSeason
	AND rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.Season, rb.I_PT

UNION ALL

SELECT 
	 rb.SEASON 
	,'Single Game Tickets'
	,SUM(ORDQTY) AS Qty
	,SUM(ORDTOTAL) AS Amt
FROM #ReportBase rb 
WHERE ITEM LIKE 'MB%'
	AND rb.I_PT = 'V'
	AND rb.SEASON = @curSeason
	AND rb.I_PRICE > 0
GROUP BY rb.Season, rb.I_PT

-------------------------------------------------------------------------------------

SELECT 
	   ISNULL(PrevYR.saleTypeName,'') AS QtyCat
      ,ISNULL(PrevYR.prevQty,0)  AS [PYQty]
	  ,ISNULL(CurYR.CurQty,0) AS [CYQty]
	  ,ISNULL(CurYR.CurQty,0) - ISNULL(PrevYR.prevQty,0)  AS [DiffVsPY]
	  ,ISNULL(budget.saleTypeName,'') AS AmtCat
	  ,ISNULL(CurYR.CurAmt,0) AS [CYAmt]
	  ,ISNULL(CONVERT(DECIMAL(12,2),budget.amount),0) AS Budget
	  ,ISNULL(CurYR.CurAmt,0) - ISNULL(CONVERT(DECIMAL(12,2),budget.amount),0)  AS Variance
	  ,CASE ISNULL(CONVERT(DECIMAL(12,2),budget.amount),0) WHEN 0 THEN 0 ELSE ISNULL(CurYR.CurAmt,0) / ISNULL(CONVERT(DECIMAL(12,2),budget.amount),0) END AS PctToBudget
	  ,ISNULL(PrevYR.prevAmt,0)  AS [PYAmt]
	  ,CASE ISNULL(PrevYR.prevAmt,0) WHEN 0 THEN 0 ELSE ISNULL(CurYR.CurAmt,0) / ISNULL(PrevYR.prevAmt,0) END AS PctToPY
FROM (
		SELECT 
			saleTypeName, 
			SUM(qty) AS prevQty, 
			SUM(amt) AS prevAmt 
		FROM @seasonsummary a 
		WHERE CAST(RIGHT(season,2) AS INT) = RIGHT(@prevseason,2) 
		GROUP BY 
			saleTypeName
	) PrevYR
LEFT OUTER JOIN (
		SELECT 
			saleTypeName, 
			SUM(qty) AS curQty, 
			SUM(amt) AS curAmt 
		FROM @seasonsummary a 
		WHERE CAST(RIGHT(season,2) AS INT) = RIGHT(@curseason,2) 
		GROUP BY 
			saleTypeName
	) CurYR
	ON  PrevYR.saleTypeName = CurYR.saleTypeName
LEFT OUTER JOIN #budget budget
	ON  PrevYR.saleTypeName = budget.saleTypeName
ORDER BY 
	CASE PrevYR.saleTypeName
		WHEN 'Single Game Tickets' THEN 5
		WHEN 'Season' THEN 7
		WHEN 'Mini Plans FSE' THEN 6 
		END

END

GO
