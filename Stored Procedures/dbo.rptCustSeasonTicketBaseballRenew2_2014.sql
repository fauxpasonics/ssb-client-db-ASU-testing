SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE    PROCEDURE [dbo].[rptCustSeasonTicketBaseballRenew2_2014] 

as 
BEGIN


declare @curSeason varchar(50)
declare @prevSeason varchar(50)
declare @studentprevSeason varchar(50)
declare @studentCurSeason varchar(50)
declare @ReportCode varchar(50)

Set @prevSeason = 'B13'
Set @curSeason = 'B14'
Set @ReportCode = 'BT'


CREATE TABLE #pSeasons (Season varchar (50)) 
Insert into #pSeasons values ('B14')

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
     (isnull(tkTrans.E_STAT,0) not in ('MI','MO', 'TO','TI','EO','EI') OR E_STAT IS NULL )

     
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
     (isnull(tkTrans.E_STAT,0) not in ('MI','MO', 'TO','TI','EO','EI') OR E_STAT IS NULL )
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


--Regular Season Ticket Current Season
select 
      rb.SEASON
      ,'Season' SALETYPENAME
      ,ISNULL(TIPRICELEVELMAP2.PL_CLASS,'NOT CLASSIFIED') PL_CLASS
      , CASE WHEN rb.I_PT like 'N%' THEN 0 WHEN rb.I_PT like 'BN%' 
      then 0  WHEN rb.I_PT LIKE '%A' THEN 0 
      ELSE 1 END as  RENEWAL
      ,SUM(ORDQTY) QTY 
      ,SUM(ORDTOTAL) AMT
from #ReportBase rb
LEFT join TIPRICELEVELMAP2  on rb.SEASON = TIPRICELEVELMAP2.SEASON 
      AND rb.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS = TIPRICELEVELMAP2.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS
      AND rb.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS = TIPRICELEVELMAP2.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
      AND rb.E_PL = TIPRICELEVELMAP2.I_PL 
      AND TIPRICELEVELMAP2.REPORTCODE =  'BT'
where rb.ITEM = 'BBS' AND rb.SEASON in (@curSeason)
      AND ( PAIDTOTAL > 0 OR CUSTOMER in ('152760','164043','186078' ) )
            AND CUSTOMER <> '137398'
GROUP BY    rb.SEASON, rb.I_PT , PL_CLASS 

UNION ALL 
--Regular Season Ticket Previous Season
select 
      tkOdet.Season SEASON
      ,'Season' SALETYPENAME
      ,ISNULL(TIPRICELEVELMAP.PL_CLASS,'NOT CLASSIFIED') PL_CLASS
      , CASE WHEN tkOdet.I_PT like 'N%' THEN 0 ELSE 1 END as RENEWAL
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
      AND TIPRICELEVELMAP.REPORTCODE =  @ReportCode
where tkOdet.season in (@prevSeason) 
      and tkItem.ITEM = 'BBS'
      and tkOdet.I_PAY > 0
group by tkOdet.Season, TIPRICELEVELMAP.PL_CLASS,tkOdet.I_PT  


-----------------------------------------------------------------------------------------

select 

      PL.PL_CLASS 
      ,isnull(bbPrev.bbPrevQty,0) bbPrevQty
      ,isnull(bbPrev.bbPrevAmt,0) bbPrevAmt
      ,isnull(bbCurRenew.bbCurRenewQty,0) bbCurRenewQty
      ,isnull(bbCurRenew.bbCurRenewAmt,0) bbCurRenewAmt
      ,isnull(bbCurNew.bbCurNewQty,0) bbCurNewQty
      ,isnull(bbCurNew.bbCurNewAmt,0) bbCurNewAmt
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
                             where SEASON in (@curSeason)   
                             and renewal = '1' 
                             group by PL_CLASS) bbCurRenew
            on PL.PL_CLASS =  bbCurRenew.PL_CLASS 

left outer join (select PL_CLASS, sum(QTY) as bbCurNewQty, sum(AMT) as bbCurNewAmt 
                             from #seasonsummary 
                             where season in (@curSeason) 
                              and renewal = '0' 
                             group by PL_CLASS ) bbCurNew
            on PL.PL_CLASS =  bbCurNew.PL_CLASS 
left outer join dbo.TIPRICELEVELCAPACITY Capacity on PL.PL_CLASS=CAPACITY.PL_CLASS And CAPACITY.SEASON = @curSeason        
order by sortOrder

      



END 




GO
