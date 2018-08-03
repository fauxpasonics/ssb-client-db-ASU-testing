SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





--exec rptCustSeasonTicketFootballRenew3_2014Build




CREATE   PROCEDURE [dbo].[rptCustSeasonTicketFootballRenew4_2014ProdReportBaseTest] 

as 
BEGIN

set transaction isolation level read uncommitted

declare @curSeason varchar(50)

Set @curSeason = 'F13'


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
select 'F06'  union all
select 'F07'  


create table #budget 
(
event varchar (10) 
,amount float
,quantity int
)

insert into #budget
(event , amount, quantity)

Select 'F01','169141', '3747'  UNION ALL
Select 'F02','1047557', '23745'  UNION ALL
Select 'F03', '1094321', '21591'  UNION ALL
Select 'F04', '494614', '11178'  UNION ALL
Select 'F05', '733864', '15963'  UNION ALL
Select 'F06', '581614' , '12918' UNION ALL
Select 'F07', '1229027', '24020'


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
       
,(isnull(vistingticketSet.visitingTicketAmt,0) + 
         isnull(studentSet.studentTicketAmt,0) + isnull(groupSet.groupTicketAmt,0)
      + isnull(publicSet.publicTicketAmt,0))/ budget.amount as PercentToGoal 
       
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
,sum((ORDQTY * (CASE When ITEM = 'F02' THEN 60 
					 WHEN ITEM = 'F03' THEN 60 
					 WHEN ITEM = 'F07' THEN 60 
					 ELSE 45 END)))as visitingTicketAmt


from #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
          on rb.ITEM    
           = eventHeaderEvent.eventCode  
  WHERE ITEM like 'F0[1-7]'
  AND rb.E_PL not in  ('10') -- deals with single game suites for now  
  AND rb.I_PT IN ('VI','V')
group by rb.ITEM 
) vistingticketSet on 
eventheader.eventCode   
 = vistingticketSet.ITEM   

-------------------------------------------------------------------------------------------
LEFT JOIN  
(
select 
	 rb.ITEM 
,sum(ORDQTY) as studentTicketQty
,sum(ORDTOTAL) as studentTicketAmt
from #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                          on rb.ITEM  = eventHeaderEvent.eventCode  
    WHERE ITEM like 'F0[1-7]%'
     and rb.E_PL not in  ('10') -- deals with single game suites for now 
	and rb.I_PT in ('S', 'STN', 'SSR')
	and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.ITEM 
) studentSet on 
eventheader.eventCode   = studentSet.ITEM   
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
    WHERE ITEM like 'F0[1-7]%'
     and rb.E_PL not in  ('10') -- deals with single game suites for now 
	 and rb.I_PT IN ('G','G100','G250')  --UPDATED FROM LAST YEAR 
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
    WHERE ITEM like 'F0[1-7]%'
    and rb.E_PL NOT IN ('10') -- deals with single game suites for now 
	and rb.I_PT NOT IN ('G','G100','G250') 
	and rb.I_PT NOT IN  ('S', 'STN', 'SSR')
	and rb.I_PT NOT IN  ('V', 'VI')
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
