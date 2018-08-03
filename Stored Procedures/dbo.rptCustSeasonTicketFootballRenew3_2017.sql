SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [dbo].[rptCustSeasonTicketFootballRenew3_2017] 
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
*/

 
BEGIN

set transaction isolation level read uncommitted

declare @curSeason varchar(50)
declare @Sport varchar(50)

Set @curSeason = '2017'
set @Sport = 'Football'

--DECLARE	@dateRange VARCHAR(20)= 'AllData'
--DECLARE @startDate DATE = DATEADD(month,-1,GETDATE())
--DECLARE @endDate DATE = GETDATE()


---- Build Report --------------------------------------------------------------------------------------------------

--Report Base 

Create table #ReportBase  
(
  SeasonHeaderYear int
 ,Sport nvarchar(255)
 ,TicketingAccountId int
 ,EventCode nvarchar(50)
 ,TicketTypeCode nvarchar(25)
 ,TicketTypeClass varchar(100)
 ,PC1 nvarchar(1)
 ,PC3 nvarchar(1)
 ,QtySeat int 
 ,RevenueTotal numeric (18,6) 
 ,TransDateTime datetime  
 ,PaidAmount numeric (18,6)
 ,IsComp int
)

INSERT INTO #ReportBase 
(
  SeasonHeaderYear 
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
 SeasonHeaderYear 
 ,Sport 
 ,TicketingAccountId 
 ,EventHeaderCode AS EventCode
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
AND fts.SeasonYear = @curseason)
OR (@dateRange <> 'AllData' 
AND fts.SeasonYear = @curSeason 
AND fts.TransDateTime
BETWEEN @startDate AND @endDate))


------------------------------------------------------------------------------------------------------------------


create table #homegames
(EventCode varchar(50)   )

insert into #homegames
(EventCode)
select '17FBF01'  union all 
select '17FBF02'  union all 
select '17FBF03'  union all 
select '17FBF04'  union all 
select '17FBF05'  union all 
select '17FBF06'  union all
select '17FBF07'


create table #budget 
(
EventCode varchar (10) 
,amount float
,quantity int
)

insert into #budget
(EventCode , amount, quantity)

Select '17FBF01',52125,1650  UNION ALL
Select '17FBF02',102150,3500 UNION ALL
Select '17FBF03',755000,13500  UNION ALL
Select '17FBF04',850000,14500  UNION ALL
Select '17FBF05',1140150,15803  UNION ALL
Select '17FBF06',400000,8000  UNION ALL
Select '17FBF07',1125000,15950

create table #eventHeader
(
EventCode varchar(50)  
,EventName  varchar(200)
,EventDate date
)

insert into #eventHeader
(
EventCode 
,EventName
,EventDate
)

select DISTINCT fts.EventHeaderCode AS EventCode
, EventHeaderName AS EventName
, EventDate 
FROM  [ro].[vw_FactTicketSalesBase] fts 
        inner join #homegames homegames 
                  on fts.EventCode   
                   = homegames.EventCode
where fts.SeasonYear = @curSeason
AND fts.Sport = @Sport



----------------------------------------------------------------------------------------------------------


--Single Game Breakout:

declare @singleSummary as SingleSummary


INSERT INTO  @singleSummary 
(
EventCode 
,EventName 
,EventDate 
,VisitingTicketQty 
,VisitingTicketAmt
,StudentTicketQty 
,StudentTicketAmt 
,GroupTicketQty 
,GroupTicketAmt 
,SuiteTicketQty 
,SuiteTicketAmt  
,PublicTicketQty 
,PublicTicketAmt 
,BudgetedQuantity 
,BudgetedAmount
,TotalTickets  
,TotalRevenue 
,PercentToGoal 
,VarianceToGoal 
) 


SELECT 
 ISNULL(eventHeader.EventCode,'')
,ISNULL(eventHeader.eventName,'')
,ISNULL(eventHeader.eventDate,'')
,ISNULL(vistingticketSet.visitingTicketQty,0)
,ISNULL(vistingticketSet.visitingTicketAmt,0)
,ISNULL(studentSet.studentTicketQty,0)
,ISNULL(studentSet.studentTicketAmt,0)
,ISNULL(groupSet.groupTicketQty,0)
,ISNULL(groupSet.groupTicketAmt,0)
,ISNULL(suiteSet.suiteTicketQty, 0)--,suiteSet.suiteTicketQty
,ISNULL(suiteSet.suiteTicketAmt, 0)--,suiteSet.suiteTicketAmt
,ISNULL(publicSet.publicTicketQty,0)
,ISNULL(publicSet.publicTicketAmt,0)
,ISNULL(budget.quantity,0) AS budgetedQuantity
,ISNULL(budget.amount,0) AS budgetedAmount

,ISNULL(vistingticketSet.visitingTicketQty,0) + 
         ISNULL(studentSet.studentTicketQty,0) + ISNULL(groupSet.groupTicketQty,0)
      + ISNULL(publicSet.publicTicketQty,0) + ISNULL(suiteSet.suiteTicketQty,0) AS TotalTickets
      
,ISNULL(vistingticketSet.visitingTicketAmt,0) + 
         ISNULL(studentSet.studentTicketAmt,0) + ISNULL(groupSet.groupTicketAmt,0)
      + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0) AS TotalRevenue 
       
,CASE WHEN budget.amount = 0 THEN 0 ELSE (ISNULL(vistingticketSet.visitingTicketAmt,0) + 
         ISNULL(studentSet.studentTicketAmt,0) + ISNULL(groupSet.groupTicketAmt,0)
      + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0))/ budget.amount END  AS PercentToGoal 
       
,   (ISNULL(vistingticketSet.visitingTicketAmt,0) + 
         ISNULL(studentSet.studentTicketAmt,0) + ISNULL(groupSet.groupTicketAmt,0)
      + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0)) - budget.amount  AS VarianceToGoal

FROM
#eventHeader eventHeader
LEFT JOIN 
(

SELECT 
rb.EventCode 
,SUM(QtySeat) AS visitingTicketQty
,SUM(RevenueTotal) AS visitingTicketAmt
--,SUM((QtySeat * (CASE  WHEN rb.EventCode IN ('17FBF01', '17FBF02') AND PC1 = 'M' THEN 30
--					  WHEN rb.EventCode IN ('17FBF01', '17FBF02') AND PC1 = 'P' THEN 20
--                      WHEN rb.EventCode = '17FBF03' THEN 50
--                      WHEN rb.EventCode = '17FBF04' THEN 50  
--                      WHEN rb.EventCode = '17FBF05' THEN 50
--                      WHEN rb.EventCode = '17FBF06' THEN 50 
--                       END))) AS visitingTicketAmt


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
       '17FBF01'  AS EventCode
       ,0 AS studentTicketQty
      ,0 AS studentTicketAmt
) studentSet ON 
eventheader.eventCode   
 = studentSet.EventCode   
------------------------------------------------------------------------------------------


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


------------------------------------------------------------------------------------------


LEFT JOIN  
(
SELECT 
 rb.EventCode
,SUM(QtySeat)      AS suiteTicketQty
,SUM(RevenueTotal) AS suiteTicketAmt
FROM #ReportBase rb  
INNER JOIN #eventHeader eventHeaderEvent ON rb.EventCode = eventHeaderEvent.EventCode   
WHERE rb.TicketTypeCode = 'CLUB' -- premium price levels
AND rb.RevenueTotal > 0
 AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
GROUP BY rb.EventCode 
) SuiteSet ON 
eventheader.EventCode   
= SuiteSet.EventCode 

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

--------------- ------------------------------------------------------------------------

--Result Set 



SELECT 
    x.*
    ,ISNULL(YTD.VarianceYTD,0) AS VarianceYTD
    ,ISNULL(YTD.BudgetYTD,0) AS BudgetYTD
    ,ISNULL(YTD.ActualYTD,0) AS ActualYTD
    ,VarToProj = CASE ISNULL(ytd.budgetYTD,0)  WHEN 0 THEN 0 ELSE ISNULL(YTD.varianceYTD,0) / ISNULL(ytd.budgetYTD,0) END
FROM @singleSummary x
JOIN
(SELECT a.EventCode
,SUM(ISNULL(b.VarianceToGoal,0))  AS varianceYTD
,SUM(ISNULL(b.budgetedAmount,0)) AS budgetYTD
,SUM(ISNULL(b.TotalRevenue,0)) AS actualYTD 
FROM @singleSummary a
JOIN @singleSummary b
ON a.eventdate >= b.eventdate
GROUP BY a.EventCode) AS YTD
ON x.EventCode = YTD.EventCode






END 
























GO
