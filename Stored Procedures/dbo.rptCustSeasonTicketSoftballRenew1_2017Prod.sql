SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO















CREATE PROCEDURE [dbo].[rptCustSeasonTicketSoftballRenew1_2017Prod] 
(
  @startDate DATE
, @endDate DATE
, @dateRange VARCHAR(20)
)
AS 

IF OBJECT_ID('tempdb..#budget')IS NOT NULL
	DROP TABLE #budget

IF OBJECT_ID('tempdb..#reportBase')IS NOT NULL
	DROP TABLE #reportBase

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


DECLARE @prevSeason VARCHAR(50)
DECLARE @curSeason VARCHAR(50)
DECLARE @prevHomeGames AS NUMERIC
DECLARE @curHomeGames AS NUMERIC

SET @prevSeason = 'SB16'
SET @curSeason = 'SB17'
SET @prevHomeGames = 29
SET @curHomeGames = 25

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
SELECT 'Season',				'70000'	UNION ALL
SELECT 'Mini Plans FSE',			'8000'	UNION ALL
SELECT 'All Session Passes',	'20000'	UNION ALL
SELECT 'Single Game Tickets',			'169000'




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
FROM dbo.vwTIReportBase rb
WHERE   rb.SEASON = @prevSeason 
		OR (rb.season = @curseason 
			AND (@dateRange = 'AllData' 
				 OR rb.MINPAYMENTDATE BETWEEN @startDate AND @endDate))

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


-----------------------------------------------------------------------------
--SEASON 
--Previous  and Current SEASON  

SELECT 
         SEASON 
        ,'Season'
       ,SUM(ORDQTY) QTY
       ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
WHERE ITEM = 'FS' 
       AND SEASON IN (@prevSeason)
      AND ( PAIDTOTAL > 0 )
         --OR CUSTOMER in ('152760','164043','186078' ) ) removed 2/18/2015
       --AND CUSTOMER <> '137398' removed 2/18/2015
GROUP BY CUSTOMER , SEASON 


UNION ALL 
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





------------------------------------------------------------------------------------------------------
--MINI Plans 
UNION ALL 

SELECT 
        SEASON 
        ,'Mini Plans FSE'
       ,CASE WHEN ITEM LIKE '2%' THEN SUM(ORDQTY) * 2/NULLIF(@curHomeGames,0)
              WHEN ITEM LIKE '3%' THEN SUM(ORDQTY) * 3/NULLIF(@curHomeGames,0)
              WHEN ITEM LIKE '4%' THEN SUM(ORDQTY) * 4/NULLIF(@curHomeGames,0)
              WHEN ITEM LIKE '5%' THEN SUM(ORDQTY) * 5/NULLIF(@curHomeGames,0)
              WHEN ITEM LIKE '6%' THEN SUM(ORDQTY) * 6/NULLIF(@curHomeGames,0)
              WHEN ITEM LIKE '7%' THEN SUM(ORDQTY) * 7/NULLIF(@curHomeGames,0)
              WHEN ITEM LIKE '8%' THEN SUM(ORDQTY) * 8/NULLIF(@curHomeGames,0)
              WHEN ITEM LIKE '9FLEX%' THEN SUM(ORDQTY) /NULLIF(@curHomeGames,0)
              WHEN ITEM LIKE '9%' AND ITEM NOT LIKE '9FLEX%' THEN SUM(ORDQTY)* 9/NULLIF(@curHomeGames,0)
              WHEN ITEM LIKE '10%' THEN SUM(ORDQTY)* 10/NULLIF(@curHomeGames,0)
              WHEN ITEM LIKE '11%' THEN SUM(ORDQTY)* 11/NULLIF(@curHomeGames,0)
              END AS QTY
       ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
WHERE  ITEM LIKE '[1-9]%'  
          AND SEASON IN (@curSeason)
          AND ( PAIDTOTAL > 0 )
GROUP BY SEASON , ITEM   

UNION ALL 

SELECT 
        SEASON 
        ,'Mini Plans FSE'
       /*,CASE WHEN ITEM LIKE '2%' THEN SUM(ORDQTY) * 2/@prevHomeGames
              WHEN ITEM LIKE '3%' THEN SUM(ORDQTY) * 3/@prevHomeGames
              WHEN ITEM LIKE '4%' THEN SUM(ORDQTY) * 4/@prevHomeGames
              WHEN ITEM LIKE '5%' THEN SUM(ORDQTY) * 5/@prevHomeGames
              WHEN ITEM LIKE '6%' THEN SUM(ORDQTY) * 6/@prevHomeGames
              WHEN ITEM LIKE '7%' THEN SUM(ORDQTY) * 7/@prevHomeGames
              --WHEN ITEM LIKE '8FLEX%' THEN SUM(ORDQTY) /@prevHomeGames
              WHEN ITEM LIKE '8%' THEN SUM(ORDQTY)* 8/@prevHomeGames --AND ITEM NOT LIKE '8FLEX%' 
              WHEN ITEM LIKE '9%' THEN SUM(ORDQTY) * 9/@prevHomeGames
              WHEN ITEM LIKE '10%' THEN SUM(ORDQTY)* 10/@prevHomeGames
              WHEN ITEM LIKE '11%' THEN SUM(ORDQTY)* 11/@prevHomeGames
              END AS QTY*/
		,CASE WHEN ITEM LIKE '2%' THEN SUM(ORDQTY) * 2/NULLIF(@prevHomeGames,0)
              WHEN ITEM LIKE '3%' THEN SUM(ORDQTY) * 3/NULLIF(@prevHomeGames,0)
              WHEN ITEM LIKE '4%' THEN SUM(ORDQTY) * 4/NULLIF(@prevHomeGames,0)
              WHEN ITEM LIKE '5%' THEN SUM(ORDQTY) * 5/NULLIF(@prevHomeGames,0)
              WHEN ITEM LIKE '6%' THEN SUM(ORDQTY) * 6/NULLIF(@prevHomeGames,0)
              WHEN ITEM LIKE '7%' THEN SUM(ORDQTY) * 7/NULLIF(@prevHomeGames,0)
              WHEN ITEM LIKE '8%' THEN SUM(ORDQTY) * 8/NULLIF(@prevHomeGames,0)
              WHEN ITEM LIKE '9FLEX%' THEN SUM(ORDQTY)/NULLIF(@prevHomeGames,0)
              WHEN ITEM LIKE '9%' AND ITEM NOT LIKE '9FLEX%' THEN SUM(ORDQTY)* 9/NULLIF(@curHomeGames,0)
              WHEN ITEM LIKE '10%' THEN SUM(ORDQTY)* 10/NULLIF(@prevHomeGames,0)
              WHEN ITEM LIKE '11%' THEN SUM(ORDQTY)* 11/NULLIF(@prevHomeGames,0)
              END AS QTY
       ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
WHERE  ITEM LIKE '[1-9]%'  
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
    WHERE ITEM LIKE 'SB[0-9]%' 
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
    WHERE ITEM LIKE 'SB[0-9]%' 
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
    WHERE ITEM LIKE  'SB[0-9]%'
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
    WHERE ITEM LIKE 'SB[0-9]%'
       AND rb.I_PT = 'V'
       AND rb.SEASON = @curSeason
       AND rb.I_PRICE > 0
GROUP BY rb.Season, rb.I_PT

-----------------------------------------------------------------------------

UNION ALL

SELECT 
       rb.SEASON 
      ,'All Session Passes' 
,SUM(ORDQTY) AS Qty
,SUM(ORDTOTAL) AS Amt
FROM #ReportBase rb 
    WHERE ITEM IN ('KCA','KCD','LCA','LCD','DDA','DDD','LSA','LSD')
       AND SEASON IN (@prevSeason)
      AND rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.Season, rb.I_PT

UNION ALL

SELECT 
       rb.SEASON 
      ,'All Session Passes' 
,SUM(ORDQTY) AS Qty
,SUM(ORDTOTAL) AS Amt
FROM #ReportBase rb 
    WHERE (ITEM LIKE 'KC%' OR ITEM LIKE 'LC%' OR ITEM LIKE 'LS%')
       AND SEASON IN (@curSeason)
      AND rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.Season, rb.I_PT
--Abbey will look for item list to verify




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
              WHEN 'Mini Plans FSE' THEN 6 
                        WHEN 'All Session Passes' THEN 8 END



END














GO
