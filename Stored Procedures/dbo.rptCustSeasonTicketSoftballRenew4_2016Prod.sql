SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[rptCustSeasonTicketSoftballRenew4_2016Prod] 

(
  @startDate DATE
, @endDate DATE
, @dateRange VARCHAR(20)
)
AS 
BEGIN

/*
DROP TABLE #SalesBase
DROP TABLE #PaidFinal
DROP TABLE #ReportBase
DROP TABLE #tournaments
DROP TABLE #budget
DROP TABLE #CYTournamentData
DROP TABLE #pSeasons
DROP TABLE  #singleSummary 
*/

--select * from dbo.rpttmpDeleteTournameSummary
--end

      
DECLARE @curSeason VARCHAR(50) = 'SB16'

--DECLARE @dateRange VARCHAR(30) = 'AllData'
--DECLARE @startDate AS DATE = DATEADD(MONTH,-1,GETDATE())
--DECLARE @endDate AS DATE = GETDATE()

CREATE TABLE #pSeasons (Season VARCHAR (50)) 
INSERT INTO #pSeasons VALUES ('SB16') 



---- Build Report --------------------------------------------------------------------------------------------------

CREATE TABLE #ReportBase  
(
  SEASON VARCHAR (15)
,CUSTOMER VARCHAR (20)
,ITEM VARCHAR (32) 
 ,E_PL VARCHAR (10)
,I_PT  VARCHAR (32)
,I_PRICE  NUMERIC (18,2)
,I_DAMT  NUMERIC (18,2)
,ORDQTY BIGINT 
 ,ORDTOTAL NUMERIC (18,2) 
 ,PAIDCUSTOMER  VARCHAR (20)
,MINPAYMENTDATE DATETIME  
 ,PAIDTOTAL NUMERIC (18,2)
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
 WHERE rb.SEASON IN ( @curSeason) 
	   AND (@dateRange = 'AllData'
			OR rb.MINPAYMENTDATE BETWEEN @startDate AND @endDate)


------------------------------------------------------------------------------------------------------------------

CREATE TABLE #tournaments
(
tournament VARCHAR(MAX)
,StartDate DATE
,EndDate DATE
) --COLLATE SQL_Latin1_General_CP1_CS_AS  )

INSERT INTO #tournaments
VALUES
('Kajikawa Classic','2016-02-11', '2016-02-15')
,('Littlewood', '2016-02-19', '2016-02-21')
,('Diamond Devil', '2016-02-26', '2016-02-28')
,('Louisville Slugger', '2016-03-11', '2016-03-13')


CREATE TABLE #budget 
(
tournament VARCHAR (MAX) --COLLATE SQL_Latin1_General_CP1_CS_AS
,quantity INT
,amount BIGINT
)

INSERT INTO #budget
VALUES
('Kajikawa Classic'		,360	,16200)
,('Littlewood'			,220	,5500 )
,('Louisville Slugger'  ,275	,5500 )
,('Diamond Devil'		,80		,2800 )

----------------------------------------------------------------------------------------------------------

CREATE TABLE #CYTournamentData
(
Season VARCHAR(15)
,tournament VARCHAR(100)
,StartDate DATE
,EndDate DATE
,ORDQTY BIGINT 
,ORDTOTAL NUMERIC (18,2)
)

INSERT INTO #CYTournamentData
(Season, Tournament, StartDate, EndDate, ORDQTY, ORDTOTAL)

SELECT
       Season
       ,'Kajikawa Classic' AS Tournament
       ,'2016-02-11' AS StartDate
       ,'2016-02-15' AS EndDate
       ,SUM(ORDQTY)
       ,SUM(ORDTOTAL)
FROM #ReportBase ReportBase
WHERE 1=1 AND ITEM IN ('KCA', 'KCD') 
AND ReportBase.I_PRICE > 0
AND ( ReportBase.PAIDTOTAL > 0 )
Group By Season


INSERT INTO #CYTournamentData
(Season, Tournament, StartDate, EndDate, ORDQTY, ORDTOTAL)

SELECT
       Season
       ,'Littlewood' as Tournament
       ,'2016-02-19' as StartDate
       ,'2016-02-21' as EndDate
       ,SUM(ORDQTY)
       ,SUM(ORDTOTAL)
FROM #ReportBase ReportBase
WHERE 1=1 AND ITEM in ('LCA', 'LCD') 
AND ReportBase.I_PRICE > 0
AND ( ReportBase.PAIDTOTAL > 0 )
Group By Season

INSERT INTO #CYTournamentData
(Season, Tournament, StartDate, EndDate, ORDQTY, ORDTOTAL)

SELECT
       Season
       ,'Louisville Slugger' as Tournament
       ,'2015-03-11' as StartDate
       ,'2015-03-13' as EndDate
       ,SUM(ORDQTY)
       ,SUM(ORDTOTAL)
FROM #ReportBase ReportBase
WHERE 1=1 AND ITEM in ('LSA', 'LSD') 
AND ReportBase.I_PRICE > 0
AND ( ReportBase.PAIDTOTAL > 0 )
Group By Season

INSERT INTO #CYTournamentData
(Season, Tournament, StartDate, EndDate, ORDQTY, ORDTOTAL)

SELECT
       Season
       ,'Diamond Devil' as Tournament
       ,'2015-02-26' as StartDate
       ,'2015-02-28' as EndDate
       ,SUM(ORDQTY)
       ,SUM(ORDTOTAL)
FROM #ReportBase ReportBase
WHERE 1=1 AND ITEM in ('DDA', 'DDD') 
AND ReportBase.I_PRICE > 0
AND ( ReportBase.PAIDTOTAL > 0 )
Group By Season

----------------------------------------------------------------------------------------------------------
--Single Game Breakout:
create table #singleSummary
( 
 Tournament varchar(max)
,StartDate   date
,EndDate date
,AllSessionPassQty bigint
,AllSessionPassAmt numeric (18,2)
,budgetedQuantity bigint 
,budgetedAmount numeric (18,2)
,PercentToGoal numeric (18,2)
,VarianceToGoal numeric (18,2)

)

INSERT INTO  #singleSummary 
(
Tournament 
,StartDate
,EndDate
,AllSessionPassQty
,AllSessionPassAmt 
,budgetedQuantity 
,budgetedAmount 
,PercentToGoal 
,VarianceToGoal 
) 


SELECT 
 tournaments.Tournament
,tournaments.StartDate
,tournaments.EndDate
,ISNULL(CY.ORDQTY,0) AS AllSessionPassQty
,ISNULL(CY.ORDTOTAL,0) AS AllSessionPassAmt
,ISNULL(budget.quantity,0) AS budgetedQuantity
,budget.amount AS budgetedAmount
,CASE WHEN budget.amount = 0 THEN 0
	  ELSE (ISNULL(CY.ORDTOTAL,0))/ budget.amount 
 END AS PercentToGoal 
,ISNULL(CY.ORDTOTAL,0)-budget.amount AS VarianceToGoal 
FROM
#tournaments tournaments

---------------------------------------------------------------------------------------

LEFT JOIN #CYTournamentData CY
ON tournaments.Tournament  = CY.Tournament 

LEFT JOIN #budget budget
ON budget.Tournament =  tournaments.Tournament

---------------------------------------------------------------------------------------
--Result Set 

SELECT 
#singleSummary.*
,YTD.varianceYTD
,YTD.budgetYTD
,YTD.actualYTD 
,budgetedQuantity AS budgetedQuantity_ASP
,budgetedAmount AS budgetedAmount_ASP
FROM #singleSummary 
JOIN
(SELECT a.tournament, a.StartDate
,SUM(ISNULL(b.VarianceToGoal,0))  AS varianceYTD
,SUM(ISNULL(b.budgetedAmount,0)) AS budgetYTD
,SUM(ISNULL(b.AllSessionPassAmt,0)) AS actualYTD 
FROM #singleSummary a
JOIN #singleSummary b
ON a.StartDate >= b.StartDate
GROUP BY a.tournament, a.StartDate) AS YTD
ON #singleSummary.tournament = YTD.tournament
ORDER BY StartDate 


END 

















GO
