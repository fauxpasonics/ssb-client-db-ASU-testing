SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE  PROCEDURE [dbo].[rptCustSeasonTicketSoftballRenew3_2016Prod] 
(
  @startDate DATE
, @endDate DATE
, @dateRange VARCHAR(20)
)
AS 



IF object_id('tempdb..#budget')IS NOT null
	DROP TABLE #budget
IF object_id('tempdb..#eventHeader')IS NOT null
	DROP TABLE #eventHeader
IF object_id('tempdb..#homegames')IS NOT null
	DROP TABLE #homegames
IF object_id('tempdb..#ReportBase')IS NOT null
	DROP TABLE #ReportBase
IF object_id('tempdb..#singleSummary')IS NOT null
	DROP TABLE #singleSummary

BEGIN

set transaction isolation level read uncommitted

declare @curSeason varchar(50)

Set @curSeason = 'SB16'

--DECLARE @dateRange VARCHAR(30) = 'AllData'
--DECLARE @startDate AS DATE = DATEADD(MONTH,-1,GETDATE())
--DECLARE @endDate AS DATE = GETDATE()


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
FROM vwTIReportBase rb 
WHERE rb.SEASON = @curSeason 
	  AND ( @dateRange = 'AllData'
			OR (rb.MINPAYMENTDATE BETWEEN @startDate AND @endDate))

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
select 'SB26'  union ALL
select 'SB27'  union ALL
select 'SB28'  union ALL
select 'SB29'  


create table #budget 
(
event varchar (10) 
,amount float
,quantity int
)

insert into #budget
(event , amount, quantity)

select	'SB01'	,3000	,318	union all
select	'SB02'	,10000	,1014	union all
select	'SB03'	,14000	,1406	union all
select	'SB04'	,9000	,906	union all
select	'SB05'	,2500	,255	union all
select	'SB06'	,3000	,306	union all
select	'SB07'	,5000	,514	union all
select	'SB08'	,4000	,404	union all
select	'SB09'	,3000	,306	union all
select	'SB10'	,5000	,514	union all
select	'SB11'	,2500	,257	union all
select	'SB12'	,5000	,495	union all
select	'SB13'	,2000	,206	union all
select	'SB14'	,3500	,348	union all
select	'SB15'	,8500	,1000	union all
select	'SB16'	,8500	,1036	union all
select	'SB17'	,8000	,928	union all
select	'SB18'	,3000	,342	union all
select	'SB19'	,4500	,513	union all
select	'SB20'	,5500	,659	union all
select	'SB21'	,6500	,780	union all
select	'SB22'	,7500	,926	union all
select	'SB23'	,5500	,635	union all
select	'SB24'	,8500	,1000	union all
select	'SB25'	,8500	,1036	union all
select	'SB26'	,8000	,928	union all
select	'SB27'	,4500	,513	union all
select	'SB28'	,5500	,635	union all
select	'SB29'	,3000	,342	



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
SELECT  tkEvent.EVENT
        ,tkEvent.NAME
        ,CAST (DATE AS DATE) EventDate
FROM    TK_EVENT tkEvent WITH ( NOLOCK )
        INNER JOIN #homegames homegames 
				   ON tkEvent.EVENT COLLATE SQL_Latin1_General_CP1_CS_AS = homegames.event COLLATE SQL_Latin1_General_CP1_CS_AS
WHERE   tkEvent.SEASON = @curSeason
        AND tkEvent.NAME NOT LIKE '%@%'

----------------------------------------------------------------------------------------------------------

SELECT 
 ISNULL(eventHeader.eventCode,'')  eventCode 
,ISNULL(eventHeader.eventName,'') eventName 
,ISNULL(eventHeader.eventDate,'') eventDate
,ISNULL(AvailSeatCount,0) AvailSeatCount 
,ISNULL(vistingticketSet.visitingTicketQty,0) visitingTicketQty 
,ISNULL(vistingticketSet.visitingTicketAmt,0) visitingTicketAmt
,ISNULL(groupSet.groupTicketQty,0) groupTicketQty 
,ISNULL(groupSet.groupTicketAmt,0) groupTicketAmt   
,ISNULL(publicSet.publicTicketQty,0) publicTicketQty 
,ISNULL(publicSet.publicTicketAmt,0) publicTicketAmt 
,ISNULL(budget.quantity,0) AS budgetedQuantity                                                                                                                                                                                                                                                                                                                                       
,ISNULL(budget.amount,0) AS budgetedAmount                                                                                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
,ISNULL(vistingticketSet.visitingTicketQty,0)  + ISNULL(groupSet.groupTicketQty,0)                                                                                                                                                                                          
      + ISNULL(publicSet.publicTicketQty,0) AS TotalTickets                                                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
,ISNULL(vistingticketSet.visitingTicketAmt,0)  + ISNULL(groupSet.groupTicketAmt,0)
      + ISNULL(publicSet.publicTicketAmt,0) AS TotalRevenue 
       
,CASE WHEN budget.amount = 0 THEN 0 ELSE (ISNULL(vistingticketSet.visitingTicketAmt,0) +  ISNULL(groupSet.groupTicketAmt,0)
      + ISNULL(publicSet.publicTicketAmt,0))/ budget.amount END  AS PercentToGoal 
       
,   (ISNULL(vistingticketSet.visitingTicketAmt,0) +  ISNULL(groupSet.groupTicketAmt,0)
      + ISNULL(publicSet.publicTicketAmt,0)) - budget.amount  AS VarianceToGoal
INTO #singleSummary


FROM
#eventHeader eventHeader
LEFT JOIN 
(
SELECT  rb.ITEM 
        ,SUM(ORDQTY) AS visitingTicketQty 
        ,SUM(ORDTOTAL) AS visitingTicketAmt
FROM    #ReportBase rb
        INNER JOIN #eventHeader eventHeaderEvent ON rb.ITEM = eventHeaderEvent.eventCode
WHERE   ITEM LIKE 'SB[0-9]%'
        AND rb.I_PT IN ( 'V' )
        AND rb.SEASON = @curSeason
        AND rb.I_PRICE > 0
GROUP BY rb.ITEM 
) vistingticketSet 
ON eventheader.eventCode  = vistingticketSet.ITEM    

-------------------------------------------------------------------------------------------


LEFT JOIN  
(
SELECT  rb.ITEM 
        ,SUM(ORDQTY) AS groupTicketQty 
        ,SUM(ORDTOTAL) AS groupTicketAmt
FROM    #ReportBase rb
        INNER JOIN #eventHeader eventHeaderEvent ON rb.ITEM = eventHeaderEvent.eventCode
WHERE   ITEM LIKE 'SB[0-9]%'
        AND rb.I_PT LIKE 'G%'
        AND rb.SEASON = @curSeason
        AND rb.I_PRICE > 0
        AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.ITEM 
) GroupSet ON 
eventheader.eventCode  = GroupSet.ITEM 



----------------------------------------------------------------------------------------------------------

LEFT JOIN  
(
SELECT  rb.ITEM 
        ,SUM(ORDQTY) AS publicTicketQty 
        ,SUM(ORDTOTAL) AS publicTicketAmt
FROM    #ReportBase rb
        INNER JOIN #eventHeader eventHeaderEvent 
				   ON rb.ITEM = eventHeaderEvent.eventCode
WHERE   ITEM LIKE 'SB[0-9]%'
        AND rb.I_PT NOT LIKE 'G%'
        AND rb.I_PT NOT LIKE 'V%'
        AND rb.SEASON = @curSeason
        AND rb.I_PRICE > 0
        AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.ITEM 
) publicSet 
ON eventheader.eventCode  = PublicSet.ITEM 

LEFT JOIN #budget budget
ON budget.event =  eventHeader.eventCode


LEFT JOIN
(
SELECT season, event, SUM(AvailSeatCount) AS AvailSeatCount
FROM ( SELECT tkSeatSeat.season
			 ,tkSeatSeat.event
			 ,COUNT(tkseatseat.seat) AS AvailSeatCount                                                        
       FROM dbo.TK_SEAT_SEAT tkSeatSeat             
			INNER JOIN dbo.TK_SSTAT tkSstat
			ON tkSeatSeat.STAT COLLATE Latin1_General_CS_AS = tkSstat.SSTAT COLLATE Latin1_General_CS_AS
			AND tkSeatSeat.Season = tkSstat.Season
       WHERE tkSeatSeat.STAT<> '-'
             AND tkSeatSeat.STAT<> 'N'--added to remove No Seats
             AND tkSeatSeat.STAT<> 'K'		 
			 AND tkSeatSeat.STAT<>  'B'
			AND tkSeatSeat.STAT<>  'v'
			 AND tkSeatSeat.STAT<>  'p'
			 AND tkSeatSeat.STAT<>  'r'
			 AND tkSeatSeat.STAT<>  'i'
			 AND tkSeatSeat.STAT <> 'c'
			 AND tkSeatSeat.STAT <> 'f'
			 AND tkSeatSeat.STAT <> 'X'
			 AND tkSeatSeat.SEASON= 'SB16'	
       GROUP BY tkSeatSeat.season
                ,tkSeatSeat.event
	  ) a
GROUP BY season, event
) seatsavailable
ON eventHeader.eventCode = seatsavailable.EVENT COLLATE DATABASE_DEFAULT


---------------------------------------------------------------------------------------
--Result Set 


SELECT 
      x.*
      ,ISNULL(YTD.VarianceYTD,0) AS VarianceYTD
      ,ISNULL(YTD.BudgetYTD,0) AS BudgetYTD
      ,ISNULL(YTD.ActualYTD,0) AS ActualYTD
      ,VarToProj = CASE ISNULL(ytd.budgetYTD,0)  
						WHEN 0 THEN 0 
						ELSE ISNULL(YTD.varianceYTD,0) 
							 / ISNULL(ytd.budgetYTD,0) 
				   END
FROM #singleSummary x
	 JOIN (SELECT a.eventCode
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
