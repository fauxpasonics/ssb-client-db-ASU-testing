SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE   PROCEDURE [rpt].[CustSeasonTicketBaseballRenew3_2014] 

as 
BEGIN

      
declare @curSeason varchar(50)

Set @curSeason = 'B14'

CREATE TABLE #pSeasons (Season varchar (50)) 
Insert into #pSeasons values ('B14')

-- Create #SalesBase --------------------------------------------------------------------------------------------------

Create table #SalesBase 
(
  SEASON varchar (15) 
 ,CUSTOMER varchar (20)
,ITEM varchar (32) COLLATE SQL_Latin1_General_CP1_CS_AS 
 ,E_PL varchar (10)
,I_PT  varchar (32) COLLATE SQL_Latin1_General_CP1_CS_AS
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
     (isnull(tkTrans.E_STAT,0) not in ('MI','MO',  'TO','TI','EO','EI') OR E_STAT IS NULL )

     
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
 ,ITEM varchar (32) COLLATE SQL_Latin1_General_CP1_CS_AS 
 ,E_PL varchar (10)
,I_PT  varchar (32) COLLATE SQL_Latin1_General_CP1_CS_AS
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
     (isnull(tkTrans.E_STAT,0) not in ('MI','MO',  'TO','TI','EO','EI') OR E_STAT IS NULL )
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
,ITEM varchar (32) COLLATE SQL_Latin1_General_CP1_CS_AS
,E_PL varchar (10)
,I_PT  varchar (32) COLLATE SQL_Latin1_General_CP1_CS_AS
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

------------------------------------------------------------------------------------------------------------------

create table #homegames
(event varchar(50) COLLATE SQL_Latin1_General_CP1_CS_AS  )

insert into #homegames
(event)
select 'B01'  union all 
select 'B02'  union all 
select 'B03'  union all 
select 'B04'  union all 
select 'B05'  union all 
select 'B06'  union all 
select 'B07'  union all
select 'B08'  union all 
select 'B09'  union all 
select 'B10'  union all 
select 'B11'  union all 
select 'B12'  union all 
select 'B13'  union all 
select 'B14'  union all
select 'B15'  union all
select 'B16'  union all
select 'B17'  union all
select 'B18'  union all
select 'B19'  union all
select 'B20'  union all
select 'B21'  union all
select 'B22'  union all
select 'B23'  union all
select 'B24'  union all
select 'B25'  union all
select 'B26'  union all
select 'B27'  union all
select 'B28'  union all
select 'B29'  union all
select 'B30' 
 
create table #budget 
(
event varchar (10) COLLATE SQL_Latin1_General_CP1_CS_AS
,amount float
,quantity int
)

insert into #budget
(event , amount, quantity)

select 'B01',5730,573  union all 
select 'B02',11460,955 union all 
select 'B03',6876,573  union all 
select 'B04',4775,478  union all 
select 'B05',13752,1146  union all 
select 'B06',13752,1146  union all 
select 'B07',9168,764  union all
select 'B08',7640,764  union all 
select 'B09',13752,1146 union all 
select 'B10',13752,1146  union all 
select 'B11',9168,764 union all 
select 'B12',6685,669  union all 
select 'B13',6685,669  union all 
select 'B14',14898,1242  union all
select 'B15',16044,1337  union all
select 'B16',16044,1337  union all
select 'B17',8595,860  union all
select 'B18',14898,1242  union all
select 'B19',8599,860  union all
select 'B20',13752,1146  union all
select 'B21',5730,573  union all
select 'B22',5730,573  union all
select 'B23',4775,478  union all
select 'B24',16044,1337  union all
select 'B25',16044,1337  union all
select 'B26',10314,860  union all
select 'B27',9550,955  union all
select 'B28',13752,1146  union all
select 'B29',8599,860  union all
select 'B30',16044,1337   



create table #eventHeader
(
eventCode varchar(50)  COLLATE SQL_Latin1_General_CP1_CS_AS
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
--,' ' EventDate
,cast (date as date) EventDate
from 
        TK_EVENT tkEvent with (nolock) 
        inner join #homegames homegames
                  on tkEvent.event COLLATE SQL_Latin1_General_CP1_CS_AS 
                    = homegames.event COLLATE SQL_Latin1_General_CP1_CS_AS 
where tkEvent.season =  @curSeason
and tkEvent.name not like '%@%'

----------------------------------------------------------------------------------------------------------


--Single Game Breakout:
create table #singleSummary
( 
 eventCode varchar(100)
,eventName varchar(500)
,eventDate varchar(100)
,visitingTicketQty bigint 
,visitingTicketAmt numeric (18,2)
,studentTicketQty bigint 
,studentTicketAmt numeric (18,2)
,groupTicketQty bigint
,groupTicketAmt numeric (18,2)
,suiteTicketQty bigint
,suiteTicketAmt numeric (18,2) 
,publicTicketQty bigint
,publicTicketAmt numeric (18,2)
,budgetedQuantity bigint 
,budgetedAmount numeric (18,2)
,TotalTickets bigint 
,TotalRevenue numeric (18,2)
,PercentToGoal numeric (18,2)
,VarianceToGoal numeric (18,2)

)

Insert into  #singleSummary 
(
eventCode 
,eventName 
,eventDate 
,visitingTicketQty 
,visitingTicketAmt
,studentTicketQty 
,studentTicketAmt 
,groupTicketQty 
,groupTicketAmt 
,suiteTicketQty 
,suiteTicketAmt  
,publicTicketQty 
,publicTicketAmt 
,budgetedQuantity 
,budgetedAmount
,TotalTickets  
,TotalRevenue 
,PercentToGoal 
,VarianceToGoal 
) 


select 
 eventHeader.eventCode
,eventHeader.eventName
,eventHeader.eventDate
,isnull(vistingticketSet.visitingTicketQty,0) visitingTicketQty
,isnull(vistingticketSet.visitingTicketAmt,0) visitingTicketAmt
,isnull(studentSet.studentTicketQty,0) studentTicketQty
,isnull(studentSet.studentTicketAmt,0) studentTicketAmt
,isnull(groupSet.groupTicketQty,0) groupTicketQty
,isnull(groupSet.groupTicketAmt,0) groupTicketAmt
, 0 as suiteTicketQty--,suiteSet.suiteTicketQty
, 0 as suiteTicketAmt--,suiteSet.suiteTicketAmt
,isnull(publicSet.publicTicketQty,0) publicTicketQty
,isnull(publicSet.publicTicketAmt,0) publicTicketAmt
,isnull(budget.quantity,0) as budgetedQuantity
,budget.amount as budgetedAmount

,isnull(vistingticketSet.visitingTicketQty,0) + 
         isnull(studentSet.studentTicketQty,0) + isnull(groupSet.groupTicketQty,0)
      + isnull(publicSet.publicTicketQty,0) as TotalTickets
      
,isnull(vistingticketSet.visitingTicketAmt,0) + 
         isnull(studentSet.studentTicketAmt,0) + isnull(groupSet.groupTicketAmt,0)
      + isnull(publicSet.publicTicketAmt,0) as TotalRevenue 
       
,(isnull(vistingticketSet.visitingTicketAmt,0) + 
         isnull(studentSet.studentTicketAmt,0) + isnull(groupSet.groupTicketAmt,0)
      + isnull(publicSet.publicTicketAmt,0))/ budget.amount as PercentToGoal 
       
,   (isnull(vistingticketSet.visitingTicketAmt,0) + 
         isnull(studentSet.studentTicketAmt,0) + isnull(groupSet.groupTicketAmt,0)
      + isnull(publicSet.publicTicketAmt,0)) - budget.amount  as VarianceToGoal
      
 

from
#eventHeader eventHeader
left join 
(

select 
       rb.ITEM 
,0 as visitingTicketQty
,0 as visitingTicketAmt
from #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                          on rb.ITEM  = eventHeaderEvent.eventCode  

group by rb.ITEM 
) vistingticketSet 
on eventheader.eventCode  = vistingticketSet.ITEM  

-------------------------------------------------------------------------------------------
LEFT JOIN  
(
select 
       rb.ITEM 
,0 as studentTicketQty
,0 as studentTicketAmt
from #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                          on rb.ITEM  = eventHeaderEvent.eventCode  
group by rb.ITEM 
) studentSet on 
eventheader.eventCode   = studentSet.ITEM  
------------------------------------------------------------------------------------------

LEFT JOIN  
(
select 
       rb.ITEM 
,sum(ORDQTY) as groupTicketQty
,sum(ORDTOTAL) as groupTicketAmt
from #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                on rb.ITEM  = eventHeaderEvent.eventCode  
    WHERE 
        ITEM like 'B[0-9]%'
    --AND ITEM <> 'MB18'
      and rb.I_PT like 'G%'
      and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.ITEM 
) GroupSet on 
eventheader.eventCode  = GroupSet.ITEM 


----------------------------------------------------------------------------------------------------------

LEFT JOIN  
(
select 
       rb.ITEM 
,sum(ORDQTY) as publicTicketQty
,sum(ORDTOTAL) as publicTicketAmt
from #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                          on rb.ITEM  = eventHeaderEvent.eventCode  
    WHERE 
        ITEM like 'B[0-9]%'
    --AND ITEM <> 'MB18'
      and rb.I_PT NOT LIKE  'G%'
      and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.ITEM 
) publicSet 
on eventheader.eventCode  = PublicSet.ITEM 

LEFT JOIN #budget budget
on budget.event =  eventHeader.eventCode

---------------------------------------------------------------------------------------
--Result Set 


select 
      #singleSummary.*
      ,YTD.varianceYTD
      ,YTD.budgetYTD
      ,YTD.actualYTD 
From #singleSummary 
join
(select a.eventCode
,SUM(isnull(b.VarianceToGoal,0))  as varianceYTD
,SUM(isnull(b.budgetedAmount,0)) as budgetYTD
,SUM(isnull(b.TotalRevenue,0)) as actualYTD 
from #singleSummary a
join #singleSummary b
on a.eventdate >= b.eventdate
group by a.eventCode) as YTD
on #singleSummary.eventcode = YTD.eventcode







END 



















GO
