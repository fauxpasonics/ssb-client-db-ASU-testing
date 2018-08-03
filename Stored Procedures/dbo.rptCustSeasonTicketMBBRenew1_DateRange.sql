SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO














CREATE proc [dbo].[rptCustSeasonTicketMBBRenew1_DateRange]
as

declare @curSeason varchar(50)
declare @prevSeason varchar(50)
declare @curFBSeason varchar(50)
declare @prevFBSeason varchar(50)
declare @studentprevSeason varchar(50)
declare @studentCurSeason varchar(50)
declare @DonationYearCY varchar(50), @DonationYearPY varchar(50), @DonationCY decimal(12,2), @DonationPY decimal(12,2), @DonationCYPledge decimal(12,2), @DonationCYAccts int, @DonationPYAccts int
declare @SeasonTicketAcctsCY int, @SeasonTicketAcctsPY int

Set @prevSeason = 'BB11'
Set @curSeason = 'BB12'
Set @prevFBSeason = 'F11'
Set @curFBSeason = 'F12'
set @studentprevSeason = 'AP11'
Set @studentCurSeason = 'AP12'
Set @DonationYearCY = '2012'
Set @DonationYearPY = '2011'



set @DonationCY = (
	select sum(l.transAmount) amount
	from dbo.ADVContactTransHeader (nolock) h
	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
	where p.ProgramCode = 'BKB'
	and h.transType = 'Cash Receipt'
	and h.transYear = @DonationYearCY
)

set @DonationPY = (
	select sum(l.transAmount) amount
	from dbo.ADVContactTransHeader (nolock) h
	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
	where p.ProgramCode = 'BKB'
	and h.transType = 'Cash Receipt'
	and h.transYear = @DonationYearPY	
)

set @DonationCYPledge = (
	select sum(l.transAmount) amount
	from dbo.ADVContactTransHeader (nolock) h
	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
	where p.ProgramCode = 'BKB'
	and h.transType = 'Cash Pledge'
	and h.transYear = @DonationYearCY
)

set @DonationCYAccts = (
	select count(distinct h.contactID) amount
	from dbo.ADVContactTransHeader (nolock) h
	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
	where 1=1
	and p.ProgramCode = 'BKB'
	and h.transType in ('Cash Pledge', 'Cash Receipt')
	and h.transYear = @DonationYearCY
)

set @DonationPYAccts = (
	select count(distinct h.contactID) amount
	from dbo.ADVContactTransHeader (nolock) h
	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
	where 1=1
	and p.ProgramCode = 'BKB'
	and h.transType in ('Cash Pledge', 'Cash Receipt')
	and h.transYear = @DonationYearPY
)



begin

create table #luMiniPack
(
	item varchar(100) COLLATE SQL_Latin1_General_CP1_CS_AS
	,gameQty  int
	,prevSeasonTotalGameQty int
	,curSeasonTotalGameQty int
)

--insert into #luMiniPack Values ('6G', 6, 17, 19)
--insert into #luMiniPack Values ('3G', 3, 17, 19)
--insert into #luMiniPack Values ('SHP', 5, 17, 19)
--insert into #luMiniPack Values ('SHP1', 4, 17, 19)
--insert into #luMiniPack Values ('WHP', 6, 17, 19)
--insert into #luMiniPack Values ('WHP1', 5, 17, 19) 
--insert into #luMiniPack Values ('WHP2', 4, 17, 19) 
--insert into #luMiniPack Values ('3P', 3, 17, 19)
--insert into #luMiniPack Values ('3PAZ', 3, 17, 19)
--insert into #luMiniPack Values ('6P', 6, 17, 19)
--insert into #luMiniPack Values ('9P', 9, 17, 19) 

insert into #luMiniPack Values ('6G', 6, 17, 19)
insert into #luMiniPack Values ('3G', 3, 17, 19)
insert into #luMiniPack Values ('SHP', 5, 17, 19)
insert into #luMiniPack Values ('SHP1', 4, 17, 19)
insert into #luMiniPack Values ('WHP', 6, 17, 19)
insert into #luMiniPack Values ('WHP1', 5, 17, 19) 
insert into #luMiniPack Values ('WHP2', 4, 17, 19) 
insert into #luMiniPack Values ('3P', 3, 17, 19)
insert into #luMiniPack Values ('3PAZ', 3, 17, 19)
insert into #luMiniPack Values ('6P', 6, 17, 19)
insert into #luMiniPack Values ('9P', 9, 17, 19) 
insert into #luMiniPack Values ('9PF', 9, 17, 19) 
insert into #luMiniPack Values ('2P', 2, 17, 19)  


create table #budget
(
	saleTypeName varchar(100)
	,amount int
)

insert into #budget

Select 'Season Sales', '342052' UNION ALL
Select 'Student Season', '270783' UNION ALL
Select 'Single Game Sales', '487165' UNION ALL
Select 'Mini Packs FSE', '25000' 

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



--************************
-- REGULAR SEASON TICKETS
--************************

--Season Ticket Total Current Year
select 
	tkOdet.Season
	,'Season Sales'
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock) 
join TK_ITEM tkItem with (nolock)
	on tkOdet.SEASON = tkItem.SEASON
	and tkOdet.ITEM = tkItem.ITEM
where tkOdet.season in (@curSeason,@prevSeason)
	--and tkOdet.ITEM = 'BS'
	and tkItem.CLASS = 'FS'
	and (tkOdet.I_PAY > 0 or tkOdet.CUSTOMER IN ('152760','164043','186078'))
group by tkOdet.Season

UNION ALL
--************************
-- STUDENT SEASON TICKETS
--************************

select 
	tkOdet.Season
	,'Student Season'
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * 30) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@studentCurSeason, @studentPrevSeason) 
	and tkOdet.ITEM like 'FSB%'
	and tkOdet.I_PAY > 0
group by tkOdet.Season


UNION ALL

select 
	tkOdet.Season
	,'Student Season'
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * 30) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@curFBSeason, @prevFBSeason)
	and tkOdet.ITEM = 'FSB' 
	and tkOdet.I_PT in ('S', 'SN', 'STN')
	and tkOdet.I_PAY > 0
group by tkOdet.Season

UNION ALL

--Student Season Ticket Total Prior Year
select 
	tkOdet.Season
	,'Student Season'
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * 30) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@prevFBSeason) 
	and tkOdet.ITEM = 'FS'
	and tkOdet.I_PL = '7'
	and tkOdet.I_PAY > 0
group by tkOdet.Season

UNION ALL

--Student Season Paper Ticket Current Year
select 
	tkOdet.Season
	,'Student Season'
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * 30) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@curFBSeason)
	and tkOdet.ITEM = 'FS' 
	and tkOdet.I_PL = '5'
	and tkOdet.I_PAY > 0
group by tkOdet.Season

UNION ALL
--Student Season Basketball Only Ticket Total
select 
	tkOdet.Season
	,'Student Season'
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@studentCurSeason, @studentPrevSeason) 
	and (tkOdet.ITEM like 'MBS%' or tkOdet.ITEM like 'MSB%')
	and tkOdet.I_PAY > 0
group by tkOdet.Season

UNION ALL

select 'BB11', 'Student Guest Passes', 0, 0


UNION ALL

select 'BB12', 'Student Guest Passes', 0, 0


UNION ALL

--************************
-- MINI PACKS
--************************

--Mini Plans Total
select 
	tkOdet.Season
	,'Mini Packs FSE'
	,CASE 
		WHEN tkOdet.SEASON = @curSeason 
			THEN SUM(tkOdet.I_OQTY * luMiniPack.gameQty)/luMiniPack.curSeasonTotalGameQty
	WHEN tkOdet.SEASON = @prevSeason
			THEN SUM(tkOdet.I_OQTY * luMiniPack.gameQty)/luMiniPack.prevSeasonTotalGameQty
	END as QTY
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock)
join TK_ITEM tkItem with (nolock)
	on tkOdet.SEASON = tkItem.SEASON
	and tkOdet.ITEM = tkItem.ITEM
join #luMiniPack luMiniPack
on tkOdet.ITEM = luMiniPack.item
where tkOdet.season in (@curSeason, @prevSeason)
	and tkItem.CLASS = 'MP'	
group by tkOdet.Season, luMiniPack.prevSeasonTotalGameQty, luMiniPack.curSeasonTotalGameQty


UNION ALL

--************************
-- INDIVIDUAL GAME TICKETS
--************************

--Individual Game Sales
select
	tkOdet.Season
	,'Single Game Sales'
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock) 
join TK_ITEM tkItem with (nolock)
	on tkOdet.SEASON = tkItem.SEASON
	and tkOdet.ITEM = tkItem.ITEM
where tkOdet.season in (@curSeason, @prevSeason)
	--and tkOdet.ITEM = 'BS'
	and tkItem.CLASS = 'S'
	and tkOdet.I_PAY > 0
group by tkOdet.Season




--************************
-- Season Ticket Accts 
--************************

set @SeasonTicketAcctsCY = (
	select COUNT (distinct tkOdet.CUSTOMER) Accts	
	from tk_odet tkOdet with (nolock) 
	join TK_ITEM tkItem with (nolock)
		on tkOdet.SEASON = tkItem.SEASON
		and tkOdet.ITEM = tkItem.ITEM
	where tkOdet.season in (@curSeason)
		--and tkOdet.ITEM = 'BS'
		and tkItem.CLASS = 'FS'
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
		--and tkOdet.ITEM = 'BS'
		and tkItem.CLASS = 'FS'
		and tkOdet.I_PAY > 0
	group by tkOdet.Season
)

select 
	PrevYR.saleTypeName 
	,PrevYR.prevQty
	,PrevYr.prevAmt
	,CurYR.CurQty
	,CurYR.CurAmt
	,budget.amount as budget
from
(select saleTypeName
, SUM(qty) as prevQty
, SUM(amt) as prevAmt 
from #seasonsummary a where cast(right(season,2) as int) = right(@prevseason,2) group by saleTypeName) PrevYR
left outer join (select saleTypeName, SUM(qty) as curQty, SUM(amt) as curAmt 
from #seasonsummary a where cast(right(season,2) as int) = right(@curseason,2) group by saleTypeName) CurYR
on PrevYR.saleTypeName = CurYR.saleTypeName
left outer join #budget budget
on PrevYR.saleTypeName = budget.saleTypeName

union all

select 'Donor Accts', @DonationPYAccts, @DonationPY, @DonationCYAccts, @DonationCY, @DonationCYPledge

union all

select 'Season Ticket Accts', @SeasonTicketAcctsPY, null, @SeasonTicketAcctsCY, null, null

END















GO
