SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE   PROCEDURE [dbo].[rptCustSeasonTicketSoftballRenew4_2015Prod] 

as 
BEGIN

/*--DROP TABLE #SalesBase
--DROP TABLE #PaidFinal
DROP TABLE #ReportBase
DROP TABLE #tournaments
DROP TABLE #budget
DROP TABLE #CYTournamentData
DROP TABLE #pSeasons
DROP TABLE  #singleSummary */

--select * from dbo.rpttmpDeleteTournameSummary
--end

      
declare @curSeason varchar(50)

Set @curSeason = 'SB15'

CREATE TABLE #pSeasons (Season varchar (50)) 
Insert into #pSeasons values ('SB15') 



---- Build Report --------------------------------------------------------------------------------------------------

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

create table #tournaments
(
tournament varchar(max)
,StartDate Date
,EndDate Date
) --COLLATE SQL_Latin1_General_CP1_CS_AS  )

insert into #tournaments
Values
('Kajikawa Classic','2015-02-05', '2015-02-08')
,('Littlewood', '2015-02-13', '2015-02-15')
,('Diamond Devil', '2015-02-20', '2015-02-22')
,('Louisville Slugger', '2015-02-27', '2015-03-01')


create table #budget 
(
tournament varchar (max) --COLLATE SQL_Latin1_General_CP1_CS_AS
,amount bigint
,quantity int
)

insert into #budget
Values
('Kajikawa Classic',14000,400)   
,('Littlewood',6000,300)  
,('Louisville Slugger',3000,150)  
,('Diamond Devil',2640,120)   



----------------------------------------------------------------------------------------------------------

create table #CYTournamentData
(
Season varchar(15)
,tournament varchar(100)
,StartDate Date
,EndDate Date
,ORDQTY bigint 
,ORDTOTAL numeric (18,2)
)

INSERT INTO #CYTournamentData
(Season, Tournament, StartDate, EndDate, ORDQTY, ORDTOTAL)

SELECT
       Season
       ,'Kajikawa Classic' as Tournament
       ,'2015-02-05' as StartDate
       ,'2015-02-08' as EndDate
       ,SUM(ORDQTY)
       ,SUM(ORDTOTAL)
FROM #ReportBase ReportBase
WHERE 1=1 AND ITEM in ('KCA', 'KCD', 'KEF') 
AND ReportBase.I_PRICE > 0
AND ( ReportBase.PAIDTOTAL > 0 )
Group By Season


INSERT INTO #CYTournamentData
(Season, Tournament, StartDate, EndDate, ORDQTY, ORDTOTAL)

SELECT
       Season
       ,'Littlewood' as Tournament
       ,'2015-02-13' as StartDate
       ,'2015-02-15' as EndDate
       ,SUM(ORDQTY)
       ,SUM(ORDTOTAL)
FROM #ReportBase ReportBase
WHERE 1=1 AND ITEM in ('LCA', 'LCD', 'LCG') 
AND ReportBase.I_PRICE > 0
AND ( ReportBase.PAIDTOTAL > 0 )
Group By Season

INSERT INTO #CYTournamentData
(Season, Tournament, StartDate, EndDate, ORDQTY, ORDTOTAL)

SELECT
       Season
       ,'Louisville Slugger' as Tournament
       ,'2015-02-27' as StartDate
       ,'2015-03-01' as EndDate
       ,SUM(ORDQTY)
       ,SUM(ORDTOTAL)
FROM #ReportBase ReportBase
WHERE 1=1 AND ITEM in ('LSA', 'LSD', 'LSG') 
AND ReportBase.I_PRICE > 0
AND ( ReportBase.PAIDTOTAL > 0 )
Group By Season

INSERT INTO #CYTournamentData
(Season, Tournament, StartDate, EndDate, ORDQTY, ORDTOTAL)

SELECT
       Season
       ,'Diamond Devil' as Tournament
       ,'2015-02-20' as StartDate
       ,'2015-02-22' as EndDate
       ,SUM(ORDQTY)
       ,SUM(ORDTOTAL)
FROM #ReportBase ReportBase
WHERE 1=1 AND ITEM in ('DDA', 'DDD', 'DDG') 
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

Insert into  #singleSummary 
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


select 
 tournaments.Tournament
,tournaments.StartDate
,tournaments.EndDate
,isnull(CY.ORDQTY,0) as AllSessionPassQty
,isnull(CY.ORDTOTAL,0) as AllSessionPassAmt
,isnull(budget.quantity,0) as budgetedQuantity
,budget.amount as budgetedAmount
,(isnull(CY.ORDTOTAL,0))/ budget.amount as PercentToGoal 
,isnull(CY.ORDTOTAL,0)-budget.amount as VarianceToGoal 
from
#tournaments tournaments

---------------------------------------------------------------------------------------

LEFT JOIN #CYTournamentData CY
on tournaments.Tournament  = CY.Tournament 

LEFT JOIN #budget budget
on budget.Tournament =  tournaments.Tournament

---------------------------------------------------------------------------------------
--Result Set 

select 
#singleSummary.*
,YTD.varianceYTD
,YTD.budgetYTD
,YTD.actualYTD 
,budgetedQuantity as budgetedQuantity_ASP
,budgetedAmount as budgetedAmount_ASP
From #singleSummary 
join
(select a.tournament, a.StartDate
,SUM(isnull(b.VarianceToGoal,0))  as varianceYTD
,SUM(isnull(b.budgetedAmount,0)) as budgetYTD
,SUM(isnull(b.AllSessionPassAmt,0)) as actualYTD 
from #singleSummary a
join #singleSummary b
on a.StartDate >= b.StartDate
group by a.tournament, a.StartDate) as YTD
on #singleSummary.tournament = YTD.tournament
ORDER BY StartDate 


END 



















GO
