SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[rptCustSeasonTicketSoftballRenew3_2019Prod] 
(
  @startDate DATE
, @endDate DATE
, @dateRange VARCHAR(20)
)
AS 

IF object_id('tempdb..#budget')IS NOT null
	DROP TABLE #budget
IF object_id('tempdb..#eventHeader')IS NOT null
	DROP TABLE #eventHeader
IF object_id('tempdb..#homegames')IS NOT null
	DROP TABLE #homegames
IF object_id('tempdb..#ReportBase')IS NOT null
	DROP TABLE #ReportBase
IF object_id('tempdb..#singleSummary')IS NOT null
	DROP TABLE #singleSummary

BEGIN

set transaction isolation level read uncommitted

declare @curSeason varchar(50)
declare @Sport varchar(50)

Set @curSeason = '2019'
set @Sport = 'Softball'

--DECLARE @dateRange VARCHAR(30) = 'AllData'
--DECLARE @startDate AS DATE = DATEADD(MONTH,-1,GETDATE())
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

SELECT SeasonYear, Sport, TicketingAccountId, EventCode, TicketTypeCode, TicketTypeClass
	, PC1, PC3, QtySeat, RevenueTotal, TransDateTime, PaidAmount, IsComp
FROM  [ro].[vw_FactTicketSalesBase] fts 
WHERE  fts.Sport = @Sport
	AND TicketTypeClass = 'Single'
	AND ((@dateRange = 'AllData' 
	AND fts.SeasonYear = @curseason)
		OR (@dateRange <> 'AllData' AND fts.SeasonYear = @curSeason AND fts.TransDateTime BETWEEN @startDate AND @endDate))

------------------------------------------------------------------------------------------------------------------

create table #homegames
(eventcode varchar(50))

insert into #homegames (eventcode)
select '19SBSB01'  union all 
select '19SBSB02'  union all 
select '19SBSB03'  union all 
select '19SBSB04'  union all 
select '19SBSB05'  union all 
select '19SBSB06'  union all 
select '19SBSB07'  union all
select '19SBSB08'  union all 
select '19SBSB09'  union all 
select '19SBSB11'  union all 
select '19SBSB12'  union all 
select '19SBSB13'  union all 
select '19SBSB14'  union all
select '19SBSB16'  union all
select '19SBSB17'  union all
select '19SBSB18'  union all
select '19SBSB19'  union all
select '19SBSB20'  union all
select '19SBSB21'  union all
select '19SBSB23'  union all
select '19SBSB24'  union all
select '19SBSB25'  union all
select '19SBSB26'  union all
select '19SBSB27'  union all
select '19SBSB28'  union all
select '19SBSB29'  union all
select '19SBSB30'  union all
select '19SBSB31'  


create table #budget 
(
	  [event]	VARCHAR (10) 
	, amount	FLOAT
	, quantity	INT
)

INSERT INTO #budget ([event], amount, quantity)

SELECT	'19SBSB01'	,6000      ,540  	UNION ALL
SELECT	'19SBSB02'	,9000      ,820  	UNION ALL
SELECT	'19SBSB03'	,10000     ,910  	UNION ALL
SELECT	'19SBSB04'	,5000      ,455  	UNION ALL
SELECT	'19SBSB05'	,3000      ,270  	UNION ALL
SELECT	'19SBSB06'	,4000      ,365  	UNION ALL
SELECT	'19SBSB07'	,3000      ,270  	UNION ALL
SELECT	'19SBSB08'	,5000      ,455  	UNION ALL
SELECT	'19SBSB09'	,4000      ,365  	UNION ALL
SELECT	'19SBSB11'	,4000      ,370  	UNION ALL
SELECT	'19SBSB12'	,4000      ,370  	UNION ALL
SELECT	'19SBSB13'	,6000      ,550  	UNION ALL
SELECT	'19SBSB14'	,6000      ,550  	UNION ALL
SELECT	'19SBSB16'	,6000      ,550  	UNION ALL
SELECT	'19SBSB17'	,6000      ,550  	UNION ALL
SELECT	'19SBSB18'	,5000      ,460  	UNION ALL
SELECT	'19SBSB19'	,5000      ,460  	UNION ALL
SELECT	'19SBSB20'	,6000      ,550  	UNION ALL
SELECT	'19SBSB21'	,6000      ,550  	UNION ALL
SELECT	'19SBSB23'	,10000     ,770  	UNION ALL
SELECT	'19SBSB24'	,11000     ,850   	UNION ALL
SELECT	'19SBSB25'	,9000      ,700  	UNION ALL
SELECT	'19SBSB26'	,10000     ,770  	UNION ALL
SELECT	'19SBSB27'	,11000     ,850  	UNION ALL
SELECT	'19SBSB28'	,9000      ,700  	UNION ALL
SELECT	'19SBSB29'	,6000      ,550  	UNION ALL
SELECT	'19SBSB30'	,6000      ,550  	UNION ALL
SELECT	'19SBSB31'	,5000      ,550  	

CREATE TABLE #eventHeader
(
	  eventCode	VARCHAR(50)  
	, eventName	VARCHAR(200)
	, eventDate	DATE
)

INSERT INTO #eventHeader (eventCode, eventName, eventDate)
SELECT DISTINCT fts.EventCode, EventName, EventDate 
FROM  [ro].[vw_FactTicketSalesBase] fts 
INNER JOIN #homegames homegames 
	ON fts.EventCode = homegames.EventCode
WHERE fts.SeasonYear = @curSeason
	AND fts.Sport = @Sport

----------------------------------------------------------------------------------------------------------

SELECT ISNULL(eventHeader.eventCode,'')  eventCode 
	, ISNULL(eventHeader.eventName,'') eventName 
	, ISNULL(eventHeader.eventDate,'') eventDate
	, ISNULL(AvailSeatCount,0) AvailSeatCount 
	, ISNULL(vistingticketSet.visitingTicketQty,0) visitingTicketQty 
	, ISNULL(vistingticketSet.visitingTicketAmt,0) visitingTicketAmt
	, ISNULL(groupSet.groupTicketQty,0) groupTicketQty 
	, ISNULL(groupSet.groupTicketAmt,0) groupTicketAmt   
	, ISNULL(publicSet.publicTicketQty,0) publicTicketQty 
	, ISNULL(publicSet.publicTicketAmt,0) publicTicketAmt 
	, ISNULL(budget.quantity,0) AS budgetedQuantity                                                                                                                                                                                                                                                                                                                                       
	, ISNULL(budget.amount,0) AS budgetedAmount                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
	, ISNULL(vistingticketSet.visitingTicketQty,0)  + ISNULL(groupSet.groupTicketQty,0) + ISNULL(publicSet.publicTicketQty,0) AS TotalTickets                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
	, ISNULL(vistingticketSet.visitingTicketAmt,0)  + ISNULL(groupSet.groupTicketAmt,0) + ISNULL(publicSet.publicTicketAmt,0) AS TotalRevenue      
	, CASE WHEN budget.amount = 0 THEN 0 ELSE (ISNULL(vistingticketSet.visitingTicketAmt,0) +  ISNULL(groupSet.groupTicketAmt,0) + ISNULL(publicSet.publicTicketAmt,0))/ budget.amount
		END AS PercentToGoal     
	, (ISNULL(vistingticketSet.visitingTicketAmt,0) +  ISNULL(groupSet.groupTicketAmt,0) + ISNULL(publicSet.publicTicketAmt,0)) - budget.amount  AS VarianceToGoal
INTO #singleSummary
FROM #eventHeader eventHeader
LEFT JOIN (
	--VISITING
		SELECT rb.EventCode, SUM(QtySeat) AS visitingTicketQty, SUM(RevenueTotal) AS visitingTicketAmt
		FROM #ReportBase rb  
		INNER JOIN #eventHeader eventHeaderEvent  
			ON rb.EventCode  = eventHeaderEvent.EventCode  
		WHERE TicketTypeCode = 'VISIT'
			AND IsComp = 0
		GROUP BY rb.EventCode
	) vistingticketSet ON eventheader.eventCode = vistingticketSet.EventCode   

-------------------------------------------------------------------------------------------

LEFT JOIN (
	--GROUP
		SELECT rb.EventCode, SUM(QtySeat) AS groupTicketQty, SUM(RevenueTotal) AS groupTicketAmt
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
		SELECT rb.EventCode, SUM(QtySeat) AS publicTicketQty, SUM(RevenueTotal) AS publicTicketAmt
		FROM #ReportBase rb  
		INNER JOIN #eventHeader eventHeaderEvent
			ON rb.EventCode  = eventHeaderEvent.EventCode   
		WHERE rb.TicketTypeCode IN ('PUBLIC', 'STUDENT')
			AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
		GROUP BY rb.EventCode
	) publicSet ON eventheader.EventCode = PublicSet.EventCode

-----------------------Budgets

LEFT JOIN #budget budget
	ON budget.[event] =  eventHeader.eventCode

----------------Available Seat Count

LEFT JOIN (
		SELECT Sport, SeasonYear, EventCode, SUM(AvailSeatCount) AS AvailSeatCount
		FROM (
				SELECT ds.Config_Org AS Sport, ds.SeasonYear, de.EventCode, SUM(QtySeat) AS AvailSeatCount
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


SELECT
      x.*
      ,ISNULL(YTD.VarianceYTD,0) AS VarianceYTD
      ,ISNULL(YTD.BudgetYTD,0) AS BudgetYTD
      ,ISNULL(YTD.ActualYTD,0) AS ActualYTD
      ,VarToProj = CASE ISNULL(ytd.budgetYTD,0)  
						WHEN 0 THEN 0 
						ELSE ISNULL(YTD.varianceYTD,0) 
							 / ISNULL(ytd.budgetYTD,0) 
				   END
FROM #singleSummary x
	 JOIN (SELECT a.eventCode
		   ,SUM(ISNULL(b.VarianceToGoal,0))  AS varianceYTD
		   ,SUM(ISNULL(b.budgetedAmount,0)) AS budgetYTD
		   ,SUM(ISNULL(b.TotalRevenue,0)) AS actualYTD 
		   FROM #singleSummary a
		   JOIN #singleSummary  b
		   ON a.eventdate >= b.eventdate
		   GROUP BY a.eventCode) AS YTD
	 ON x.eventcode = YTD.eventcode
ORDER BY eventDate


END 


/****** Object:  StoredProcedure [dbo].[rptCustSeasonTicketSoftballRenew4_2018Prod]    Script Date: 5/30/2018 6:59:24 PM ******/
SET ANSI_NULLS ON
GO
