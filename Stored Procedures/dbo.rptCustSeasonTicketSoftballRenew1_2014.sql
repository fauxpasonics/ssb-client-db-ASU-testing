SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE  PROCEDURE [dbo].[rptCustSeasonTicketSoftballRenew1_2014]


as
BEGIN


declare @curSeason varchar(50)
declare @prevSeason varchar(50)
declare @studentprevSeason varchar(50)
declare @studentCurSeason varchar(50)
declare @DonationYearCY varchar(50), @DonationYearPY varchar(50)
, @DonationCY decimal(12,2), @DonationPY decimal(12,2)
, @DonationCYPledge decimal(12,2), @DonationCYAccts int, @DonationPYAccts int
declare @SeasonTicketAcctsCY int, @SeasonTicketAcctsPY int
declare @curHomeGames as numeric 

Set @prevSeason = 'SB13'
Set @curSeason = 'SB14'
Set @curHomeGames = 32


set @DonationCY =  0 

set @DonationPY = 0  

set @DonationCYPledge = 0  


create table #budget
(
      saleTypeName varchar(100)
      ,amount int
      ,priorYear int
)

insert into #budget
--Budget and Prior Year Revenue
Select 'Mini Packs FSE', '12000', '10082' UNION ALL
Select 'Season Sales', '95800', '86048' UNION ALL
Select 'Season Suite', '0', '0' UNION ALL
Select 'Single Game Tickets', '181775', '140036' UNION ALL
Select 'All Session Passes', '35425', '34253' UNION ALL
Select 'Single Game Suite', '0', '0'  UNION ALL
Select 'Student Guest Pass', '0', '0' UNION ALL
Select 'Student Season', '0' , '0'
------------------------------------------------------------------------------------------
CREATE TABLE #pSeasons (Season varchar (50)) 
Insert into #pSeasons values ('SB14')

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
      ,sum(isnull(tkTransItem.I_OQTY_TOT,0) * (isnull(I_Price,0) - isnull(I_Damt,0)))   as ORDTOTAL
      
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
      

where
     (isnull(tkTrans.E_STAT,0) not in ( 'MI','MO','TO','TI','EO','EI') OR E_STAT IS NULL )

     
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
     (isnull(tkTrans.E_STAT,0) not in ( 'MI','MO','TO','TI','EO','EI') OR E_STAT IS NULL )
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


----------------------------------------------------------------------------------
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
----------------------------------------------------------------------------------------
--PREVIOUS SEASON  
SELECT 
        
     'SB13' AS SEASON 
       ,'Season Sales'
      ,'473' qty 
      ,'86048' amt 

UNION ALL

--CURRENT SEASON 
SELECT 
        SEASON 
       ,'Season Sales'
      ,SUM(ORDQTY) QTY
      ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where ITEM = 'SBS'   AND SEASON in (@curSeason)
      AND ( PAIDTOTAL > 0 OR CUSTOMER in ('152760','164043','186078' )  )
      AND CUSTOMER <> '137398'
GROUP BY  SEASON 

UNION ALL
----------------------------------------------------------------------------------------------
SELECT 
        
     'SB13' AS SEASON 
       ,'Student Season'
      ,'0' qty 
      ,'0' amt 

UNION ALL

SELECT 
        SEASON 
       ,'Student Season'
      ,0  QTY
      ,0  AMT
FROM #ReportBase 
where SEASON in (@curSeason)
GROUP BY  SEASON 

----------------------------------------------------------------------------------------

UNION ALL

select 'SB13', 'Student Guest Passes', 0, 0


UNION ALL

SELECT 
        SEASON 
       ,'Student Guest Passes'
      ,0 QTY
      ,0 AMT
FROM #ReportBase 
where SEASON in (@curSeason) 
GROUP BY  SEASON 

------------------------------------------------------------------------------------------
UNION ALL
SELECT 
       'SB13' SEASON 
       ,'Mini Packs FSE'
      ,'38' QTY
      ,'10082'  AMT

UNION ALL

SELECT 
       SEASON 
       ,'Mini Packs FSE'
      ,CASE WHEN ITEM LIKE '2%' THEN SUM(ORDQTY) * 2/@curHomeGames
             WHEN ITEM LIKE '3%' THEN SUM(ORDQTY) * 3/@curHomeGames
             WHEN ITEM LIKE '4%' THEN SUM(ORDQTY) * 4/@curHomeGames
             WHEN ITEM LIKE '5%' THEN SUM(ORDQTY) * 5/@curHomeGames
             WHEN ITEM LIKE '6%' THEN SUM(ORDQTY) * 6/@curHomeGames
             WHEN ITEM LIKE '7%' THEN SUM(ORDQTY) * 7/@curHomeGames
             WHEN ITEM LIKE '8%' THEN SUM(ORDQTY) * 8/@curHomeGames
             WHEN ITEM LIKE '9%' THEN SUM(ORDQTY) * 9/@curHomeGames
             WHEN ITEM LIKE '10%' THEN SUM(ORDQTY)* 10/@curHomeGames
             WHEN ITEM LIKE '11%' THEN SUM(ORDQTY)* 11/@curHomeGames
            END AS QTY
      ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where  ITEM like '[1-9]%'  
         AND SEASON in (@curSeason)
         AND ( PAIDTOTAL > 0 )
GROUP BY SEASON , ITEM   

--------------------------------------------------------------------------------------------------

UNION ALL 
SELECT 
       'SB13' SEASON 
       ,'Single Game Tickets'
      ,'17910' QTY
      ,'140036' AMT

UNION ALL

select 
       rb.SEASON 
      ,'Single Game Tickets'
,sum(ORDQTY) as Qty
,sum(ORDTOTAL) as Amt
from #ReportBase rb 
    WHERE ITEM like 'SB[0-9]%'
    --AND ITEM <> 'MB18' 
       AND SEASON in (@curSeason)
      and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.Season, rb.I_PT
---------------------------------------------------------------------------------------------
UNION ALL 
SELECT 
       'SB13' SEASON 
       ,'All Session Passes'
      ,'1246' QTY
      ,'34253' AMT

UNION ALL

select 
       rb.SEASON 
      ,'All Session Passes'
,sum(ORDQTY) as Qty
,sum(ORDTOTAL) as Amt
from #ReportBase rb 
    WHERE ITEM in ('KCA','KCJS','KCG', 'KASPT','LCA','LCJS','LCG','LSA','LSJS','LSG','DDA','DDJS','DDG')
    --AND ITEM <> 'MB18' 
       AND SEASON in (@curSeason)
      and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.Season, rb.I_PT


----------------------------------------------------------------------------------------------
--************************
-- Season Ticket Accts 
--************************

set @SeasonTicketAcctsCY = (
      SELECT COUNT (distinct CUSTOMER) Accts   
      FROM #ReportBase with (nolock) 
      WHERE ITEM = 'SBS'   AND SEASON in (@curSeason, @prevSeason)
      AND ( PAIDTOTAL > 0 OR CUSTOMER in ('152760','164043','186078' ) )
      AND CUSTOMER <> '137398'
GROUP BY  SEASON 
)



set @DonationCYAccts = 0 

select 
      PrevYR.saleTypeName 
      ,isnull(PrevYR.prevQty,0) prevQty
      ,isnull(PrevYr.prevAmt,0) prevAmt
      ,isnull(CurYR.CurQty,0) CurQty
      ,isnull(CurYR.CurAmt,0) CurAmt
      ,convert(decimal(12,2),budget.amount) Budget
      ,@DonationCYAccts DonationAcctCY
      ,@DonationPYAccts DonationAcctPY
      ,@SeasonTicketAcctsCY SeasonTicketAcctsCY
      ,@SeasonTicketAcctsPY SeasonTicketAcctsPY
      ,@DonationCY DonationCY
      ,@DonationPY DonationPY
      --,@DonationCYFTB DonationCYFTB
      --,@DonationCYCLUB DonationCYCLUB
      --,@DonationPYFTB DonationPYFTB
      --,@DonationPYCLUB DonationPYCLUB
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

--union all

--select 'Donor Accts', @DonationPYAccts, @DonationPY, @DonationCYAccts, @DonationCY, @DonationCYPledge

--union all

--select 'Season Ticket Accts', @SeasonTicketAcctsPY, null, @SeasonTicketAcctsCY, null, null













end














GO
