SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE  PROCEDURE [dbo].[rptCustSeasonTicketMBBRenew4_DateRange]
(
	@StartDate datetime,
	@EndDate datetime
)
as
BEGIN

declare @curSeason varchar(50)

Set @curSeason = 'BB12'
--set @StartDate = '2011-01-01 12:00:00'
--set @EndDate = '2012-10-17 12:00:00'

create table #homegames
(event varchar(50) COLLATE SQL_Latin1_General_CP1_CS_AS)

insert into #homegames
(event)
select distinct 
	ITEM 
from TK_ITEM tkItem 
where tkItem.season = @curSeason
	and tkItem.CLASS = 'S'

	
	
create table #luBudget
(	
	event varchar(50) COLLATE SQL_Latin1_General_CP1_CS_AS
	,budgetAmt int
	,budgetAvg decimal(18,6)
)
	
insert into #luBudget values ('MB01','750','11340')
insert into #luBudget values ('MB02','500','7560')
insert into #luBudget values ('MB03','500','7560')
insert into #luBudget values ('MB04','500','7560')
insert into #luBudget values ('MB05','500','7560')
insert into #luBudget values ('MB06','500','7560')
insert into #luBudget values ('MB07','500','7560')
insert into #luBudget values ('MB08','1250','18900')
insert into #luBudget values ('MB09','500','7560')
insert into #luBudget values ('MB10','1000','12120')
insert into #luBudget values ('MB11','1250','25150')
insert into #luBudget values ('MB12','1750','35210')
insert into #luBudget values ('MB13','3500','150445')
insert into #luBudget values ('MB14','1250','25150')
insert into #luBudget values ('MB15','1750','35210')
insert into #luBudget values ('MB16','1250','25150')
insert into #luBudget values ('MB17','1750','35210')
insert into #luBudget values ('MB18','1250','25150')
insert into #luBudget values ('MB19','1750','35210')



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
where tkEvent.season = @curSeason
and tkEvent.name <> 'No Game'
and tkEvent.EVENT <> 'NIT1'


--add visitor tickets 


create table #singleSummary
( 
eventCode varchar(100)
,eventName varchar(500)
,eventDate varchar(100)
,budgetAmt int
,budgetAvg decimal (18,6)
,groupTicketQty int
,groupTicketAmt decimal (18,2)
,publicTicketQty int
,publicTicketAmt decimal (18,2)
,studentQty int
,studentAmt decimal(18,2)
)

insert into #singleSummary
select 
 eventHeader.eventCode
,eventHeader.eventName
,eventHeader.eventDate
,luBudget.budgetAmt
,luBudget.budgetAvg
,groupSet.groupTicketQty
,groupSet.groupTicketAmt
,publicSet.publicTicketQty
,publicSet.publicTicketAmt
,StudentSet.StudentQty
,StudentSet.StudentAmt
from
#eventHeader eventHeader
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
        left join TK_PRTYPE tkPrtype on tkOdet.SEASON = tkPrtype.SEASON 
							and tkOdet.I_PT = tkPrtype.PRTYPE 
where tkOdet.season = @curSeason  
and tkPrtype.CLASS = 'G' 
and tkOdet.I_PAY > 0
and tkOdet.I_DATE between @StartDate and @EndDate
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
                  and tkOdetEventAssoc.event = tkEvent.Event
        inner join #eventHeader eventHeaderEvent  
                          on tkEvent.event = eventHeaderEvent.eventCode 
        inner join #eventHeader eventHeaderItem  
                          on tkItem.item = eventHeaderItem.eventCode 
        left join TK_PRTYPE tkPrtype on tkOdet.SEASON = tkPrtype.SEASON 
					          and tkOdet.I_PT = tkPrtype.PRTYPE 
where tkOdet.season = @curSeason 
and tkPrtype.CLASS <> 'G' 
and tkOdet.I_PT <> 'S'
and tkOdet.I_DATE between @StartDate and @EndDate
--and tkOdet.I_PL not in ('10')
and tkOdet.I_PAY > 0
group by tkevent.event
) PublicSet
on eventheader.eventCode = PublicSet.event 
left outer join 
(
select 
tkevent.event
,sum(tkOdet.I_OQTY) as StudentQty
,sum(tkOdet.I_OQTY * tkOdetEventAssoc.E_PRICE - tkOdetEventAssoc.E_DAMT) as StudentAmt
from dbo.TK_ODET tkOdet
inner join dbo.TK_ODET_EVENT_ASSOC tkOdetEventAssoc with (nolock) 
	on tkOdet.season = tkOdetEventAssoc.season
		and tkOdet.zid = tkOdetEventAssoc.zid
inner join dbo.TK_Event tkEvent with (nolock) 
	on tkOdetEventAssoc.season = tkEvent.season
		and tkOdetEventAssoc.event = tkEvent.Event			
where tkOdet.season = @curSeason
and tkOdet.I_PT like 'S'
and tkOdet.I_PAY > 0
and tkOdet.I_DATE between @StartDate and @EndDate
group by tkevent.event
) StudentSet on eventheader.eventCode = StudentSet.event 
left outer join #luBudget luBudget
on eventheader.eventCode = luBudget.event


select 
	singleSummary.*
	,YTD.varianceYTD
	,YTD.budgetYTD
	,YTD.actualYTD 
From #singleSummary singleSummary
join
(select a.eventCode, (SUM(isnull(b.groupTicketAmt,0) + isnull(b.publicTicketAmt,0))) - (SUM(isnull(b.BudgetAmt,0) * isnull(b.budgetAvg,0))) as varianceYTD, SUM(isnull(b.BudgetAmt,0) * isnull(b.budgetAvg,0)) as budgetYTD, SUM(isnull(b.groupTicketAmt,0) + isnull(b.publicTicketAmt,0)) as actualYTD 
from #singleSummary a
join #singleSummary b
on a.eventdate >= b.eventdate
group by a.eventCode) as YTD
on singleSummary.eventcode = YTD.eventcode

end








GO
