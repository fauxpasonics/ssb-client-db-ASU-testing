SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE PROCEDURE [rpt].[CustSeasonTicketBaseballRenew1_2016Prod] 
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

DECLARE @prevSeason VARCHAR(50) = 'B15'
DECLARE @curSeason VARCHAR(50) = 'B16'
DECLARE @prevHomeGames AS NUMERIC = 36
DECLARE @curHomeGames AS NUMERIC = 36

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
SELECT 'Mini Plans FSE', 35000 UNION ALL
SELECT 'Season', 270000 UNION ALL
SELECT 'Single Game Tickets', 477000 UNION ALL
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

SELECT  'B01'	,11250	  ,750		,450	,650	UNION ALL
SELECT  'B02'	,11250	  ,750		,450	,650	UNION ALL
SELECT  'B03'	,7500	  ,500		,350	,550	UNION ALL
SELECT  'B04'	,11250	  ,750		,350	,550	UNION ALL
SELECT  'B05'	,11250	  ,750		,450	,650	UNION ALL
SELECT  'B06'	,11250	  ,750		,450	,650	UNION ALL
SELECT  'B07'	,7500	  ,500		,350	,550	UNION ALL
SELECT  'B08'	,11250	  ,750		,350	,550	UNION ALL
SELECT  'B09'	,11250	  ,750		,450	,650	UNION ALL
SELECT  'B10'	,11250	  ,750		,450	,650	UNION ALL
SELECT  'B11'	,18000	  ,1200		,350	,550	UNION ALL
SELECT  'B12'	,18000	  ,1200		,450	,650	UNION ALL
SELECT  'B13'	,18000	  ,1200		,450	,650	UNION ALL
SELECT  'B14'	,12750	  ,850		,350	,550	UNION ALL
SELECT  'B15'	,12750	  ,850		,350	,550	UNION ALL
SELECT  'B16'	,16500	  ,1100		,450	,650	UNION ALL
SELECT  'B17'	,16500	  ,1100		,450	,650	UNION ALL
SELECT  'B18'	,12000	  ,800		,350	,550	UNION ALL
SELECT  'B19'	,12000	  ,800		,350	,550	UNION ALL
SELECT  'B20'	,18000	  ,1200		,450	,650	UNION ALL
SELECT  'B21'	,18000	  ,1200		,450	,650	UNION ALL
SELECT  'B22'	,12750	  ,850		,350	,550	UNION ALL
SELECT  'B23'	,16500	  ,1100		,350	,550	UNION ALL
SELECT  'B24'	,27000	  ,1800		,450	,650	UNION ALL
SELECT  'B25'	,27000	  ,1800		,350	,550	UNION ALL
SELECT  'B26'	,18000	  ,1200		,350	,550	UNION ALL
SELECT  'B27'	,6600	  ,550		,450	,650	UNION ALL
SELECT  'B28'	,6600	  ,550		,450	,650	UNION all
select  'B29'	,3600	  ,300		,350	,550	union all
select  'B30'	,11250	  ,750		,450	,650	union all
select  'B31'	,11250	  ,750		,450	,650	union all
select  'B32'	,7500	  ,500		,350	,550	union all
select  'B33'	,7200	  ,600		,350	,550	union all
select  'B34'	,7200	  ,600		,450	,650	union all
select  'B35'	,4800	  ,400		,450	,650	union all
select  'B36'	,4800	  ,400		,350	,550



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
WHERE ITEM = 'BBS' 
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
	       WHEN ITEM LIKE '9FLEX%' THEN SUM(ORDQTY) /@curHomeGames
		   WHEN ITEM LIKE '9%' AND ITEM NOT LIKE '9FLEX%' THEN SUM(ORDQTY)* 9/@curHomeGames
	       WHEN ITEM LIKE '10%' THEN SUM(ORDQTY)* 10/@curHomeGames
	       WHEN ITEM LIKE '11%' THEN SUM(ORDQTY)* 11/@curHomeGames
		END AS QTY
	,SUM(ORDTOTAL) AMT
FROM #ReportBase 
WHERE  ITEM LIKE '[1-9]%'  
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
