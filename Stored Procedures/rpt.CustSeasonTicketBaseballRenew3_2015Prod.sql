SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--exec rptCustSeasonTicketBaseballRenew3_2015Prod

CREATE      PROCEDURE [rpt].[CustSeasonTicketBaseballRenew3_2015Prod] 

AS 
BEGIN

set transaction isolation level read uncommitted

declare @curSeason varchar(50)

Set @curSeason = 'B15'


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
select 'B30'  union all
select 'B31'  union all
select 'B32'  union all
select 'B33'  union all
select 'B34'  union all
select 'B35'  union all
select 'B36'   

create table #budget 
(
event varchar (10) 
,amount float
,quantity INT
,suite16 int
,suite32 int
)

insert into #budget
(event , amount, quantity, suite16, suite32)

select 'B01',11250,750,450,650 union all
select 'B02',11250,750,450,650 union all
select 'B03',7500,500,350,550 union all
select 'B04',11250,750,350,550 union all
select 'B05',11250,750,450,650 union all
select 'B06',11250,750,450,650 union all
select 'B07',7500,500,350,550 union all
select 'B08',11250,750,350,550 union all
select 'B09',11250,750,450,650 union all
select 'B10',11250,750,450,650 union all
select 'B11',18000,1200,350,550 union all
select 'B12',18000,1200,450,650 union all
select 'B13',18000,1200,450,650 union all
select 'B14',12750,850,350,550 union all
select 'B15',12750,850,350,550 union all
select 'B16',16500,1100,450,650 union all
select 'B17',16500,1100,450,650 union all
select 'B18',12000,800,350,550 union all
select 'B19',12000,800,350,550 union all
select 'B20',18000,1200,450,650 union all
select 'B21',18000,1200,450,650 union all
select 'B22',12750,850,350,550 union all
select 'B23',16500,1100,350,550 union all
select 'B24',27000,1800,450,650 union all
select 'B25',27000,1800,350,550 union all
select 'B26',18000,1200,350,550 union all
select 'B27',6600,550,450,650 union all
select 'B28',6600,550,450,650 union all
select 'B29',3600,300,350,550 union all
select 'B30',11250,750,450,650 union all
select 'B31',11250,750,450,650 union all
select 'B32',7500,500,350,550 union all
select 'B33',7200,600,350,550 union all
select 'B34',7200,600,450,650 union all
select 'B35',4800,400,450,650 union all
select 'B36',4800,400,350,550




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
,isnull(eventHeader.eventName,'') 			            eventName 
,isnull(eventHeader.eventDate,'') 					    eventDate
,isnull(AvailSeatCount,0) 							    AvailSeatCount 
,isnull(vistingticketSet.visitingTicketQty,0)		    visitingTicketQty 
,isnull(vistingticketSet.visitingTicketAmt,0)		    visitingTicketAmt
,isnull(groupSet.groupTicketQty,0)					    groupTicketQty 
,isnull(groupSet.groupTicketAmt,0)					    groupTicketAmt   
,isnull(publicSet.publicTicketQty,0)					publicTicketQty 
,isnull(publicSet.publicTicketAmt,0)				    publicTicketAmt 
,isnull(suiteSet.suiteTicketQty,0)					    suiteTicketQty 
,isnull(suiteSet.suiteTicketAmt,0)				        suiteTicketAmt 
,isnull(budget.quantity,0) as budgetedQuantity																					 
,isnull(budget.amount,0) as budgetedAmount																						 
																																 
,isnull(vistingticketSet.visitingTicketQty,0)  + isnull(groupSet.groupTicketQty,0)												 
      + isnull(publicSet.publicTicketQty,0) + isnull(suiteSet.suiteTicketQty,0) as TotalTickets																		 
      																															   
,isnull(vistingticketSet.visitingTicketAmt,0)  + isnull(groupSet.groupTicketAmt,0)
      + isnull(publicSet.publicTicketAmt,0) + isnull(suiteSet.suiteTicketAmt,0) as TotalRevenue 
       
,case when budget.amount = 0 then 0 else (isnull(vistingticketSet.visitingTicketAmt,0) 
	  +  isnull(groupSet.groupTicketAmt,0) + isnull(publicSet.publicTicketAmt,0) 
	  + isnull(suiteSet.suiteTicketAmt,0))/ budget.amount end  as PercentToGoal 
       
,   (isnull(vistingticketSet.visitingTicketAmt,0) +  isnull(groupSet.groupTicketAmt,0)
      + isnull(publicSet.publicTicketAmt,0) + isnull(suiteSet.suiteTicketAmt,0)) - budget.amount  as VarianceToGoal
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
        ITEM like 'B[0-9]%'
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
        ITEM like 'B[0-9]%'
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
--,sum(ORDTOTAL) as publicTicketAmt
,sum(CASE WHEN rb.I_PT = 'FFP' THEN (ORDTOTAL - ORDQTY*(8)) ELSE ORDTOTAL END) AS publicTicketAmt
from #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                          on rb.ITEM  = eventHeaderEvent.eventCode  
    WHERE 
        ITEM like 'B[0-9]%'
	and rb.I_PT NOT LIKE  'G%'
	and rb.I_PT NOT LIKE 'V%'
	AND rb.I_PT NOT IN ('SSP', 'SSR', 'SSRC')
	and rb.SEASON = @curSeason
	and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.ITEM 
) publicSet 
on eventheader.eventCode  = PublicSet.ITEM 


-------------------------------------------------------------------------------------------


LEFT JOIN  
(
select 
	 rb.ITEM 
,sum(ORDQTY) as suiteTicketQty
--,sum(ORDTOTAL) as suiteTicketAmt
,SUM(CASE 
		WHEN ordqty = 16 THEN budget.suite16 --check B24 multiple suites purchased that day
		WHEN ordqty = 32 THEN budget.suite32
		ELSE 0 end) AS SuiteTicketAmt
from #ReportBase rb  
       INNER JOIN #eventHeader eventHeaderEvent  
       on rb.ITEM  = eventHeaderEvent.eventCode
	   LEFT JOIN #budget budget
	   ON eventHeaderEvent.eventCode = budget.event  
	WHERE 
    ITEM like 'B[0-9]%'
	AND rb.I_PT IN ('SSP', 'SSR', 'SSRC')
	AND rb.SEASON = @curSeason
	AND rb.I_PRICE > 0
	AND ( rb.PAIDTOTAL > 0 )
group by rb.ITEM 
) suiteSet on 
eventheader.eventCode  = suiteSet.ITEM 



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
       AND tkSeatSeat.SEASON= 'B15'
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


SELECT 
	x.*
	,ISNULL(YTD.VarianceYTD,0) AS VarianceYTD
	,ISNULL(YTD.BudgetYTD,0) AS BudgetYTD
	,ISNULL(YTD.ActualYTD,0) AS ActualYTD
	,VarToProj = CASE ISNULL(ytd.budgetYTD,0)  WHEN 0 THEN 0 ELSE ISNULL(YTD.varianceYTD,0) / ISNULL(ytd.budgetYTD,0) END
FROM #singleSummary x
JOIN
(SELECT a.eventCode
,SUM(ISNULL(b.VarianceToGoal,0))  AS varianceYTD
,SUM(ISNULL(b.budgetedAmount,0)) AS budgetYTD
,SUM(ISNULL(b.TotalRevenue,0)) AS actualYTD 
FROM #singleSummary a
JOIN #singleSummary  b
ON a.eventdate >= b.eventdate
GROUP BY a.eventCode) AS YTD
ON x.eventcode = YTD.eventcode
ORDER BY eventDate


END 


GO
