SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








--exec rptCustSeasonTicketFootballRenew3_2015Build



CREATE PROCEDURE [dbo].[rptCustSeasonTicketFootballRenew3_2016] 
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

Set @curSeason = 'F16'

--DECLARE	@dateRange VARCHAR(20)= 'AllData1'
--DECLARE @startDate DATE = DATEADD(month,-1,GETDATE())
--DECLARE @endDate DATE = GETDATE()


---- Build Report --------------------------------------------------------------------------------------------------

--Report Base 



Create table #ReportBase  
(
  SEASON varchar (15)
 ,CUSTOMER varchar (20)
 ,ITEM varchar (32) 
 ,E_PL varchar (10)
 ,I_PT  varchar (32)
 ,I_PRICE  numeric (18,2)
 ,I_DAMT  numeric (18,2)
 ,ORDQTY bigint 
 ,ORDTOTAL numeric (18,2) 
 ,PAIDCUSTOMER  varchar (20)
 ,MINPAYMENTDATE datetime  
 ,PAIDTOTAL numeric (18,2)
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
 FROM vwTIReportBase rb 
WHERE   (@dateRange = 'AllData' 
		 AND rb.season = @curseason)
		OR (@dateRange <> 'AllData' 
			AND rb.season = @curSeason 
			AND rb.MINPAYMENTDATE 
				BETWEEN @startDate AND @endDate)

------------------------------------------------------------------------------------------------------------------


create table #homegames
(event varchar(50)   )

insert into #homegames
(event)
select 'F01'  union all 
select 'F02'  union all 
select 'F03'  union all 
select 'F04'  union all 
select 'F05'  union all 
select 'F06'  


create table #budget 
(
event varchar (10) 
,amount float
,quantity int
)

insert into #budget
(event , amount, quantity)

Select 'F01',0,0  UNION ALL
Select 'F02',0,0 UNION ALL
Select 'F03',0,0  UNION ALL
Select 'F04',0,0  UNION ALL
Select 'F05',0,0  UNION ALL
Select 'F06',0,0  


create table #eventHeader
(
eventCode varchar(50)  
,eventName  varchar(200)
,eventDate date
)

insert into #eventHeader
(
eventCode 
,eventName
,eventDate
)
select 
 tkEvent.event 
,tkEvent.name
--,' ' EventDate

,cast (date as date) EventDate
from 
        TK_EVENT tkEvent with (nolock) 
        inner join #homegames homegames 
                  on tkEvent.event   COLLATE SQL_Latin1_General_CP1_CS_AS
                   = homegames.event COLLATE SQL_Latin1_General_CP1_CS_AS 
where tkEvent.season  =  @curSeason
and tkEvent.name not like '%@%'

----------------------------------------------------------------------------------------------------------



--Single Game Breakout:

declare @singleSummary as SingleSummary
--create table #singleSummary

--( 

-- eventCode varchar(100)

--,eventName varchar(500)

--,eventDate varchar(100)

--,visitingTicketQty bigint 

--,visitingTicketAmt numeric (18,2)

--,studentTicketQty bigint 

--,studentTicketAmt numeric (18,2)

--,groupTicketQty bigint

--,groupTicketAmt numeric (18,2)

--,suiteTicketQty bigint

--,suiteTicketAmt numeric (18,2) 

--,publicTicketQty bigint

--,publicTicketAmt numeric (18,2)

--,budgetedQuantity bigint 

--,budgetedAmount numeric (18,2)

--,TotalTickets bigint 

--,TotalRevenue numeric (18,2)

--,PercentToGoal numeric (18,2)

--,VarianceToGoal numeric (18,2)


--)


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
 ISNULL(eventHeader.eventCode,'')
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
       rb.ITEM 
,SUM(ORDQTY) AS visitingTicketQty
,SUM((ORDQTY * (CASE WHEN ITEM = 'F01' THEN 0 
                     WHEN ITEM = 'F02' AND E_PL = '11' THEN 75
				     WHEN ITEM = 'F02' AND E_PL = '13' THEN 50
                     WHEN ITEM = 'F03' THEN 65
                     WHEN ITEM = 'F04' THEN 65  
                     WHEN ITEM = 'F05' THEN 65
                     WHEN ITEM = 'F06' THEN 60 
                       END))) AS visitingTicketAmt


FROM #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
          ON rb.ITEM    
           = eventHeaderEvent.eventCode  
  WHERE ITEM LIKE 'F0[1-6]'
  --AND rb.E_PL NOT IN   ('20', '18', '19', '16') -- premium price levels

  AND rb.I_PT IN ('V')
GROUP BY rb.ITEM 
) vistingticketSet ON 
eventheader.eventCode   
 = vistingticketSet.ITEM   

-------------------------------------------------------------------------------------------

LEFT JOIN  
(
SELECT 
       'F01'  AS ITEM 
       ,0 AS studentTicketQty
      ,0 AS studentTicketAmt
) studentSet ON 
eventheader.eventCode   
 = studentSet.ITEM   
------------------------------------------------------------------------------------------


LEFT JOIN  
(
SELECT 
       rb.ITEM 
,SUM(ORDQTY) AS groupTicketQty
,SUM(ORDTOTAL) AS groupTicketAmt
FROM #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                ON rb.ITEM   
                 = eventHeaderEvent.eventCode   
    WHERE ITEM LIKE 'F0[1-6]%'
     AND rb.E_PL NOT IN  ('20', '18', '19', '16') -- premium price levels

      AND rb.I_PT LIKE 'G%' --UPDATED FROM LAST YEAR 

      AND rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.ITEM 
) GroupSet ON 
eventheader.eventCode   
= GroupSet.ITEM  

------------------------------------------------------------------------------------------


LEFT JOIN  
(
SELECT 
       rb.ITEM 
,SUM(ORDQTY) AS suiteTicketQty
,SUM(ORDTOTAL) AS suiteTicketAmt
FROM #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                ON rb.ITEM   
                 = eventHeaderEvent.eventCode   
    WHERE ITEM LIKE 'F0[1-6]%'
     AND rb.E_PL IN  ('20', '18', '19') -- premium price levels
     AND rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.ITEM 
) SuiteSet ON 
eventheader.eventCode   
= SuiteSet.ITEM  

----------------------------------------------------------------------------------------------------------


LEFT JOIN  
(
SELECT 
       rb.ITEM 
,SUM(ORDQTY) AS publicTicketQty
,SUM(ORDTOTAL) AS publicTicketAmt
FROM #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
       ON rb.ITEM  
       = eventHeaderEvent.eventCode   
    WHERE ITEM LIKE 'F0[1-6]%'
    AND rb.E_PL NOT IN  ('20', '18', '19', '16') -- premium price levels 

      AND rb.I_PT NOT LIKE 'G%' 
      --and rb.I_PT NOT IN  ('S', 'STN', 'SSR')

      AND rb.I_PT NOT IN  ('V')
      AND rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.ITEM 
) publicSet 
ON eventheader.eventCode  
  = PublicSet.ITEM  

LEFT JOIN #budget budget
ON budget.event  
=  eventHeader.eventCode 

---------------------------------------------------------------------------------------

--Result Set 



SELECT 
    x.*
    ,ISNULL(YTD.VarianceYTD,0) AS VarianceYTD
    ,ISNULL(YTD.BudgetYTD,0) AS BudgetYTD
    ,ISNULL(YTD.ActualYTD,0) AS ActualYTD
    ,VarToProj = CASE ISNULL(ytd.budgetYTD,0)  WHEN 0 THEN 0 ELSE ISNULL(YTD.varianceYTD,0) / ISNULL(ytd.budgetYTD,0) END
FROM @singleSummary x
JOIN
(SELECT a.eventCode
,SUM(ISNULL(b.VarianceToGoal,0))  AS varianceYTD
,SUM(ISNULL(b.budgetedAmount,0)) AS budgetYTD
,SUM(ISNULL(b.TotalRevenue,0)) AS actualYTD 
FROM @singleSummary a
JOIN @singleSummary b
ON a.eventdate >= b.eventdate
GROUP BY a.eventCode) AS YTD
ON x.eventcode = YTD.eventcode






END 
















GO
