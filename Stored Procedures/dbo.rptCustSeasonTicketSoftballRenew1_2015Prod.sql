SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--exec rptCustSeasonTicketSoftballRenew1_2015Prod

CREATE          PROCEDURE [dbo].[rptCustSeasonTicketSoftballRenew1_2015Prod] 

as 
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @prevSeason varchar(50)
declare @curSeason varchar(50)
declare @prevHomeGames as numeric
declare @curHomeGames as numeric



Set @prevSeason = 'SB14'
Set @curSeason = 'SB15'
Set @prevHomeGames = 32
Set @curHomeGames = 25
----------------------------------------------------------------------------------


--BEGIN



Create table   #budget 
(
       saleTypeName varchar(100)
       ,amount int
)

insert into #budget
--Budget and Prior Year Revenue
Select 'Mini Plans FSE', 15000  UNION ALL
Select 'Season', 104000  UNION ALL
Select 'Single Game Tickets',   148188 UNION ALL
Select 'All Session Passes', 25640


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
 FROM vwTIReportBase rb where rb.SEASON IN ( @prevSeason,@curSeason) 


-----------------------------------------------------------------------------------------
Declare @SeasonSummary table 
(
       season varchar(100)
       ,saleTypeName  varchar(50)
       ,qty  int
       ,amt money
)


insert into @SeasonSummary
(
season
,saleTypeName
,qty
,amt
)


-----------------------------------------------------------------------------
--SEASON 
--Previous  and Current SEASON  
SELECT 
         SEASON 
        ,'Season'
       ,SUM(ORDQTY) QTY
       ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where ITEM = 'SBS' 
       AND SEASON in (@prevSeason)
      AND ( PAIDTOTAL > 0 )
         --OR CUSTOMER in ('152760','164043','186078' ) ) removed 2/18/2015
       --AND CUSTOMER <> '137398' removed 2/18/2015
GROUP BY CUSTOMER , SEASON 


UNION ALL 
SELECT 
         SEASON 
        ,'Season'
       ,SUM(ORDQTY) QTY
       ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where ITEM = 'SBS' 
       AND SEASON in ( @curSeason)
       AND (PAIDTOTAL > 0 ) 
GROUP BY CUSTOMER , SEASON 





------------------------------------------------------------------------------------------------------
--MINI Plans 
UNION ALL 

SELECT 
        SEASON 
        ,'Mini Plans FSE'
       ,CASE WHEN ITEM LIKE '2%' THEN SUM(ORDQTY) * 2/@curHomeGames
              WHEN ITEM LIKE '3%' THEN SUM(ORDQTY) * 3/@curHomeGames
              WHEN ITEM LIKE '4%' THEN SUM(ORDQTY) * 4/@curHomeGames
              WHEN ITEM LIKE '5%' THEN SUM(ORDQTY) * 5/@curHomeGames
              WHEN ITEM LIKE '6%' THEN SUM(ORDQTY) * 6/@curHomeGames
              WHEN ITEM LIKE '7%' THEN SUM(ORDQTY) * 7/@curHomeGames
              WHEN ITEM LIKE '8%' THEN SUM(ORDQTY) * 8/@curHomeGames
              WHEN ITEM LIKE '9FLEX%' THEN SUM(ORDQTY) /@curHomeGames
                 WHEN ITEM LIKE '9%' AND ITEM NOT LIKE '9FLEX%' THEN SUM(ORDQTY)* 9/@curHomeGames
              WHEN ITEM LIKE '10%' THEN SUM(ORDQTY)* 10/@curHomeGames
              WHEN ITEM LIKE '11%' THEN SUM(ORDQTY)* 11/@curHomeGames
              END AS QTY
       ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where  ITEM like '[1-9]%'  
          AND SEASON in (@curSeason)
          AND ( PAIDTOTAL > 0 )
GROUP BY SEASON , ITEM   

UNION ALL 

SELECT 
        SEASON 
        ,'Mini Plans FSE'
       ,CASE WHEN ITEM LIKE '2%' THEN SUM(ORDQTY) * 2/@prevHomeGames
              WHEN ITEM LIKE '3%' THEN SUM(ORDQTY) * 3/@prevHomeGames
              WHEN ITEM LIKE '4%' THEN SUM(ORDQTY) * 4/@prevHomeGames
              WHEN ITEM LIKE '5%' THEN SUM(ORDQTY) * 5/@prevHomeGames
              WHEN ITEM LIKE '6%' THEN SUM(ORDQTY) * 6/@prevHomeGames
              WHEN ITEM LIKE '7%' THEN SUM(ORDQTY) * 7/@prevHomeGames
              --WHEN ITEM LIKE '8FLEX%' THEN SUM(ORDQTY) /@prevHomeGames
              WHEN ITEM LIKE '8%' THEN SUM(ORDQTY)* 8/@prevHomeGames --AND ITEM NOT LIKE '8FLEX%' 
              WHEN ITEM LIKE '9%' THEN SUM(ORDQTY) * 9/@prevHomeGames
              WHEN ITEM LIKE '10%' THEN SUM(ORDQTY)* 10/@prevHomeGames
              WHEN ITEM LIKE '11%' THEN SUM(ORDQTY)* 11/@prevHomeGames
              END AS QTY
       ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where  ITEM like '[1-9]%'  
          AND SEASON in (@prevSeason)
          AND ( PAIDTOTAL > 0 )
GROUP BY SEASON , ITEM   

--------------------------------------------------------------------------------------------------------
UNION ALL 



select 
        rb.SEASON 
       ,'Single Game Tickets'
,sum(ORDQTY) as Qty
,sum(ORDTOTAL) as Amt
from #ReportBase rb 
    WHERE ITEM like 'SB[0-9]%' 
       and rb.SEASON = @prevSeason
       and rb.I_PT not LIKE 'V%'
       and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.Season, rb.I_PT

UNION ALL

select 
        rb.SEASON 
       ,'Single Game Tickets'
,sum(ORDQTY) as Qty
,sum(ORDTOTAL) as Amt
from #ReportBase rb 
    WHERE ITEM like 'SB[0-9]%' 
       and rb.SEASON = @prevSeason
       and rb.I_PT = 'V'
       and rb.I_PRICE > 0
group by rb.Season, rb.I_PT
UNION ALL 

select 
        rb.SEASON 
       ,'Single Game Tickets'
,sum(ORDQTY) as Qty
,sum(ORDTOTAL) as Amt
from #ReportBase rb 
    WHERE ITEM like  'SB[0-9]%'
       and rb.I_PT not LIKE 'V%'
       and rb.SEASON = @curSeason
       and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.Season, rb.I_PT

UNION ALL

select 
        rb.SEASON 
       ,'Single Game Tickets'
,sum(ORDQTY) as Qty
,sum(ORDTOTAL) as Amt
from #ReportBase rb 
    WHERE ITEM like 'SB[0-9]%'
       and rb.I_PT = 'V'
       and rb.SEASON = @curSeason
       and rb.I_PRICE > 0
group by rb.Season, rb.I_PT


UNION ALL

select 
       rb.SEASON 
      ,'All Session Passes' 
,sum(ORDQTY) as Qty
,sum(ORDTOTAL) as Amt
from #ReportBase rb 
    WHERE ITEM in ('KCA','KCD','KEF','LCA','LCD','LCG','DDA','DDD','DDG','LSA','LSD','LSG','KCJS','LCJS','LSJS','DDJS','KASPT')
       AND SEASON in (@prevSeason, @curSeason)
      and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.Season, rb.I_PT
--Abbey will look for item list to verify




-------------------------------------------------------------------------------------


select 

          isnull(PrevYR.saleTypeName,'') as QtyCat
      ,isnull(PrevYR.prevQty,0)  as [PYQty]
         ,isnull(CurYR.CurQty,0) as [CYQty]
         ,isnull(CurYR.CurQty,0) - isnull(PrevYR.prevQty,0)  as [DiffVsPY]
         ,isnull(budget.saleTypeName,'') as AmtCat
         ,isnull(CurYR.CurAmt,0) as [CYAmt]
         ,isnull(convert(decimal(12,2),budget.amount),0) as Budget
         ,isnull(CurYR.CurAmt,0) - isnull(convert(decimal(12,2),budget.amount),0)  as Variance
         ,case isnull(convert(decimal(12,2),budget.amount),0) when 0 then 0 else isnull(CurYR.CurAmt,0) / isnull(convert(decimal(12,2),budget.amount),0) end as PctToBudget
         ,isnull(PrevYR.prevAmt,0)  as [PYAmt]
         ,case isnull(PrevYR.prevAmt,0) when 0 then 0 else isnull(CurYR.CurAmt,0) / isnull(PrevYR.prevAmt,0) end as PctToPY

       
from
(select saleTypeName, SUM(qty) as prevQty, SUM(amt) 
as prevAmt from @seasonsummary a where cast(right(season,2) as int)
= right(@prevseason,2) group by saleTypeName) PrevYR
left outer join (select saleTypeName, SUM(qty) as curQty, SUM(amt)
as curAmt from @seasonsummary a where cast(right(season,2) as int) 
 = right(@curseason,2) group by saleTypeName) CurYR
on PrevYR.saleTypeName = CurYR.saleTypeName
left outer join #budget budget
on PrevYR.saleTypeName = budget.saleTypeName
order by 
       case PrevYR.saleTypeName
              when 'Single Game Tickets' then 5
              when 'Season' then 7
              when 'Mini Plans FSE' then 6 
                        when 'All Session Passes' then 8 end



END


GO
