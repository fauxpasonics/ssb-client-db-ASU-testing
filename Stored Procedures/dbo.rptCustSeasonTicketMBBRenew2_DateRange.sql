SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE  proc [dbo].[rptCustSeasonTicketMBBRenew2_DateRange]
as

declare @curSeason varchar(50)
declare @prevSeason varchar(50)
declare @curFBSeason varchar(50)
declare @prevFBSeason varchar(50)
declare @studentprevSeason varchar(50)
declare @studentCurSeason varchar(50)

Set @prevSeason = 'BB11'
Set @curSeason = 'BB12'
Set @prevFBSeason = 'F11'
Set @curFBSeason = 'F12'
set @studentprevSeason = 'AP11'
Set @studentCurSeason = 'AP12'

begin

--create table #luMiniPack
--(
--	item varchar(100)
--	,gameQty  int
--	,prevSeasonTotalGameQty int
--	,curSeasonTotalGameQty int
--)

--insert into #luMiniPack Values ('6G', 6, 17, 19)
--insert into #luMiniPack Values ('3G', 3, 17, 19)
--insert into #luMiniPack Values ('SHP', 3, 17, 19)
--insert into #luMiniPack Values ('SHP1', 4, 17, 19)
--insert into #luMiniPack Values ('WHP', 6, 17, 19)
--insert into #luMiniPack Values ('WHP1', 4, 17, 19) 


create table #SeasonSummary
(
	season varchar(100)
	,saleTypeName  varchar(50)
	,pl_class varchar(50)
	,renewal int
	,qty  int
	,amt money
)


insert into #SeasonSummary
(
 season
,saleTypeName
,pl_class
,renewal
,qty
,amt
)

--Season Ticket Total 
select 
      tkOdet.Season SEASON
      ,'Season' SALETYPENAME
      ,ISNULL(TIPRICELEVELMAP.PL_CLASS,'NOT CLASSIFIED') PL_CLASS
      ,CASE WHEN tkOdet.I_PT like 'N%' THEN 0 ELSE 1 END as  RENEWAL
      ,SUM(tkOdet.I_OQTY) QTY 
      ,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock) 
join tk_item tkItem with (nolock)
on tkOdet.Season = tkItem.Season
and tkOdet.Item = tkItem.Item
LEFT join TIPRICELEVELMAP  on tkOdet.SEASON = TIPRICELEVELMAP.SEASON 
      AND tkOdet.ITEM = TIPRICELEVELMAP.ITEM
      AND tkOdet.I_PT = TIPRICELEVELMAP.I_PT 
      AND tkOdet.I_PL = TIPRICELEVELMAP.I_PL 
      AND TIPRICELEVELMAP.REPORTCODE =  'BBT'
where tkOdet.season in (@prevSeason, @CurSeason)
      and tkItem.CLASS = 'FS'
	and (tkOdet.I_PAY > 0 or tkOdet.CUSTOMER IN ('152760','164043','186078'))
group by tkOdet.Season,tkOdet.i_pt, TIPRICELEVELMAP.PL_CLASS 

UNION ALL


--Student Season Ticket Total - Combo
select 
	tkOdet.Season SEASON
	,'Student Season' SALETYPENAME 
	,'Students - Combo' PL_ClASS
	,CASE WHEN tkOdet.I_PT like 'N%' THEN 0 ELSE 1 END as  RENEWAL
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY *  30) AMT	
from tk_odet tkOdet with (nolock) 
where tkOdet.season in (@studentCurSeason, @studentPrevSeason) 
	and tkOdet.ITEM like 'FSB%'
	and tkOdet.I_PAY > 0
group by tkOdet.Season, tkOdet.I_PT

UNION ALL

--Football Student Season Paper Ticket 
select 
	tkOdet.Season  SEASON 
	,'Student Season' SALETYPENAME
	,'Students - Combo' PL_CLASS 
	,CASE WHEN tkOdet.I_PT like 'N%' THEN 0 ELSE 1 END as  RENEWAL
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * 30) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@curFBSeason, @prevFBSeason)
	and tkOdet.ITEM = 'FSB' 
	and tkOdet.I_PT in ('S', 'SN', 'STN')
	and tkOdet.I_PAY > 0
group by tkOdet.Season, tkOdet.I_PT

UNION ALL

select 
	tkOdet.Season  SEASON 
	,'Student Season' SALETYPENAME
	,'Students - Combo' PL_CLASS 
	,CASE WHEN tkOdet.I_PT like 'N%' THEN 0 ELSE 1 END as  RENEWAL
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * 30) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@prevFBSeason) 
	and tkOdet.ITEM = 'FS'
	and tkOdet.I_PL = '7'
	and tkOdet.I_PAY > 0
group by tkOdet.Season, tkOdet.I_PT

UNION ALL

select 
	tkOdet.Season  SEASON 
	,'Student Season' SALETYPENAME
	,'Students - Combo' PL_CLASS 
	,CASE WHEN tkOdet.I_PT like 'N%' THEN 0 ELSE 1 END as  RENEWAL
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * 30) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@curFBSeason) 
	and tkOdet.ITEM = 'FS'
	and tkOdet.I_PL = '5'
	and tkOdet.I_PAY > 0
group by tkOdet.Season, tkOdet.I_PT

UNION ALL

--Student Season Ticket Total - Basketball Only
select 
	tkOdet.Season  SEASON 
	,'Student Season' SALETYPENAME 
	,'Students - Basketball Only'  PL_ClASS
	,CASE WHEN tkOdet.I_PT like 'N%' THEN 0 ELSE 1 END as  RENEWAL
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock) 
where tkOdet.season in (@studentCurSeason, @studentprevSeason) 
	and tkOdet.ITEM like 'MSB%' or tkOdet.ITEM like 'MBS%'
	and tkOdet.I_PAY > 0
group by tkOdet.Season, tkOdet.I_PT

--UNION ALL

--Mini Pack Total

--select 
--	tkOdet.Season
--	,'Mini Packs' SALETYPENAME
--	,'Mini Packs' PL_CLASS 
--	,1 RENEWAL
--	,SUM(tkOdet.I_OQTY) QTY
--	,CASE 
--		WHEN tkOdet.SEASON = @curSeason 
--			THEN SUM(tkOdet.I_OQTY * luMiniPack.gameQty)/luMiniPack.curSeasonTotalGameQty
--	WHEN tkOdet.SEASON = @prevSeason
--			THEN SUM(tkOdet.I_OQTY * luMiniPack.gameQty)/luMiniPack.prevSeasonTotalGameQty
--	END as QTY
--	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
--from tk_odet tkOdet with (nolock)
--join TK_ITEM tkItem with (nolock)
--	on tkOdet.SEASON = tkItem.SEASON
--	and tkOdet.ITEM = tkItem.ITEM
--join #luMiniPack luMiniPack
--on tkOdet.ITEM = luMiniPack.item
--where tkOdet.season in (@curSeason, @prevSeason)
--	and tkItem.CLASS = 'MP'	
--group by tkOdet.Season--, luMiniPack.prevSeasonTotalGameQty, luMiniPack.curSeasonTotalGameQty



select 

	 PL.PL_CLASS 
	,bbPrev.bbPrevQty
	,bbPrev.bbPrevAmt
	,bbCurRenew.bbCurRenewQty
	,bbCurRenew.bbCurRenewAmt
	,bbCurNew.bbCurNewQty
	,bbCurNew.bbCurNewAmt
	,CAPACITY.CAPACITY capacity
	,isnull(CAPACITY.SORT_ORDER,998) sortOrder --998 to be last in sort order, but before 999 NOT CLASSIFIED
From (select distinct PL_CLASS from #seasonsummary) PL   
left outer join (select PL_CLASS, sum(QTY) as bbPrevQty, sum(AMT) as bbPrevAmt 
					from #seasonsummary 
					where season in (@prevSeason,@prevFBSeason,@studentprevSeason)				
					 group by PL_CLASS)  bbPrev
		on PL.PL_CLASS = bbPrev.PL_CLASS  

left outer join (select PL_CLASS
	, sum(QTY) as bbCurRenewQty, sum(AMT) as bbCurRenewAmt 
					from #seasonsummary 
					where season in (@curSeason,@curFBSeason,@studentcurSeason)	  
					and renewal = '1' 
					group by PL_CLASS) bbCurRenew
		on PL.PL_CLASS =  bbCurRenew.PL_CLASS 

left outer join (select PL_CLASS, sum(QTY) as bbCurNewQty, sum(AMT) as bbCurNewAmt 
					from #seasonsummary 
					where season in (@curSeason,@curFBSeason,@studentcurSeason)	 
					 and renewal = '0' 
					group by PL_CLASS ) bbCurNew
		on PL.PL_CLASS =  bbCurNew.PL_CLASS 
left outer join dbo.TIPRICELEVELCAPACITY Capacity on PL.PL_CLASS=CAPACITY.PL_CLASS And CAPACITY.SEASON=@curSeason		
order by sortOrder

	
End






GO
