SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE proc [dbo].[rptCustSeasonTicketFootballRenew1_DateRange]
as

declare @curSeason varchar(50)
declare @prevSeason varchar(50)
declare @studentprevSeason varchar(50)
declare @studentCurSeason varchar(50)
declare @DonationYearCY varchar(50), @DonationYearPY varchar(50), @DonationCY decimal(12,2), @DonationPY decimal(12,2), @DonationCYPledge decimal(12,2), @DonationCYAccts int, @DonationPYAccts int
declare @SeasonTicketAcctsCY int, @SeasonTicketAcctsPY int

Set @prevSeason = 'f11'
Set @curSeason = 'f12'
set @studentprevSeason = 'AP11'
Set @studentCurSeason = 'AP12'
Set @DonationYearCY = '2012'
Set @DonationYearPY = '2011'

--Donation Accts and Donations
set @DonationCY = (
	select sum(l.transAmount) amount
	from dbo.ADVContactTransHeader (nolock) h
	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
	where p.ProgramCode = 'FTB'
	and h.transType = 'Cash Receipt'
	and h.transYear = '2012'
)

set @DonationPY = (
	select sum(l.transAmount) amount
	from dbo.ADVContactTransHeader (nolock) h
	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
	where p.ProgramCode = 'FTB'
	and h.transType = 'Cash Receipt'
	and h.transYear = '2011'	
)

set @DonationCYPledge = (
	select sum(l.transAmount) amount
	from dbo.ADVContactTransHeader (nolock) h
	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
	where p.ProgramCode = 'FTB'
	and h.transType = 'Cash Pledge'
	and h.transYear = '2012'
)


set @DonationCYAccts = (
	select count(distinct h.contactID) amount
	from dbo.ADVContactTransHeader (nolock) h
	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
	where 1=1
	and p.ProgramCode = 'FTB'
	and h.transType in ('Cash Pledge', 'Cash Receipt')
	and h.transYear = @DonationYearCY
)

set @DonationPYAccts = (
	select count(distinct h.contactID) amount
	from dbo.ADVContactTransHeader (nolock) h
	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
	where 1=1
	and p.ProgramCode = 'FTB'
	and h.transType in ('Cash Pledge', 'Cash Receipt')
	and h.transYear = @DonationYearPY
)
begin

create table #budget
(
	saleTypeName varchar(100)
	,amount int
	,priorYear int
)

insert into #budget
--Budget and Prior Year Revenue
Select 'Mini Packs FSE', '87500', '15465' UNION ALL
Select 'Season', '3140600', '2608358' UNION ALL
Select 'Season Suites/ MFSC', '510050', '431854' UNION ALL
Select 'Single Game', '3332500', '3567944' UNION ALL
Select 'Single Game Suite', '150900', '162690'  UNION ALL
Select 'Student Guest Passes', '0', '37680' UNION ALL
Select 'Student Season', '1207500' , '889218'


create table #SeasonSummary
(
	season varchar(100)
	,saleTypeName  varchar(50)
	,qty  int
	,amt money
)


insert into #SeasonSummary
(
 season
 ,saleTypeName
,qty
,amt
)

--Season Ticket Total
select 
	tkOdet.Season
	,'Season'
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet
where tkOdet.season in (@prevSeason)
	and tkOdet.ITEM = 'FS'
	and tkOdet.I_PL <> '7'
	and tkOdet.I_PAY > 0
	--and (tkOdet.I_PAY > 0 or tkOdet.CUSTOMER IN ('152760','164043','186078'))
group by tkOdet.Season

union all


select 
	tkOdet.Season
	,'Season'
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet
where tkOdet.season in (@curSeason)
	and tkOdet.ITEM = 'FS'
	and tkOdet.I_PL <> '5'
	and tkOdet.I_PAY > 0
	--and (tkOdet.I_PAY > 0 or tkOdet.CUSTOMER IN ('152760','164043','186078'))
group by tkOdet.Season

UNION ALL

--Student Season Ticket Total
select 
	tkOdet.Season
	,'Student Season'
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * ((tkOdet.I_PRICE - 30) - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet
where tkOdet.season in (@studentCurSeason, @studentPrevSeason) 
	and tkOdet.ITEM like 'FSB%'
	and tkOdet.I_PAY > 0
group by tkOdet.Season

UNION ALL

select 
	tkOdet.Season
	,'Student Season'
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * ((tkOdet.I_PRICE - 30) - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@prevSeason) 
	and tkOdet.ITEM = 'FS'
	and tkOdet.I_PL = '7'
	and tkOdet.I_PAY > 0
group by tkOdet.Season

UNION ALL

select 
	tkOdet.Season
	,'Student Season'
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * ((tkOdet.I_PRICE - 30) - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@curSeason) 
	and tkOdet.ITEM = 'FS'
	and tkOdet.I_PL = '5'
	and tkOdet.I_PAY > 0
group by tkOdet.Season

UNION ALL

select 
	tkOdet.Season
	,'Student Season'
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet
where tkOdet.season in (@curSeason, @prevSeason)
	and tkOdet.ITEM = 'FSB' 
	and tkOdet.I_PT in ('S', 'SN', 'STN')
	and tkOdet.I_PAY > 0
group by tkOdet.Season

--------------------------------------------------
--takes out customers ('18864','3498')

UNION ALL
select 
      tkOdet.Season
      ,'Student Season'
      ,SUM(tkOdet.I_OQTY) * -1 QTY  
      ,SUM(tkOdet.I_OQTY * ((tkOdet.I_PRICE - 30) - tkOdet.I_DAMT)) * -1 AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@curSeason) 
      and tkOdet.ITEM = 'FS'
      and tkOdet.I_PL = '5'
      and tkOdet.I_PAY > 0
      and CUSTOMER in ('18864','3498')
group by tkOdet.Season

UNION ALL

--adds back customers ('18864','3498')
select 
      tkOdet.Season
      ,'Season'
      ,SUM(tkOdet.I_OQTY)   QTY     
      ,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT))  AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@curSeason) 
      and tkOdet.ITEM = 'FS'
      and tkOdet.I_PL = '5'
      and tkOdet.I_PAY > 0
      and CUSTOMER in ('18864','3498')
group by tkOdet.Season


---------------------------------------------------------------------------





















UNION ALL

--Student Guest Pass Total
select 
	tkOdet.Season
	,'Student Guest Passes'
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet
where tkOdet.season in (@curSeason, @prevSeason)
	and tkOdet.ITEM = 'FSB' 
	and tkOdet.I_PT in ('GP', 'GPN', 'GP1')
	and tkOdet.I_PAY > 0
group by tkOdet.Season

UNION ALL

select 
	tkOdet.Season
	,'Student Guest Passes'
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@studentprevSeason, @studentCurSeason) 
	and tkOdet.ITEM in ('GP', 'GPN')
	and tkOdet.I_PAY > 0
group by tkOdet.Season


UNION ALL

--Mini Plans Total
select 
	tkOdet.Season
	,'Mini Packs FSE'
	,CASE WHEN season = @curSeason then SUM(tkOdet.I_OQTY)/2 else SUM(tkOdet.I_OQTY) end QTY  --Divde by 2 for 2012 season since there are 6 home games	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@curSeason, @prevSeason)
	and tkOdet.ITEM in ('3G', '4G', '3P') 
group by tkOdet.Season

UNION ALL

--Season Suites Total
select 
	suite.season
	,'Season Suites/ MFSC'
	,SUM(Suite.QTY) as QTY
	,SUM(Suite.AMT + Donation.AMT + ISNULL(MFS.AMT,0)) as AMT
From
(select
	tkOdet.Season
	,COUNT(tkOdet.ZID) QTY	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet
where tkOdet.season in (@curSeason, @prevSeason)
	and tkOdet.ITEM in ('FSS') 
	and tkOdet.I_PT = 'P'
group by tkOdet.Season) Suite
left outer join 
(select
	tkOdet.Season
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet
where tkOdet.season in (@prevSeason)
	and tkOdet.ITEM in ('FSAF') 
group by tkOdet.Season
UNION ALL
select
	tkOdet.Season
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet
where tkOdet.season in (@curSeason)
	and tkOdet.ITEM in ('SUITE') 
group by tkOdet.Season
) donation
on suite.season = donation.Season
left outer join 
(select
	tkOdet.Season
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet
where tkOdet.season in (@curSeason, @prevSeason)
	and tkOdet.I_PL = '11'
group by  tkOdet.Season) MFS
on suite.season = MFS.Season
group by suite.season

UNION ALL

--Single Game Suite Total
select 
	suite.season
	,'Single Game Suite'
	,SUM(Suite.QTY) as QTY
	,SUM(Suite.AMT + ISNULL(Donation.AMT, 0)) as AMT
From
(select 
	tkOdet.Season
	,tkOdet.Customer
	,COUNT(tkOdet.ZID) QTY	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet
join tk_event tkEvent
on tkOdet.Item = tkEvent.Event
and tkOdet.season = tkEvent.season
where tkOdet.season in (@curSeason, @prevSeason)
	and tkEvent.Facility = 'SDS'
	and tkOdet.I_PL in ('10')
	and tkOdet.I_PT in ('P', 'SR')
	and tkOdet.I_PRICE > 0
group by tkOdet.customer, tkOdet.Season, tkOdet.I_PT) suite
left outer join 
(select
	tkOdet.Customer
	,tkOdet.Season
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet
where tkOdet.season in (@curSeason, @prevSeason)
	and tkOdet.ITEM like 'SR0%'
group by tkOdet.Customer, tkOdet.Season) donation
on suite.season = donation.Season
and suite.customer = donation.customer
group by suite.season

UNION ALL

--Single Game Total
select 
	tkOdet.Season
	,'Single Game'
,sum(tkOdet.I_OQTY) as Qty
,sum(tkOdet.I_OQTY * tkOdet.I_PRICE - tkOdet.I_DAMT) as Amt
from tk_odet tkOdet
join tk_event tkEvent
on tkOdet.Item = tkEvent.Event
and tkOdet.season = tkEvent.season
where tkOdet.season in (@curSeason, @prevSeason)
	and tkEvent.Facility = 'SDS'
	and tkOdet.I_PT not in ('P', 'SR', 'vi')
	and tkEvent.ETYPE = 'F'
	and tkOdet.I_PRICE > 0
	and tkOdet.I_PAY > 0
group by tkOdet.Season, tkOdet.I_PT
UNION ALL
select 
	tkOdet.Season
	,'Single Game'
,sum(tkOdet.I_OQTY) as Qty
,sum((tkOdet.I_OQTY * (CASE When tkevent.event = 'F02' Then 50 WHEN TKEVENT.EVENT = 'F04' THEN 50 ELSE 40 END)))as Amt
from tk_odet tkOdet
join tk_event tkEvent
on tkOdet.Item = tkEvent.Event
and tkOdet.season = tkEvent.season
where tkOdet.season in (@curSeason, @prevSeason)
	and tkEvent.Facility = 'SDS'
	and tkOdet.I_PT = ('vi')
	and tkEvent.ETYPE = 'F'
group by tkOdet.Season, tkOdet.I_PT
-- Season Ticket Accts 

set @SeasonTicketAcctsCY = (
	select COUNT (distinct tkOdet.CUSTOMER) Accts	
	from tk_odet tkOdet with (nolock) 
	join TK_ITEM tkItem with (nolock)
		on tkOdet.SEASON = tkItem.SEASON
		and tkOdet.ITEM = tkItem.ITEM
	where tkOdet.season in (@curSeason)
		and tkItem.CLASS = 'FS'
		and tkOdet.I_PL <> '5'
		and tkOdet.I_PAY > 0
	group by tkOdet.Season
)

set @SeasonTicketAcctsPY = (
	select COUNT (distinct tkOdet.CUSTOMER) Accts	
	from tk_odet tkOdet with (nolock) 
	join TK_ITEM tkItem with (nolock)
		on tkOdet.SEASON = tkItem.SEASON
		and tkOdet.ITEM = tkItem.ITEM
	where tkOdet.season in (@prevSeason)
		and tkItem.CLASS = 'FS'
		and tkOdet.I_PL <> '7'
		and tkOdet.I_PAY > 0
	group by tkOdet.Season
)


select 
	PrevYR.saleTypeName 
	,PrevYR.prevQty
	,budget.priorYear as prevAmt
	,CurYR.CurQty
	,CurYR.CurAmt
	,convert(decimal(12,2),budget.amount) Budget
from
(select saleTypeName, SUM(qty) as prevQty, SUM(amt) as prevAmt from #seasonsummary a where cast(right(season,2) as int) = right(@prevseason,2) group by saleTypeName) PrevYR
left outer join (select saleTypeName, SUM(qty) as curQty, SUM(amt) as curAmt from #seasonsummary a where cast(right(season,2) as int) = right(@curseason,2) group by saleTypeName) CurYR
on PrevYR.saleTypeName = CurYR.saleTypeName
left outer join #budget budget
on PrevYR.saleTypeName = budget.saleTypeName

union all

select 'Donor Accts', @DonationPYAccts, @DonationPY, @DonationCYAccts, @DonationCY, @DonationCYPledge

union all

select 'Season Ticket Accts', @SeasonTicketAcctsPY, null, @SeasonTicketAcctsCY, null, null

END








GO
