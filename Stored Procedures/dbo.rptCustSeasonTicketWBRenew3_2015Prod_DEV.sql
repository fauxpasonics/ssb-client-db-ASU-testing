SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [dbo].[rptCustSeasonTicketWBRenew3_2015Prod_DEV] 
    (
      @startDate DATE
    , @endDate DATE
    , @dateRange VARCHAR(20)
    )
AS

/*
DROP TABLE #budget
DROP TABLE #eventHeader
DROP TABLE #homegames
DROP TABLE #ReportBase
*/

BEGIN

set transaction isolation level read uncommitted

declare @curSeason varchar(50)

Set @curSeason = 'WB15'

--DECLARE	@dateRange VARCHAR(20)= 'AllData'
--DECLARE @startDate DATE = DATEADD(day,-1,GETDATE())
--DECLARE @endDate DATE = GETDATE()

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
 WHERE   (@dateRange = 'AllData' 
		 AND rb.season = @curseason)
		OR (@dateRange <> 'AllData' 
			AND rb.season = @curSeason 
			AND rb.MINPAYMENTDATE 
				BETWEEN @startDate AND @endDate) 

------------------------------------------------------------------------------------------------------------------

create table #homegames
(event varchar(50)   )

insert into #homegames
(event)
select 'WB01'  union all 
select 'WB02'  union all 
select 'WB03'  union all 
select 'WB04'  union all 
select 'WB05'  union all 
select 'WB06'  union all 
select 'WB07'  union all
select 'WB08'  union all 
select 'WB09'  union all 
select 'WB10'  union all 
select 'WB11'  union all 
select 'WB12'  union all 
select 'WB13'  union all 
select 'WB14'  union all
select 'WB15'  --union all select 'WB16'   

create table #budget 
(
event varchar (10) 
,amount float
,quantity int
)

insert into #budget
(event , amount, quantity)

SELECT 'WB01'	,'5100'	,'600'  UNION ALL 
SELECT 'WB02'	,'2125'	,'250'  UNION ALL 
SELECT 'WB03'	,'1700'	,'200'  UNION ALL 
SELECT 'WB04'	,'3825'	,'450'  UNION ALL 
SELECT 'WB05'	,'4500'	,'600'  UNION ALL 
SELECT 'WB06'	,'2400'	,'200'  UNION ALL 
SELECT 'WB07'	,'5120'	,'512'  UNION ALL
SELECT 'WB08'	,'8800'	,'800'  UNION ALL 
SELECT 'WB09'	,'1815'	,'165'  UNION ALL 
SELECT 'WB10'	,'4950'	,'550'  UNION ALL 
SELECT 'WB11'	,'6400'	,'800'  UNION ALL 
SELECT 'WB12'	,'5100'	,'600'  UNION ALL 
SELECT 'WB13'	,'2250'	,'250'  UNION ALL 
SELECT 'WB14'	,'5100'	,'600'  UNION ALL
SELECT 'WB15'	,'6163'	,'725'  



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


--INSERT INTO  @singleSummary 
--(
--EventCode 
--,EventName 
--,EventDate 
--,VisitingTicketQty 
--,VisitingTicketAmt
--,GroupTicketQty 
--,GroupTicketAmt   
--,PublicTicketQty 
--,PublicTicketAmt 
--,BudgetedQuantity 
--,BudgetedAmount
--,TotalTickets  
--,TotalRevenue 
--,PercentToGoal 
--,VarianceToGoal 
--) 


SELECT 
 ISNULL(eventHeader.eventCode,'')                                                                                                eventCode 
,ISNULL(eventHeader.eventName,'') 																								 eventName 
,ISNULL(eventHeader.eventDate,'') 																								 eventDate
,ISNULL(vistingticketSet.visitingTicketQty,0)																					 visitingTicketQty 
,ISNULL(vistingticketSet.visitingTicketAmt,0)																					 visitingTicketAmt
,ISNULL(groupSet.groupTicketQty,0)																								 groupTicketQty 
,ISNULL(groupSet.groupTicketAmt,0)																								 groupTicketAmt   
,ISNULL(publicSet.publicTicketQty,0)																							 publicTicketQty 
,ISNULL(publicSet.publicTicketAmt,0)																							 publicTicketAmt 
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

SELECT 
	 rb.ITEM 
,SUM(ORDQTY) AS visitingTicketQty
,SUM(ORDTOTAL) AS visitingTicketAmt
FROM #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                          ON rb.ITEM  = eventHeaderEvent.eventCode  
WHERE ITEM IN (SELECT event FROM #homegames)
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
WHERE ITEM IN (SELECT event FROM #homegames)
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
,SUM(ORDTOTAL) AS publicTicketAmt
FROM #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
                          ON rb.ITEM  = eventHeaderEvent.eventCode  
WHERE ITEM IN (SELECT event FROM #homegames)
	  AND rb.I_PT NOT LIKE  'G%'
	  AND rb.I_PT NOT LIKE 'V%'
	  AND rb.SEASON = @curSeason
	  AND rb.I_PRICE > 0
	  AND ( rb.PAIDTOTAL > 0 )
GROUP BY rb.ITEM 
) publicSet 
ON eventheader.eventCode  = PublicSet.ITEM 
LEFT JOIN #budget budget
ON budget.event =  eventHeader.eventCode

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
JOIN #singleSummary b
ON a.eventdate >= b.eventdate
GROUP BY a.eventCode) AS YTD
ON x.eventcode = YTD.eventcode






END 








GO
