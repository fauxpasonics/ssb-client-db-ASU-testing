SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE  proc [dbo].[rptCustSeasonTicketFootballRenew3_DateRange]
as

declare @currSeason varchar(50)

Set @currSeason = 'f12'


begin

create table #homegames
(event varchar(50) COLLATE SQL_Latin1_General_CP1_CS_AS)

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
event varchar (50) COLLATE SQL_Latin1_General_CP1_CS_AS
,amount float
,quantity int
)

insert into #budget
(event, amount, quantity)

Select 'F01', '277000', '11800' UNION ALL
Select 'F02', '576250', '15200' UNION ALL
Select 'F03', '530000', '14200' UNION ALL
Select 'F04', '1025000', '17000' UNION ALL
Select 'F05', '520000', '15200' UNION ALL
Select 'F06', '404250', '13600'


create table #eventHeader
(
eventCode varchar(50) COLLATE SQL_Latin1_General_CP1_CS_AS
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
,cast (date as date) EventDate
from 
        TK_Event tkEvent with (nolock) 
        inner join #homegames homegames
                  on tkevent.event = homegames.event
where tkEvent.season = @currSeason
and tkEvent.name not like '%@%'
--add visitor tickets 



select 
 eventHeader.eventCode
,eventHeader.eventName
,eventHeader.eventDate
,vistingticketSet.visitingTicketQty
,vistingticketSet.visitingTicketAmt
,studentSet.studentTicketQty
,studentSet.studentTicketAmt
,groupSet.groupTicketQty
,groupSet.groupTicketAmt
, 0 as suiteTicketQty--,suiteSet.suiteTicketQty
, 0 as suiteTicketAmt--,suiteSet.suiteTicketAmt
,publicSet.publicTicketQty
,publicSet.publicTicketAmt
,budget.quantity as budgetedQuantity
,budget.amount as budgetedAmount
from
#eventHeader eventHeader
left join 
(
select 
 tkevent.event
,sum(tkOdet.i_oqty) as visitingTicketQty
,sum(tkOdet.i_oqty * (CASE When tkevent.event = 'F02' Then 50 WHEN TKEVENT.EVENT = 'F04' THEN 50 ELSE 40 END)) as visitingTicketAmt
From 
TK_ODET tkOdet with (nolock) 
      inner join TK_ITEM tkItem with (nolock)   
                          on tkOdet.season = tkItem.season 
                          and tkOdet.item = tkItem.item 
        inner join TK_ODET_EVENT_ASSOC tkOdetEventAssoc with (nolock) 
                  on tkOdet.season = tkOdetEventAssoc.season
                  and tkOdet.zid = tkOdetEventAssoc.zid
        inner join TK_Event tkEvent with (nolock) 
                  on tkOdetEventAssoc.season = tkEvent.season
                  and tkOdetEventAssoc.event = tkEvent.Event
        inner join #eventHeader eventHeaderEvent  
                          on tkEvent.event = eventHeaderEvent.eventCode 
        inner join #eventHeader eventHeaderItem  
                          on tkItem.item = eventHeaderItem.eventCode 
where tkOdet.season = @currSeason 
and tkOdet.I_PT in ( 'vi', 'v')
group by tkevent.event
) vistingticketSet
on 
eventheader.eventCode = vistingticketSet.event
left join
(
select 
 tkevent.event
,sum(tkOdet.I_OQTY) as studentTicketQty
,sum(tkOdet.I_OQTY * tkOdetEventAssoc.E_PRICE - tkOdetEventAssoc.E_DAMT) as studentTicketAmt
From 
TK_ODET tkOdet with (nolock) 
      inner join TK_ITEM tkItem with (nolock)   
                          on tkOdet.season = tkItem.season 
                          and tkOdet.item = tkItem.item 
        inner join TK_ODET_EVENT_ASSOC tkOdetEventAssoc with (nolock) 
                  on tkOdet.season = tkOdetEventAssoc.season
                  and tkOdet.zid = tkOdetEventAssoc.zid
        inner join TK_Event tkEvent with (nolock) 
                  on tkOdetEventAssoc.season = tkEvent.season
                  and tkOdetEventAssoc.event = tkEvent.Event
        inner join #eventHeader eventHeaderEvent  
                          on tkEvent.event = eventHeaderEvent.eventCode 
        inner join #eventHeader eventHeaderItem  
                          on tkItem.item = eventHeaderItem.eventCode 
where tkOdet.season = @currSeason  
and tkOdet.I_PT = 'S'
and tkOdet.I_PAY > 0
group by tkevent.event
) StudentSet
on eventheader.eventCode = StudentSet.event
--left outer join
--(
--select 
-- tkevent.event
--,sum(tkOdet.I_OQTY) as suiteTicketQty
--,sum(tkOdet.I_OQTY * tkOdetEventAssoc.E_PRICE - tkOdetEventAssoc.E_DAMT) as suiteTicketAmt
--From 
--TK_ODET tkOdet with (nolock) 
--      inner join TK_ITEM tkItem with (nolock) 
--                          on tkOdet.season = tkItem.season 
--                          and tkOdet.item = tkItem.item 
--        inner join TK_ODET_EVENT_ASSOC tkOdetEventAssoc with (nolock) 
--                  on tkOdet.season = tkOdetEventAssoc.season
--                  and tkOdet.zid = tkOdetEventAssoc.zid
--        inner join TK_Event tkEvent with (nolock) 
--                  on tkOdetEventAssoc.season = tkEvent.season
--                  and tkOdetEventAssoc.event = tkEvent.zid
--        inner join #eventHeader eventHeaderEvent  
--                          on tkEvent.event = eventHeaderEvent.eventCode 
--        inner join #eventHeader eventHeaderItem  
--                          on tkItem.item = eventHeaderItem.eventCode 
--where tkOdet.season = @currSeason 
--and tkOdet.I_PL = '10'
--and i_pt in ('P', 'SR')
--group by tkevent.event
--) SuiteSet
--on
--eventheader.eventCode = SuiteSet.event 
left outer join
(
select 
 tkevent.event
,sum(tkOdet.I_OQTY) as groupTicketQty
,sum(tkOdet.I_OQTY * tkOdetEventAssoc.E_PRICE - tkOdetEventAssoc.E_DAMT) as groupTicketAmt
From 
TK_ODET tkOdet with (nolock) 
      inner join TK_ITEM tkItem  with (nolock)  
                          on tkOdet.season = tkItem.season 
                          and tkOdet.item = tkItem.item 
        inner join TK_ODET_EVENT_ASSOC tkOdetEventAssoc with (nolock) 
                  on tkOdet.season = tkOdetEventAssoc.season
                  and tkOdet.zid = tkOdetEventAssoc.zid
        inner join TK_Event tkEvent with (nolock) 
                  on tkOdetEventAssoc.season = tkEvent.season
                  and tkOdetEventAssoc.event = tkEvent.Event
        inner join #eventHeader eventHeaderEvent  
                          on tkEvent.event = eventHeaderEvent.eventCode 
        inner join #eventHeader eventHeaderItem  
                          on tkItem.item = eventHeaderItem.eventCode 
where tkOdet.season = @currSeason  
and tkOdet.I_PT in ('G', 'G51', 'G100', 'G150', 'GA')
and tkOdet.I_PRICE > 0
group by tkevent.event
) GroupSet
on
eventheader.eventCode = GroupSet.event 
left outer join
(
select 
 tkevent.event
,sum(tkOdet.I_OQTY) as publicTicketQty
,sum(tkOdet.I_OQTY * tkOdetEventAssoc.E_PRICE - tkOdetEventAssoc.E_DAMT) as publicTicketAmt
From 
TK_ODET tkOdet with (nolock) 
      inner join TK_ITEM tkItem with (nolock)   
                          on tkOdet.season = tkItem.season 
                          and tkOdet.item = tkItem.item 
        inner join TK_ODET_EVENT_ASSOC tkOdetEventAssoc with (nolock) 
                  on tkOdet.season = tkOdetEventAssoc.season
                  and tkOdet.zid = tkOdetEventAssoc.zid
        inner join TK_Event tkEvent with (nolock) 
                  on tkOdetEventAssoc.season = tkEvent.season
                  and tkOdetEventAssoc.event = tkEvent.EVENT
        inner join #eventHeader eventHeaderEvent  
                          on tkEvent.event = eventHeaderEvent.eventCode 
        inner join #eventHeader eventHeaderItem  
                          on tkItem.item = eventHeaderItem.eventCode 
where tkOdet.season = @currSeason 
and tkOdet.I_PT not in ('S', 'G', 'G51', 'G150', 'G100', 'SR', 'P', 'v', 'vi', 'GA')
and tkOdet.I_PL not in ('10')
and tkOdet.I_PRICE > 0
and tkOdet.I_PAY > 0
group by tkevent.event
) PublicSet
on
eventheader.eventCode = PublicSet.event 
left outer join #budget budget
on budget.event =  eventHeader.eventCode


end





GO
