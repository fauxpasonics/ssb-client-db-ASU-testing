SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE    proc [dbo].[rptCustSeasonTicketFootballRenew2_DateRange2013]
as

declare @currSeason varchar(50)
declare @prevSeason varchar(50)
declare @studentprevSeason varchar(50)
declare @studentCurrSeason varchar(50)

Set @prevSeason = 'F12'
Set @currSeason = 'F13'
set @studentprevSeason = 'AP12'
Set @studentCurrSeason = 'AP13'


begin


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


--Regular Season Ticket Previous Season
select 
      tkOdet.Season SEASON
      ,'Season' SALETYPENAME
      ,ISNULL(TIPRICELEVELMAP.PL_CLASS,'NOT CLASSIFIED') PL_CLASS
      , CASE WHEN tkOdet.I_PT like 'N%' THEN 0 WHEN tkOdet.I_PT like 'N%' then 0 ELSE 1 END as  RENEWAL
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
      AND TIPRICELEVELMAP.REPORTCODE =  'FT'
where tkOdet.season = @prevSeason
and tkItem.item in ('FS')
and tkOdet.I_PL <> '5'
and tkOdet.I_pay > 0
group by tkOdet.Season,tkOdet.i_pt, TIPRICELEVELMAP.PL_CLASS 

union all

--Regular Season Ticket Current Season
select 
      tkOdet.Season SEASON
      ,'Season' SALETYPENAME
      ,ISNULL(TIPRICELEVELMAP.PL_CLASS,'NOT CLASSIFIED') PL_CLASS
      , CASE WHEN tkOdet.I_PT like 'N%' THEN 0 WHEN tkOdet.I_PT like 'N%' then 0 ELSE 1 END as  RENEWAL
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
      AND TIPRICELEVELMAP.REPORTCODE =  'FT'
where tkOdet.season = @currSeason
and tkItem.item in ('FS')
and tkOdet.I_PL <> '5'
	and (tkOdet.I_PAY > 0 or tkOdet.CUSTOMER IN ('152760','164043','186078'))
group by tkOdet.Season,tkOdet.i_pt, TIPRICELEVELMAP.PL_CLASS 

UNION ALL

--Student Season Ticket Total Prior and Current Season
select 
	tkOdet.Season
	,'Student Season'
	,'Student Season'
	,0
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * ((tkOdet.I_PRICE - 30) - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@studentCurrSeason, @studentprevSeason) 
	and tkOdet.ITEM like 'FSB%'
	and tkOdet.I_PAY > 0
group by tkOdet.Season, tkOdet.I_PT



UNION ALL

--Student Season Ticket Total Prior Season
select 
	tkOdet.Season
	,'Student Season'
	,'Student Season'
	,0
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * ((tkOdet.I_PRICE - 30) - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@prevSeason) 
	and tkOdet.ITEM = 'FS'
	and tkOdet.I_PL = '5'
	and tkOdet.I_PAY > 0
group by tkOdet.Season, tkOdet.I_PT

UNION ALL

--Student Season Ticket Total Current Season
select 
	tkOdet.Season
	,'Student Season'
	,'Student Season'
	,0
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - 30 - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@currSeason)
	and tkOdet.ITEM = 'FS' 
	and tkOdet.I_PL = '5'
	and (tkOdet.I_PAY > 0 or tkOdet.CUSTOMER IN ('152760','164043','186078'))
group by tkOdet.Season, tkOdet.I_PT


------------------------------------------------------------------------------
--takes out customers ('18864','3498') from season tickets 

UNION ALL
select 
	tkOdet.Season
	,'Student Season'
	,'Student Season'
	,0
	,SUM(tkOdet.I_OQTY) * -1 QTY	
	,SUM(tkOdet.I_OQTY * ((tkOdet.I_PRICE - 30) - tkOdet.I_DAMT)) * -1 AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@prevSeason, @currSeason) 
	and tkOdet.ITEM = 'FS'
	and tkOdet.I_PL = '5'
	and tkOdet.I_PAY > 0
	and CUSTOMER in ('18864','3498')
group by tkOdet.Season, tkOdet.I_PT

UNION ALL
--add back customers ('18864','3498') from season tickets 
select 
      tkOdet.Season SEASON
      ,'Season' SALETYPENAME
      ,'$249/$279/$335 Level'  PL_CLASS
      , CASE WHEN tkOdet.I_PT like 'N%' THEN 0 WHEN tkOdet.I_PT like 'N%' then 0 ELSE 1 END as  RENEWAL
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
      AND TIPRICELEVELMAP.REPORTCODE =  'FT'
where tkOdet.season in (@prevSeason, @currSeason) 
and tkItem.item in ('FS')
and tkOdet.I_PL = '5'
and tkOdet.I_pay > 0
and CUSTOMER in ('18864','3498')
group by tkOdet.Season,tkOdet.i_pt, TIPRICELEVELMAP.PL_CLASS 

----------------------------------------------------------------------------------------






















UNION ALL
--Student Season Paper Ticket Current and Prior Season
select 
	tkOdet.Season
	,'Student Season'
	,'Student Season'
	,0
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock)
where tkOdet.season in (@currSeason, @prevSeason)
	and tkOdet.ITEM = 'FSB' 
	and tkOdet.I_PT in ('S', 'SN', 'STN')
	and tkOdet.I_PAY > 0
group by tkOdet.Season, tkOdet.I_PT

UNION ALL


--Student Guest Pass Total
 select 
	tkOdet.Season
	,'Student Guest Passes'
	,'Student Guest Passes'
	,0 RENEWAL
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock) 
where tkOdet.season in (@prevSeason, @currSeason)
	and tkOdet.ITEM = 'FSB' 
	and tkOdet.I_PT in ('GP', 'GPN', 'GP1')
	and tkOdet.I_PAY > 0
group by 
tkOdet.Season, tkOdet.I_PT

UNION ALL

--Student Guest Pass Total
 select 
	tkOdet.Season
	,'Student Guest Passes'
	,'Student Guest Passes'
	,0  RENEWAL
	,SUM(tkOdet.I_OQTY) QTY	
	,SUM(tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT)) AMT
from tk_odet tkOdet with (nolock) 
where tkOdet.season in ( @studentprevSeason,@studentCurrSeason)
	and tkOdet.ITEM in ('GP', 'GPN')
	and tkOdet.I_PAY > 0
group by 
tkOdet.Season, tkOdet.I_PT


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
					where season in (@prevSeason, @studentprevSeason)				
					 group by PL_CLASS)  bbPrev
		on PL.PL_CLASS = bbPrev.PL_CLASS  

left outer join (select PL_CLASS
	, sum(QTY) as bbCurRenewQty, sum(AMT) as bbCurRenewAmt 
					from #seasonsummary 
					where season in (@currSeason, @studentCurrSeason)	  
					and renewal = '1' 
					group by PL_CLASS) bbCurRenew
		on PL.PL_CLASS =  bbCurRenew.PL_CLASS 

left outer join (select PL_CLASS, sum(QTY) as bbCurNewQty, sum(AMT) as bbCurNewAmt 
					from #seasonsummary 
					where season in (@currSeason, @studentCurrSeason)	 
					 and renewal = '0' 
					group by PL_CLASS ) bbCurNew
		on PL.PL_CLASS =  bbCurNew.PL_CLASS 
left outer join dbo.TIPRICELEVELCAPACITY Capacity on PL.PL_CLASS=CAPACITY.PL_CLASS And CAPACITY.SEASON=@currSeason		
order by sortOrder

	
End













GO
