SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [dbo].[rptCustExecutiveSummary] as 

set transaction isolation level read uncommitted

declare @curSeason varchar(50)

Set @curSeason = 'F14'


--select * from tk_odet where season = 'F14' and item like 'F%' and I_PL = '11' MBSC  -- make it an FSE


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
select 'F01'  union all 
select 'F02'  union all 
select 'F03'  union all 
select 'F04'  union all 
select 'F05'  union all 
select 'F06'  


create table #budget 
(
event varchar (10) 
,amount float
,totalAmount float
,quantity int
)

insert into #budget
(event , amount, totalAmount, quantity)

Select 'F01',95000, 728600, 1500  UNION ALL
Select 'F02',710000, 1343600, 12500 UNION ALL
Select 'F03',902000, 1535600, 14000  UNION ALL
Select 'F04',783000, 1416600, 12000  UNION ALL
Select 'F05',1800000, 2433600, 17500  UNION ALL
Select 'F06',385000, 1018600, 7000

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
declare @singleSummary table
--create table #singleSummary
( 
 eventCode varchar(100)
,eventName varchar(500)
,eventDate varchar(100)
,singleTicketQty bigint
,singleTicketBudgetAmt numeric (18,2)
,singleTicketBudgetQty bigint
,singleTicketBudgetPct decimal (18,2)
,singleTicketAmt numeric (18,2)
,seasonTicketQty bigint
,seasonTicketAmt numeric (18,2)
,totalTickets bigint 
,totalRevenue numeric (18,2)
,totalBudgetAmount numeric (18,2)
,totalBudgetPct decimal (18,2)
,seatsAvailable numeric (18,2)
,seatsAvailableAvg numeric (18,2)

)

Insert into  @singleSummary 
(
 eventCode
,eventName
,eventDate
,singleTicketQty
,singleTicketBudgetAmt
,singleTicketBudgetQty
,singleTicketBudgetPct
,singleTicketAmt
,seasonTicketQty
,seasonTicketAmt
,totalTickets
,totalRevenue
,totalBudgetAmount
,totalBudgetPct
,seatsAvailable
,seatsAvailableAvg
) 


select 
 isnull(eventHeader.eventCode,'') eventCode
,isnull(eventHeader.eventName,'') eventName
,isnull(eventHeader.eventDate,'') eventDate
,isnull(vistingticketSet.visitingTicketQty,0)
      + isnull(publicSet.publicTicketQty,0) as singleTicketQty
,isnull(budget.amount,0) as singleTicketBudgetAmt
,isnull(budget.quantity,0) as singleTicketBudgetQty
,CAST((isnull(vistingticketSet.visitingTicketQty,0) + isnull(publicSet.publicTicketQty,0))AS decimal)/CAST(isnull(budget.quantity,0) as decimal) as singleTicketBudgetPct
,isnull(vistingticketSet.visitingTicketAmt,0)  + isnull(publicSet.publicTicketAmt,0) as singleTicketAmt 
,isnull(seasonTicketQty,0) as seasonTicketQty
,isnull(seasonTicketAmt,0) as seasonTicketAmt
,isnull(vistingticketSet.visitingTicketQty,0)  + isnull(publicSet.publicTicketQty,0) + isnull(seasonTicketQty,0) as totalTickets
,isnull(vistingticketSet.visitingTicketAmt,0)  + isnull(publicSet.publicTicketAmt,0) + (ISNULL(seasonTicketAmt,0)/6.0) as totalRevenue
,isnull(budget.totalAmount,0) as totalBudgetAmount
,CAST(isnull(vistingticketSet.visitingTicketAmt,0)  + isnull(publicSet.publicTicketAmt,0 + isnull(seasonTicketAmt,0)) as decimal)/CAST(isnull(budget.totalAmount,0) as decimal) as totalBudgetPct
,seatsavailable.seat_count AS seatsAvailable
,(ISNULL(budget.totalAmount,0) - ISNULL(vistingticketSet.visitingTicketAmt,0)  + ISNULL(publicSet.publicTicketAmt,0 + ISNULL(seasonTicketAmt,0)))/seatsavailable.seat_count AS seatAvailableAvg
FROM
#eventHeader eventHeader
LEFT JOIN 
(

SELECT 
rb.ITEM 
,SUM(ORDQTY) AS visitingTicketQty
,SUM((ORDQTY * (CASE WHEN ITEM = 'F01' THEN 50 
                              WHEN ITEM = 'F02' THEN 50
                             WHEN ITEM = 'F03' THEN 65
                             WHEN ITEM = 'F04' THEN 65  
                              WHEN ITEM = 'F05' THEN 125
                             WHEN ITEM = 'F06' THEN 50 
                       END))) AS visitingTicketAmt


FROM #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
          ON rb.ITEM    
           = eventHeaderEvent.eventCode  
  WHERE ITEM LIKE 'F0[1-6]'
  AND rb.E_PL NOT IN  ('10','11') -- deals with single game suites for now  
  AND rb.I_PT IN ('V')
GROUP BY rb.ITEM 
) vistingticketSet ON 
eventheader.eventCode   
 = vistingticketSet.ITEM   
 ----------------------------------------------------------------------------------------------------------
 LEFT JOIN  
(
SELECT 
       rb.ITEM 
,SUM(ORDQTY) AS publicTicketQty
,SUM(ORDTOTAL) AS publicTicketAmt
FROM #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
       ON rb.ITEM  
       = eventHeaderEvent.eventCode   
    WHERE ITEM LIKE 'F0[1-6]%'
    AND rb.E_PL NOT IN ('10','11') -- deals with single game suites for now 
    -- and rb.I_PT NOT LIKE 'G%' 
      --and rb.I_PT NOT IN  ('S', 'STN', 'SSR')
      and rb.I_PT NOT IN  ('V')
      AND rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.ITEM 
) publicSet 
ON eventheader.eventCode  
  = PublicSet.ITEM

JOIN
(
SELECT season, event, SUM(seat_count) AS seat_count
FROM
(
	SELECT   
	tkSeatSeat.season
	,tkSeatSeat.event
	,COUNT(tkseatseat.seat) AS seat_count                                                         
	FROM dbo.TK_SEAT_SEAT tkSeatSeat
              
	INNER JOIN dbo.TK_SSTAT tkSstat 
	ON tkSeatSeat.STAT COLLATE Latin1_General_CS_AS = tkSstat.SSTAT COLLATE Latin1_General_CS_AS 
	AND tkSeatSeat.Season = tkSstat.Season 

	WHERE 
		   tkSeatSeat.STAT<> '-'
			   AND tkSeatSeat.STAT<> 'N'--added to remove No Seats
			   AND tkSeatSeat.STAT<> 'K' 
	AND tkSeatSeat.SEASON= 'F14'
	--AND tkSeatSeat.EVENT= 'F06'
	AND LEVEL <> 'S' 
	--holds don't want
	AND tkSeatSeat.STAT<>  'B'
	AND tkSeatSeat.STAT<>  'p'
	AND tkSeatSeat.STAT<>  'h'
	AND tkSeatSeat.STAT<>  'r'
	AND tkSeatSeat.STAT<>  'i'
	AND tkSeatSeat.STAT<>  'X'
	AND tkSeatSeat.STAT <> 'f'
	AND ISNULL(PL,99999)  NOT IN ('6','5','10','11')  
	GROUP BY 
		tkSeatSeat.season
		,tkSeatSeat.event
) a
GROUP BY season, event
) seatsavailable
ON eventHeader.eventCode = seatsavailable.EVENT COLLATE database_default
--6 & 5 – are students; 10 & 11 are suites and MBSC so I’m not sure that we need to include 10 & 11 here

JOIN
(
	SELECT season, SUM(QTY) AS seasonTicketQty, SUM(AMT) AS seasonTicketAmt
	FROM
	(
		SELECT 
			 SEASON 
			 ,'Mini Plans FSE' AS sub
			 ,CASE WHEN ITEM LIKE '2%' THEN  SUM(ORDQTY) * 2/6
				   WHEN ITEM LIKE '3%' THEN SUM(ORDQTY) * 3/6
				   WHEN ITEM LIKE '4%' THEN SUM(ORDQTY) * 4/6
				   WHEN ITEM LIKE '5%' THEN SUM(ORDQTY) * 5/6
				   WHEN ITEM = 'FS' THEN SUM(ORDQTY)
				END AS QTY
			,SUM(ORDTOTAL) AMT
		FROM #ReportBase 
		WHERE  (ITEM LIKE '[2-5]%' OR Item = 'FS')
			   AND SEASON IN ('F14')--(@curSeason)
			AND ( PAIDTOTAL > 0 OR CUSTOMER IN ('152760','164043','186078'))
			AND CUSTOMER <> '137398'
		GROUP BY SEASON , ITEM   
	) a
	GROUP BY season
) seasontix
ON 1=1
LEFT JOIN #budget budget
ON budget.event  =  eventHeader.eventCode 

---------------------------------------------------------------------------------------
--Result Set 


SELECT 
	CASE grouping_id(eventcode,eventname, eventdate)
	WHEN 7 THEN 'Total'
	ELSE eventname END AS RowLabel,
	eventcode,eventname, eventdate, SUM(singleTicketQty) singleTicketQty, SUM(seasonticketqty) seasonticketQty, SUM(x.seasonTicketAmt/6.0) seasonTicketAmt, 
	SUM(x.seatsAvailable) seatsAvailable, (SUM(x.totalBudgetAmount) - SUM(x.totalRevenue))/ SUM(x.seatsAvailable) seatsAvailableAvg, SUM(x.singleTicketAmt) singleTicketAmt, 
	SUM(x.singleTicketAmt)/SUM(x.singleTicketBudgetAmt*1.0) singleTicketBudgetPct,
	SUM(x.singleTicketBudgetAmt) singleTicketBudgetAmt, SUM(x.singleTicketBudgetQty) singleTicketBudgetQty, 
	SUM(x.totalBudgetAmount) totalBudgetAmount,
	SUM(x.totalRevenue)/SUM(x.totalBudgetAmount) totalBudgetPct, SUM(x.totalRevenue) totalRevenue, SUM(x.totalTickets) totalTickets,
	SUM(x.totalRevenue)/SUM(x.totalTickets) avgTicketPrice
FROM @singleSummary x
GROUP BY GROUPING SETS ((eventCode, eventName,eventDate), ())
ORDER BY grouping_id(eventcode,eventname, eventdate) ASC, eventCode




GO
