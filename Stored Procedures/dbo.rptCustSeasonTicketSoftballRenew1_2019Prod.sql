SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[rptCustSeasonTicketSoftballRenew1_2019Prod] 
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

IF OBJECT_ID('tempdb..#SeasonSummary')IS NOT NULL
	DROP TABLE #SeasonSummary

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


DECLARE @prevSeason VARCHAR(50)
DECLARE @curSeason VARCHAR(50)
DECLARE @Sport VARCHAR(50)
DECLARE @prevHomeGames AS NUMERIC
DECLARE @curHomeGames AS NUMERIC

SET @prevSeason = '2018'
SET @curSeason = '2019'
Set @Sport = 'Softball'
SET @prevHomeGames = 28
SET @curHomeGames = 28

--DECLARE @dateRange VARCHAR(30) = 'AllData'
--DECLARE @startDate AS DATE = DATEADD(MONTH,-12,GETDATE())
--DECLARE @endDate AS DATE = GETDATE()
----------------------------------------------------------------------------------


--BEGIN



CREATE TABLE   #budget 
(
         saleTypeName VARCHAR(100)
       , amount INT
)

INSERT INTO #budget
--Budget and Prior Year Revenue
SELECT 'Season',				0	UNION ALL
SELECT 'Mini Plans FSE',		0	UNION ALL
SELECT 'All Session Passes',	0	UNION ALL
SELECT 'Single Game Tickets',	0




---- Build Report --------------------------------------------------------------------------------------------------


Create table #ReportBase  
(
	  SeasonYear			INT
	, Sport					NVARCHAR(255)
	, DimSeasonId			INT
	, TicketingAccountId	NVARCHAR(50)
	, DimItemId				INT
	, PC3					NVARCHAR(1)
	, DimPriceCodeId		INT
	, DimPriceTypeId		INT
	, DimPlanId				INT
	, SectionName			NVARCHAR(50)
	, TicketTypeCode		NVARCHAR(25)
	, TicketTypeClass		VARCHAR(100)
	, IsComp				INT
	, QtySeat				INT 
	, QtySeatFSE			NUMERIC (18,6)
	, QtySeatRenewable		INT
	, RevenueTotal			NUMERIC (18,6) 
	, TransDateTime			DATETIME  
	, PaidAmount			NUMERIC (18,6)
)

INSERT INTO #ReportBase (SeasonYear, Sport, DimSeasonId, TicketingAccountId, DimItemId, PC3
	, DimPriceCodeId, DimPriceTypeId, DimPlanId, SectionName, TicketTypeCode, TicketTypeClass
	, IsComp, QtySeat, QtySeatFSE, QtySeatRenewable, RevenueTotal, TransDateTime, PaidAmount) 

SELECT SeasonYear, Sport, DimSeasonId, TicketingAccountId, DimItemId, PC3
	, DimPriceCodeId, DimPriceTypeId, DimPlanId, SectionName, TicketTypeCode, TicketTypeClass
	, IsComp, SUM(QtySeat), SUM(QtySeatFSE), SUM(QtySeatRenewable)
	, SUM(CASE WHEN ETL__SourceSystem = 'TM' THEN RevenueTotal
		ELSE RevenueTicket END) AS RevenueTotal
	, TransDateTime 
	, SUM(PaidAmount)
FROM  [ro].[vw_FactTicketSalesBase_All] fts 
WHERE  1=1
	AND EventCode NOT IN ('19SBSB10', '19SBSB15', '19SBSB22')
	AND fts.Sport = @Sport
	AND (fts.SeasonYear = @prevSeason 
		OR (@dateRange = 'AllData' AND fts.SeasonYear = @curseason)
		OR (@dateRange <> 'AllData' AND fts.SeasonYear = @curSeason AND fts.TransDateTime BETWEEN @startDate AND @endDate))
GROUP BY SeasonYear, Sport, DimSeasonId, TicketingAccountId, DimItemId, PC3
	, DimPriceCodeId, DimPriceTypeId, DimPlanId, SectionName, TicketTypeCode
	, TicketTypeClass, IsComp, TransDateTime 

-----------------------------------------------------------------------------------------
CREATE TABLE #SeasonSummary 
(
	  season		VARCHAR(100)
	, saleTypeName  VARCHAR(50)
	, qty			INT
	, amt			MONEY
)

INSERT INTO #SeasonSummary (season, saleTypeName, qty, amt)
-----------------------------------------------------------------------------
--SEASON 
--Previous  and Current SEASON  

SELECT SeasonYear, 'Season', SUM(QtySeatRenewable) QTY, SUM(RevenueTotal) AMT
FROM #ReportBase 
WHERE TicketTypeCode = 'FS' 
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
GROUP BY SeasonYear

------------------------------------------------------------------------------------------------------
--MINI Plans 
UNION ALL 

SELECT SeasonYear, 'Mini Plans FSE', SUM(QtySeatFSE)  QTY, SUM(RevenueTotal) AMT
FROM #ReportBase 
WHERE TicketTypeCode = 'MINI'
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
GROUP BY SeasonYear     

UNION ALL 

------------------------- SINGLE GAME (GROUP/PUBLIC LOGIC)

SELECT rb.SeasonYear, 'Single Game Tickets', SUM(rb.QtySeat) AS Qty, SUM(rb.RevenueTotal) AS Amt
FROM #ReportBase rb 
WHERE rb.TicketTypeClass = 'Single'
	AND rb.TicketTypeCode NOT IN ('VISIT')
	AND rb.RevenueTotal > 0
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
	AND rb.IsComp = 0
GROUP BY rb.SeasonYear

UNION ALL

------------------------------------------------ SINGLE GAME (VISITOR LOGIC) --------------------------------------------------------
SELECT rb.SeasonYear, 'Single Game Tickets', SUM(rb.QtySeat) AS Qty, SUM(rb.RevenueTotal) AS Amt
FROM #ReportBase rb 
WHERE rb.TicketTypeCode = 'VISIT'
	AND rb.IsComp = 0
GROUP BY rb.SeasonYear
-----------------------------------------------------------------------------
UNION ALL

SELECT rb.SeasonYear, 'All Session Passes', SUM(QtySeatRenewable) AS Qty, SUM(rb.RevenueTotal) AS Amt
FROM #ReportBase rb 
WHERE rb.TicketTypeCode = 'ASP'
	AND rb.IsComp = 0
	AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
GROUP BY Seasonyear


-------------------------------------------------------------------------------------


SELECT ISNULL(PrevYR.saleTypeName,'') AS QtyCat
	, ISNULL(PrevYR.prevQty,0)  AS [PYQty]
	, ISNULL(CurYR.CurQty,0) AS [CYQty]
	, ISNULL(CurYR.CurQty,0) - ISNULL(PrevYR.prevQty,0)  AS [DiffVsPY]
	, ISNULL(budget.saleTypeName,'') AS AmtCat
	, ISNULL(CurYR.CurAmt,0) AS [CYAmt]
	, ISNULL(CONVERT(DECIMAL(12,2),budget.amount),0) AS Budget
	, ISNULL(CurYR.CurAmt,0) - ISNULL(CONVERT(DECIMAL(12,2),budget.amount),0)  AS Variance
	, CASE ISNULL(CONVERT(DECIMAL(12,2),budget.amount),0) WHEN 0 THEN 0 ELSE ISNULL(CurYR.CurAmt,0) / ISNULL(CONVERT(DECIMAL(12,2),budget.amount),0) END AS PctToBudget
	, ISNULL(PrevYR.prevAmt,0)  AS [PYAmt]
	, CASE ISNULL(PrevYR.prevAmt,0) WHEN 0 THEN 0 ELSE ISNULL(CurYR.CurAmt,0) / ISNULL(PrevYR.prevAmt,0) END AS PctToPY   
FROM (
		SELECT saleTypeName, SUM(qty) AS prevQty, SUM(amt) AS prevAmt
		FROM #SeasonSummary a
		WHERE CAST(RIGHT(season,2) AS INT) = RIGHT(@prevseason,2)
		GROUP BY saleTypeName
	) PrevYR
LEFT OUTER JOIN (
		SELECT saleTypeName, SUM(qty) AS curQty, SUM(amt) AS curAmt
		FROM #SeasonSummary a
		WHERE CAST(RIGHT(season,2) AS INT) = RIGHT(@curseason,2)
		GROUP BY saleTypeName
	) CurYR ON PrevYR.saleTypeName = CurYR.saleTypeName
LEFT OUTER JOIN #budget budget
	ON PrevYR.saleTypeName = budget.saleTypeName
ORDER BY CASE PrevYR.saleTypeName
    WHEN 'Single Game Tickets' THEN 5
    WHEN 'Season' THEN 7
    WHEN 'Mini Plans FSE' THEN 6 
    WHEN 'All Session Passes' THEN 8 END



END














GO
