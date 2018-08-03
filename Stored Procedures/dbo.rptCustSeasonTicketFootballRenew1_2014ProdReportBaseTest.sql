SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO












--EXEC rptCustSeasonTicketFootballRenew1_2014Prod



--exec  [dbo].[rptCustSeasonTicketFootballRenew1_2014ProdReportBaseTest] 

--exec rptCustSeasonTicketFootballRenew1_2014Build


CREATE         PROCEDURE [dbo].[rptCustSeasonTicketFootballRenew1_2014ProdReportBaseTest] 

as 
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @curSeason varchar(50)
declare @prevSeason varchar(50)
declare @studentprevSeason varchar(50)
declare @studentcurSeason varchar(50)

Set @prevSeason = 'F13'
Set @curSeason = 'F14'
set @studentprevSeason = 'AP13'
Set @studentcurSeason = 'AP14'



----------------------------------------------------------------------------------

--BEGIN

Create table   #budget 
(
	saleTypeName varchar(100)
	,amount int
)

insert into #budget
--Budget and Prior Year Revenue
Select 'Mini Plans FSE', '80000'  UNION ALL
Select 'Season', '3721600' UNION ALL
Select 'Season Suite', '322000'   UNION ALL
Select 'Single Game Tickets', '4675000' UNION ALL
Select 'Single Game Suite', '182200' UNION ALL 
Select 'MBSC', '20000'    
--Select 'Student Guest Pass', '0'        UNION ALL
--Select 'Student Season', '1182984'









---- Build Report --------------------------------------------------------------------------------------------------


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
 FROM vwTIReportBase rb where rb.SEASON IN ( @prevSeason,@curSeason, @studentprevSeason,  @studentcurSeason) 


-----------------------------------------------------------------------------------------
Declare @SeasonSummary table 
(
	season varchar(100)
	,saleTypeName  varchar(50)
	,qty  int
	,amt money
)


insert into @SeasonSummary
(
 season
 ,saleTypeName
,qty
,amt
)


-----------------------------------------------------------------------------
--SEASON 
--Previous  and Current SEASON  
SELECT 
	  SEASON 
	 ,'Season'
	 ,SUM(ORDQTY) QTY
	 ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where ITEM = 'FS' AND E_PL not in ('10')  AND SEASON in (@prevSeason, @curSeason)
	AND ( PAIDTOTAL > 0 OR CUSTOMER in ('152760','164043','186078' ) )
	AND CUSTOMER <> '137398'
GROUP BY CUSTOMER , SEASON 

-----------------------------------------------------------------------------------------
UNION ALL 
--SEASON 
--Previous  and Current SEASON  
SELECT 
	  SEASON 
	 ,'MBSC'
	 ,case when ITEM like 'F0[1-6]%' then  SUM(ORDQTY)/6 else 
	  SUM(ORDQTY) end QTY
	 ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where( ITEM = 'FSC' or (ITEM like 'F0[1-6]%' and E_PL = '11') ) 
AND SEASON IN (@curSeason)
	AND  PAIDTOTAL > 0
GROUP BY CUSTOMER , ITEM, SEASON 

UNION ALL 
SELECT 
	  'F13' 
	 ,'MBSC'
	 ,0 QTY
	 ,0 AMT


-----------------------------------------------------------------------------------------



















--Student Season 
--UNION ALL 

--Previous  
--SELECT 
--	 SEASON 
--	 ,'Student Season'
--	,SUM(ORDQTY) QTY
--	--,SUM(ORDTOTAL) AMT
--	,SUM(ORDQTY * (I_PRICE - 30) - I_DAMT) AMT
--FROM #ReportBase 
--where ITEM LIKE 'FSB%'
--	   AND SEASON in  (@prevSeason,@studentprevSeason)
--	AND ( PAIDTOTAL > 0 )
--GROUP BY SEASON 

--Current 
--SELECT 
--	 SEASON 
--	 ,'Student Season'
--	--,SUM(ORDQTY) QTY
--	,0 as Qty
--	--,SUM(ORDQTY * (I_PRICE - 30) - I_DAMT) AMT
--	,0 as AMT 
--FROM #ReportBase 
--where ITEM LIKE 'FSB%'
--	   AND SEASON in  (@prevSeason,@studentprevSeason,@curSeason,@studentcurSeason)
--	AND ( PAIDTOTAL > 0 )
--GROUP BY SEASON 


-------------------------------------------------------------------------------------------------
--Student Guest Pass 
--UNION ALL 

--PREVIOUS AND CURRENT SEASON 
--SELECT 
--	 SEASON 
--	 ,'Student Guest Pass'
--	,SUM(ORDQTY) QTY
--	,SUM(ORDTOTAL) AMT
--FROM #ReportBase 
--where ITEM = 'FSGP'  
--	   AND SEASON in  (@prevSeason,@studentprevSeason,@curSeason,@studentcurSeason)
--	AND ( PAIDTOTAL > 0 )
--GROUP BY SEASON 

------------------------------------------------------------------------------------------------------
--MINI PACKS 
UNION ALL 

SELECT 
	 SEASON 
	 ,'Mini Plans FSE'
	 ,CASE WHEN ITEM LIKE '2%' THEN  SUM(ORDQTY) * 2/6
	       WHEN ITEM LIKE '3%' THEN SUM(ORDQTY) * 3/6
	       WHEN ITEM LIKE '4%' THEN SUM(ORDQTY) * 4/6
	       WHEN ITEM LIKE '5%' THEN SUM(ORDQTY) * 5/6
		END AS QTY
	,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where  ITEM like '[2-5]%'  
	   AND SEASON in (@curSeason)
	   AND ( PAIDTOTAL > 0 )
GROUP BY SEASON , ITEM   

--MINI PACKS 
UNION ALL 

SELECT 
	 SEASON 
	 ,'Mini Plans FSE'
	 ,CASE WHEN ITEM LIKE '2%' THEN  SUM(ORDQTY) * 2/7
	       WHEN ITEM LIKE '3%' THEN SUM(ORDQTY) * 3/7
	       WHEN ITEM LIKE '4%' THEN SUM(ORDQTY) * 4/7
	       WHEN ITEM LIKE '5%' THEN SUM(ORDQTY) * 5/7
		END AS QTY
	,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where  ITEM like '[2-5]%'  
	   AND SEASON in ( @prevSeason)
	   AND ( PAIDTOTAL > 0 )
GROUP BY SEASON , ITEM   




----------------------------------------------------------------------------------------------------
--SEASON SUITE
UNION ALL 
--
SELECT 
	 SEASON 
	 ,'Season Suite'
	,COUNT(ITEM) QTY
	,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where ITEM in ('FSS','FSSUITE')  
	   AND SEASON in  (@curSeason, @prevSeason)
	AND ( PAIDTOTAL > 0 )
GROUP BY SEASON 

------------------------------------------------------------------------------
--UNION ALL 
----Previous year DONSUITE 
--SELECT 
--	 'F13' AS SEASON 
--	 ,'Donation Suite'
--	,0 AS  QTY
--	,578477  AMT
	
	
--UNION ALL 


----DONSUITE 
--SELECT 
--	 SEASON 
--	 ,'Donation Suite'
--	,0 AS  QTY
--	,SUM(ORDTOTAL) AMT
--FROM #ReportBase 
--where ITEM = 'DONSUITE'  
--	   AND SEASON in  (@curSeason)
--	AND ( PAIDTOTAL > 0 )
--GROUP BY SEASON 

--------------------------------------------------------------------------------------

UNION ALL 
	
--Single Game Suite Total
select 
	suite.SEASON
	,'Single Game Suite'
	,SUM(Suite.QTY) as QTY
	,SUM(Suite.AMT + ISNULL(Donation.AMT, 0)) as AMT
From
(select 
	 rb.SEASON 
	,CUSTOMER
	,COUNT(CUSTOMER) QTY	
	,SUM(ORDTOTAL) AMT
from #ReportBase rb 
    WHERE ITEM like 'F0[1-7]%'
	and rb.E_PL in ('10')
	and rb.I_PT in ('SP')
	and rb.SEASON in  (@prevSeason)
group by rb.CUSTOMER, rb.SEASON, rb.I_PT) suite
left outer join 
(select
	SEASON 
	,CUSTOMER
	,SUM(ORDTOTAL) AMT
from #ReportBase
where SEASON in  (@prevSeason)
	and ITEM like 'SR0%'
group by CUSTOMER, SEASON) donation
on suite.SEASON = donation.Season
and suite.customer = donation.customer
and suite.SEASON = donation.SEASON 
group by suite.season


UNION ALL 
	
--Single Game Suite Total
select 
	suite.SEASON
	,'Single Game Suite'
	,SUM(Suite.QTY) as QTY
	,SUM(Suite.AMT + ISNULL(Donation.AMT, 0)) as AMT
From
(select 
	 rb.SEASON 
	,CUSTOMER
	,COUNT(CUSTOMER) QTY	
	,SUM(ORDTOTAL) AMT
from #ReportBase rb 
    WHERE ITEM like 'F0[1-6]%'
	and rb.E_PL in ('10')
	and rb.I_PT in ('SP')
	and rb.SEASON in  (@curSeason)
group by rb.CUSTOMER, rb.SEASON, rb.I_PT) suite
left outer join 
(select
	SEASON 
	,CUSTOMER
	,SUM(ORDTOTAL) AMT
from #ReportBase
where SEASON in  (@curSeason)
	and ITEM like 'SRO%'
group by CUSTOMER, SEASON) donation
on suite.SEASON = donation.Season
and suite.customer = donation.customer
and suite.SEASON = donation.SEASON 
group by suite.season

--------------------------------------------------------------------------------------------------------
UNION ALL 

--previous year 

--Single Game Total
select 
	 rb.SEASON 
	,'Single Game Tickets'
,sum(ORDQTY) as Qty
,sum(ORDTOTAL) as Amt
from #ReportBase rb 
    WHERE rb.SEASON IN  (@prevSeason)
    and ITEM like 'F0[1-7]'
     and rb.E_PL not in  ('10') -- deals with single game suites for now 
	and rb.I_PT not in ('VI', 'V')
	and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.Season, rb.I_PT
UNION ALL
select 
	 rb.Season
	,'Single Game Tickets'
,sum(ORDQTY) as Qty
,sum((ORDQTY * (CASE When ITEM = 'F02' THEN 60 
					 WHEN ITEM = 'F03' THEN 60 
					 WHEN ITEM = 'F07' THEN 60 
					 ELSE 45 END)))as Amt
from #ReportBase rb
  WHERE rb.SEASON IN   (@prevSeason)
  and ITEM like 'F0[1-7]'
  AND rb.E_PL not in  ('10') -- deals with single game suites for now  
  AND rb.I_PT IN ('VI', 'V')
group by rb.SEASON, rb.I_PT

----------------------------------------------------------------------------------------

UNION ALL 
--current  game 

--Single Game Total
select 
	 rb.SEASON 
	,'Single Game Tickets'
,sum(ORDQTY) as Qty
,sum(ORDTOTAL) as Amt
from #ReportBase rb 
    WHERE rb.SEASON IN  (@curSeason) 
    and ITEM like 'F0[1-6]'
     and rb.E_PL not in  ('10','11') -- deals with single game suites for now 
	and rb.I_PT not in ('V')
	and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.Season, rb.I_PT

UNION ALL
select 
	 rb.Season
	,'Single Game Tickets'
,sum(ORDQTY) as Qty
,sum((ORDQTY * (CASE When ITEM = 'F01' THEN 50 
					 WHEN ITEM = 'F02' THEN 50
					 WHEN ITEM = 'F03' THEN 65
					 WHEN ITEM = 'F04' THEN 65  
					 WHEN ITEM = 'F05' THEN 125
					 WHEN ITEM = 'F06' THEN 50 
					 END)))as Amt
from #ReportBase rb
  WHERE rb.SEASON IN  (@curSeason) 
  and ITEM like 'F0[1-6]'
  AND rb.E_PL not in  ('10', '11') -- deals with single game suites for now  
  AND rb.I_PT IN ('V')
group by rb.SEASON, rb.I_PT

-------------------------------------------------------------------------------------


select 

	   isnull(PrevYR.saleTypeName,'') as QtyCat
      ,isnull(PrevYR.prevQty,0)  as [PYQty]
	  ,isnull(CurYR.CurQty,0) as [CYQty]
	  ,isnull(CurYR.CurQty,0) - isnull(PrevYR.prevQty,0)  as [DiffVsPY]
	  ,isnull(budget.saleTypeName,'') as AmtCat
	  ,isnull(CurYR.CurAmt,0) as [CYAmt]
	  ,isnull(convert(decimal(12,2),budget.amount),0) as Budget
	  ,isnull(CurYR.CurAmt,0) - isnull(convert(decimal(12,2),budget.amount),0)  as Variance
	  ,case isnull(convert(decimal(12,2),budget.amount),0) when 0 then 0 else isnull(CurYR.CurAmt,0) / isnull(convert(decimal(12,2),budget.amount),0) end as PctToBudget
	  ,isnull(PrevYR.prevAmt,0)  as [PYAmt]
	  ,case isnull(PrevYR.prevAmt,0) when 0 then 0 else isnull(CurYR.CurAmt,0) / isnull(PrevYR.prevAmt,0) end as PctToPY

	
from
(select saleTypeName, SUM(qty) as prevQty, SUM(amt) 
as prevAmt from @seasonsummary a where cast(right(season,2) as int)
 = right(@prevseason,2) group by saleTypeName) PrevYR
left outer join (select saleTypeName, SUM(qty) as curQty, SUM(amt)
 as curAmt from @seasonsummary a where cast(right(season,2) as int) 
 = right(@curseason,2) group by saleTypeName) CurYR
on PrevYR.saleTypeName = CurYR.saleTypeName
left outer join #budget budget
on PrevYR.saleTypeName = budget.saleTypeName
order by 
	case PrevYR.saleTypeName
		when 'Single Game Suite' then 3
		when 'Single Game Tickets' then 5
		--when 'Student Guest Pass' then 2
		when 'Season' then 7
		when 'Season Suite' then 4
		--when 'Student Season' then 1
		when 'MBSC' then 8 
		when 'Mini Plans FSE' then 6 end



END















































GO
