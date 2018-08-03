SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[rptCustSeasonTicketBaseballRenew3_2019Prod] 
(
  @startDate DATE
, @endDate DATE
, @dateRange VARCHAR(20)
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

declare @curSeason varchar(50)
declare @Sport varchar(50)

Set @curSeason = '2019'
set @Sport = 'Baseball'

--DECLARE @dateRange VARCHAR(30) = 'AllData'
--DECLARE @startDate AS DATE = DATEADD(MONTH,-12,GETDATE())
--DECLARE @endDate AS DATE = GETDATE()


---- Build Report --------------------------------------------------------------------------------------------------
--Report Base 


Create table #ReportBase  
(
  SeasonYear			INT
, Sport					NVARCHAR(255)
, TicketingAccountId	INT
, EventCode				NVARCHAR(50)
, TicketTypeCode		NVARCHAR(25)
, TicketTypeClass		VARCHAR(100)
, PC1					NVARCHAR(1)
, PC3					NVARCHAR(1)
, QtySeat				INT 
, RevenueTotal			NUMERIC (18,6) 
, TransDateTime			DATETIME  
, PaidAmount			NUMERIC (18,6)
, IsComp				INT
)

INSERT INTO #ReportBase (SeasonYear, Sport, TicketingAccountId, EventCode, TicketTypeCode
	, TicketTypeClass, PC1, PC3, QtySeat, RevenueTotal, TransDateTime, PaidAmount, IsComp) 

SELECT SeasonYear, Sport, TicketingAccountId, EventCode, TicketTypeCode
	, TicketTypeClass, PC1, PC3, QtySeat, RevenueTotal, TransDateTime, PaidAmount, IsComp
FROM  [ro].[vw_FactTicketSalesBase] fts 
WHERE  fts.Sport = @Sport
	AND TicketTypeClass = 'Single'
	AND ((@dateRange = 'AllData' AND fts.SeasonYear = @curseason)
		OR (@dateRange <> 'AllData' AND fts.SeasonYear = @curSeason AND fts.TransDateTime BETWEEN @startDate AND @endDate))

------------------------------------------------------------------------------------------------------------------

create table #homegames
(eventcode varchar(50)   )

insert into #homegames (eventcode)
select '19BBB01'  union all 
select '19BBB02'  union all 
select '19BBB03'  union all 
select '19BBB04'  union all 
select '19BBB05'  union all 
select '19BBB06'  union all 
select '19BBB07'  union all
select '19BBB08'  union all 
select '19BBB09'  union all 
select '19BBB10'  union all 
select '19BBB11'  union all 
select '19BBB12'  union all 
select '19BBB13'  union all 
select '19BBB14'  union all
select '19BBB15'  union all
select '19BBB16'  union all
select '19BBB17'  union all
select '19BBB18'  union all
select '19BBB19'  union all
select '19BBB20'  union all
select '19BBB21'  union all
select '19BBB22'  union all
select '19BBB23'  union all
select '19BBB24'  union all
select '19BBB25'  union all
select '19BBB26'  union all
select '19BBB27'  union all
select '19BBB28'  union all
select '19BBB29'  union all
select '19BBB30'  union all
select '19BBB31'  union all
select '19BBB32'  union all
select '19BBB33'  UNION ALL
SELECT '19BBB34'

CREATE TABLE #budget 
(
  eventcode	VARCHAR (10) 
, amount	FLOAT
, quantity	INT
, suite16	int
, suite32	INT
)

INSERT INTO #budget (eventcode , quantity, amount, suite16, suite32)

SELECT '19BBB01'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB02'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB03'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB04'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB05'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB06'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB07'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB08'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB09'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB10'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB11'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB12'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB13'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB14'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB15'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB16'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB17'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB18'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB19'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB20'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB21'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB22'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB23'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB24'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB25'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB26'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB27'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB28'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB29'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB30'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB31'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB32'	,0	,0	,0	,0	UNION ALL
SELECT '19BBB33'	,0	,0  ,0	,0	UNION ALL
SELECT '19BBB34'	,0	,0  ,0	,0	



CREATE TABLE #eventHeader
(
	  eventCode varchar(50)  
	, eventName  varchar(200)
	, eventDate date
)

INSERT INTO #eventHeader (eventCode, eventName, eventDate)

SELECT DISTINCT fts.EventCode AS EventCode, EventName AS EventName, EventDate 
FROM  [ro].[vw_FactTicketSalesBase] fts 
INNER JOIN #homegames homegames 
	on fts.EventCode = homegames.EventCode
WHERE fts.SeasonYear = @curSeason
	AND fts.Sport = @Sport


----------------------------------------------------------------------------------------------------------

SELECT 
	  ISNULL(eventHeader.eventCode,'')                       eventCode 
	, ISNULL(eventHeader.eventName,'') 			            eventName 
	, ISNULL(eventHeader.eventDate,'') 					    eventDate
	, ISNULL(AvailSeatCount,0) 							    AvailSeatCount 
	, ISNULL(vistingticketSet.visitingTicketQty,0)		    visitingTicketQty 
	, ISNULL(vistingticketSet.visitingTicketAmt,0)		    visitingTicketAmt
	, ISNULL(groupSet.groupTicketQty,0)					    groupTicketQty 
	, ISNULL(groupSet.groupTicketAmt,0)					    groupTicketAmt   
	, ISNULL(publicSet.publicTicketQty,0)					publicTicketQty 
	, ISNULL(publicSet.publicTicketAmt,0)				    publicTicketAmt 
	, ISNULL(suiteSet.suiteTicketQty,0)					    suiteTicketQty 
	, ISNULL(suiteSet.suiteTicketAmt,0)				        suiteTicketAmt 
	, ISNULL(budget.quantity,0) AS budgetedQuantity																					 
	, ISNULL(budget.amount,0) AS budgetedAmount																						 																																 
	, ISNULL(vistingticketSet.visitingTicketQty,0) + ISNULL(groupSet.groupTicketQty,0) + ISNULL(publicSet.publicTicketQty,0) + ISNULL(suiteSet.suiteTicketQty,0) AS TotalTickets																		    																															   
	, ISNULL(vistingticketSet.visitingTicketAmt,0)  + ISNULL(groupSet.groupTicketAmt,0) + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0) AS TotalRevenue 
	, CASE WHEN budget.amount = 0 THEN 0
		ELSE (ISNULL(vistingticketSet.visitingTicketAmt,0) + ISNULL(groupSet.groupTicketAmt,0) + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0))/ budget.amount
		END  AS PercentToGoal       
	, (ISNULL(vistingticketSet.visitingTicketAmt,0) +  ISNULL(groupSet.groupTicketAmt,0) + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0)) - budget.amount  AS VarianceToGoal
INTO #singleSummary
FROM #eventHeader eventHeader
LEFT JOIN (
	-- Visiting
		SELECT rb.EventCode 
			, SUM(QtySeat) AS visitingTicketQty
			, SUM(RevenueTotal) AS visitingTicketAmt
		FROM #ReportBase rb  
		INNER JOIN #eventHeader eventHeaderEvent  
			ON rb.EventCode  = eventHeaderEvent.EventCode  
		WHERE TicketTypeCode = 'VISIT'
			AND IsComp = 0
		GROUP BY rb.EventCode
	) vistingticketSet ON eventheader.eventCode = vistingticketSet.EventCode  
-------------------------------------------------------------------------------------------
LEFT JOIN (
	-- Group
		SELECT rb.EventCode
			, SUM(QtySeat)      AS groupTicketQty
			, SUM(RevenueTotal) AS groupTicketAmt
		FROM #ReportBase rb  
		INNER JOIN #eventHeader eventHeaderEvent
			ON rb.EventCode  = eventHeaderEvent.EventCode   
		WHERE rb.TicketTypeCode = 'GROUP' 
			AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
		GROUP BY rb.EventCode 
	) GroupSet ON eventheader.EventCode = GroupSet.EventCode
----------------------------------------------------------------------------------------------------------
LEFT JOIN (
	--PUBLIC
		SELECT rb.EventCode
			, SUM(QtySeat)      AS publicTicketQty
			, SUM(RevenueTotal) AS publicTicketAmt
		FROM #ReportBase rb  
		INNER JOIN #eventHeader eventHeaderEvent
			ON rb.EventCode  = eventHeaderEvent.EventCode   
		WHERE rb.TicketTypeCode IN ('PUBLIC', 'STUDENT')
			AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
		GROUP BY rb.EventCode
	) publicSet ON eventheader.EventCode = PublicSet.EventCode
-------------------------------------------------------------------------------------------
LEFT JOIN (
	--Single Game Suite
		SELECT rb.EventCode
			, SUM(QtySeat) AS suiteTicketQty
			, SUM(RevenueTotal) AS SuiteTicketAmt
		FROM #ReportBase rb  
		INNER JOIN #eventHeader eventHeaderEvent  
			ON rb.EventCode  = eventHeaderEvent.eventCode
		WHERE rb.TicketTypeCode IN ('SGS')
			AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
		GROUP BY rb.EventCode
	) suiteSet ON eventheader.eventCode  = suiteSet.EventCode
LEFT JOIN #budget budget
	ON budget.eventCode =  eventHeader.eventCode
LEFT JOIN (
		SELECT Sport, SeasonYear, EventCode, SUM(AvailSeatCount) AS AvailSeatCount
		FROM (
				SELECT ds.Config_Org AS Sport
					, ds.SeasonYear
					, de.EventCode
					, SUM(QtySeat) AS AvailSeatCount
				FROM [ro].[vw_FactAvailSeats] fa
				INNER JOIN [ro].[vw_DimSeason] ds
					ON fa.DimSeasonid = ds.DimSeasonId
				INNER JOIN [ro].[vw_DimEvent] de
					ON fa.DimEventId = de.DimEventId
				INNER JOIN [ro].[vw_DimSeatStatus] dss
					ON fa.DimSeatStatusId = dss.DimSeatStatusId
				WHERE ds.Seasonyear = @curSeason
					AND ds.Config_Org = @Sport
					AND dss.SeatStatusCode NOT IN ('KIL', 'KS', 'T')
				GROUP BY ds.Config_Org, ds.SeasonYear, de.EventCode
			) a
		GROUP BY Sport, SeasonYear, EventCode
	) seatsavailable ON eventHeader.eventCode = seatsavailable.EventCode

---------------------------------------------------------------------------------------
--Result Set 


SELECT x.*
	, ISNULL(YTD.VarianceYTD,0) AS VarianceYTD
	, ISNULL(YTD.BudgetYTD,0) AS BudgetYTD
	, ISNULL(YTD.ActualYTD,0) AS ActualYTD
	, CASE ISNULL(ytd.budgetYTD,0)  
	  		WHEN 0 THEN 0 
	  		ELSE ISNULL(YTD.varianceYTD,0) / ISNULL(ytd.budgetYTD,0) 
	   END AS VarToProj
FROM #singleSummary x
JOIN (
		SELECT a.eventCode
			, SUM(ISNULL(b.VarianceToGoal,0))  AS varianceYTD
			, SUM(ISNULL(b.budgetedAmount,0)) AS budgetYTD
			, SUM(ISNULL(b.TotalRevenue,0)) AS actualYTD 
		FROM #singleSummary a
		JOIN #singleSummary  b
			ON a.eventdate >= b.eventdate
		GROUP BY a.eventCode
	) AS YTD ON x.eventcode = YTD.eventcode
ORDER BY eventDate

END 











GO
