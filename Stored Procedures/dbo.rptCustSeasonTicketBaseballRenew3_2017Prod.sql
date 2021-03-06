SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO











--exec rptCustSeasonTicketBaseballRenew3_2015Prod

CREATE PROCEDURE [dbo].[rptCustSeasonTicketBaseballRenew3_2017Prod] 
(
  @startDate DATE
, @endDate DATE
, @dateRange VARCHAR(20)
)
AS 

BEGIN

IF OBJECT_ID('tempdb..#budget')IS NOT NULL	
DROP TABLE #budget
IF OBJECT_ID('tempdb..#ReportBase')IS NOT NULL	
DROP TABLE #ReportBase
IF OBJECT_ID('tempdb..#homegames')IS NOT NULL	
DROP TABLE #homegames
IF OBJECT_ID('tempdb..#eventHeader')IS NOT NULL	
DROP TABLE #eventHeader
IF OBJECT_ID('tempdb..#singleSummary')IS NOT NULL	
DROP TABLE #singleSummary

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @curSeason VARCHAR(50) = 'B17'

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
	   AND (@dateRange = 'AllData'
			OR rb.MINPAYMENTDATE BETWEEN @startDate AND @endDate) 

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
select 'B33'  

CREATE TABLE #budget 
(
event varchar (10) 
,amount float
,quantity INT
,suite16 int
,suite32 int
)

INSERT INTO #budget
(		event , quantity, amount, suite16, suite32)

SELECT 'B01'	,0	,7500	,0	,0	UNION ALL
SELECT 'B02'	,0	,6000	,0	,0	UNION ALL
SELECT 'B03'	,0	,4000	,0	,0	UNION ALL
SELECT 'B04'	,0	,5000	,0	,0	UNION ALL
SELECT 'B05'	,0	,5000	,0	,0	UNION ALL
SELECT 'B06'	,0	,6000	,0	,0	UNION ALL
SELECT 'B07'	,0	,7500	,0	,0	UNION ALL
SELECT 'B08'	,0	,4000	,0	,0	UNION ALL
SELECT 'B09'	,0	,9000	,0	,0	UNION ALL
SELECT 'B10'	,0	,9000	,0	,0	UNION ALL
SELECT 'B11'	,0	,8500	,0	,0	UNION ALL
SELECT 'B12'	,0	,10000	,0	,0	UNION ALL
SELECT 'B13'	,0	,8000	,0	,0	UNION ALL
SELECT 'B14'	,0	,20000	,0	,0	UNION ALL
SELECT 'B15'	,0	,15000	,0	,0	UNION ALL
SELECT 'B16'	,0	,12000	,0	,0	UNION ALL
SELECT 'B17'	,0	,9000	,0	,0	UNION ALL
SELECT 'B18'	,0	,15000	,0	,0	UNION ALL
SELECT 'B19'	,0	,15000	,0	,0	UNION ALL
SELECT 'B20'	,0	,10000	,0	,0	UNION ALL
SELECT 'B21'	,0	,7500	,0	,0	UNION ALL
SELECT 'B22'	,0	,9000	,0	,0	UNION ALL
SELECT 'B23'	,0	,12000	,0	,0	UNION ALL
SELECT 'B24'	,0	,7000	,0	,0	UNION ALL
SELECT 'B25'	,0	,4500	,0	,0	UNION ALL
SELECT 'B26'	,0	,6500	,0	,0	UNION ALL
SELECT 'B27'	,0	,4000	,0	,0	UNION ALL
SELECT 'B28'	,0	,16000	,0	,0	UNION ALL
SELECT 'B29'	,0	,14000	,0	,0	UNION ALL
SELECT 'B30'	,0	,9000	,0	,0	UNION ALL
SELECT 'B31'	,0	,16000	,0	,0	UNION ALL
SELECT 'B32'	,0	,18000	,0	,0	UNION ALL
SELECT 'B33'	,0	,21000	,0	,0	



CREATE TABLE #eventHeader
(
eventCode varchar(50)  
,eventName  varchar(200)
,eventDate date
)

INSERT INTO #eventHeader
(
eventCode 
,eventName
,eventDate
)
SELECT 
 tkEvent.event 
,tkEvent.name
,cast (date as date) EventDate
FROM TK_EVENT tkEvent with (nolock) 
     INNER JOIN #homegames homegames 
                ON tkEvent.event   COLLATE SQL_Latin1_General_CP1_CS_AS
                   = homegames.event COLLATE SQL_Latin1_General_CP1_CS_AS 
WHERE tkEvent.season  =  @curSeason
and tkEvent.name not like '%@%'

----------------------------------------------------------------------------------------------------------

SELECT 
 ISNULL(eventHeader.eventCode,'')                       eventCode 
,ISNULL(eventHeader.eventName,'') 			            eventName 
,ISNULL(eventHeader.eventDate,'') 					    eventDate
,ISNULL(AvailSeatCount,0) 							    AvailSeatCount 
,ISNULL(vistingticketSet.visitingTicketQty,0)		    visitingTicketQty 
,ISNULL(vistingticketSet.visitingTicketAmt,0)		    visitingTicketAmt
,ISNULL(groupSet.groupTicketQty,0)					    groupTicketQty 
,ISNULL(groupSet.groupTicketAmt,0)					    groupTicketAmt   
,ISNULL(publicSet.publicTicketQty,0)					publicTicketQty 
,ISNULL(publicSet.publicTicketAmt,0)				    publicTicketAmt 
,ISNULL(suiteSet.suiteTicketQty,0)					    suiteTicketQty 
,ISNULL(suiteSet.suiteTicketAmt,0)				        suiteTicketAmt 
,ISNULL(budget.quantity,0) AS budgetedQuantity																					 
,ISNULL(budget.amount,0) AS budgetedAmount																						 
																																 
,ISNULL(vistingticketSet.visitingTicketQty,0)  + ISNULL(groupSet.groupTicketQty,0)												 
      + ISNULL(publicSet.publicTicketQty,0) + ISNULL(suiteSet.suiteTicketQty,0) AS TotalTickets																		 
      																															   
,ISNULL(vistingticketSet.visitingTicketAmt,0)  + ISNULL(groupSet.groupTicketAmt,0)
      + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0) AS TotalRevenue 
       
,CASE WHEN budget.amount = 0 THEN 0 ELSE (ISNULL(vistingticketSet.visitingTicketAmt,0) 
	  +  ISNULL(groupSet.groupTicketAmt,0) + ISNULL(publicSet.publicTicketAmt,0) 
	  + ISNULL(suiteSet.suiteTicketAmt,0))/ budget.amount END  AS PercentToGoal 
       
,   (ISNULL(vistingticketSet.visitingTicketAmt,0) +  ISNULL(groupSet.groupTicketAmt,0)
      + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0)) - budget.amount  AS VarianceToGoal
INTO #singleSummary


FROM
#eventHeader eventHeader
LEFT JOIN 
(

SELECT 
	 rb.ITEM 
,SUM(ORDQTY) AS visitingTicketQty
,SUM(ORDTOTAL) AS visitingTicketAmt
FROM #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                          ON rb.ITEM  = eventHeaderEvent.eventCode  
    WHERE 
        ITEM LIKE 'B[0-9]%'
	AND rb.I_PT IN ('V')
	AND rb.SEASON = @curSeason
	AND rb.I_PRICE > 0
GROUP BY rb.ITEM 
) vistingticketSet 
ON eventheader.eventCode  = vistingticketSet.ITEM    

-------------------------------------------------------------------------------------------


LEFT JOIN  
(
SELECT 
	 rb.ITEM 
,SUM(ORDQTY) AS groupTicketQty
,SUM(ORDTOTAL) AS groupTicketAmt
FROM #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                ON rb.ITEM  = eventHeaderEvent.eventCode  
    WHERE 
        ITEM LIKE 'B[0-9]%'
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
SELECT 
	 rb.ITEM 
,SUM(ORDQTY) AS publicTicketQty
,SUM(CASE WHEN rb.I_PT = 'FFP' THEN (ORDTOTAL - ORDQTY*(8)) ELSE ORDTOTAL END) AS publicTicketAmt
FROM #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                          ON rb.ITEM  = eventHeaderEvent.eventCode  
    WHERE 
        ITEM LIKE 'B[0-9]%'
	AND rb.I_PT NOT LIKE  'G%'
	AND rb.I_PT NOT LIKE 'V%'
	AND rb.I_PT NOT LIKE 'SSR%'
	AND rb.SEASON = @curSeason
	AND rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.ITEM 
) publicSet 
ON eventheader.eventCode  = PublicSet.ITEM 


-------------------------------------------------------------------------------------------


LEFT JOIN  
(
SELECT 
	 rb.ITEM 
,SUM(ORDQTY) AS suiteTicketQty
,SUM(ORDTOTAL) AS SuiteTicketAmt
FROM #ReportBase rb  
       INNER JOIN #eventHeader eventHeaderEvent  
       ON rb.ITEM  = eventHeaderEvent.eventCode
	   LEFT JOIN #budget budget
	   ON eventHeaderEvent.eventCode = budget.event  
	WHERE 
    ITEM LIKE 'B[0-9]%'
	AND rb.I_PT like 'SSR%'
	AND rb.SEASON = @curSeason
	AND rb.I_PRICE > 0
	AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.ITEM 
) suiteSet ON 
eventheader.eventCode  = suiteSet.ITEM 



LEFT JOIN #budget budget
ON budget.event =  eventHeader.eventCode


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
       AND tkSeatSeat.SEASON = @curseason
       --holds don't want
       AND tkSeatSeat.STAT<>  'B'
       AND tkSeatSeat.STAT<>  'v'
       AND tkSeatSeat.STAT<>  'p'
       AND tkSeatSeat.STAT<>  'r'
       AND tkSeatSeat.STAT<>  'i'
       AND tkSeatSeat.STAT <> 'c'
       AND tkSeatSeat.STAT <> 'f'
       AND tkSeatSeat.STAT <> 'X'
	   AND tkSeatSeat.STAT <> 'h'
 
       GROUP BY
              tkSeatSeat.season
              ,tkSeatSeat.event
 
) a
GROUP BY season, event
) seatsavailable
ON eventHeader.eventCode = seatsavailable.EVENT COLLATE DATABASE_DEFAULT

---------------------------------------------------------------------------------------
--Result Set 


SELECT x.*
	  ,ISNULL(YTD.VarianceYTD,0) AS VarianceYTD
	  ,ISNULL(YTD.BudgetYTD,0) AS BudgetYTD
	  ,ISNULL(YTD.ActualYTD,0) AS ActualYTD
	  ,CASE ISNULL(ytd.budgetYTD,0)  
	  		WHEN 0 
	  		THEN 0 
	  		ELSE ISNULL(YTD.varianceYTD,0) / ISNULL(ytd.budgetYTD,0) 
	   END AS VarToProj
FROM #singleSummary x
	 JOIN (SELECT a.eventCode
				 ,SUM(ISNULL(b.VarianceToGoal,0))  AS varianceYTD
				 ,SUM(ISNULL(b.budgetedAmount,0)) AS budgetYTD
				 ,SUM(ISNULL(b.TotalRevenue,0)) AS actualYTD 
		   FROM #singleSummary a
				 JOIN #singleSummary  b
					  ON a.eventdate >= b.eventdate
		   GROUP BY a.eventCode
		   ) AS YTD
		   ON x.eventcode = YTD.eventcode
ORDER BY eventDate

END 










GO
