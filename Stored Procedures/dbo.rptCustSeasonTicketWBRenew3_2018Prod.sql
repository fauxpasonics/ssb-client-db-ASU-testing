SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE PROCEDURE [dbo].[rptCustSeasonTicketWBRenew3_2018Prod] 
    (
      @startDate DATE
    , @endDate DATE
    , @dateRange VARCHAR(20)
    )
AS

/*
DROP TABLE #budget
DROP TABLE #eventHeader
DROP TABLE #homegames
DROP TABLE #ReportBase
DROP TABLE #singleSummary
*/

BEGIN

set transaction isolation level read uncommitted


declare @curSeason varchar(50)
declare @Sport varchar(50)

Set @curSeason = '2018'
set @Sport = 'WBB'

--DECLARE	@dateRange VARCHAR(20)= 'AllData'
--DECLARE @startDate DATE = DATEADD(day,-12,GETDATE())
--DECLARE @endDate DATE = GETDATE()

---- Build Report --------------------------------------------------------------------------------------------------
--Report Base 

Create table #ReportBase  
(
  SeasonYear NVARCHAR(25)
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
AND ((@dateRange = 'AllData' 
AND fts.SeasonYear = @curseason)
OR (@dateRange <> 'AllData' 
AND fts.SeasonYear = @curSeason 
AND fts.TransDateTime
BETWEEN @startDate AND @endDate))
------------------------------------------------------------------------------------------------------------------

create table #homegames
(eventcode varchar(50)   )

insert into #homegames
(eventcode)
select '18WBWB01'  union all 
select '18WBWB02'  union all 
select '18WBWB03'  union all 
select '18WBWB04'  union all 
select '18WBWB05'  union all 
select '18WBWB06'  union all 
select '18WBWB07'  union all
select '18WBWB08'  union all 
select '18WBWB09'  union all 
select '18WBWB10'  union all 
select '18WBWB11'  union all 
select '18WBWB12'  union all 
select '18WBWB13'  union all 
select '18WBWB14'  union all
select '18WBWB15'  UNION ALL
SELECT '18WBWB16' 

create table #budget 
(
eventcode varchar (10) 
,amount float
,quantity int
)

insert into #budget
(eventcode , amount, quantity)

SELECT '18WBWB01'	,'0'	,'0'  UNION ALL 
SELECT '18WBWB02'	,'0'	,'0'  UNION ALL 
SELECT '18WBWB03'	,'0'	,'0'  UNION ALL 
SELECT '18WBWB04'	,'0'	,'0'  UNION ALL 
SELECT '18WBWB05'	,'0'	,'0'  UNION ALL 
SELECT '18WBWB06'	,'0'	,'0'  UNION ALL 
SELECT '18WBWB07'	,'0'	,'0'  UNION ALL
SELECT '18WBWB08'	,'0'	,'0'  UNION ALL 
SELECT '18WBWB09'	,'0'	,'0'  UNION ALL 
SELECT '18WBWB10'	,'0'	,'0'  UNION ALL 
SELECT '18WBWB11'	,'0'	,'0'  UNION ALL 
SELECT '18WBWB12'	,'0'	,'0'  UNION ALL 
SELECT '18WBWB13'	,'0'	,'0'  UNION ALL 
SELECT '18WBWB14'	,'0'	,'0'  UNION ALL
SELECT '18WBWB15'	,'0'	,'0'  UNION ALL
SELECT '18WBWB16'	,'0'	,'0'



	IF OBJECT_ID ('tempdb..#eventHeader')  is not null
		drop table #eventHeader

	create table #eventHeader (
		 EventCode varchar(50)  
		,EventName  varchar(200)
		,EventDate date
	)
	insert into #eventHeader (
 		 eventCode 
		,eventName
		,eventDate
	) 
	select DISTINCT
		 fts.EventCode AS eventCode
		,fts.EventName
		,cast(fts.EventDate as date) EventDate
	FROM ro.vw_FactTicketSalesBase fts
	inner join #homegames homegames 
		on fts.EventCode = homegames.EventCode 
	where fts.SeasonYear =  @curSeason
		and fts.Sport = @Sport
	ORDER BY fts.eventCode


----------------------------------------------------------------------------------------------------------


--Single Game Breakout:


SELECT 
 ISNULL(eventHeader.eventCode,'')                                                                                                eventCode 
,ISNULL(eventHeader.eventName,'') 																								 eventName 
,ISNULL(eventHeader.eventDate,'') 																								 eventDate
,ISNULL(vistingticketSet.visitingTicketQty,0)																					 visitingTicketQty 
,ISNULL(vistingticketSet.visitingTicketAmt,0)																					 visitingTicketAmt
,ISNULL(groupSet.groupTicketQty,0)																								 groupTicketQty 
,ISNULL(groupSet.groupTicketAmt,0)																								 groupTicketAmt   
,ISNULL(publicSet.publicTicketQty,0)																							 publicTicketQty 
,ISNULL(publicSet.publicTicketAmt,0)																							 publicTicketAmt 
,ISNULL(budget.quantity,0) AS budgetedQuantity																					 
,ISNULL(budget.amount,0) AS budgetedAmount																						 
																																 
,ISNULL(vistingticketSet.visitingTicketQty,0)  + ISNULL(groupSet.groupTicketQty,0)												 
      + ISNULL(publicSet.publicTicketQty,0) AS TotalTickets																		 
      																															   
,ISNULL(vistingticketSet.visitingTicketAmt,0)  + ISNULL(groupSet.groupTicketAmt,0)
      + ISNULL(publicSet.publicTicketAmt,0) AS TotalRevenue 
       
,CASE WHEN budget.amount = 0 THEN 0 ELSE (ISNULL(vistingticketSet.visitingTicketAmt,0) +  ISNULL(groupSet.groupTicketAmt,0)
      + ISNULL(publicSet.publicTicketAmt,0))/ budget.amount END  AS PercentToGoal 
       
,   (ISNULL(vistingticketSet.visitingTicketAmt,0) +  ISNULL(groupSet.groupTicketAmt,0)
      + ISNULL(publicSet.publicTicketAmt,0)) - budget.amount  AS VarianceToGoal
INTO #singleSummary
FROM
#eventHeader eventHeader
LEFT JOIN 
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
eventheader.EventCode   = GroupSet.EventCode

----------------------------------------------------------------------------------------------------------



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

LEFT JOIN #budget budget
ON budget.EventCode  =  eventHeader.EventCode 

---------------------------------------------------------------------------------------
--Result Set 


SELECT 
    x.*
    ,ISNULL(YTD.VarianceYTD,0) AS VarianceYTD
    ,ISNULL(YTD.BudgetYTD,0) AS BudgetYTD
    ,ISNULL(YTD.ActualYTD,0) AS ActualYTD
    ,VarToProj = CASE ISNULL(ytd.budgetYTD,0)  WHEN 0 THEN 0 ELSE ISNULL(YTD.varianceYTD,0) / ISNULL(ytd.budgetYTD,0) END
FROM #singleSummary x
JOIN
(SELECT a.EventCode
,SUM(ISNULL(b.VarianceToGoal,0))  AS varianceYTD
,SUM(ISNULL(b.budgetedAmount,0)) AS budgetYTD
,SUM(ISNULL(b.TotalRevenue,0)) AS actualYTD 
FROM #singleSummary a
JOIN #singleSummary b
ON a.eventdate >= b.eventdate
GROUP BY a.EventCode) AS YTD
ON x.EventCode = YTD.EventCode







END 












GO
