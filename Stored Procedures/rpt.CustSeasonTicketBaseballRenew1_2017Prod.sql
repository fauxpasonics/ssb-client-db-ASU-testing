SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE PROCEDURE [rpt].[CustSeasonTicketBaseballRenew1_2017Prod] 
(
  @startDate DATE
, @endDate DATE
, @dateRange VARCHAR(20)
)
AS 

IF OBJECT_ID('tempdb..#budget') IS NOT NULL
DROP TABLE #budget

IF OBJECT_ID('tempdb..#ReportBase') IS NOT NULL
DROP TABLE #ReportBase

IF OBJECT_ID('tempdb..#suitebudget') IS NOT NULL
DROP TABLE #suitebudget

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @prevSeason VARCHAR(50) = 'B16'
DECLARE @curSeason VARCHAR(50) = 'B17'
DECLARE @prevHomeGames AS NUMERIC = 36
DECLARE @curHomeGames AS NUMERIC = 33

--DECLARE @dateRange VARCHAR(30) = 'AllData'
--DECLARE @startDate AS DATE = DATEADD(MONTH,-1,GETDATE())
--DECLARE @endDate AS DATE = GETDATE()

----------------------------------------------------------------------------------


--BEGIN



CREATE TABLE   #budget 
(
	saleTypeName VARCHAR(100)
	,amount INT
)

INSERT INTO #budget
--Budget and Prior Year Revenue
SELECT 'Mini Plans FSE', 0 UNION ALL
SELECT 'Season', 0 UNION ALL
SELECT 'Single Game Tickets', 0 UNION ALL
SELECT 'Scout Card', 0
----------------------------------------------------------------------------------


CREATE TABLE #suitebudget 
(
event VARCHAR (10) 
,amount FLOAT
,quantity INT
,suite16 INT
,suite32 INT
)

INSERT INTO #suitebudget
(		event , amount, quantity, suite16, suite32)

SELECT  'B01'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B02'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B03'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B04'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B05'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B06'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B07'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B08'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B09'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B10'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B11'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B12'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B13'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B14'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B15'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B16'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B17'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B18'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B19'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B20'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B21'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B22'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B23'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B24'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B25'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B26'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B27'	,0		  ,0		,0		,0		UNION ALL
SELECT  'B28'	,0		  ,0		,0		,0		UNION ALL
select  'B29'	,0		  ,0		,0		,0		UNION ALL
select  'B30'	,0		  ,0		,0		,0		UNION ALL
select  'B31'	,0		  ,0		,0		,0		UNION ALL
select  'B32'	,0		  ,0		,0		,0		UNION ALL
select  'B33'	,0		  ,0		,0		,0		UNION ALL
select  'B34'	,0		  ,0		,0		,0		UNION ALL
select  'B35'	,0		  ,0		,0		,0		UNION ALL
select  'B36'	,0		  ,0		,0		,0		



---- Build Report --------------------------------------------------------------------------------------------------


CREATE TABLE #ReportBase  
(
  SEASON VARCHAR (15)
 ,CUSTOMER VARCHAR (20)
 ,ITEM VARCHAR (32) 
 ,E_PL VARCHAR (10)
 ,I_PT  VARCHAR (32)
 ,I_PRICE  NUMERIC (18,2)
 ,I_DAMT  NUMERIC (18,2)
 ,ORDQTY BIGINT 
 ,ORDTOTAL NUMERIC (18,2) 
 ,PAIDCUSTOMER  VARCHAR (20)
 ,MINPAYMENTDATE DATETIME  
 ,PAIDTOTAL NUMERIC (18,2)
)

INSERT INTO #ReportBase 
(
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
 FROM vwTIReportBase rb 
WHERE   rb.SEASON = @prevSeason 
		OR (@dateRange = 'AllData' 
			AND rb.season = @curseason)
		OR (@dateRange <> 'AllData' 
			AND rb.season = @curSeason 
			AND rb.MINPAYMENTDATE 
				BETWEEN @startDate AND @endDate) 


-----------------------------------------------------------------------------------------
DECLARE @SeasonSummary TABLE 
(
	season VARCHAR(100)
	,saleTypeName  VARCHAR(50)
	,qty  INT
	,amt MONEY
)


INSERT INTO @SeasonSummary
(
 season
 ,saleTypeName
,qty
,amt
)


----------------------------------------------- SEASON -------------------------------------------
 
--PREVIOUS  
SELECT 
	  SEASON 
	 ,'Season'
	 ,SUM(ORDQTY) QTY
	 ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
WHERE ITEM = 'FS' 
	AND SEASON IN (@prevSeason)
	AND (PAIDTOTAL > 0 ) 
GROUP BY CUSTOMER , SEASON 

UNION ALL 

--CURRENT
SELECT 
	  SEASON 
	 ,'Season'
	 ,SUM(ORDQTY) QTY
	 ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
WHERE ITEM = 'FS' 
	AND SEASON IN ( @curSeason)
	AND (PAIDTOTAL > 0 ) 
GROUP BY CUSTOMER , SEASON 

UNION ALL 
-----------------------------------------------MINI Plans -------------------------------------------

--PREVIOUS
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
	       WHEN ITEM LIKE '9FLEX%' THEN SUM(ORDQTY) /@prevHomeGames
		   WHEN ITEM LIKE '9%' AND ITEM NOT LIKE '9FLEX%' THEN SUM(ORDQTY)* 9/@prevHomeGames
	       WHEN ITEM LIKE '10%' THEN SUM(ORDQTY)* 10/@prevHomeGames
	       WHEN ITEM LIKE '11%' THEN SUM(ORDQTY)* 11/@prevHomeGames
		END AS QTY
	,SUM(ORDTOTAL) AMT
FROM #ReportBase 
WHERE  ITEM LIKE '[1-9]%'  
	   AND SEASON IN (@prevSeason)
	   AND ( PAIDTOTAL > 0 )
GROUP BY SEASON , ITEM   

UNION ALL 

--CURRENT
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
	       WHEN ITEM LIKE 'FLEX%' THEN SUM(ORDQTY) /@curHomeGames
		   WHEN ITEM LIKE '9%'  THEN SUM(ORDQTY)* 9/@curHomeGames
	       WHEN ITEM LIKE '10%' THEN SUM(ORDQTY)* 10/@curHomeGames
	       WHEN ITEM LIKE '11%' THEN SUM(ORDQTY)* 11/@curHomeGames
		END AS QTY
	,SUM(ORDTOTAL) AMT
FROM #ReportBase 
WHERE ( ITEM LIKE '[1-9]%'  OR ITEM LIKE 'FLEX%')
	   AND SEASON IN (@curSeason)
	   AND ( PAIDTOTAL > 0 )
GROUP BY SEASON , ITEM   

UNION ALL  

------------------------------------------------ SINGLE GAME (GROUP/PUBLIC LOGIC) --------------------------------------------------------
--PREVIOUS
SELECT 
	 rb.SEASON 
	,'Single Game Tickets'
,SUM(ORDQTY) AS Qty
,SUM(CASE WHEN rb.I_PT = 'FFP' THEN (ORDTOTAL - ORDQTY*(8)) ELSE ORDTOTAL END) AS Amt
FROM #ReportBase rb 
WHERE ITEM LIKE  'B[0-9]%'
	  AND rb.I_PT NOT LIKE 'V%'
	  AND rb.I_PT NOT IN ('SSP', 'SSR', 'SSRC')
	  AND rb.SEASON = @prevSeason 
	  AND rb.I_PRICE > 0
	  AND rb.PAIDTOTAL > 0 
GROUP BY rb.Season, rb.I_PT

UNION ALL 

--CURRENT
SELECT 
	 rb.SEASON 
	,'Single Game Tickets'
,SUM(ORDQTY) AS Qty
,SUM(CASE WHEN rb.I_PT = 'FFP' THEN (ORDTOTAL - ORDQTY*(8)) ELSE ORDTOTAL END) AS Amt
FROM #ReportBase rb 
WHERE ITEM LIKE  'B[0-9]%'
	  AND rb.I_PT NOT LIKE 'V%'
	  AND rb.I_PT NOT IN ('SSP', 'SSR', 'SSRC')
	  AND rb.SEASON = @curSeason 
	  AND rb.I_PRICE > 0
	  AND rb.PAIDTOTAL > 0 
GROUP BY rb.Season, rb.I_PT

UNION ALL

------------------------------------------------ SINGLE GAME (VISITOR LOGIC) --------------------------------------------------------
--PREVIOUS
SELECT 
	 rb.SEASON 
	,'Single Game Tickets'
,SUM(ORDQTY) AS Qty
,SUM(ORDTOTAL) AS Amt
FROM #ReportBase rb 
    WHERE ITEM LIKE 'B[0-9]%'
	AND rb.I_PT = 'V'
	AND rb.SEASON = @prevSeason
	AND rb.I_PRICE > 0
GROUP BY rb.Season, rb.I_PT

UNION ALL

--CURRENT
SELECT 
	 rb.SEASON 
	,'Single Game Tickets'
,SUM(ORDQTY) AS Qty
,SUM(ORDTOTAL) AS Amt
FROM #ReportBase rb 
    WHERE ITEM LIKE 'B[0-9]%'
	AND rb.I_PT = 'V'
	AND rb.SEASON = @curSeason
	AND rb.I_PRICE > 0
GROUP BY rb.Season, rb.I_PT

UNION ALL

------------------------------------------------ SINGLE GAME (SUITE LOGIC) --------------------------------------------------------

SELECT 
	 rb.SEASON 
	,'Single Game Tickets'
,SUM(ORDQTY) AS Qty
,SUM(CASE 
		WHEN ordqty = 16 THEN sb.suite16 --check B24 multiple suites purchased that day
		WHEN ordqty = 32 THEN sb.suite32
		ELSE 0 END) AS Amt
FROM #ReportBase rb 
LEFT JOIN #suitebudget sb ON rb.item = sb.[event]
    WHERE ITEM LIKE 'B[0-9]%'
	AND rb.I_PT IN ('SSP', 'SSR', 'SSRC')
	AND rb.SEASON = @prevSeason 
	AND rb.I_PRICE > 0
	AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.Season, rb.I_PT

UNION ALL

SELECT 
	 rb.SEASON 
	,'Single Game Tickets'
,SUM(ORDQTY) AS Qty
,SUM(CASE 
		WHEN ordqty = 16 THEN sb.suite16 --check B24 multiple suites purchased that day
		WHEN ordqty = 32 THEN sb.suite32
		ELSE 0 END) AS Amt
FROM #ReportBase rb 
LEFT JOIN #suitebudget sb ON rb.item = sb.[event]
    WHERE ITEM LIKE 'B[0-9]%'
	AND rb.I_PT IN ('SSP', 'SSR', 'SSRC')
	AND rb.SEASON = @curSeason
	AND rb.I_PRICE > 0
	AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.Season, rb.I_PT
 
UNION ALL

--------------------------------------------- SCOUT CARD ----------------------------------------
 
SELECT 
       rb.SEASON 
      ,'Scout Card'
,SUM(ORDQTY) AS Qty
,SUM(ORDTOTAL) AS Amt
FROM #ReportBase rb 
WHERE ITEM LIKE 'SC'
      AND SEASON IN (@prevSeason, @curSeason)
      AND rb.I_PRICE > 0
	  AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.Season, rb.I_PT


--------------------------------------------- FINAL OUTPUT ----------------------------------------


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

	
FROM
(SELECT saleTypeName, SUM(qty) AS prevQty, SUM(amt) 
AS prevAmt FROM @seasonsummary a WHERE CAST(RIGHT(season,2) AS INT)
 = RIGHT(@prevseason,2) GROUP BY saleTypeName) PrevYR
LEFT OUTER JOIN (SELECT saleTypeName, SUM(qty) AS curQty, SUM(amt)
 AS curAmt FROM @seasonsummary a WHERE CAST(RIGHT(season,2) AS INT) 
 = RIGHT(@curseason,2) GROUP BY saleTypeName) CurYR
ON PrevYR.saleTypeName = CurYR.saleTypeName
LEFT OUTER JOIN #budget budget
ON PrevYR.saleTypeName = budget.saleTypeName
ORDER BY 
	CASE PrevYR.saleTypeName
		WHEN 'Single Game Tickets' THEN 5
		WHEN 'Season' THEN 7
		WHEN 'Mini Plans FSE' THEN 6 END




END









GO
