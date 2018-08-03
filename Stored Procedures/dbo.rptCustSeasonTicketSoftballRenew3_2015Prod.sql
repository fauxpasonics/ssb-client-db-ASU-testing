SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






--exec rptCustSeasonTicketSoftballRenew3_2015Prod



CREATE      PROCEDURE [dbo].[rptCustSeasonTicketSoftballRenew3_2015Prod] 

as 
BEGIN

set transaction isolation level read uncommitted

declare @curSeason varchar(50)

Set @curSeason = 'SB15'


---- Build Report --------------------------------------------------------------------------------------------------
--Report Base 


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
 FROM vwTIReportBase rb where rb.SEASON IN ( @curSeason) 

------------------------------------------------------------------------------------------------------------------

create table #homegames
(event varchar(50)   )

insert into #homegames
(event)
select 'SB01'  union all 
select 'SB02'  union all 
select 'SB03'  union all 
select 'SB04'  union all 
select 'SB05'  union all 
select 'SB06'  union all 
select 'SB07'  union all
select 'SB08'  union all 
select 'SB09'  union all 
select 'SB10'  union all 
select 'SB11'  union all 
select 'SB12'  union all 
select 'SB13'  union all 
select 'SB14'  union all
select 'SB15'  union all
select 'SB16'  union all
select 'SB17'  union all
select 'SB18'  union all
select 'SB19'  union all
select 'SB20'  union all
select 'SB21'  union all
select 'SB22'  union all
select 'SB23'  union all
select 'SB24'  union all
select 'SB25'  union all
select 'SB26' 

create table #budget 
(
event varchar (10) 
,amount float
,quantity int
)

insert into #budget
(event , amount, quantity)

select 'SB01',2550,300 union all
select 'SB02',5738,675 union all
select 'SB03',9350,1100 union all
select 'SB04',9350,1100 union all
select 'SB05',2125,250 union all
select 'SB06',8925,1050 union all
select 'SB07',8075,950 union all
select 'SB08',0,0 union all
select 'SB09',1700,200 union all
select 'SB10',8925,1050 union all
select 'SB11',2550,300 union all
select 'SB12',8075,950 union all
select 'SB13',2550,300 union all
select 'SB14',8075,950 union all
select 'SB15',4950,550 union all
select 'SB16',5850,650 union all
select 'SB17',3600,400 union all
select 'SB18',4950,550 union all
select 'SB19',5850,650 union all
select 'SB20',4050,450 union all
select 'SB21',4500,500 union all
select 'SB22',4950,550 union all
select 'SB23',4050,450 union all
select 'SB24',8550,950 union all
select 'SB25',9450,1050 union all
select 'SB26',9450,1050


create table #eventHeader
(
eventCode varchar(50)  
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
                  on tkEvent.event   COLLATE SQL_Latin1_General_CP1_CS_AS
                   = homegames.event COLLATE SQL_Latin1_General_CP1_CS_AS 
where tkEvent.season  =  @curSeason
and tkEvent.name not like '%@%'

----------------------------------------------------------------------------------------------------------

select 
 isnull(eventHeader.eventCode,'')                       eventCode 
,isnull(eventHeader.eventName,'')                                                           eventName 
,isnull(eventHeader.eventDate,'')                                                                                     eventDate
,isnull(AvailSeatCount,0)                                                                                                     AvailSeatCount 
,isnull(vistingticketSet.visitingTicketQty,0)                     visitingTicketQty 
,isnull(vistingticketSet.visitingTicketAmt,0)                                    visitingTicketAmt
,isnull(groupSet.groupTicketQty,0)                                                                                  groupTicketQty 
,isnull(groupSet.groupTicketAmt,0)                                                                                 groupTicketAmt   
,isnull(publicSet.publicTicketQty,0)                                                                              publicTicketQty 
,isnull(publicSet.publicTicketAmt,0)                                                                 publicTicketAmt 
,isnull(budget.quantity,0) as budgetedQuantity                                                                                                                                                                                                                                                                                                                                       
,isnull(budget.amount,0) as budgetedAmount                                                                                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
,isnull(vistingticketSet.visitingTicketQty,0)  + isnull(groupSet.groupTicketQty,0)                                                                                                                                                                                          
      + isnull(publicSet.publicTicketQty,0) as TotalTickets                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
,isnull(vistingticketSet.visitingTicketAmt,0)  + isnull(groupSet.groupTicketAmt,0)
      + isnull(publicSet.publicTicketAmt,0) as TotalRevenue 
       
,case when budget.amount = 0 then 0 else (isnull(vistingticketSet.visitingTicketAmt,0) +  isnull(groupSet.groupTicketAmt,0)
      + isnull(publicSet.publicTicketAmt,0))/ budget.amount end  as PercentToGoal 
       
,   (isnull(vistingticketSet.visitingTicketAmt,0) +  isnull(groupSet.groupTicketAmt,0)
      + isnull(publicSet.publicTicketAmt,0)) - budget.amount  as VarianceToGoal
into #singleSummary


from
#eventHeader eventHeader
left join 
(

select 
                 rb.ITEM 
,sum(ORDQTY) as visitingTicketQty
,sum(ORDTOTAL) as visitingTicketAmt
from #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                          on rb.ITEM  = eventHeaderEvent.eventCode  
    WHERE 
        ITEM like 'SB[0-9]%'
                and rb.I_PT in ('V')
                and rb.SEASON = @curSeason
                and rb.I_PRICE > 0
group by rb.ITEM 
) vistingticketSet 
on eventheader.eventCode  = vistingticketSet.ITEM    

-------------------------------------------------------------------------------------------


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
        ITEM like 'SB[0-9]%'
                and rb.I_PT like 'G%'
                and rb.SEASON = @curSeason
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
        ITEM like 'SB[0-9]%'
                and rb.I_PT NOT LIKE  'G%'
                and rb.I_PT NOT LIKE 'V%'
                and rb.SEASON = @curSeason
                and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.ITEM 
) publicSet 
on eventheader.eventCode  = PublicSet.ITEM 

LEFT JOIN #budget budget
on budget.event =  eventHeader.eventCode


LEFT JOIN
(
SELECT season, event, SUM(AvailSeatCount) AS AvailSeatCount
FROM

(
       SELECT  
       tkSeatSeat.season
       ,tkSeatSeat.event
       ,COUNT(tkseatseat.seat) AS AvailSeatCount                                                        
       FROM dbo.TK_SEAT_SEAT tkSeatSeat
             
       INNER JOIN dbo.TK_SSTAT tkSstat
       ON tkSeatSeat.STAT COLLATE Latin1_General_CS_AS = tkSstat.SSTAT COLLATE Latin1_General_CS_AS
       AND tkSeatSeat.Season = tkSstat.Season

       WHERE
                 tkSeatSeat.STAT<> '-'
                        AND tkSeatSeat.STAT<> 'N'--added to remove No Seats
                        AND tkSeatSeat.STAT<> 'K'
       AND tkSeatSeat.SEASON= 'SB15'
       --holds don't want
       AND tkSeatSeat.STAT<>  'B'
       AND tkSeatSeat.STAT<>  'v'
       AND tkSeatSeat.STAT<>  'p'
       AND tkSeatSeat.STAT<>  'r'
       AND tkSeatSeat.STAT<>  'i'
       AND tkSeatSeat.STAT <> 'c'
       AND tkSeatSeat.STAT <> 'f'
       AND tkSeatSeat.STAT <> 'X'

       GROUP BY
              tkSeatSeat.season
              ,tkSeatSeat.event

) a
GROUP BY season, event
) seatsavailable
ON eventHeader.eventCode = seatsavailable.EVENT COLLATE database_default


























---------------------------------------------------------------------------------------
--Result Set 


select 
                x.*
                ,isnull(YTD.VarianceYTD,0) as VarianceYTD
                ,isnull(YTD.BudgetYTD,0) as BudgetYTD
                ,isnull(YTD.ActualYTD,0) as ActualYTD
                ,VarToProj = case isnull(ytd.budgetYTD,0)  when 0 then 0 else isnull(YTD.varianceYTD,0) / isnull(ytd.budgetYTD,0) end
From #singleSummary x
join
(select a.eventCode
,SUM(isnull(b.VarianceToGoal,0))  as varianceYTD
,SUM(isnull(b.budgetedAmount,0)) as budgetYTD
,SUM(isnull(b.TotalRevenue,0)) as actualYTD 
from #singleSummary a
join #singleSummary  b
on a.eventdate >= b.eventdate
group by a.eventCode) as YTD
on x.eventcode = YTD.eventcode
order by eventDate





END 


























GO
