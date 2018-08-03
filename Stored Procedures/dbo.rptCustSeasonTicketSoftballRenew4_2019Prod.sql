SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[rptCustSeasonTicketSoftballRenew4_2019Prod] 

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

      
DECLARE @curSeason VARCHAR(50) = '2019'
DECLARE @Sport VARCHAR(50) = 'Softball'

--DECLARE @dateRange VARCHAR(30) = 'AllData'
--DECLARE @startDate AS DATE = DATEADD(MONTH,-1,GETDATE())
--DECLARE @endDate AS DATE = GETDATE()

CREATE TABLE #pSeasons (SeasonYear VARCHAR (50)) 
INSERT INTO #pSeasons VALUES ('2018') 



---- Build Report --------------------------------------------------------------------------------------------------

Create table #ReportBase  
(
	  SeasonYear			INT
	, Sport					NVARCHAR(255)
	, TicketingAccountId	INT
	, EventCode				NVARCHAR(50)
	, TicketTypeCode		NVARCHAR(25)
	, TicketTypeClass		VARCHAR(100)
	, PC1					NVARCHAR(1)
	, PC3					NVARCHAR(1)
	, QtySeatRenewable		INT 
	, RevenueTotal			NUMERIC (18,6) 
	, TransDateTime			DATETIME  
	, PaidAmount			NUMERIC (18,6)
	, IsComp				INT
)

INSERT INTO #ReportBase (SeasonYear, Sport, TicketingAccountId, EventCode, TicketTypeCode
	, TicketTypeClass, PC1, PC3, QtySeatRenewable, RevenueTotal, TransDateTime, PaidAmount, IsComp) 

SELECT SeasonYear, Sport, TicketingAccountId, EventCode, TicketTypeCode, TicketTypeClass
	, PC1, PC3, QtySeatRenewable, RevenueTotal, TransDateTime, PaidAmount, IsComp
FROM  [ro].[vw_FactTicketSalesBase] fts 
WHERE  fts.Sport = @Sport
	AND TicketTypeCode = 'ASP'
	AND ((@dateRange = 'AllData' AND fts.SeasonYear = @curseason)
		OR (@dateRange <> 'AllData' AND fts.SeasonYear = @curSeason AND fts.TransDateTime BETWEEN @startDate AND @endDate))

------------------------------------------------------------------------------------------------------------------

CREATE TABLE #tournaments
(
	  tournament VARCHAR(MAX)
	, StartDate DATE
	, EndDate DATE
) --COLLATE SQL_Latin1_General_CP1_CS_AS  )

INSERT INTO #tournaments
VALUES
	  ('Kajikawa Classic','2019-02-08', '2019-02-11')
	, ('Littlewood', '2019-02-16', '2019-02-18')



CREATE TABLE #budget 
(
	  tournament VARCHAR (MAX) --COLLATE SQL_Latin1_General_CP1_CS_AS
	, quantity INT
	, amount BIGINT
)

INSERT INTO #budget
VALUES
	  ('Kajikawa Classic'		,0     ,20000)
	, ('Littlewood'			,0     ,3000)


----------------------------------------------------------------------------------------------------------

CREATE TABLE #CYTournamentData
(
	  SeasonYear VARCHAR(15)
	, tournament VARCHAR(100)
	, StartDate DATE
	, EndDate DATE
	, ORDQTY BIGINT 
	, ORDTOTAL NUMERIC (18,2)
)

INSERT INTO #CYTournamentData
(SeasonYear, Tournament, StartDate, EndDate, ORDQTY, ORDTOTAL)

SELECT SeasonYear
	, 'Kajikawa Classic' AS Tournament
	, '2019-02-08' AS StartDate
	, '2019-02-11' AS EndDate
	, SUM(QtySeatRenewable) ORDQTY
	, SUM(RevenueTotal) ORDTOTAL
FROM #ReportBase ReportBase
WHERE 1=1 
	AND EventCode IN ('19SBSB01', '19SBSB02', '19SBSB03', '19SBSB04') --may need to update each year
	AND ( ReportBase.PaidAmount > 0 )
Group By SeasonYear



INSERT INTO #CYTournamentData
(SeasonYear, Tournament, StartDate, EndDate, ORDQTY, ORDTOTAL)

SELECT SeasonYear
       ,'Littlewood' as Tournament
       ,'2019-02-16' as StartDate
       ,'2019-02-18' as EndDate
       ,SUM(QtySeatRenewable) ORDQTY
       ,SUM(RevenueTotal) ORDTOTAL
FROM #ReportBase ReportBase
WHERE 1=1 
	AND EventCode IN ('19SBSB05', '19SBSB06', '19SBSB07') --may need to update each year
	AND ( ReportBase.PaidAmount > 0 )
Group By SeasonYear


----------------------------------------------------------------------------------------------------------
--Single Game Breakout:
create table #singleSummary
( 
	  Tournament varchar(max)
	, StartDate   date
	, EndDate date
	, AllSessionPassQty bigint
	, AllSessionPassAmt numeric (18,2)
	, budgetedQuantity bigint 
	, budgetedAmount numeric (18,2)
	, PercentToGoal numeric (18,2)
	, VarianceToGoal numeric (18,2)
)

INSERT INTO  #singleSummary (Tournament, StartDate, EndDate, AllSessionPassQty
	, AllSessionPassAmt, budgetedQuantity, budgetedAmount, PercentToGoal, VarianceToGoal) 

SELECT tournaments.Tournament, tournaments.StartDate, tournaments.EndDate, ISNULL(CY.ORDQTY,0) AS AllSessionPassQty
	, ISNULL(CY.ORDTOTAL,0) AS AllSessionPassAmt, ISNULL(budget.quantity,0) AS budgetedQuantity
	, budget.amount AS budgetedAmount
	, CASE WHEN budget.amount = 0 THEN 0
		ELSE (ISNULL(CY.ORDTOTAL,0))/ budget.amount 
		END AS PercentToGoal 
	, ISNULL(CY.ORDTOTAL,0)-budget.amount AS VarianceToGoal 
FROM #tournaments tournaments
LEFT JOIN #CYTournamentData CY
	ON tournaments.Tournament  = CY.Tournament 
LEFT JOIN #budget budget
	ON budget.Tournament =  tournaments.Tournament

---------------------------------------------------------------------------------------
--Result Set 

SELECT #singleSummary.*
	, YTD.varianceYTD
	, YTD.budgetYTD
	, YTD.actualYTD 
	, budgetedQuantity AS budgetedQuantity_ASP
	, budgetedAmount AS budgetedAmount_ASP
FROM #singleSummary 
JOIN (
		SELECT a.tournament, a.StartDate
			, SUM(ISNULL(b.VarianceToGoal,0))  AS varianceYTD
			, SUM(ISNULL(b.budgetedAmount,0)) AS budgetYTD
			, SUM(ISNULL(b.AllSessionPassAmt,0)) AS actualYTD 
		FROM #singleSummary a
		JOIN #singleSummary b
			ON a.StartDate >= b.StartDate
		GROUP BY a.tournament, a.StartDate
	) AS YTD ON #singleSummary.tournament = YTD.tournament
ORDER BY StartDate


END 











GO
