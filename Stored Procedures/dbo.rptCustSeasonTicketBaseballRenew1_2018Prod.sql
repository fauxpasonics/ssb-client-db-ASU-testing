SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





--select DATEADD(MONTH,-12,GETDATE()), getdate()
--[dbo].[rptCustSeasonTicketBaseballRenew1_2018Prod] '2017-01-10', '2018-01-10', 'AllData'


CREATE PROCEDURE [dbo].[rptCustSeasonTicketBaseballRenew1_2018Prod] 
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

declare @prevSeason varchar(50)
declare @curSeason varchar(50)
declare @Sport VARCHAR(50)

Set @prevSeason = '2017'
Set @curSeason = '2018'
Set @Sport = 'Baseball'
DECLARE @prevHomeGames AS NUMERIC = 33
DECLARE @curHomeGames AS NUMERIC = 34

--DECLARE @dateRange VARCHAR(30) = 'AllData'
--DECLARE @startDate AS DATE = DATEADD(MONTH,-12,GETDATE())
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
SELECT 'Mini Plans FSE', 25875 UNION ALL
SELECT 'Season', 219125 UNION ALL
SELECT 'Single Game Tickets', 330000 UNION ALL
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


Create table #ReportBase  
(
  SeasonYear int
 ,Sport nvarchar(255)
 ,DimSeasonId int
 ,TicketingAccountId nvarchar(50)
 ,DimItemId INT
 ,ItemCode nvarchar(50)
 ,PC3 NVARCHAR(1)
 ,DimPriceCodeId int
 ,DimPriceTypeId int
 ,DimPlanId int
 ,SectionName nvarchar(50)
 ,TicketTypeCode nvarchar(25)
 ,TicketTypeClass varchar(100)
 ,IsComp int
 ,QtySeat int 
 ,QtySeatFSE numeric (18,6)
 ,QtySeatRenewable int
 ,RevenueTotal numeric (18,6) 
 ,TransDateTime datetime  
 ,PaidAmount numeric (18,6)
)

INSERT INTO #ReportBase 
(
  SeasonYear 
 ,Sport 
 ,DimSeasonId
 ,TicketingAccountId 
 ,DimItemId 
 ,ItemCode
 ,PC3
 ,DimPriceCodeId 
 ,DimPriceTypeId
 ,DimPlanId
 ,SectionName
 ,TicketTypeCode
 ,TicketTypeClass
 ,IsComp
 ,QtySeat  
 ,QtySeatFSE
 ,QtySeatRenewable
 ,RevenueTotal 
 ,TransDateTime 
 ,PaidAmount 
) 

SELECT 
 SeasonYear 
 ,Sport 
 ,DimSeasonId
 ,TicketingAccountId 
 ,DimItemId 
 ,ItemCode
 ,PC3
 ,DimPriceCodeId
 ,DimPriceTypeId
 ,DimPlanId
 ,SectionName
 ,TicketTypeCode
 ,TicketTypeClass
 ,IsComp
 ,SUM(QtySeat)
 ,SUM(QtySeatFSE)
 ,SUM(QtySeatRenewable)
 ,SUM(CASE WHEN ETL__SourceSystem = 'TM' THEN RevenueTotal
		ELSE RevenueTicket END) AS RevenueTotal
 ,TransDateTime 
 ,SUM(PaidAmount)
FROM  [ro].[vw_FactTicketSalesBase_All] fts 
WHERE  1=1
AND fts.Sport = @Sport
AND (fts.SeasonYear = @prevSeason 
OR (@dateRange = 'AllData' 
	AND fts.SeasonYear = @curseason)
OR (@dateRange <> 'AllData' 
			AND fts.SeasonYear = @curSeason 
			AND fts.TransDateTime
				BETWEEN @startDate AND @endDate))
GROUP BY 
 SeasonYear 
 ,Sport 
 ,DimSeasonId
 ,TicketingAccountId 
 ,DimItemId 
 ,ItemCode
 ,PC3
 ,DimPriceCodeId
 ,DimPriceTypeId
 ,DimPlanId
 ,SectionName
 ,TicketTypeCode
 ,TicketTypeClass
 ,IsComp
 ,TransDateTime 


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
 
SELECT 
	SeasonYear
	,'Season'
	,SUM(QtySeatRenewable) QTY
	,SUM(RevenueTotal) AMT
FROM #ReportBase 
WHERE TicketTypeCode = 'FS' 
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
GROUP BY SeasonYear


UNION ALL 
-----------------------------------------------MINI Plans -------------------------------------------
SELECT 	 SeasonYear
	 ,'Mini Plans FSE'
	 ,SUM(QTY)  QTY
	 ,SUM(AMT) AMT
FROM (
SELECT 
	 SeasonYear
	 ,'Mini Plans FSE' TicketType
	 ,SUM(QtySeatFSE)  QTY
	 ,SUM(RevenueTotal) AMT
FROM #ReportBase 
WHERE TicketTypeCode = 'MINI'
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
	AND Seasonyear = '2018'
	AND ItemCode <> '18BBFLEX' -- update each year
GROUP BY SeasonYear   

UNION ALL

SELECT  ---separated Flex Plans to account for FSE Calc 
	 SeasonYear
	 ,'Mini Plans FSE' TicketType
	 ,SUM(QtySeat)/@curHomeGames  QTY
	 ,SUM(RevenueTotal) AMT
FROM #ReportBase 
WHERE ItemCode = '18BBFLEX' -- update each year
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets


GROUP BY SeasonYear   
) cy
GROUP BY SeasonYear

UNION ALL  

SELECT ---separated Paciolan mini plans because FTS is not handling flex plans correctly; remove for 2019 season
	 SeasonYear
	 ,'Mini Plans FSE'
	 ,SUM(QtySeatFSE) + '27' QTY
	 ,SUM(RevenueTotal) + '9530'  AMT
FROM #ReportBase 
WHERE TicketTypeCode = 'MINI'
    AND (PaidAmount > 0) 
	AND Seasonyear = '2017'
GROUP BY SeasonYear 

UNION ALL 

------------------------------------------------ SINGLE GAME (GROUP/PUBLIC LOGIC) --------------------------------------------------------
SELECT 
	 rb.SeasonYear 
	,'Single Game Tickets'
	,SUM(rb.QtySeat) AS Qty
	,SUM(rb.RevenueTotal) AS Amt
FROM #ReportBase rb 
WHERE rb.TicketTypeClass = 'Single'
	AND rb.TicketTypeCode NOT IN ('VISIT','SGS')
	AND rb.RevenueTotal > 0
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
	AND rb.IsComp = 0
GROUP BY rb.SeasonYear

UNION ALL

------------------------------------------------ SINGLE GAME (VISITOR LOGIC) --------------------------------------------------------
SELECT 
	 rb.SeasonYear 
	,'Single Game Tickets'
	,SUM(rb.QtySeat) AS Qty
	,SUM(rb.RevenueTotal) AS Amt
FROM #ReportBase rb 
WHERE rb.TicketTypeCode = 'VISIT'
	AND rb.IsComp = 0
GROUP BY rb.SeasonYear


UNION ALL

------------------------------------------------ SINGLE GAME (SUITE LOGIC) --------------------------------------------------------

SELECT 
	 rb.SeasonYear 
	,'Single Game Tickets'
	,SUM(rb.QtySeat) AS Qty
	,SUM(rb.RevenueTotal) AS Amt
FROM #ReportBase rb 
WHERE rb.TicketTypeCode = 'SGS'
	AND rb.RevenueTotal > 0
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
	AND rb.IsComp = 0
GROUP BY rb.SeasonYear

 
UNION ALL

--------------------------------------------- SCOUT CARD ----------------------------------------
 
SELECT 
	 rb.SeasonYear 
	,'Scout Card'
	,SUM(rb.QtySeat) AS Qty
	,SUM(rb.RevenueTotal) AS Amt
FROM #ReportBase rb 
WHERE rb.TicketTypeCode = 'SC'
GROUP BY rb.SeasonYear


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
LEFT OUTER JOIN (SELECT saleTypeName
				, SUM(qty) AS curQty
				, SUM(amt) AS curAmt 
				FROM @seasonsummary a WHERE CAST(RIGHT(season,2) AS INT) 
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
