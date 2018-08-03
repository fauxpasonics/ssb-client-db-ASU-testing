SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







--exec rptCustSeasonTicketFootballRenew3_2014Build




CREATE   PROCEDURE [dbo].[rptCustSeasonTicketFootballRenew3_2014ProdReportBaseTest] 

as 
BEGIN

set transaction isolation level read uncommitted

declare @curSeason varchar(50)

Set @curSeason = 'F14'


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
 FROM vwTIReportBase rb where rb.SEASON IN ( @curSeason) 

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

Select 'F01',95000, 1500  UNION ALL
Select 'F02',710000, 12500 UNION ALL
Select 'F03',902000, 14000  UNION ALL
Select 'F04',783000, 12000  UNION ALL
Select 'F05',1800000, 17500  UNION ALL
Select 'F06',385000 ,7000


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

Insert into  @singleSummary 
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


select 
 isnull(eventHeader.eventCode,'')
,isnull(eventHeader.eventName,'')
,isnull(eventHeader.eventDate,'')
,isnull(vistingticketSet.visitingTicketQty,0)
,isnull(vistingticketSet.visitingTicketAmt,0)
,isnull(studentSet.studentTicketQty,0)
,isnull(studentSet.studentTicketAmt,0)
,isnull(groupSet.groupTicketQty,0)
,isnull(groupSet.groupTicketAmt,0)
, 0 as suiteTicketQty--,suiteSet.suiteTicketQty
, 0 as suiteTicketAmt--,suiteSet.suiteTicketAmt
,isnull(publicSet.publicTicketQty,0)
,isnull(publicSet.publicTicketAmt,0)
,isnull(budget.quantity,0) as budgetedQuantity
,isnull(budget.amount,0) as budgetedAmount

,isnull(vistingticketSet.visitingTicketQty,0) + 
         isnull(studentSet.studentTicketQty,0) + isnull(groupSet.groupTicketQty,0)
      + isnull(publicSet.publicTicketQty,0) as TotalTickets
      
,isnull(vistingticketSet.visitingTicketAmt,0) + 
         isnull(studentSet.studentTicketAmt,0) + isnull(groupSet.groupTicketAmt,0)
      + isnull(publicSet.publicTicketAmt,0) as TotalRevenue 
       
,case when budget.amount = 0 then 0 else (isnull(vistingticketSet.visitingTicketAmt,0) + 
         isnull(studentSet.studentTicketAmt,0) + isnull(groupSet.groupTicketAmt,0)
      + isnull(publicSet.publicTicketAmt,0))/ budget.amount end  as PercentToGoal 
       
,   (isnull(vistingticketSet.visitingTicketAmt,0) + 
         isnull(studentSet.studentTicketAmt,0) + isnull(groupSet.groupTicketAmt,0)
      + isnull(publicSet.publicTicketAmt,0)) - budget.amount  as VarianceToGoal

from
#eventHeader eventHeader
left join 
(

select 
       rb.ITEM 
,sum(ORDQTY) as visitingTicketQty
,sum((ORDQTY * (CASE When ITEM = 'F01' THEN 50 
                              WHEN ITEM = 'F02' THEN 50
                             WHEN ITEM = 'F03' THEN 65
                             WHEN ITEM = 'F04' THEN 65  
                              WHEN ITEM = 'F05' THEN 125
                             WHEN ITEM = 'F06' THEN 50 
                       End))) as visitingTicketAmt


from #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
          on rb.ITEM    
           = eventHeaderEvent.eventCode  
  WHERE ITEM like 'F0[1-6]'
  AND rb.E_PL not in  ('10', '11') -- deals with single game suites for now  
  AND rb.I_PT IN ('V')
group by rb.ITEM 
) vistingticketSet on 
eventheader.eventCode   
 = vistingticketSet.ITEM   

-------------------------------------------------------------------------------------------
LEFT JOIN  
(
select 
       'F01'  as ITEM 
       ,0 as studentTicketQty
      ,0 as studentTicketAmt
) studentSet on 
eventheader.eventCode   
 = studentSet.ITEM   
------------------------------------------------------------------------------------------

LEFT JOIN  
(
select 
       rb.ITEM 
,sum(ORDQTY) as groupTicketQty
,sum(ORDTOTAL) as groupTicketAmt
from #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                on rb.ITEM   
                 = eventHeaderEvent.eventCode   
    WHERE ITEM like 'F0[1-6]%'
     and rb.E_PL not in  ('10', '11') -- deals with single game suites for now 
      and rb.I_PT LIKE 'G%' --UPDATED FROM LAST YEAR 
      and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.ITEM 
) GroupSet on 
eventheader.eventCode   
= GroupSet.ITEM  

----------------------------------------------------------------------------------------------------------

LEFT JOIN  
(
select 
       rb.ITEM 
,sum(ORDQTY) as publicTicketQty
,sum(ORDTOTAL) as publicTicketAmt
from #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
       on rb.ITEM  
       = eventHeaderEvent.eventCode   
    WHERE ITEM like 'F0[1-6]%'
    and rb.E_PL NOT IN ('10', '11') -- deals with single game suites for now 
      and rb.I_PT NOT LIKE 'G%' 
      --and rb.I_PT NOT IN  ('S', 'STN', 'SSR')
      and rb.I_PT NOT IN  ('V')
      and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.ITEM 
) publicSet 
on eventheader.eventCode  
  = PublicSet.ITEM  

LEFT JOIN #budget budget
on budget.event  
=  eventHeader.eventCode 

---------------------------------------------------------------------------------------
--Result Set 


select 
	x.*
	,isnull(YTD.VarianceYTD,0) as VarianceYTD
	,isnull(YTD.BudgetYTD,0) as BudgetYTD
	,isnull(YTD.ActualYTD,0) as ActualYTD
	,VarToProj = case isnull(ytd.budgetYTD,0)  when 0 then 0 else isnull(YTD.varianceYTD,0) / isnull(ytd.budgetYTD,0) end
From @singleSummary x
join
(select a.eventCode
,SUM(isnull(b.VarianceToGoal,0))  as varianceYTD
,SUM(isnull(b.budgetedAmount,0)) as budgetYTD
,SUM(isnull(b.TotalRevenue,0)) as actualYTD 
from @singleSummary a
join @singleSummary b
on a.eventdate >= b.eventdate
group by a.eventCode) as YTD
on x.eventcode = YTD.eventcode






END 


















GO
