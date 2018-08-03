SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO















CREATE PROCEDURE [dbo].[rptCustSeasonTicketFootballRenew1_2016Prod_Ordered]
    (
      @startDate DATE
    , @endDate DATE
    , @dateRange VARCHAR(20)
    )
AS 

/*
DROP TABLE #budget
DROP TABLE #ReportBase	
*/

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @curSeason varchar(50)
declare @prevSeason varchar(50)

Set @prevSeason = 'F15'
Set @curSeason = 'F16'

--DECLARE	@dateRange VARCHAR(20)= 'AllData'
--DECLARE @startDate DATE = DATEADD(month,-1,GETDATE())
--DECLARE @endDate DATE = GETDATE()

----------------------------------------------------------------------------------


--BEGIN


Create table   #budget 
(
    saleTypeName varchar(100)
    ,amount int
)

insert into #budget
--Budget and Prior Year Revenue

Select 'Mini Plans FSE', '0'  UNION ALL
Select 'Season', '0' UNION ALL
Select 'Season Suite', '0'   UNION ALL
Select 'Single Game Tickets', '0' UNION ALL
Select 'Single Game Suite', '0' UNION ALL 
Select 'MBSC', '0'    



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
FROM vwTIReportBase rb 
WHERE   rb.SEASON = @prevSeason 
		OR (@dateRange = 'AllData' 
			AND rb.season = @curseason)
		OR (@dateRange <> 'AllData' 
			AND rb.season = @curSeason 
			AND rb.MINPAYMENTDATE 
				BETWEEN @startDate AND @endDate)


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
where ITEM = 'FS' AND SEASON in (@prevSeason, @curSeason)
    --AND ( PAIDTOTAL > 0 OR CUSTOMER in ('152760','164043','186078' ) )
    AND CUSTOMER <> '137398'
GROUP BY CUSTOMER , SEASON 

-----------------------------------------------------------------------------------------

UNION ALL 
--SEASON 

--Previous  and Current SEASON  

SELECT 
      SEASON 
     ,'MBSC'
     ,SUM(ORDQTY) QTY
     ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where ITEM = 'FSC' and E_PL = '20'
AND SEASON IN (@curSeason)
    --AND  PAIDTOTAL > 0
GROUP BY CUSTOMER , ITEM, SEASON 

UNION ALL 

SELECT 
      SEASON 
     ,'MBSC'
     ,SUM(ORDQTY)QTY
     ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where( ITEM = 'FSC' and E_PL = '11' ) 
AND SEASON IN (@prevSeason)
    --AND  PAIDTOTAL > 0
GROUP BY CUSTOMER , ITEM, SEASON 


-----------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------

--MINI PLANS

UNION ALL 

SELECT 
     SEASON 
     ,'Mini Plans FSE'
     ,CASE WHEN ITEM LIKE '2%' THEN  SUM(ORDQTY) * 2/6
           WHEN ITEM LIKE '3%' THEN SUM(ORDQTY) * 3/6
           WHEN ITEM LIKE '4%' THEN SUM(ORDQTY) * 4/6
           WHEN ITEM LIKE '5%' THEN SUM(ORDQTY) * 5/6
        END AS QTY
    ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where  ITEM like '[2-5]%'  
       AND SEASON in (@curSeason)
       --AND ( PAIDTOTAL > 0 )
GROUP BY SEASON , ITEM   

--MINI PLANS

UNION ALL 

SELECT 
     SEASON 
     ,'Mini Plans FSE'
     ,CASE WHEN ITEM LIKE '2%' THEN  SUM(ORDQTY) * 2/7
           WHEN ITEM LIKE '3%' THEN SUM(ORDQTY) * 3/7
           WHEN ITEM LIKE '4%' THEN SUM(ORDQTY) * 4/7
           WHEN ITEM LIKE '5%' THEN SUM(ORDQTY) * 5/7
        END AS QTY
    ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where  ITEM like '[2-5]%'  
       AND SEASON in ( @prevSeason)
       --AND ( PAIDTOTAL > 0 )
GROUP BY SEASON , ITEM   




----------------------------------------------------------------------------------------------------

--SEASON SUITE

UNION ALL 
--

SELECT 
     SEASON 
     ,'Season Suite'
    ,COUNT(ITEM) QTY
    ,SUM(ORDTOTAL) AMT
FROM #ReportBase 
where ITEM in ('FSS','FSSUITE')  
       AND SEASON in  (@curSeason, @prevSeason)
    --AND ( PAIDTOTAL > 0 )
GROUP BY SEASON 

------------------------------------------------------------------------------

--UNION ALL 

----Previous year DONSUITE 

--SELECT 

--     'F13' AS SEASON 

--     ,'Donation Suite'

--    ,0 AS  QTY

--    ,578477  AMT

    
    
--UNION ALL 



----DONSUITE 

--SELECT 

--     SEASON 

--     ,'Donation Suite'

--    ,0 AS  QTY

--    ,SUM(ORDTOTAL) AMT

--FROM #ReportBase 

--where ITEM = 'DONSUITE'  

--       AND SEASON in  (@curSeason)

--    --AND ( PAIDTOTAL > 0 )

--GROUP BY SEASON 


--------------------------------------------------------------------------------------


UNION ALL 
    
--Single Game Suite Total
/*
select 
    suite.SEASON
    ,'Single Game Suite'
    ,SUM(Suite.QTY) as QTY
    ,SUM(Suite.AMT + ISNULL(Donation.AMT, 0)) as AMT
From
(select 
     rb.SEASON 
    ,CUSTOMER
    ,COUNT(CUSTOMER) QTY    
    ,SUM(ORDTOTAL) AMT
from #ReportBase rb 
    WHERE ITEM like 'F0[1-6]%'
    and rb.E_PL in ('10')
    and rb.I_PT in ('SP')
    and rb.SEASON in  (@prevSeason)
group by rb.CUSTOMER, rb.SEASON, rb.I_PT) suite
left outer join 
(select
    SEASON 
    ,CUSTOMER
    ,SUM(ORDTOTAL) AMT
from #ReportBase
where SEASON in  (@prevSeason)
    and ITEM like 'SR0%'
group by CUSTOMER, SEASON) donation
on suite.SEASON = donation.Season
and suite.customer = donation.customer
and suite.SEASON = donation.SEASON 
group by suite.season
*/
select 
	suite.SEASON
	,'Single Game Suite'
	,SUM(Suite.QTY) as QTY
	,SUM(Suite.AMT + ISNULL(Donation.AMT, 0)) as AMT
From
(select 
	 rb.SEASON 
	,CUSTOMER
	,COUNT(CUSTOMER) QTY	
	,SUM(ORDTOTAL) AMT
from #ReportBase rb 
    WHERE ITEM like 'F0[1-7]%'
	and rb.E_PL in ('10')
	and rb.I_PT in ('SP')
	and rb.SEASON in  (@prevSeason)
group by rb.CUSTOMER, rb.SEASON, rb.I_PT) suite
left outer join 
(select
	SEASON 
	,CUSTOMER
	,SUM(ORDTOTAL) AMT
from #ReportBase
where SEASON in  (@prevSeason)
	and ITEM like 'SRO%'
group by CUSTOMER, SEASON) donation
on suite.SEASON = donation.Season
and suite.customer = donation.customer
and suite.SEASON = donation.SEASON 
group by suite.season


UNION ALL 
    
--Single Game Suite Total

select 
    suite.SEASON
    ,'Single Game Suite'
    ,SUM(Suite.QTY) as QTY
    ,SUM(Suite.AMT + ISNULL(Donation.AMT, 0)) as AMT
From
(select 
     rb.SEASON 
    ,CUSTOMER
    ,COUNT(CUSTOMER) QTY    
    ,SUM(ORDTOTAL) AMT
from #ReportBase rb 
    WHERE ITEM like 'F0[1-6]%'
    and rb.E_PL in ('16')
    and rb.I_PT in ('SP')
    and rb.SEASON in  (@curSeason)
group by rb.CUSTOMER, rb.SEASON, rb.I_PT) suite
left outer join 
(select
    SEASON 
    ,CUSTOMER
    ,SUM(ORDTOTAL) AMT
from #ReportBase
where SEASON in  (@curSeason)
    and ITEM like 'SRO%'
group by CUSTOMER, SEASON) donation
on suite.SEASON = donation.Season
and suite.customer = donation.customer
and suite.SEASON = donation.SEASON 
group by suite.season

--------------------------------------------------------------------------------------------------------

UNION ALL 

--current year 


--Single Game Total

select 
     rb.SEASON 
    ,'Single Game Tickets'
,sum(ORDQTY) as Qty
,sum(ORDTOTAL) as Amt
from #ReportBase rb 
    WHERE rb.SEASON IN  (@curSeason) 
    and ITEM like 'F0[1-6]'
     and rb.E_PL not in  ('16') -- deals with single game suites for now 

    and rb.I_PT not in ('V')
    and rb.I_PRICE > 0
--AND ( rb.PAIDTOTAL > 0 )
group by rb.Season, rb.I_PT

UNION ALL
select 
     rb.Season
    ,'Single Game Tickets'
,sum(ORDQTY) as Qty
,sum((ORDQTY * (CASE When ITEM = 'F01' THEN 0 
                     WHEN ITEM = 'F02' AND E_PL = '11' THEN 75
				     WHEN ITEM = 'F02' AND E_PL = '13' THEN 50
                     WHEN ITEM = 'F03' THEN 65
                     WHEN ITEM = 'F04' THEN 65  
                     WHEN ITEM = 'F05' THEN 65
                     WHEN ITEM = 'F06' THEN 60 
                     END)))as Amt
from #ReportBase rb
  WHERE rb.SEASON IN  (@curSeason) 
  and ITEM like 'F0[1-6]'
  AND rb.E_PL not in  ('16') -- deals with single game suites for now  
  AND rb.I_PT IN ('V')
group by rb.SEASON, rb.I_PT


----------------------------------------------------------------------------------------


UNION ALL 
--previous season 



select 
     rb.SEASON 
    ,'Single Game Tickets'
,sum(ORDQTY) as Qty
,sum(ORDTOTAL) as Amt
from #ReportBase rb 
    WHERE rb.SEASON IN  (@prevSeason) 
    and ITEM like 'F0[1-7]'
     and rb.E_PL not in  ('10') -- deals with single game suites for now 
    and rb.I_PT not in ('V')
    and rb.I_PRICE > 0
--AND ( rb.PAIDTOTAL > 0 )
group by rb.Season, rb.I_PT

UNION ALL
select 
     rb.Season
    ,'Single Game Tickets'
,sum(ORDQTY) as Qty
,sum((ORDQTY * (CASE When ITEM = 'F01' THEN 50 
                     WHEN ITEM = 'F02' THEN 50
                     WHEN ITEM = 'F03' THEN 55
                     WHEN ITEM = 'F04' THEN 50  
                     WHEN ITEM = 'F05' THEN 55
                     WHEN ITEM = 'F06' THEN 50 
					 WHEN ITEM = 'F07' THEN 55
                     END)))as Amt
from #ReportBase rb
  WHERE rb.SEASON IN  (@prevSeason) 
  and ITEM like 'F0[1-7]'
  AND rb.E_PL not in  ('10') -- deals with single game suites for now  
  AND rb.I_PT IN ('V')
group by rb.SEASON, rb.I_PT

-------------------------------------------------------------------------------------



SELECT 

       ISNULL(PrevYR.saleTypeName,'') AS QtyCat
      ,ISNULL(PrevYR.prevQty,0)  AS [PYQty]
      ,ISNULL(CurYR.CurQty,0) AS [CYQty]
      ,ISNULL(CurYR.CurQty,0) - ISNULL(PrevYR.prevQty,0)  AS [DiffVsPY]
      ,ISNULL(budget.saleTypeName,'') AS AmtCat
      ,ISNULL(CurYR.CurAmt,0) AS [CYAmt]
      ,ISNULL(CONVERT(DECIMAL(12,2),budget.amount),0) AS Budget
      ,ISNULL(CurYR.CurAmt,0) - ISNULL(CONVERT(DECIMAL(12,2),budget.amount),0)  AS Variance
      ,CASE ISNULL(CONVERT(DECIMAL(12,2),budget.amount),0) WHEN 0 THEN 0 ELSE ISNULL(CurYR.CurAmt,0) / ISNULL(CONVERT(DECIMAL(12,2),budget.amount),0) END AS PctToBudget
      ,ISNULL(PrevYR.prevAmt,0)  AS [PYAmt]
      ,CASE ISNULL(PrevYR.prevAmt,0) WHEN 0 THEN 0 ELSE ISNULL(CurYR.CurAmt,0) / ISNULL(PrevYR.prevAmt,0) END AS PctToPY

    
FROM
(SELECT saleTypeName, SUM(qty) AS prevQty, SUM(amt) 
AS prevAmt FROM @seasonsummary a WHERE CAST(RIGHT(season,2) AS INT)
 = RIGHT(@prevseason,2) GROUP BY saleTypeName) PrevYR
LEFT OUTER JOIN (SELECT saleTypeName, SUM(qty) AS curQty, SUM(amt)
 AS curAmt FROM @seasonsummary a WHERE CAST(RIGHT(season,2) AS INT) 
 = RIGHT(@curseason,2) GROUP BY saleTypeName) CurYR
ON PrevYR.saleTypeName = CurYR.saleTypeName
LEFT OUTER JOIN #budget budget
ON PrevYR.saleTypeName = budget.saleTypeName
ORDER BY 
    CASE PrevYR.saleTypeName
        WHEN 'Single Game Suite' THEN 3
        WHEN 'Single Game Tickets' THEN 5
        --when 'Student Guest Pass' then 2

        WHEN 'Season' THEN 7
        WHEN 'Season Suite' THEN 4
        --when 'Student Season' then 1

        WHEN 'MBSC' THEN 8 
        WHEN 'Mini Plans FSE' THEN 6 END



END
























GO
