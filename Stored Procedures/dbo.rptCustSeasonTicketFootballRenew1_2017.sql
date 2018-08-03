SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE PROCEDURE [dbo].[rptCustSeasonTicketFootballRenew1_2017]
    (
      @startDate DATE
    , @endDate DATE
    , @dateRange VARCHAR(20)
    )
AS 

/*
DROP TABLE #budget
DROP TABLE #ReportBase	
DROP TABLE #SeasonSummary	
*/

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @curSeason varchar(50)
declare @prevSeason varchar(50)
declare @Sport varchar(50)


Set @prevSeason = '2016'
Set @curSeason = '2017'
Set @Sport = 'Football'

--DECLARE	@dateRange VARCHAR(20)= 'AllData'
--DECLARE @startDate DATE = DATEADD(month,-1,GETDATE())
--DECLARE @endDate DATE = GETDATE()

----------------------------------------------------------------------------------

--BEGIN


Create table   #budget 
(
    saleTypeName varchar(100)
    ,amount int
)

insert into #budget
--Budget and Prior Year Revenue

Select 'Mini Plans FSE', '125000'  UNION ALL
Select 'Season', '5181475' UNION ALL
Select 'Season Suite', '0'   UNION ALL
Select 'Single Game Tickets', '4424425' UNION ALL
Select 'Single Game Suite', '160000' UNION ALL 
Select 'MBSC', '0'    



---- Build Report --------------------------------------------------------------------------------------------------



Create table #ReportBase  
(
  SeasonYear int
 ,Sport nvarchar(255)
 ,DimSeasonId int
 ,TicketingAccountId nvarchar(50)
 ,ItemCode nvarchar(50)
 , PC3 nvarchar(1)
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
 ,ItemCode
 , PC3
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
 ,ItemCode
 , PC3
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
FROM  [ro].[vw_FactTicketSalesBase_All] fts 
WHERE  DimSeasonId <> 134 --exclude Paciolan 2017 Football data
AND fts.Sport = @Sport
AND (fts.SeasonYear = @prevSeason 
OR (@dateRange = 'AllData' 
	AND fts.SeasonYear = @curseason)
OR (@dateRange <> 'AllData' 
			AND fts.SeasonYear = @curSeason 
			AND fts.TransDateTime
				BETWEEN @startDate AND @endDate))


-----------------------------------------------------------------------------------------

Create table #SeasonSummary 
(
    SeasonYear int
    ,saleTypeName  varchar(50)
    ,qty  int
    ,amt money
)


insert into #SeasonSummary
(
 SeasonYear
 ,saleTypeName
,qty
,amt
)


-----------------------------------------------------------------------------

--SEASON 

--Previous  and Current SEASON  

SELECT 
      SeasonYear
     ,'Season' 
     ,SUM(QtySeatRenewable) QTY
     ,SUM(RevenueTotal) AMT
 FROM #ReportBase 
where (TicketTypeCode = 'FS' or TicketTypeCode = 'FSC')
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
GROUP BY SeasonYear


-----------------------------------------------------------------------------------------

UNION ALL 
--SEASON 

--Previous  and Current SEASON  

SELECT 
      SeasonYear
     ,'MBSC' AS SaleTypeName
     ,SUM(QtySeatFSE) QTY
     ,SUM(RevenueTotal) AMT
FROM #ReportBase 
WHERE TicketTypeCode = 'MBSC'
     AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
GROUP BY SeasonYear 


------------------------------------------------------------------------------------------------------

--MINI PLANS

UNION ALL 

SELECT 
     SeasonYear
     ,'Mini Plans FSE'
     ,SUM(QtySeatFSE) QTY
     ,SUM(RevenueTotal) AMT
FROM #ReportBase 
where  TicketTypeCode = 'MINI'
       AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
GROUP BY SeasonYear    


----------------------------------------------------------------------------------------------------

--SEASON SUITE

UNION ALL 
--

SELECT 
     SeasonYear
     ,'Season Suite'
     ,COUNT(Distinct SectionName) QTY
     ,SUM(RevenueTotal) AMT
FROM #ReportBase 
where  TicketTypeCode = 'FSS'
        AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
	   AND SeasonYear = @curSeason
GROUP BY SeasonYear 

UNION ALL 

SELECT SeasonYear
, 'Season Suite' SaleTypeName
, SUM(QTY) QTY
, SUM(AMT) AMT
FROM 
( SELECT 
     SeasonYear
     ,'Season Suite' SaleTypeName
     ,CASE WHEN ItemCode = '17FBFSST' THEN 0 ELSE COUNT(ItemCode)/6 END AS QTY
     ,SUM(RevenueTotal)  AMT
FROM #ReportBase 
where  TicketTypeCode = 'FSS'
       AND PaidAmount > 0 
	   AND SeasonYear = @PrevSeason
GROUP BY SeasonYear, ItemCode

UNION ALL 

SELECT 
     '2016' SeasonYear
     ,'Season Suite' SaleTypeName
     ,'0' QTY
     ,'174800'  AMT
 
) a
GROUP BY Seasonyear, SaleTypeName


-----------------------------------------------------------------------------


UNION ALL 

SELECT 
SeasonYear
, 'Single Game Suite' SaleTypeName
, SUM(QTY) QTY
,SUM(AMT) AMT
FROM (
SELECT 
     SeasonYear
    ,'Single Game Suite' SaleTypeName
     ,COUNT(TicketingAccountId) QTY
     ,SUM(RevenueTotal) AMT

FROM #ReportBase rb 

WHERE TicketTypeCode = 'SGS' 
    AND RevenueTotal > 0
	AND PaidAmount > 0 
	AND SeasonYear = @PrevSeason
GROUP BY SeasonYear

UNION ALL

SELECT 
     '2016' SeasonYear
     ,'Single Game Suite' SaleTypeName
     ,'0' QTY
     ,'31600'  AMT
 
) a
GROUP BY Seasonyear, SaleTypeName

UNION ALL 


SELECT SeasonYear
, 'Single Game Suite' 
, SUM(QTY) AS QTY
, SUM(AMT) AS AMT 
FROM (SELECT 
		 SeasonYear
		,'Single Game Suite' AS SaleTypeName
		 ,CASE WHEN ItemCode like '%SRO%' THEN 0 ELSE COUNT(DISTINCT SectionName) END AS QTY
		 ,SUM(RevenueTotal) AMT

		FROM #ReportBase rb 

		WHERE TicketTypeCode = 'SGS'
			AND RevenueTotal > 0
			 AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
			AND SeasonYear = @curSeason

		GROUP BY SeasonYear, Itemcode

	)x
GROUP BY SeasonYear

--------------------------------------------------------------------------------------------------------

UNION ALL 


--Single Game Total

SELECT
     SeasonYear
    ,'Single Game Tickets'
     ,SUM(QtySeat) QTY
     ,SUM(RevenueTotal) AMT


FROM #ReportBase rb 

WHERE TicketTypeClass = 'Single'
	AND TicketTypeCode NOT IN ('VISIT', 'SGS')
    AND RevenueTotal > 0
	 AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
	AND IsComp = 0

GROUP BY SeasonYear

UNION ALL

SELECT 
     Seasonyear
    ,'Single Game Tickets'
     ,SUM(QtySeat) QTY
     ,SUM(RevenueTotal) AMT

FROM #ReportBase rb

WHERE TicketTypeCode = 'VISIT'
	AND IsComp = 0

GROUP BY SeasonYear



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


(

SELECT saleTypeName, SUM(qty) AS prevQty, SUM(amt) 
AS prevAmt FROM #seasonsummary a WHERE CAST(RIGHT(SeasonYear,2) AS INT)
 = RIGHT(@prevseason,2) GROUP BY saleTypeName
 ) PrevYR
LEFT OUTER JOIN (SELECT saleTypeName, SUM(qty) AS curQty, SUM(amt)
 AS curAmt FROM #seasonsummary a WHERE CAST(RIGHT(SeasonYear,2) AS INT) 
 = RIGHT(@curseason,2) GROUP BY saleTypeName
 ) CurYR
ON PrevYR.saleTypeName = CurYR.saleTypeName
LEFT OUTER JOIN #budget budget
ON PrevYR.saleTypeName = budget.saleTypeName
ORDER BY 
    CASE PrevYR.saleTypeName
        WHEN 'Single Game Suite' THEN 3
        WHEN 'Single Game Tickets' THEN 5
        --when 'Student Guest Pass' then 2

        WHEN 'Season' THEN 7
        WHEN 'Season Suite' THEN 4
        --when 'Student Season' then 1

        WHEN 'MBSC' THEN 8 
        WHEN 'Mini Plans FSE' THEN 6 END



END









































GO
