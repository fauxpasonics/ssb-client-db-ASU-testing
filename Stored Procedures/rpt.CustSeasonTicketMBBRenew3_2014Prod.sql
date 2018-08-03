SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--exec [dbo].[rptCustSeasonTicketMBBRenew3_2014Prodbk] 


CREATE     PROCEDURE [rpt].[CustSeasonTicketMBBRenew3_2014Prod] 

as 
BEGIN

set transaction isolation level read uncommitted

declare @curSeason varchar(50)

Set @curSeason = 'BB14'


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
select 'MB01'  union all 
select 'MB02'  union all 
select 'MB03'  union all 
select 'MB04'  union all 
select 'MB05'  union all 
select 'MB06'  union all 
select 'MB07'  union all
select 'MB08'  union all 
select 'MB09'  union all 
select 'MB10'  union all 
select 'MB11'  union all 
select 'MB12'  union all 
select 'MB13'  union all 
select 'MB14'  union all
select 'MB15'  union all 
select 'MB16'  union all 
select 'MB17'  union all 
select 'MB18'  

create table #budget 
(
event varchar (10) 
,amount float
,quantity int
)

insert into #budget
(event , amount, quantity)


select 'MB01',13800,600  union all 
select 'MB02',5750,250  union all 
select 'MB03',5750,250  union all 
select 'MB04',12075,525  union all 
select 'MB05',37500,1500  union all 
select 'MB06',12075,525  union all 
select 'MB07',12075,525  union all
select 'MB08',6900,300 union all 
select 'MB09',28750,1250 union all 
select 'MB10',25000,1000  union all 
select 'MB11',49500,1980  union all 
select 'MB12',10000,400  union all 
select 'MB13',52875,2115  union all 
select 'MB14',169950,3399  union all
select'MB15',50000,2000  union all 
select 'MB16',37500,1500  union all 
select 'MB17',20000,800  union all 
select 'MB18',50500,2020



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


--Single Game Breakout:
--declare @singleSummary as SingleSummary

/*
Insert into  @singleSummary 
(
E
,
,
,
,
,
,
,
,
,
,
,
,
,
,
,
) 
*/

select 
 isnull(eventHeader.eventCode,'')                                                                                                eventCode 
,isnull(eventHeader.eventName,'') 																								 eventName 
,isnull(eventHeader.eventDate,'') 																								 eventDate
,isnull(AvailSeatCount,0) 																										 AvailSeatCount 
,isnull(vistingticketSet.visitingTicketQty,0)																					 visitingTicketQty 
,isnull(vistingticketSet.visitingTicketAmt,0)																					 visitingTicketAmt
,isnull(groupSet.groupTicketQty,0)																								 groupTicketQty 
,isnull(groupSet.groupTicketAmt,0)																								 groupTicketAmt   
,isnull(publicSet.publicTicketQty,0)																							 publicTicketQty 
,isnull(publicSet.publicTicketAmt,0)																							 publicTicketAmt 
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
        ITEM like 'MB%'
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
        ITEM like 'MB%'
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
        ITEM like 'MB%'
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


---------------------------------------------------------------------------------------



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
	AND tkSeatSeat.SEASON= 'BB14'
	--AND tkSeatSeat.EVENT= 'MB11'
	--AND LEVEL <> 'S' 
	--holds don't want
	AND tkSeatSeat.STAT<>  'B'
	AND tkSeatSeat.STAT<>  'v'
	AND tkSeatSeat.STAT<>  'p'
	AND tkSeatSeat.STAT<>  'r'
	AND tkSeatSeat.STAT<>  'i'
	AND tkSeatSeat.STAT <> 'c'
	AND tkSeatSeat.STAT <> 'f'
	AND tkSeatSeat.STAT <> 'X'


	AND ISNULL(PL,99999)  NOT IN ('9')  
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
join #singleSummary b
on a.eventdate >= b.eventdate
group by a.eventCode) as YTD
on x.eventcode = YTD.eventcode
order by eventDate





END 





















GO
