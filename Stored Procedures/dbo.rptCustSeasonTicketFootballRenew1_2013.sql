SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








--exec rptCustSeasonTicketFootballRenew1_2013test

CREATE  PROCEDURE [dbo].[rptCustSeasonTicketFootballRenew1_2013] 

as 
BEGIN

declare @curSeason varchar(50)
declare @prevSeason varchar(50)
declare @studentprevSeason varchar(50)
declare @studentCurSeason varchar(50)
declare @DonationYearCY varchar(50), @DonationYearPY varchar(50)
, @DonationCYFTB decimal(12,2)
, @DonationCYCLUB decimal(12,2)
, @DonationPYFTB decimal(12,2)
, @DonationPYCLUB decimal(12,2)
, @DonationCYPledge decimal(12,2), @DonationCYAccts int, @DonationPYAccts int
declare @SeasonTicketAcctsCY int, @SeasonTicketAcctsPY int

Set @prevSeason = 'f12'
Set @curSeason = 'f13'
set @studentprevSeason = 'AP12'
Set @studentCurSeason = 'AP13'
Set @DonationYearCY = '2013'
Set @DonationYearPY = '2012'


--Donation Accts and Donations
set @DonationCYFTB = (
	select sum(l.transAmount) amount
	from dbo.ADVContactTransHeader (nolock) h
	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
	where p.ProgramCode in ('FTB') 
	and h.transType = 'Cash Receipt'
	and h.transYear = @DonationYearCY
)

set @DonationCYCLUB = (
	select sum(l.transAmount) amount
	from dbo.ADVContactTransHeader (nolock) h
	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
	where p.ProgramCode in ('SCLUB') 
	and h.transType = 'Cash Receipt'
	and h.transYear = @DonationYearCY
)


set @DonationPYFTB = (
	select ( sum(l.transAmount) - 71400 ) as amount
	from dbo.ADVContactTransHeader (nolock) h
	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
	where p.ProgramCode = 'FTB'
	and h.transType = 'Cash Receipt'
	and h.transYear =   @DonationYearPY	
)

set @DonationPYCLUB = 71400 

set @DonationCYPledge = (
	select sum(l.transAmount) amount
	from dbo.ADVContactTransHeader (nolock) h
	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
	where p.ProgramCode  in ('FTB', 'SCLUB')
	and h.transType = 'Cash Pledge'
	and h.transYear = @DonationYearCY
)


--set @DonationCYAccts = (
--	select count(distinct h.contactID) amount
--	from dbo.ADVContactTransHeader (nolock) h
--	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
--	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
--	where 1=1
--	and p.ProgramCode in ('FTB', 'SCLUB')
--	and h.transType in ('Cash Receipt')
--	and h.transYear = @DonationYearCY
--)



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
--BEGIN

create table #budget
(
	saleTypeName varchar(100)
	,amount int
	,priorYear int
)

insert into #budget
--Budget and Prior Year Revenue
Select 'Mini Packs FSE', '87500', '15465' UNION ALL
Select 'Season / MBSC', '3042040', '2608358' UNION ALL
Select 'Season Suite', '500000', '431854' UNION ALL
Select 'Single Game Tickets', '5350139', '3567944' UNION ALL
Select 'Single Game Suite', '170000', '162690'  UNION ALL
Select 'Student Guest Pass', '0', '37680' UNION ALL
Select 'Student Season', '1182984' , '889218'


CREATE TABLE #pSeasons (Season varchar (50)) 
--INSERT INTO #pSeasons  select * FROM dbo.split (@Season,',') 
--Insert into #pSeasons values ('F12')
Insert into #pSeasons values ('F13')
--Insert into #pSeasons values ('AP12')
Insert into #pSeasons values ('AP13')


-- Create #SalesBase --------------------------------------------------------------------------------------------------


Create table #SalesBase 
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

) 

Insert Into #SalesBase
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

)

select
     tkTrans.SEASON
	,tkTransItem.CUSTOMER
	,tkTransItem.ITEM
	,tkTransItemEvent.E_PL
	,tkTransItem.I_PT
	,tkTransItem.I_PRICE
	,tkTransItem.I_DAMT 
	,sum(isnull(tkTransItem.I_OQTY_TOT,0)) ORDQTY
	,sum(((isnull(tkTransItem.I_OQTY_TOT,0) * isnull(I_Price,0)) - isnull(I_Damt,0)))   as ORDTOTAL
	
FROM 
	dbo.TK_TRANS tkTrans
	INNER JOIN dbo.TK_TRANS_ITEM tkTransItem
	 on tkTrans.Season = tkTransItem.Season
	 and tkTrans.Trans_No = tkTransItem.Trans_No
	 	 
	 
	LEFT JOIN 
	 (select
	   subtkTransItemEvent.SEASON,
	   max(isnull(subtkTransItemEvent.E_PL,999)) E_PL,
	   subtkTransItemEvent.TRANS_NO,
	   subtkTransItemEvent.VMC
	  FROM
	   dbo.TK_TRANS_ITEM_EVENT subtkTransItemEvent
	  INNER JOIN  #pSeasons subpSeasons
	   on subtkTransItemEvent.SEASON = subpSeasons.Season
	  group by
	   subtkTransItemEvent.SEASON,
	   subtkTransItemEvent.TRANS_NO,
	   subtkTransItemEvent.VMC) tkTransItemEvent
			on tkTransItem.SEASON = tkTransItemEvent.SEASON 
			and tkTransItem.TRANS_NO = tkTransItemEvent.TRANS_NO 
			and tkTransItem.VMC = tkTransItemEvent.VMC
	
	INNER JOIN  dbo.TK_ITEM tkItem
	 on tkTransItem.SEASON = tkItem.SEASON and tkTransItem.ITEM = tkItem.ITEM
	 
     INNER JOIN  #pSeasons Seasons
	   on tkTrans.SEASON = Seasons.Season
	
	--LEFT OUTER JOIN dbo.TK_PTABLE_PRLEV tkPTablePRLev
	-- on tkTransItem.SEASON = tkPTablePRLev.SEASON and tkItem.ptable = tkPTablePRLev.ptable
	--  and tkTransItemEvent.E_PL = tkPTablePRLev.PL
	

where
	tkTrans.SOURCE <> 'TK.ERES.SH.PURCHASE'
    and   (tkTrans.E_STAT not in ( 'MI','MO','TO','TI','EO','EI') or tkTrans.E_STAT IS NULL)

     
group by
	 tkTrans.SEASON
	,tkTransItem.CUSTOMER
 	,tkTransItem.ITEM
	,tkTransItemEvent.E_PL
	,tkTransItem.I_PT 
	,tkTransItem.I_PRICE 
	,tkTransItem.I_DAMT 




-- Create #PaidFinal --------------------------------------------------------------------------------------------------


Create table #PaidFinal
( 
  CUSTOMER varchar (20)
 ,MINPAYMENTDATE datetime 
 ,ITEM varchar (32) 
 ,E_PL varchar (10)
 ,I_PT  varchar (32)
 ,I_PRICE  numeric (18,2)  
 ,PAIDTOTAL numeric (18,2)
 ,SEASON varchar (15) 
) 

Insert Into #PaidFinal
(
  CUSTOMER
 ,MINPAYMENTDATE 
 ,ITEM
 ,E_PL
 ,I_PT
 ,I_PRICE
 ,PAIDTOTAL
 ,SEASON 
)

select
	tkTransItem.CUSTOMER
	,min(tkTrans.DATE) minPaymentDate 
	,tkTransItem.ITEM
	,tkTransItemEvent.E_PL
	,tkTransItem.I_PT
	,tkTransItem.I_PRICE 
	,SUM(ISNULL((tkTransItemPaymode.I_PAY_PAMT ),0))  PAIDTOTAL
	,tkTransItem.SEASON 

FROM
	dbo.TK_TRANS tkTrans
	INNER JOIN dbo.TK_TRANS_ITEM tkTransItem
	on tkTrans.Season = tkTransItem.Season
	 and tkTrans.Trans_No = tkTransItem.Trans_No
	LEFT JOIN 
	 (select
	   subtkTransItemEvent.SEASON,
	   max(isnull(subtkTransItemEvent.E_PL,5)) E_PL,
	   subtkTransItemEvent.TRANS_NO,
	   subtkTransItemEvent.VMC
	  FROM
	   dbo.TK_TRANS_ITEM_EVENT subtkTransItemEvent
	  INNER JOIN #pSeasons subpSeasons
	   on subtkTransItemEvent.SEASON = subpSeasons.Season
	  group by
	   subtkTransItemEvent.SEASON,
	   subtkTransItemEvent.TRANS_NO,
	   subtkTransItemEvent.VMC) tkTransItemEvent
	    on tkTransItem.SEASON = tkTransItemEvent.SEASON
	     and tkTransItem.TRANS_NO = tkTransItemEvent.TRANS_NO
	     and tkTransItem.VMC = tkTransItemEvent.VMC
	
		inner join dbo.TK_TRANS_ITEM_PAYMODE tkTransItemPaymode 
		ON tkTransItem.SEASON = tkTransItemPaymode.SEASON 
		and tkTransItem.TRANS_NO = tkTransItemPaymode.TRANS_NO 
		and tkTransItem.VMC = tkTransItemPaymode.VMC


	
	INNER JOIN  dbo.TK_ITEM tkItem
	 on tkTransItem.SEASON = tkItem.SEASON and tkTransItem.ITEM = tkItem.ITEM
	 
	INNER JOIN  #pSeasons Seasons
	   on tkTrans.SEASON = Seasons.Season 
	 
	LEFT OUTER JOIN dbo.TK_PTABLE_PRLEV tkPTablePRLev
	 on tkTransItem.SEASON = tkPTablePRLev.SEASON and tkItem.ptable = tkPTablePRLev.ptable
	  and tkTransItemEvent.E_PL  = tkPTablePRLev.PL
	  
	  

where
	tkTrans.SOURCE <> 'TK.ERES.SH.PURCHASE'
    and   (tkTrans.E_STAT not in ( 'MI','MO','TO','TI','EO','EI') or tkTrans.E_STAT IS NULL)
    AND tkTransItemPaymode.I_PAY_TYPE = 'I'

group by
	 tkTransItem.CUSTOMER
	,tkTransItem.ITEM
	,tkTransItemEvent.E_PL
	,tkTransItem.I_PT
	,tkTransItem.I_PRICE
	,tkTransItem.Season
having SUM(ISNULL((tkTransItemPaymode.I_PAY_PAMT ),0)) > 0 	

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

Insert into #ReportBase 
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

select 
	 SalesBase.SEASON
	,SalesBase.CUSTOMER 
	,SalesBase.ITEM
	,SalesBase.E_PL
	,SalesBase.I_PT
	,SalesBase.I_PRICE  
    ,SalesBase.I_DAMT 
	,SalesBase.ORDQTY
	,SalesBase.ORDTOTAL
	,PaidFinal.CUSTOMER as PAIDCUSTOMER 
	,PaidFinal.MINPAYMENTDATE
	,isnull(PaidFinal.PAIDTOTAL,0) PAIDTOTAL 
 
	from #SalesBase  SalesBase 

	   LEFT JOIN  #PaidFinal PaidFinal
	  on    SalesBase.CUSTOMER = PaidFinal.CUSTOMER
	    and SalesBase.SEASON = PaidFinal.SEASON 
        and SalesBase.ITEM = PaidFinal.ITEM
        and isnull(SalesBase.E_PL,99)  = isnull(PaidFinal.E_PL,99) 
        and isnull(SalesBase.I_PT,99) = isnull(PaidFinal.I_PT,99) 
        and SalesBase.I_PRICE = PaidFinal.I_PRICE
  WHERE SalesBase.ORDQTY <> 0 


----------------------------------------------------------------------------------------------
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
--PREVIOUS SEASON  
SELECT 
	  
     'F12' AS SEASON 
	 ,'Season / MBSC'
	,'22103' qty 
	,'2707042' amt 

UNION ALL 

--CURRENT SEASON 
SELECT 
	  SEASON 
	 ,'Season / MBSC'
	,SUM(ORDQTY) QTY
	,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where ITEM = 'FS' AND E_PL not in ('10')  AND SEASON in (@curSeason)
	AND ( PAIDTOTAL > 0 OR CUSTOMER in ('152760','164043','186078' ) )
	AND CUSTOMER <> '137398'
GROUP BY CUSTOMER , SEASON 


-----------------------------------------------------------------------------------------


UNION ALL 
SELECT 
	 'F12' SEASON 
	 ,'Student Season'
	,'10137' QTY
	,'1183222'  AMT



-------------------------------------------------------------------------------------------------
--Work with 2 accounts that are coded incorrectly in system and will not be changed



UNION ALL 

SELECT 
	 SEASON 
	 ,'Student Season'
	,SUM(ORDQTY) QTY
	--,SUM(ORDTOTAL) AMT
	,SUM(ORDQTY * (I_PRICE - I_DAMT - 30)) AMT
FROM #ReportBase 
where ITEM LIKE 'FSB%'
	   AND SEASON in  (@curSeason,@studentCurSeason)
	AND ( PAIDTOTAL > 0 )
GROUP BY SEASON 

--SELECT * FROM TK_ODET WHERE SEASON = 'F13' AND ITEM LIKE 'FSB%'

UNION ALL 
SELECT 
	 'F12' SEASON 
	 ,'Student Guest Pass'
	,'113' QTY
	,'21935'  AMT


UNION ALL 
SELECT 
	 SEASON 
	 ,'Student Guest Pass'
	,SUM(ORDQTY) QTY
	,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where ITEM = 'FSGP'  
	   AND SEASON in   (@curSeason,@studentCurSeason)
	AND ( PAIDTOTAL > 0 )
GROUP BY SEASON 

------------------------------------------------------------------------------------------------------
UNION ALL 
SELECT 
	 'F12' SEASON 
	 ,'Mini Packs FSE'
	,'363' QTY
	,'141839'  AMT

--7 HOME GAMES FOR 2013 
UNION ALL
SELECT 
	 SEASON 
	 ,'Mini Packs FSE'
	 ,CASE WHEN ITEM LIKE '2%' THEN  SUM(ORDQTY) * 2/7
	       WHEN ITEM LIKE '3%' THEN SUM(ORDQTY) * 3/7
	       WHEN ITEM LIKE '4%' THEN SUM(ORDQTY) * 4/7
	       WHEN ITEM LIKE '5%' THEN SUM(ORDQTY) * 5/7
		END AS QTY
	,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where  ITEM like '[2-5]%'  
	   AND SEASON in (@curSeason)
	   AND ( PAIDTOTAL > 0 )
GROUP BY SEASON , ITEM   


----------------------------------------------------------------------------------------------------
UNION ALL 
SELECT 
	 'F12' SEASON 
	 ,'Season Suite'
	,'23' QTY
	,'346117' AMT



UNION ALL

--Season Suites Total
select 
	suite.SEASON
	,'Season Suite'
	,SUM(Suite.QTY) as QTY
	,SUM(Suite.AMT + Donation.AMT) as AMT
From

(select
	SEASON
	,COUNT(CUSTOMER) QTY	
	,SUM(ORDTOTAL) AMT
from #ReportBase
	WHERE SEASON in  (@curSeason)
	and ITEM in ('FSS') 
	and I_PT = 'P'
group by SEASON) Suite
left outer join 
(select
	SEASON
	,SUM(ORDTOTAL) AMT
from #ReportBase
		WHERE SEASON in (@curSeason)
		and ITEM in ('SUITE') 
	
group by SEASON
)
donation
on suite.season = donation.Season
group by suite.SEASON 


UNION ALL 
SELECT 
	 'F12' SEASON 
	 ,'Single Game Suite'
	,'46' QTY
	,'154265' AMT


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
group by rb.CUSTOMER, rb.SEASON, rb.I_PT) suite
left outer join 
(select
	SEASON 
	,CUSTOMER
	,SUM(ORDTOTAL) AMT
from #ReportBase
where SEASON in (@curSeason)
	and ITEM like 'SR0%'
group by CUSTOMER, SEASON) donation
on suite.SEASON = donation.Season
and suite.customer = donation.customer
group by suite.season


--------------------------------------------------------------------------------------------------------
UNION ALL 
SELECT 
	 'F12' SEASON 
	 ,'Single Game Tickets'
	,'76314' QTY
	,'3192604' AMT

UNION ALL



--Single Game Total
select 
	 rb.SEASON 
	,'Single Game Tickets'
,sum(ORDQTY) as Qty
,sum(ORDTOTAL) as Amt
from #ReportBase rb 
    WHERE ITEM like 'F0[1-7]'
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
  WHERE ITEM like 'F0[1-7]'
  AND rb.E_PL not in  ('10') -- deals with single game suites for now  
  AND rb.I_PT IN ('VI', 'V')
group by rb.SEASON, rb.I_PT


-- Season Ticket Accts 

set @SeasonTicketAcctsCY = (
	select COUNT (distinct CUSTOMER) Accts	
	from #ReportBase with (nolock) 
	where SEASON in (@curSeason)
		and ITEM = 'FS'
		and E_PL not in ('10') 
		AND ( PAIDTOTAL > 0 OR CUSTOMER in ('152760','164043','186078' ) )
	   AND CUSTOMER <> '137398'
	group by SEASON
)

set @SeasonTicketAcctsPY = ('6541')

set @DonationCYAccts =	( select SUM(ORDQTY) 
FROM #ReportBase rb join dbo.TIPRICELEVELMAP2 tm on 
	    rb.ITEM  COLLATE SQL_Latin1_General_CP1_CS_AS = TM.ITEM  COLLATE SQL_Latin1_General_CP1_CS_AS
	AND rb.I_PT  COLLATE SQL_Latin1_General_CP1_CS_AS = tm.I_PT  COLLATE SQL_Latin1_General_CP1_CS_AS
	AND rb.E_PL   = tm.I_PL  
where rb.ITEM = 'FS' AND rb.E_PL not in ('10')  AND rb.SEASON in (@curSeason)
	AND ( rb.PAIDTOTAL > 0 OR rb.CUSTOMER in ('152760','164043','186078' ) )
	AND rb.CUSTOMER <> '137398' AND tm.SEASON in (@curSeason)  
	AND TM.REQCONTRIB = 1 
)

select 
	PrevYR.saleTypeName 
	,PrevYR.prevQty
	,PrevYR.prevAmt  --WAS BUDGET.PRIORYEAR 
	,CurYR.CurQty
	,CurYR.CurAmt
	,convert(decimal(12,2),budget.amount) Budget
	,@DonationCYAccts DonationAcctCY
	,@DonationPYAccts DonationAcctPY
	,@SeasonTicketAcctsCY SeasonTicketAcctsCY
	,@SeasonTicketAcctsPY SeasonTicketAcctsPY
	,@DonationCYFTB DonationCYFTB
	,@DonationCYCLUB DonationCYCLUB
	,@DonationPYFTB DonationPYFTB
	,@DonationPYCLUB DonationPYCLUB
	
from
(select saleTypeName, SUM(qty) as prevQty, SUM(amt) 
as prevAmt from #seasonsummary a where cast(right(season,2) as int)
 = right(@prevseason,2) group by saleTypeName) PrevYR
left outer join (select saleTypeName, SUM(qty) as curQty, SUM(amt)
 as curAmt from #seasonsummary a where cast(right(season,2) as int) 
 = right(@curseason,2) group by saleTypeName) CurYR
on PrevYR.saleTypeName = CurYR.saleTypeName
left outer join #budget budget
on PrevYR.saleTypeName = budget.saleTypeName

--union all

--select 'Donor Accts', @DonationPYAccts, @DonationPY, @DonationCYAccts, @DonationCY, null--@DonationCYPledge

--union all

--select 'Season Ticket Accts', @SeasonTicketAcctsPY, null, @SeasonTicketAcctsCY, null, null


END


























GO
