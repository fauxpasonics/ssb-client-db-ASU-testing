SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








--exec rptCustSeasonTicketWBRenew1_2015Prod

CREATE PROCEDURE [dbo].[rptCustSeasonTicketWBRenew1_2017Prod] 
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
declare @Sport VARCHAR(50)

Set @prevSeason = '2016'
Set @curSeason = '2017'
Set @Sport = 'WBB'

--DECLARE @daterange varchar(20)= 'alldata'
--DECLARE @startdate date = dateadd(month,-10,getdate())
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
Select 'Mini Plans FSE', '3100'  UNION ALL
Select 'Season', '76000' UNION ALL
Select 'Single Game Tickets', '81000'   


---- Build Report --------------------------------------------------------------------------------------------------

Create table #ReportBase  
(
  SeasonYear int
 ,Sport nvarchar(255)
 ,DimSeasonId int
 ,TicketingAccountId nvarchar(50)
 ,DimItemId INT
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
 ,SUM(RevenueTotal )
 ,TransDateTime 
 ,SUM(PaidAmount)
FROM  [ro].[vw_FactTicketSalesBase_All] fts 
WHERE  1=1
AND fts.Sport = @Sport
AND (fts.SeasonYear = @prevSeason 
AND PaidAmount > 0
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
--Previous and Current SEASON  
SELECT 
	SeasonYear
	,'Season'
	,SUM(QtySeatRenewable) QTY
	,SUM(RevenueTotal) AMT
FROM #ReportBase 
WHERE TicketTypeCode = 'FS' 
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
GROUP BY SeasonYear


------------------------------------------------------------------------------------------------------
--MINI Plans 
UNION ALL 

SELECT 
	 SeasonYear
	 ,'Mini Plans FSE'
	 ,SUM(QtySeatFSE) QTY
	 ,SUM(RevenueTotal) AMT
FROM #ReportBase 
WHERE TicketTypeCode = 'MINI'
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
GROUP BY SeasonYear  
  

--------------------------------------------------------------------------------------------------------
UNION ALL 

SELECT 
	 rb.SeasonYear 
	,'Single Game Tickets'
	,SUM(rb.QtySeat) AS Qty
	,SUM(rb.RevenueTotal) AS Amt
FROM #ReportBase rb 
WHERE rb.TicketTypeClass = 'Single'
	AND rb.TicketTypeCode NOT IN ('VISIT')
	AND rb.RevenueTotal > 0
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
	AND rb.IsComp = 0
GROUP BY rb.SeasonYear


UNION ALL 

SELECT 
	 rb.SeasonYear 
	,'Single Game Tickets'
	,SUM(rb.QtySeat) AS Qty
	,SUM(rb.RevenueTotal) AS Amt
FROM #ReportBase rb 
WHERE rb.TicketTypeCode = 'VISIT'
	AND rb.IsComp = 0
GROUP BY rb.SeasonYear



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
		SELECT saleTypeName, SUM(qty) AS prevQty, SUM(amt) AS prevAmt 
		FROM @seasonsummary a 
		WHERE CAST(RIGHT(season,2) AS INT) = RIGHT(@prevseason,2) 
		GROUP BY saleTypeName
	) PrevYR
LEFT OUTER JOIN (
		SELECT saleTypeName, SUM(qty) AS curQty, SUM(amt) AS curAmt 
		FROM @seasonsummary a 
		WHERE CAST(RIGHT(season,2) AS INT) = RIGHT(@curseason,2) 
		GROUP BY saleTypeName
	) CurYR	ON  PrevYR.saleTypeName = CurYR.saleTypeName
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
