SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--DROP TABLE #Reportbase
--DROP TABLE #homeGames
--DROP TABLE #budget
--DROP TABLE #EventHeader
CREATE     PROCEDURE [rpt].[CustSeasonTicketWBRenew3_2014Prod] 

as 
BEGIN

set transaction isolation level read uncommitted

declare @curSeason varchar(50)

Set @curSeason = 'WB14'


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
select 'WB01'  union all 
select 'WB02'  union all 
select 'WB03'  union all 
select 'WB04'  union all 
select 'WB05'  union all 
select 'WB06'  union all 
select 'WB07'  union all
select 'WB08'  union all 
select 'WB09'  union all 
select 'WB10'  union all 
select 'WB11'  union all 
select 'WB12'  union all 
select 'WB13'  union all 
select 'WB14'  union all
select 'WB15'  union all
select 'WB16'   

create table #budget 
(
event varchar (10) 
,amount float
,quantity int
)

insert into #budget
(event , amount, quantity)


select 'WB01',0,0  union all 
select 'WB02' ,2960,350  union all 
select 'WB03' ,4250,500  union all 
select 'WB04',8075,950  union all 
select 'WB05',5100,600  union all 
select 'WB06',3825,450  union all 
select 'WB07',3825,450  union all
select 'WB08',5950,700 union all 
select 'WB09',4250,500 union all 
select 'WB10',8500,1000  union all 
select 'WB11',1909,225  union all 
select 'WB12',3612,425 union all 
select 'WB13',8075,950  union all 
select 'WB14',3612,425  union all
select 'WB15',5100,600  union all
select'WB16',3612,425 



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
--declare @singleSummary as SingleSummary


--Insert into  @singleSummary 
--(
--EventCode 
--,EventName 
--,EventDate 
--,VisitingTicketQty 
--,VisitingTicketAmt
--,GroupTicketQty 
--,GroupTicketAmt   
--,PublicTicketQty 
--,PublicTicketAmt 
--,BudgetedQuantity 
--,BudgetedAmount
--,TotalTickets  
--,TotalRevenue 
--,PercentToGoal 
--,VarianceToGoal 
--) 



select 
 isnull(eventHeader.eventCode,'')                                                                                                eventCode 
,isnull(eventHeader.eventName,'') 																								 eventName 
,isnull(eventHeader.eventDate,'') 																								 eventDate
,isnull(vistingticketSet.visitingTicketQty,0)																					 visitingTicketQty 
,isnull(vistingticketSet.visitingTicketAmt,0)																					 visitingTicketAmt
,isnull(groupSet.groupTicketQty,0)																								 groupTicketQty 
,isnull(groupSet.groupTicketAmt,0)																								 groupTicketAmt   
,isnull(publicSet.publicTicketQty,0)																							 publicTicketQty 
,isnull(publicSet.publicTicketAmt,0)																							 publicTicketAmt 
,isnull(budget.quantity,0) as budgetedQuantity																					 
,isnull(budget.amount,0) as budgetedAmount																						 
																																 
,isnull(vistingticketSet.visitingTicketQty,0)  + isnull(groupSet.groupTicketQty,0)												 
      + isnull(publicSet.publicTicketQty,0) as TotalTickets																		 
      																															   
,isnull(vistingticketSet.visitingTicketAmt,0)  + isnull(groupSet.groupTicketAmt,0)
      + isnull(publicSet.publicTicketAmt,0) as TotalRevenue 
       
,case when budget.amount = 0 then 0 else (isnull(vistingticketSet.visitingTicketAmt,0) +  isnull(groupSet.groupTicketAmt,0)
      + isnull(publicSet.publicTicketAmt,0))/ budget.amount end  as PercentToGoal 
       
,   (isnull(vistingticketSet.visitingTicketAmt,0) +  isnull(groupSet.groupTicketAmt,0)
      + isnull(publicSet.publicTicketAmt,0)) - budget.amount  as VarianceToGoal
into #singleSummary
from
#eventHeader eventHeader
left join 
(

select 
	 rb.ITEM 
,sum(ORDQTY) as visitingTicketQty
,sum(ORDTOTAL) as visitingTicketAmt
from #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                          on rb.ITEM  = eventHeaderEvent.eventCode  
    WHERE 
        ITEM like 'WB%'
	and rb.I_PT in ('V')
	and rb.SEASON = @curSeason
	and rb.I_PRICE > 0
group by rb.ITEM 
) vistingticketSet 
on eventheader.eventCode  = vistingticketSet.ITEM    

-------------------------------------------------------------------------------------------


LEFT JOIN  
(
select 
	 rb.ITEM 
,sum(ORDQTY) as groupTicketQty
,sum(ORDTOTAL) as groupTicketAmt
from #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                on rb.ITEM  = eventHeaderEvent.eventCode  
    WHERE 
        ITEM like 'WB%'
	and rb.I_PT like 'G%'
	and rb.SEASON = @curSeason
	and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.ITEM 
) GroupSet on 
eventheader.eventCode  = GroupSet.ITEM 



----------------------------------------------------------------------------------------------------------

LEFT JOIN  
(
select 
	 rb.ITEM 
,sum(ORDQTY) as publicTicketQty
,sum(ORDTOTAL) as publicTicketAmt
from #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                          on rb.ITEM  = eventHeaderEvent.eventCode  
    WHERE 
        ITEM like 'WB%'
	and rb.I_PT NOT LIKE  'G%'
	and rb.I_PT NOT LIKE 'V%'
	and rb.SEASON = @curSeason
	and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.ITEM 
) publicSet 
on eventheader.eventCode  = PublicSet.ITEM 

LEFT JOIN #budget budget
on budget.event =  eventHeader.eventCode

---------------------------------------------------------------------------------------
--Result Set 


select 
	x.*
	,isnull(YTD.VarianceYTD,0) as VarianceYTD
	,isnull(YTD.BudgetYTD,0) as BudgetYTD
	,isnull(YTD.ActualYTD,0) as ActualYTD
	,VarToProj = case isnull(ytd.budgetYTD,0)  when 0 then 0 else isnull(YTD.varianceYTD,0) / isnull(ytd.budgetYTD,0) end
From #singleSummary x
join
(select a.eventCode
,SUM(isnull(b.VarianceToGoal,0))  as varianceYTD
,SUM(isnull(b.budgetedAmount,0)) as budgetYTD
,SUM(isnull(b.TotalRevenue,0)) as actualYTD 
from #singleSummary a
join #singleSummary b
on a.eventdate >= b.eventdate
group by a.eventCode) as YTD
on x.eventcode = YTD.eventcode






END 


GO
