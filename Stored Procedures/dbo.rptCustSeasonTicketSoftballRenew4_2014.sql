SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE   PROCEDURE [dbo].[rptCustSeasonTicketSoftballRenew4_2014] 



as 
BEGIN

/*DROP TABLE #SalesBase
DROP TABLE #PaidFinal
DROP TABLE #ReportBase
DROP TABLE #tournaments
DROP TABLE #budget
DROP TABLE #CYTournamentData
DROP TABLE #pSeasons
DROP TABLE  #singleSummary */

      
declare @curSeason varchar(50)

Set @curSeason = 'SB14'

CREATE TABLE #pSeasons (Season varchar (50)) 
Insert into #pSeasons values ('SB14')

-- Create #SalesBase --------------------------------------------------------------------------------------------------

Create table #SalesBase 
(
  SEASON varchar (15) 
 ,CUSTOMER varchar (20)
,ITEM varchar (32) --COLLATE SQL_Latin1_General_CP1_CS_AS 
 ,E_PL varchar (10)
,I_PT  varchar (32) --COLLATE SQL_Latin1_General_CP1_CS_AS
,I_PRICE  numeric (18,2)
,I_DAMT  numeric (18,2)
,ORDQTY bigint 
 ,ORDTOTAL numeric (18,2) 

) 

Insert Into #SalesBase
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

)

select
     tkTrans.SEASON
      ,tkTransItem.CUSTOMER
      ,tkTransItem.ITEM
      ,tkTransItemEvent.E_PL
      ,tkTransItem.I_PT
      ,tkTransItem.I_PRICE
      ,tkTransItem.I_DAMT 
      ,sum(isnull(tkTransItem.I_OQTY_TOT,0)) ORDQTY
      ,sum(isnull(tkTransItem.I_OQTY_TOT,0) * (isnull(I_Price,0) - isnull(I_Damt,0)))   as ORDTOTAL
      
FROM 
      dbo.TK_TRANS tkTrans
      INNER JOIN dbo.TK_TRANS_ITEM tkTransItem
      on tkTrans.Season = tkTransItem.Season
      and tkTrans.Trans_No = tkTransItem.Trans_No
            
       
      LEFT JOIN 
       (select
         subtkTransItemEvent.SEASON,
         max(isnull(subtkTransItemEvent.E_PL,5)) E_PL,
         subtkTransItemEvent.TRANS_NO,
         subtkTransItemEvent.VMC
        FROM
         dbo.TK_TRANS_ITEM_EVENT subtkTransItemEvent
        INNER JOIN  #pSeasons subpSeasons
         on subtkTransItemEvent.SEASON = subpSeasons.Season
        group by
         subtkTransItemEvent.SEASON,
         subtkTransItemEvent.TRANS_NO,
         subtkTransItemEvent.VMC) tkTransItemEvent
                 on tkTransItem.SEASON = tkTransItemEvent.SEASON 
                 and tkTransItem.TRANS_NO = tkTransItemEvent.TRANS_NO 
                 and tkTransItem.VMC = tkTransItemEvent.VMC
      
      INNER JOIN  dbo.TK_ITEM tkItem
      on tkTransItem.SEASON = tkItem.SEASON and tkTransItem.ITEM = tkItem.ITEM
      
     INNER JOIN  #pSeasons Seasons
         on tkTrans.SEASON = Seasons.Season
      


where
     (isnull(tkTrans.E_STAT,0) not in ('MI','MO',  'TO','TI','EO','EI') OR E_STAT IS NULL )

     
group by
      tkTrans.SEASON
      ,tkTransItem.CUSTOMER
     ,tkTransItem.ITEM
      ,tkTransItemEvent.E_PL
      ,tkTransItem.I_PT 
      ,tkTransItem.I_PRICE 
      ,tkTransItem.I_DAMT 




-- Create #PaidFinal --------------------------------------------------------------------------------------------------


Create table #PaidFinal
( 
  CUSTOMER varchar (20)
,MINPAYMENTDATE datetime 
 ,ITEM varchar (32) --COLLATE SQL_Latin1_General_CP1_CS_AS 
 ,E_PL varchar (10)
,I_PT  varchar (32) --COLLATE SQL_Latin1_General_CP1_CS_AS
,I_PRICE  numeric (18,2)  
 ,PAIDTOTAL numeric (18,2)
,SEASON varchar (15) 
) 

Insert Into #PaidFinal
(
  CUSTOMER
,MINPAYMENTDATE 
 ,ITEM
,E_PL
,I_PT
,I_PRICE
,PAIDTOTAL
,SEASON 
)

select
      tkTransItem.CUSTOMER
      ,min(tkTrans.DATE) minPaymentDate 
      ,tkTransItem.ITEM
      ,tkTransItemEvent.E_PL
      ,tkTransItem.I_PT
      ,tkTransItem.I_PRICE 
      ,SUM(ISNULL((tkTransItemPaymode.I_PAY_PAMT ),0))  PAIDTOTAL
      ,tkTransItem.SEASON 

FROM
      dbo.TK_TRANS tkTrans
      INNER JOIN dbo.TK_TRANS_ITEM tkTransItem
      on tkTrans.Season = tkTransItem.Season
      and tkTrans.Trans_No = tkTransItem.Trans_No
      LEFT JOIN 
       (select
         subtkTransItemEvent.SEASON,
         max(isnull(subtkTransItemEvent.E_PL,5)) E_PL,
         subtkTransItemEvent.TRANS_NO,
         subtkTransItemEvent.VMC
        FROM
         dbo.TK_TRANS_ITEM_EVENT subtkTransItemEvent
        INNER JOIN #pSeasons subpSeasons
         on subtkTransItemEvent.SEASON = subpSeasons.Season
        group by
         subtkTransItemEvent.SEASON,
         subtkTransItemEvent.TRANS_NO,
         subtkTransItemEvent.VMC) tkTransItemEvent
          on tkTransItem.SEASON = tkTransItemEvent.SEASON
           and tkTransItem.TRANS_NO = tkTransItemEvent.TRANS_NO
           and tkTransItem.VMC = tkTransItemEvent.VMC
      
            inner join dbo.TK_TRANS_ITEM_PAYMODE tkTransItemPaymode 
            ON tkTransItem.SEASON = tkTransItemPaymode.SEASON 
            and tkTransItem.TRANS_NO = tkTransItemPaymode.TRANS_NO 
            and tkTransItem.VMC = tkTransItemPaymode.VMC


      
      INNER JOIN  dbo.TK_ITEM tkItem
      on tkTransItem.SEASON = tkItem.SEASON and tkTransItem.ITEM = tkItem.ITEM
      
      INNER JOIN  #pSeasons Seasons
         on tkTrans.SEASON = Seasons.Season 
       
      LEFT OUTER JOIN dbo.TK_PTABLE_PRLEV tkPTablePRLev
      on tkTransItem.SEASON = tkPTablePRLev.SEASON and tkItem.ptable = tkPTablePRLev.ptable
        and tkTransItemEvent.E_PL  = tkPTablePRLev.PL
        
        

where
     (isnull(tkTrans.E_STAT,0) not in ('MI','MO',  'TO','TI','EO','EI') OR E_STAT IS NULL )
     AND tkTransItemPaymode.I_PAY_TYPE = 'I'


group by
      tkTransItem.CUSTOMER
      ,tkTransItem.ITEM
      ,tkTransItemEvent.E_PL
      ,tkTransItem.I_PT
      ,tkTransItem.I_PRICE
      ,tkTransItem.Season
having SUM(ISNULL((tkTransItemPaymode.I_PAY_PAMT ),0)) > 0      

---- Build Report --------------------------------------------------------------------------------------------------


Create table #ReportBase 
(
  SEASON varchar (15)
,CUSTOMER varchar (20)
,ITEM varchar (32) --COLLATE SQL_Latin1_General_CP1_CS_AS
,E_PL varchar (10)
,I_PT  varchar (32) --COLLATE SQL_Latin1_General_CP1_CS_AS
,I_PRICE  numeric (18,2)
,I_DAMT  numeric (18,2)
,ORDQTY bigint 
 ,ORDTOTAL numeric (18,2) 
 ,PAIDCUSTOMER  varchar (20)
,MINPAYMENTDATE datetime  
 ,PAIDTOTAL numeric (18,2)
)

Insert into #ReportBase 
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

select 
       SalesBase.SEASON
      ,SalesBase.CUSTOMER 
      ,SalesBase.ITEM
      ,SalesBase.E_PL
      ,SalesBase.I_PT
      ,SalesBase.I_PRICE  
    ,SalesBase.I_DAMT 
      ,SalesBase.ORDQTY
      ,SalesBase.ORDTOTAL
      ,PaidFinal.CUSTOMER as PAIDCUSTOMER 
      ,PaidFinal.MINPAYMENTDATE
      ,isnull(PaidFinal.PAIDTOTAL,0) PAIDTOTAL 
 
      from #SalesBase  SalesBase 

         LEFT JOIN  #PaidFinal PaidFinal
        on    SalesBase.CUSTOMER = PaidFinal.CUSTOMER
          and SalesBase.SEASON = PaidFinal.SEASON 
        and SalesBase.ITEM = PaidFinal.ITEM
        and isnull(SalesBase.E_PL,99)  = isnull(PaidFinal.E_PL,99) 
        and isnull(SalesBase.I_PT,99) = isnull(PaidFinal.I_PT,99) 
        and SalesBase.I_PRICE = PaidFinal.I_PRICE
  WHERE SalesBase.ORDQTY <> 0 

------------------------------------------------------------------------------------------------------------------

create table #tournaments
(
tournament varchar(max)
,StartDate Date
,EndDate Date
) --COLLATE SQL_Latin1_General_CP1_CS_AS  )

insert into #tournaments
Values
('Kajikawa Classic','2014-02-6', '2014-02-09')
,('Littlewood', '2014-02-14', '2014-02-16')
,('Diamond Devil', '2014-02-21', '2014-02-23')
,('Louisville Slugger', '2014-02-27', '2014-03-02')

 
create table #budget 
(
tournament varchar (max) --COLLATE SQL_Latin1_General_CP1_CS_AS
,amount bigint
,quantity int
)

insert into #budget
Values
('Kajikawa Classic',27200,850)   
,('Littlewood',4250,250)  
,('Louisville Slugger',2700,75)  
,('Diamond Devil',1275,150)   



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
	,'2014-02-6' as StartDate
	,'2014-02-09' as EndDate
	,SUM(ORDQTY)
	,SUM(ORDTOTAL)
FROM #ReportBase ReportBase
WHERE 1=1 AND ITEM in ('KCA', 'KCJS', 'KCG', 'KASPT') 
AND ReportBase.I_PRICE > 0
AND ( ReportBase.PAIDTOTAL > 0 )
Group By Season


INSERT INTO #CYTournamentData
(Season, Tournament, StartDate, EndDate, ORDQTY, ORDTOTAL)

SELECT
	Season
	,'Littlewood' as Tournament
	,'2014-02-14' as StartDate
	,'2014-02-16' as EndDate
	,SUM(ORDQTY)
	,SUM(ORDTOTAL)
FROM #ReportBase ReportBase
WHERE 1=1 AND ITEM in ('LCA', 'LCJS', 'LCG') 
AND ReportBase.I_PRICE > 0
AND ( ReportBase.PAIDTOTAL > 0 )
Group By Season

INSERT INTO #CYTournamentData
(Season, Tournament, StartDate, EndDate, ORDQTY, ORDTOTAL)

SELECT
	Season
	,'Louisville Slugger' as Tournament
	,'2014-02-27' as StartDate
	,'2014-03-02' as EndDate
	,SUM(ORDQTY)
	,SUM(ORDTOTAL)
FROM #ReportBase ReportBase
WHERE 1=1 AND ITEM in ('LSA', 'LSJS', 'LSG') 
AND ReportBase.I_PRICE > 0
AND ( ReportBase.PAIDTOTAL > 0 )
Group By Season

INSERT INTO #CYTournamentData
(Season, Tournament, StartDate, EndDate, ORDQTY, ORDTOTAL)

SELECT
	Season
	,'Diamond Devil' as Tournament
	,'2014-02-21' as StartDate
	,'2014-02-23' as EndDate
	,SUM(ORDQTY)
	,SUM(ORDTOTAL)
FROM #ReportBase ReportBase
WHERE 1=1 AND ITEM in ('DDA', 'DDJS', 'DDG') 
AND ReportBase.I_PRICE > 0
AND ( ReportBase.PAIDTOTAL > 0 )
Group By Season

----------------------------------------------------------------------------------------------------------
--Single Game Breakout:
create table #singleSummary
( 
 Tournament varchar(max)
 ,StartDate	date
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
