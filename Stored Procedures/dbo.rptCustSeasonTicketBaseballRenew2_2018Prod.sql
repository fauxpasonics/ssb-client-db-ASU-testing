SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO













CREATE PROCEDURE [dbo].[rptCustSeasonTicketBaseballRenew2_2018Prod] 
(
@startDate DATE
,@endDate DATE
,@dateRange VARCHAR(20)
)
AS 

BEGIN

set transaction isolation level read UNCOMMITTED


IF object_id('tempdb..#reportBase')IS NOT NULL
DROP TABLE #ReportBase

IF object_id('tempdb..#seasonSummary')IS NOT NULL
DROP TABLE #seasonSummary

IF object_id('tempdb..#PriceLevelMap')IS NOT NULL
	DROP TABLE #PriceLevelMap


declare @curSeason varchar(50)
declare @prevSeason varchar(50)
declare @Sport varchar(50)
Set @prevSeason = '2017'
Set @curSeason = '2018'
set @Sport = 'Baseball'

--DECLARE @dateRange VARCHAR(30) = 'AllData'
--DECLARE @startDate AS DATE = DATEADD(MONTH,-12,GETDATE())
--DECLARE @endDate AS DATE = GETDATE()

--------------------------Build Price Level Map--------------------------------------------

 SELECT DISTINCT x.SeasonYear
			   ,x.PL_CLASS
              , x.PC1
        INTO    #PriceLevelMap 
        FROM    ( SELECT    fts.SeasonYear
								,CASE WHEN fts.PC1 = 'A'	THEN 'Infield Box'
                                 WHEN fts.PC1 = 'B'			THEN 'Field Level'
                                 WHEN fts.PC1 = 'C'			THEN 'Infield Reserved'
                                 WHEN fts.PC1 = 'D'			THEN 'Baseline Reserved'
								 WHEN fts.PC1 = 'E'			THEN 'Students'
								 WHEN fts.PC1 = 'F'			THEN 'General Admission'
                                 ELSE 'Unknown'
                            END AS PL_CLASS
                          , fts.PC1
                 FROM      ro.vw_FactTicketSalesBase_All fts
                  WHERE     1 = 1
                            AND fts.SeasonYear = @CurSeason AND fts.Sport = @Sport
							AND fts.TicketTypeCode = 'FS'
                  GROUP BY  fts.SeasonYear
							, fts.PC1
                ) x
				GROUP BY  x.SeasonYear, x.PL_CLASS, x.PC1
UNION 

  SELECT DISTINCT x.SeasonYear
			,x.PL_CLASS
              , x.PC1
        FROM    ( SELECT    fts.SeasonYear
								,CASE WHEN fts.PriceLevelCode = 1	THEN 'Infield Box'
                                 WHEN fts.PriceLevelCode = 2		THEN 'Field Level'
                                 WHEN fts.PriceLevelCode = 3		THEN 'Infield Reserved'
                                 WHEN fts.PriceLevelCode = 4		THEN 'Baseline Reserved'
								 WHEN fts.PriceLevelCode = 5		THEN 'Students'
								WHEN fts.PriceLevelCode = 6			THEN 'General Admission'
                                 ELSE 'Unknown'
                            END AS PL_CLASS
                          , fts.PriceLevelCode AS PC1
                  FROM      ro.vw_FactTicketSalesBase_All fts
                  WHERE     1 = 1
                            AND fts.SeasonYear = @prevSeason AND fts.Sport = @Sport
							AND fts.TicketTypeCode = 'FS'
                  GROUP BY  fts.SeasonYear
							,fts.PriceLevelCode
                ) x
				GROUP BY  x.SeasonYear, x.PL_CLASS, x.PC1

---- Build Report --------------------------------------------------------------------------------------------------


Create table #ReportBase  
(
  SeasonYear int
 ,Sport nvarchar(255)
 ,DimSeasonId int
 ,TicketingAccountId nvarchar(50)
 ,DimItemId int
 ,DimPriceCodeId int
 ,DimPriceTypeId int
 ,DimPlanTypeId int
 ,PC1 nvarchar(1)
 ,PC3 NVARCHAR(1)
 ,PriceLevelCode nvarchar(25)
 ,TicketTypeCode nvarchar(25)
 ,TicketTypeClass varchar(100)
 ,IsComp int
 ,TransDateTime datetime  
 ,QtySeatRenewable int
 ,RevenueTotal numeric (18,6) 
 ,PaidAmount numeric (18,6)
)

INSERT INTO #ReportBase 
(
 SeasonYear
 ,Sport
 ,DimSeasonId
 ,TicketingAccountId
 ,DimItemId
 ,DimPriceCodeId
 ,DimPriceTypeId
 ,DimPlanTypeId
 ,PC1
 ,PC3
 ,PriceLevelCode
 ,TicketTypeCode
 ,TicketTypeClass
 ,IsComp
 ,TransDateTime
 ,QtySeatRenewable
 ,RevenueTotal  
 ,PaidAmount 
) 

SELECT 
 SeasonYear
 ,Sport
 ,DimSeasonId
 ,TicketingAccountId
 ,DimItemId
 ,DimPriceCodeId
 ,DimPriceTypeId
 ,DimPlanTypeId
 ,PC1
 ,PC3
 ,PriceLevelCode
 ,TicketTypeCode
 ,TicketTypeClass
 ,IsComp 
 ,TransDateTime
 ,SUM(QtySeatRenewable) QtySeatRenewable
 ,SUM(RevenueTotal) RevenueTotal
 ,SUM(PaidAmount) PaidAmount
FROM  [ro].[vw_FactTicketSalesBase_All] fts 
WHERE  1=1
AND fts.Sport =  @Sport
AND fts.TicketTypeCode in ('FS')
--AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
AND (fts.SeasonYear = @prevSeason 
OR (@dateRange = 'AllData' 
    AND fts.SeasonYear = @curseason)
OR (@dateRange <> 'AllData' 
            AND fts.SeasonYear = @curSeason 
            AND fts.TransDateTime
                BETWEEN @startDate AND @endDate))
GROUP BY  SeasonYear
 ,Sport
 ,DimSeasonId
 ,TicketingAccountId
 ,DimItemId
 ,DimPriceCodeId
 ,DimPriceTypeId
 ,DimPlanTypeId
 ,PC1
 ,PC3
 ,PriceLevelCode
 ,TicketTypeCode
 ,TicketTypeClass
 ,IsComp
 ,TransDateTime
----------------------------------------------------------------------------------------------


create table #SeasonSummary
(
	season varchar(100)
	,saleTypeName  varchar(50)
	,pl_class varchar(50)
	,renewal int
	,qty  int
	,amt money
)


insert into #SeasonSummary
(
 season
,saleTypeName
,pl_class
,renewal
,qty
,amt
)


--Regular Season Ticket Current Season
select DISTINCT 
      rb.SeasonYear
      ,'Season' SALETYPENAME
      , PL_CLASS 
      , CASE WHEN DimPlanTypeId IN ('1','2') THEN 0 --New & Additional 
			ELSE 1 END as RENEWAL
      ,SUM(QtySeatRenewable) QTY 
      ,SUM(RevenueTotal) AMT
from #ReportBase rb
LEFT join #PriceLevelMap plm ON rb.PC1 = plm.PC1
where rb.SeasonYear in (@curSeason)
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
GROUP BY    rb.SeasonYear, rb.DimPlanTypeId, PL_CLASS

UNION

select 
      rb.SeasonYear
      ,'Season' SALETYPENAME
      , PL_CLASS 
      , CASE WHEN DimPlanTypeId IN ('1','2') THEN 0 --New & Additional
			ELSE 1 END as RENEWAL
      , SUM(QtySeatRenewable) QTY 
      ,SUM(RevenueTotal) AMT
from #ReportBase rb
LEFT join #PriceLevelMap plm ON rb.PriceLevelCode = plm.PC1
where rb.SeasonYear in (@prevSeason)
    AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
GROUP BY    rb.SeasonYear, rb.DimPlanTypeId, PL_CLASS

SELECT 

	 ISNULL(PL.PL_CLASS,'') AS QtyCat
	,ISNULL(bbPrev.bbPrevQty,0) AS PYQty
	,ISNULL(bbPrev.bbPrevAmt,0) AS PYAmt
	,ISNULL(bbCurRenew.bbCurRenewQty,0) AS CYRenewQty
	,ISNULL(bbCurRenew.bbCurRenewAmt,0) AS CYRenewAmt
	,ISNULL(bbCurNew.bbCurNewQty,0) AS CYNewQty
	,ISNULL(bbCurNew.bbCurNewAmt,0) AS CYNewAmt
	,RenewPct = CASE WHEN CAST(ISNULL(bbPrev.bbPrevQty,0) AS FLOAT) = 0 THEN 0 
	  ELSE CAST(ISNULL(bbCurRenew.bbCurRenewQty,0) AS FLOAT) / CAST(bbPrev.bbPrevQty AS FLOAT) END
	,TotalQty = ISNULL(bbCurRenew.bbCurRenewQty,0)  + ISNULL(bbCurNew.bbCurNewQty,0)
	,TotalAmt = ISNULL(bbCurRenew.bbCurRenewAmt,0) + ISNULL(bbCurNew.bbCurNewAmt,0)
	,ISNULL(CAPACITY.CAPACITY,0) Capacity
	,ISNULL(CAPACITY.SORT_ORDER,998) sortOrder --998 to be last in sort order, but before 999 NOT CLASSIFIED
FROM (SELECT DISTINCT PL_CLASS FROM #seasonsummary) PL   
LEFT OUTER JOIN (SELECT PL_CLASS, SUM(QTY) AS bbPrevQty, SUM(AMT) AS bbPrevAmt 
					FROM #seasonsummary 
					WHERE season IN (@prevSeason)				
					 GROUP BY PL_CLASS)  bbPrev
		ON PL.PL_CLASS = bbPrev.PL_CLASS  

LEFT OUTER JOIN (SELECT PL_CLASS
	, SUM(QTY) AS bbCurRenewQty, SUM(AMT) AS bbCurRenewAmt 
					FROM #seasonsummary 
					WHERE SEASON IN (@curSeason)	  
					AND renewal = '1' 
					GROUP BY PL_CLASS) bbCurRenew
		ON PL.PL_CLASS =  bbCurRenew.PL_CLASS 

LEFT OUTER JOIN (SELECT PL_CLASS, SUM(QTY) AS bbCurNewQty, SUM(AMT) AS bbCurNewAmt 
					FROM #seasonsummary 
					WHERE season IN (@curSeason)	 
					 AND renewal = '0' 
					GROUP BY PL_CLASS ) bbCurNew
		ON PL.PL_CLASS =  bbCurNew.PL_CLASS 
LEFT OUTER JOIN rpt.TM_PRICELEVELCAPACITY Capacity 
	ON PL.PL_CLASS = CAPACITY.PL_CLASS AND CAPACITY.SeasonYear = @curSeason  AND CAPACITY.Sport = @Sport		
ORDER BY sortOrder



END 







GO
