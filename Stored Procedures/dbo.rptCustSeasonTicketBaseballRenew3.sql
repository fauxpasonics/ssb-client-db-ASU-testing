SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[rptCustSeasonTicketBaseballRenew3] 
(
  @startDate DATE
, @endDate DATE
, @dateRange VARCHAR(20)
, @curSeason varchar(50)
)
AS 

BEGIN

IF OBJECT_ID('tempdb..#budget')IS NOT NULL	
DROP TABLE #budget
IF OBJECT_ID('tempdb..#ReportBase')IS NOT NULL	
DROP TABLE #ReportBase
IF OBJECT_ID('tempdb..#homegames')IS NOT NULL	
DROP TABLE #homegames
IF OBJECT_ID('tempdb..#eventHeader')IS NOT NULL	
DROP TABLE #eventHeader
IF OBJECT_ID('tempdb..#singleSummary')IS NOT NULL	
DROP TABLE #singleSummary

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--declare @curSeason varchar(50)
declare @Sport varchar(50)

--Set @curSeason = '2018'
set @Sport = 'Baseball'

--DECLARE @dateRange VARCHAR(30) = 'AllData'
--DECLARE @startDate AS DATE = DATEADD(MONTH,-12,GETDATE())
--DECLARE @endDate AS DATE = GETDATE()


---- Build Report --------------------------------------------------------------------------------------------------
--Report Base 


Create table #ReportBase  
(
  SeasonYear int
 ,Sport nvarchar(255)
 ,TicketingAccountId int
 ,EventCode nvarchar(50)
 ,TicketTypeCode nvarchar(25)
 ,TicketTypeClass varchar(100)
 ,PC1 nvarchar(1)
 ,PC3 NVARCHAR(1)
 ,QtySeat int 
 ,RevenueTotal numeric (18,6) 
 ,TransDateTime datetime  
 ,PaidAmount numeric (18,6)
 ,IsComp int
)

INSERT INTO #ReportBase 
(
  SeasonYear 
 ,Sport 
 ,TicketingAccountId 
 ,EventCode
 ,TicketTypeCode
 ,TicketTypeClass
 ,PC1
 ,PC3
 ,QtySeat  
 ,RevenueTotal  
 ,TransDateTime 
 ,PaidAmount 
 ,IsComp
) 

SELECT 
 SeasonYear 
 ,Sport 
 ,TicketingAccountId 
 ,EventCode
 ,TicketTypeCode
 ,TicketTypeClass
 ,PC1
 ,PC3
 ,QtySeat  
 ,RevenueTotal  
 ,TransDateTime 
 ,PaidAmount
 ,IsComp
FROM  [ro].[vw_FactTicketSalesBase] fts 
WHERE  fts.Sport = @Sport
AND TicketTypeClass = 'Single'
AND ((@dateRange = 'AllData' 
AND fts.SeasonYear = LEFT(@curseason,4))
OR (@dateRange <> 'AllData' 
AND fts.SeasonYear = LEFT(@curseason,4) 
AND fts.TransDateTime
BETWEEN @startDate AND @endDate))

------------------------------------------------------------------------------------------------------------------

create table #homegames
(eventcode varchar(50)   )

insert into #homegames
(eventcode)
SELECT concat(right(@curseason,2),'BBB01') UNION ALL
SELECT concat(right(@curseason,2),'BBB02') UNION ALL
SELECT concat(right(@curseason,2),'BBB03') UNION ALL
SELECT concat(right(@curseason,2),'BBB04') UNION ALL
SELECT concat(right(@curseason,2),'BBB05') UNION ALL
SELECT concat(right(@curseason,2),'BBB06') UNION ALL
SELECT concat(right(@curseason,2),'BBB07') UNION ALL
SELECT concat(right(@curseason,2),'BBB08') UNION ALL
SELECT concat(right(@curseason,2),'BBB09') UNION ALL
SELECT concat(right(@curseason,2),'BBB10') UNION ALL
SELECT concat(right(@curseason,2),'BBB11') UNION ALL
SELECT concat(right(@curseason,2),'BBB12') UNION ALL
SELECT concat(right(@curseason,2),'BBB13') UNION ALL
SELECT concat(right(@curseason,2),'BBB14') UNION ALL
SELECT concat(right(@curseason,2),'BBB15') UNION ALL
SELECT concat(right(@curseason,2),'BBB16') UNION ALL
SELECT concat(right(@curseason,2),'BBB17') UNION ALL
SELECT concat(right(@curseason,2),'BBB18') UNION ALL
SELECT concat(right(@curseason,2),'BBB19') UNION ALL
SELECT concat(right(@curseason,2),'BBB20') UNION ALL
SELECT concat(right(@curseason,2),'BBB21') UNION ALL
SELECT concat(right(@curseason,2),'BBB22') UNION ALL
SELECT concat(right(@curseason,2),'BBB23') UNION ALL
SELECT concat(right(@curseason,2),'BBB24') UNION ALL
SELECT concat(right(@curseason,2),'BBB25') UNION ALL
SELECT concat(right(@curseason,2),'BBB26') UNION ALL
SELECT concat(right(@curseason,2),'BBB27') UNION ALL
SELECT concat(right(@curseason,2),'BBB28') UNION ALL
SELECT concat(right(@curseason,2),'BBB29') UNION ALL
SELECT concat(right(@curseason,2),'BBB30') UNION ALL
SELECT concat(right(@curseason,2),'BBB31') UNION ALL
SELECT concat(right(@curseason,2),'BBB32') UNION ALL
SELECT concat(right(@curseason,2),'BBB33') UNION ALL
SELECT concat(right(@curseason,2),'BBB34')

CREATE TABLE #budget 
(
eventcode varchar (10) 
,amount float
,quantity INT
,suite16 int
,suite32 int
)

INSERT INTO #budget
(		eventcode , quantity, amount, suite16, suite32)

SELECT concat(right(@curseason,2),'BBB01')	,850	,9000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB02')	,850	,9000   ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB03')	,500	,5000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB04')	,700	,7000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB05')	,700	,7000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB06')	,550	,5500  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB07')	,1100	,11000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB08')	,1100	,11000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB09')	,900	,9000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB10')	,700	,7000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB11')	,700	,7000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB12')	,500	,5000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB13')	,1250	,15000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB14')	,1000	,12000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB15')	,1000	,12000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB16')	,950	,9500  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB17')	,1500	,15000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB18')	,1100	,11000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB19')	,1100	,11000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB20')	,1000	,12000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB21')	,1000	,12000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB22')	,950	,9500  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB23')	,1000	,12000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB24')	,1000	,12000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB25')	,750	,9000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB26')	,700	,7000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB27')	,1000	,12000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB28')	,1000	,12000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB29')	,950	,9500  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB30')	,600	,6000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB31')	,600	,6000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB32')	,900	,9000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB33')	,1000	,12000  ,0	,0	UNION ALL
SELECT concat(right(@curseason,2),'BBB34')	,1000	,12000  ,0	,0	



CREATE TABLE #eventHeader
(
eventCode varchar(50)  
,eventName  varchar(200)
,eventDate date
)

INSERT INTO #eventHeader
(
eventCode 
,eventName
,eventDate
)

select DISTINCT fts.EventCode AS EventCode
, EventName AS EventName
, EventDate 
FROM  [ro].[vw_FactTicketSalesBase] fts 
        inner join #homegames homegames 
                  on fts.EventCode   
                   = homegames.EventCode
where fts.SeasonYear = LEFT(@curseason,4)
AND fts.Sport = @Sport


----------------------------------------------------------------------------------------------------------

SELECT 
 ISNULL(eventHeader.eventCode,'')                       eventCode 
,ISNULL(eventHeader.eventName,'') 			            eventName 
,ISNULL(eventHeader.eventDate,'') 					    eventDate
,ISNULL(AvailSeatCount,0) 							    AvailSeatCount 
,ISNULL(vistingticketSet.visitingTicketQty,0)		    visitingTicketQty 
,ISNULL(vistingticketSet.visitingTicketAmt,0)		    visitingTicketAmt
,ISNULL(groupSet.groupTicketQty,0)					    groupTicketQty 
,ISNULL(groupSet.groupTicketAmt,0)					    groupTicketAmt   
,ISNULL(publicSet.publicTicketQty,0)					publicTicketQty 
,ISNULL(publicSet.publicTicketAmt,0)				    publicTicketAmt 
,ISNULL(suiteSet.suiteTicketQty,0)					    suiteTicketQty 
,ISNULL(suiteSet.suiteTicketAmt,0)				        suiteTicketAmt 
,ISNULL(budget.quantity,0) AS budgetedQuantity																					 
,ISNULL(budget.amount,0) AS budgetedAmount																						 
																																 
,ISNULL(vistingticketSet.visitingTicketQty,0)  + ISNULL(groupSet.groupTicketQty,0)												 
      + ISNULL(publicSet.publicTicketQty,0) + ISNULL(suiteSet.suiteTicketQty,0) AS TotalTickets																		 
      																															   
,ISNULL(vistingticketSet.visitingTicketAmt,0)  + ISNULL(groupSet.groupTicketAmt,0)
      + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0) AS TotalRevenue 
       
,CASE WHEN budget.amount = 0 THEN 0 ELSE (ISNULL(vistingticketSet.visitingTicketAmt,0) 
	  +  ISNULL(groupSet.groupTicketAmt,0) + ISNULL(publicSet.publicTicketAmt,0) 
	  + ISNULL(suiteSet.suiteTicketAmt,0))/ budget.amount END  AS PercentToGoal 
       
,   (ISNULL(vistingticketSet.visitingTicketAmt,0) +  ISNULL(groupSet.groupTicketAmt,0)
      + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0)) - budget.amount  AS VarianceToGoal
INTO #singleSummary


FROM
#eventHeader eventHeader
LEFT JOIN 

--VISITING
(

SELECT 
rb.EventCode 
,SUM(QtySeat) AS visitingTicketQty
,SUM(RevenueTotal) AS visitingTicketAmt

FROM #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
          ON rb.EventCode  = eventHeaderEvent.EventCode  
WHERE TicketTypeCode = 'VISIT'
AND IsComp = 0
GROUP BY rb.EventCode
) vistingticketSet ON 
eventheader.eventCode   
 = vistingticketSet.EventCode  

-------------------------------------------------------------------------------------------

--GROUP

LEFT JOIN  
(
SELECT 
 rb.EventCode
,SUM(QtySeat)      AS groupTicketQty
,SUM(RevenueTotal) AS groupTicketAmt
FROM #ReportBase rb  
INNER JOIN #eventHeader eventHeaderEvent ON rb.EventCode  = eventHeaderEvent.EventCode   
WHERE rb.TicketTypeCode = 'GROUP' 
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
GROUP BY rb.EventCode 
) GroupSet ON 
eventheader.EventCode   
= GroupSet.EventCode



----------------------------------------------------------------------------------------------------------
--PUBLIC

LEFT JOIN  
(
SELECT 
 rb.EventCode
,SUM(QtySeat)      AS publicTicketQty
,SUM(RevenueTotal) AS publicTicketAmt
FROM #ReportBase rb  
INNER JOIN #eventHeader eventHeaderEvent ON rb.EventCode  = eventHeaderEvent.EventCode   
WHERE rb.TicketTypeCode IN ('PUBLIC', 'STUDENT')
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
GROUP BY rb.EventCode
) publicSet 
ON eventheader.EventCode = PublicSet.EventCode


-------------------------------------------------------------------------------------------
--Single Game Suite

LEFT JOIN  
(
SELECT 
rb.EventCode
,SUM(QtySeat) AS suiteTicketQty
,SUM(RevenueTotal) AS SuiteTicketAmt
FROM #ReportBase rb  
INNER JOIN #eventHeader eventHeaderEvent  
       ON rb.EventCode  = eventHeaderEvent.eventCode
WHERE rb.TicketTypeCode IN ('SGS')
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
GROUP BY rb.EventCode
) suiteSet ON 
eventheader.eventCode  = suiteSet.EventCode



LEFT JOIN #budget budget
ON budget.eventCode =  eventHeader.eventCode


LEFT JOIN
(
SELECT Sport, SeasonYear, EventCode, SUM(AvailSeatCount) AS AvailSeatCount
FROM
 
(

SELECT ds.Config_Org AS Sport
, ds.SeasonYear
, de.EventCode
,SUM(QtySeat) AS AvailSeatCount
FROM [ro].[vw_FactAvailSeats] fa
INNER JOIN [ro].[vw_DimSeason] ds ON fa.DimSeasonid = ds.DimSeasonId
INNER JOIN [ro].[vw_DimEvent] de ON fa.DimEventId = de.DimEventId
INNER JOIN [ro].[vw_DimSeatStatus] dss ON fa.DimSeatStatusId = dss.DimSeatStatusId
WHERE ds.Seasonyear = LEFT(@curseason,4)
AND ds.Config_Org = @Sport
AND dss.SeatStatusCode NOT IN ('KIL', 'KS', 'T')

GROUP BY ds.Config_Org, ds.SeasonYear, de.EventCode
 
) a
GROUP BY Sport, SeasonYear, EventCode
) seatsavailable
ON eventHeader.eventCode = seatsavailable.EventCode

---------------------------------------------------------------------------------------
--Result Set 


SELECT x.*
	  ,ISNULL(YTD.VarianceYTD,0) AS VarianceYTD
	  ,ISNULL(YTD.BudgetYTD,0) AS BudgetYTD
	  ,ISNULL(YTD.ActualYTD,0) AS ActualYTD
	  ,CASE ISNULL(ytd.budgetYTD,0)  
	  		WHEN 0 
	  		THEN 0 
	  		ELSE ISNULL(YTD.varianceYTD,0) / ISNULL(ytd.budgetYTD,0) 
	   END AS VarToProj
FROM #singleSummary x
	 JOIN (SELECT a.eventCode
				 ,SUM(ISNULL(b.VarianceToGoal,0))  AS varianceYTD
				 ,SUM(ISNULL(b.budgetedAmount,0)) AS budgetYTD
				 ,SUM(ISNULL(b.TotalRevenue,0)) AS actualYTD 
		   FROM #singleSummary a
				 JOIN #singleSummary  b
					  ON a.eventdate >= b.eventdate
		   GROUP BY a.eventCode
		   ) AS YTD
		   ON x.eventcode = YTD.eventcode
ORDER BY eventDate

END 
GO
