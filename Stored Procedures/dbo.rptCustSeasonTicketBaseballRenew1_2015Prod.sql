SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--exec rptCustSeasonTicketBaseballRenew1_2015Prod

CREATE PROCEDURE [dbo].[rptCustSeasonTicketBaseballRenew1_2015Prod] 

AS 
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @prevSeason VARCHAR(50)
DECLARE @curSeason VARCHAR(50)
DECLARE @prevHomeGames AS NUMERIC
DECLARE @curHomeGames AS NUMERIC



SET @prevSeason = 'B14'
SET @curSeason = 'B15'
SET @prevHomeGames = 30
SET @curHomeGames = 36
----------------------------------------------------------------------------------


--BEGIN



CREATE TABLE   #budget 
(
	saleTypeName VARCHAR(100)
	,amount INT
)

INSERT INTO #budget
--Budget and Prior Year Revenue
SELECT 'Mini Plans FSE', 34400  UNION ALL
SELECT 'Season', 246000  UNION ALL
SELECT 'Single Game Tickets',   449500 UNION ALL
SELECT 'Scout Card', 0
----------------------------------------------------------------------------------


CREATE table #suitebudget 
(
event varchar (10) 
,amount float
,quantity INT
,suite16 int
,suite32 int
)

insert into #suitebudget
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
 FROM vwTIReportBase rb WHERE rb.SEASON IN ( @prevSeason,@curSeason) 


-----------------------------------------------------------------------------------------
DECLARE @SeasonSummary TABLE 
(
	season VARCHAR(100)
	,saleTypeName  VARCHAR(50)
	,qty  INT
	,amt MONEY
)


INSERT INTO @SeasonSummary
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
WHERE ITEM = 'BBS' 
	AND SEASON IN (@prevSeason)
	AND ( PAIDTOTAL > 0 OR CUSTOMER IN ('152760','164043','186078' ) )
	AND CUSTOMER <> '137398'
GROUP BY CUSTOMER , SEASON 


UNION ALL 
SELECT 
	  SEASON 
	 ,'Season'
	 ,SUM(ORDQTY) QTY
	 ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
WHERE ITEM = 'BBS' 
	AND SEASON IN ( @curSeason)
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
	       WHEN ITEM LIKE '8FLEX%' THEN SUM(ORDQTY) /@prevHomeGames
		   WHEN ITEM LIKE '8%' AND ITEM NOT LIKE '8FLEX%' THEN SUM(ORDQTY)* 8/@prevHomeGames
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
,sum(CASE WHEN rb.I_PT = 'FFP' THEN (ORDTOTAL - ORDQTY*(8)) ELSE ORDTOTAL END) AS Amt
from #ReportBase rb 
    WHERE ITEM like 'B[0-9]%' 
	and rb.SEASON = 'B14' --@prevSeason
	and rb.I_PT not LIKE 'V%'
	AND rb.I_PT NOT IN ('SSP', 'SSR', 'SSRC')
	and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.Season, rb.I_PT

UNION ALL 

select 
	 rb.SEASON 
	,'Single Game Tickets'
,sum(ORDQTY) as Qty
,sum(CASE WHEN rb.I_PT = 'FFP' THEN (ORDTOTAL - ORDQTY*(8)) ELSE ORDTOTAL END) AS Amt
from #ReportBase rb 
    WHERE ITEM like  'B[0-9]%'
	and rb.I_PT not LIKE 'V%'
	AND rb.I_PT NOT IN ('SSP', 'SSR', 'SSRC')
	and rb.SEASON = 'B15' --@curSeason
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
    WHERE ITEM like 'B[0-9]%' 
	and rb.SEASON = 'B14' --@prevSeason
	and rb.I_PT = 'V'
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
    WHERE ITEM like 'B[0-9]%'
	and rb.I_PT = 'V'
	and rb.SEASON = 'B15' --@curSeason
	and rb.I_PRICE > 0
	AND ( rb.PAIDTOTAL > 0 )
group by rb.Season, rb.I_PT

UNION ALL

select 
	 rb.SEASON 
	,'Single Game Tickets'
,sum(ORDQTY) as Qty
,SUM(CASE 
		WHEN ordqty = 16 THEN sb.suite16 --check B24 multiple suites purchased that day
		WHEN ordqty = 32 THEN sb.suite32
		ELSE 0 end) AS Amt
from #ReportBase rb 
LEFT JOIN #suitebudget sb ON rb.item = sb.[event]
    WHERE ITEM like 'B[0-9]%'
	and rb.I_PT IN ('SSP', 'SSR', 'SSRC')
	and rb.SEASON = 'B14' --@prevSeason
	and rb.I_PRICE > 0
	AND ( rb.PAIDTOTAL > 0 )
group by rb.Season, rb.I_PT

UNION ALL

select 
	 rb.SEASON 
	,'Single Game Tickets'
,sum(ORDQTY) as Qty
,SUM(CASE 
		WHEN ordqty = 16 THEN sb.suite16 --check B24 multiple suites purchased that day
		WHEN ordqty = 32 THEN sb.suite32
		ELSE 0 end) AS Amt
from #ReportBase rb 
LEFT JOIN #suitebudget sb ON rb.item = sb.[event]
    WHERE ITEM like 'B[0-9]%'
	and rb.I_PT IN ('SSP', 'SSR', 'SSRC')
	and rb.SEASON = 'B15' --@curSeason
	and rb.I_PRICE > 0
	AND ( rb.PAIDTOTAL > 0 )
group by rb.Season, rb.I_PT
 
UNION ALL
 
select 
       rb.SEASON 
      ,'Scout Card'
,sum(ORDQTY) as Qty
,sum(ORDTOTAL) as Amt
from #ReportBase rb 
    WHERE ITEM like 'SC'
    --AND ITEM <> 'MB18' 
       AND SEASON in (@prevSeason, @curSeason)
      and rb.I_PRICE > 0
AND ( rb.PAIDTOTAL > 0 )
group by rb.Season, rb.I_PT






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
		when 'Mini Plans FSE' then 6 end



END


GO
