SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







-- =============================================
-- Created By: Abbey Meitin
-- Create Date: 2018-04-12
-- Reviewed By: 
-- Reviewed Date: 
-- Description: ASU Football HOB Sales by Price Level
-- =============================================
 
/***** Revision History
 

 
*****/





/*
DROP TABLE #ReportBase
DROP TABLE #SeasonSummary
DROP TABLE #PriceLevelMap
*/

CREATE PROCEDURE [dbo].[rptCustSeasonTicketFootballRenew2_2018] 
    (
      @startDate DATE
    , @endDate DATE
    , @dateRange VARCHAR(20)
    )
AS  

BEGIN
      
declare @curSeason varchar(50)
declare @prevSeason varchar(50)
declare @Sport varchar(50)
Set @prevSeason = '2017'
Set @curSeason = '2018'
set @Sport = 'Football'

--DECLARE	@dateRange VARCHAR(20)= 'AllData'
--DECLARE @startDate DATE = DATEADD(month,-10,GETDATE())
--DECLARE @endDate DATE = GETDATE()

------- Build Price Level Map -----------------------------------------

SELECT DISTINCT  x.SeasonYear
					      , x.PL_CLASS 
						  --, x.DimTicketTypeId
						  , x.PC1

        INTO    #PriceLevelMap 
        FROM    ( SELECT    SeasonYear
								,CASE WHEN fts.PC1 = 'A' THEN 'Section 7 ($1800)'
                                 WHEN fts.PC1 = 'B' THEN 'Section 204 ($1650)'
                                 WHEN fts.PC1 = 'C' THEN 'Section 203;205 ($1250)'
                                 WHEN fts.PC1 = 'D'THEN 'Loge 128-139 ($1200)'
                                 WHEN fts.PC1 = 'E' THEN 'Section 6;8 ($1200)'
								 WHEN fts.PC1 = 'F' THEN 'Loge 145-149 ($900)'
								 WHEN fts.PC1 = 'G' THEN 'Section 201-201,206-207 ($800)'
								 WHEN fts.PC1 = 'H' THEN 'Section 5;9 ($500)'
								 WHEN fts.PC1 = 'I' THEN 'Section 29-31 ($600)'
								 WHEN fts.PC1 = 'J' THEN 'Section 1-4;10-13;304-306 ($375)'
								 WHEN fts.PC1 = 'K' THEN 'Section 27-28;32-33 ($450)'
								 WHEN fts.PC1 = 'L' THEN 'Section 302-303;307-308 ($235)'
								 WHEN fts.PC1 = 'M' THEN 'Section 24-26;34-36 ($315)'
								 WHEN fts.PC1 = 'N' THEN 'Section 301;309 ($200)'
								 WHEN fts.PC1 = 'O' THEN 'Section 241-243 ($210)'
								 WHEN fts.PC1 = 'P' THEN 'Section 238-240; 244-246 ($200)'
								 WHEN fts.PC1 = 'Q' THEN 'Section 237; 247 ($150)'
								 WHEN fts.PC1 = 'Y' THEN 'Young Alumni'
								 WHEN fts.PC1 = 'T' THEN 'Founders Suites'
								 WHEN fts.PC1 = 'U' THEN 'Coachs Club'
								 WHEN fts.PC1 = 'V'	THEN 'Legends Club'
								 WHEN fts.PC1 = 'W'	THEN 'Legends Club Suites'
								 WHEN fts.PC1 = 'Z'	THEN 'North Terrace Club'

                                 ELSE 'Unknown'
                            END AS PL_CLASS
                          --, fts.DimTicketTypeId
						  , fts.PC1
                  FROM      [ro].[vw_FactTicketSalesBase] fts
                  WHERE     1 = 1
                            AND fts.SeasonYear = @curSeason AND fts.Sport = @Sport
							AND fts.TicketTypeCode IN ('FS', 'FSC')
                  GROUP BY  fts.SeasonYear
						  --, fts.DimTicketTypeId
						  , fts.PC1
                ) x
				GROUP BY  x.SeasonYear
					      , x.PL_CLASS 
						  --, x.DimTicketTypeId
						  , x.PC1




UNION

 SELECT DISTINCT  x.SeasonYear
					      , x.PL_CLASS 
						  --, x.DimTicketTypeId
						  , x.PC1


        FROM    ( SELECT    SeasonYear
								,CASE WHEN fts.PriceLevelCode = '1' THEN 'Section 7 ($1800)'
                                 WHEN fts.PriceLevelCode = '3' THEN 'Section 204 ($1650)'
                                 WHEN fts.PriceLevelCode = '4' THEN 'Section 203;205 ($1250)'
                                 WHEN fts.PriceLevelCode  = '2'  THEN 'Loge 128-139 ($1200)'
                                 WHEN fts.PriceLevelCode  = '5'  THEN 'Section 6;8 ($1200)'
								 WHEN fts.PriceLevelCode  = '6' THEN 'Loge 145-149 ($900)'
								 WHEN fts.PriceLevelCode  = '7' THEN 'Section 201-202,206-207 ($800)'
								 WHEN fts.PriceLevelCode  = '9'   THEN 'Section 5;9 ($500)'
								 WHEN fts.PriceLevelCode  = '8'  THEN 'Section 29-31 ($600)'
								 WHEN fts.PriceLevelCode  IN ('10', '11') THEN 'Section 1-4;10-13;304-306 ($375)'
								 WHEN fts.PriceLevelCode  = '12' THEN 'Section 302-303;307-308 ($235)'
								 WHEN fts.PriceLevelCode  = '14'  THEN 'Section 301;309 ($200)'
								 WHEN fts.PriceLevelCode = '13' THEN 'Section 238-240; 244-246 ($200)'
								 WHEN fts.PriceLevelCode  = '15'  THEN 'Section 237; 247 ($150)'
								 WHEN fts.PriceLevelCode  = '23' THEN 'Young Alumni'
                                 ELSE 'Unknown'
                            END AS PL_CLASS
                          --, fts.DimTicketTypeId 
						  , fts.PriceLevelCode AS PC1
				
                  FROM      [ro].[vw_FactTicketSalesBase_All] fts
                  WHERE     1 = 1
                            AND fts.SeasonYear = @PrevSeason AND fts.Sport = @Sport
							AND fts.TicketTypeCode IN ('FS', 'FSC')
                  GROUP BY  fts.SeasonYear
							,fts.PriceLevelCode 
						  --, fts.DimTicketTypeId
						  , fts.PriceLevelCode

                ) x
				GROUP BY   x.SeasonYear
					      , x.PL_CLASS 
						  --, x.DimTicketTypeId
						  , x.PC1

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
 ,PC3 nvarchar(1)
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

SELECT DISTINCT
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
 --, CASE WHEN fts.DimEventId <= 0 AND fts.DimPlanId > 0 THEN SUM(QtySeat) ELSE SUM(QtySeatRenewable) END QtySeatRenewable -- Payton Soicher 7/23/2018
 ,SUM(RevenueTotal) RevenueTotal
 ,SUM(PaidAmount) PaidAmount
FROM  [ro].[vw_FactTicketSalesBase_All] fts 
WHERE  DimSeasonId <> 134 --exclude Paciolan 2017 Football data
AND fts.Sport =  @Sport
AND fts.TicketTypeCode in ('FS', 'FSC')
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
 , fts.DimEventId
 , fts.DimPlanId
 

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

select 
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
AND rb.PaidAmount > 0
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
LEFT OUTER JOIN (SELECT DISTINCT PL_CLASS, SUM(QTY) AS bbPrevQty, SUM(AMT) AS bbPrevAmt 
                    FROM #seasonsummary 
                    WHERE season IN (@PrevSeason)                
                     GROUP BY PL_CLASS)  bbPrev
        ON PL.PL_CLASS = bbPrev.PL_CLASS  

LEFT OUTER JOIN (SELECT DISTINCT PL_CLASS, SUM(QTY) AS bbCurRenewQty, SUM(AMT) AS bbCurRenewAmt 
                    FROM #seasonsummary 
                    WHERE SEASON IN (@curSeason)      
                    AND renewal = '1' 
                    GROUP BY PL_CLASS) bbCurRenew
        ON PL.PL_CLASS =  bbCurRenew.PL_CLASS 

LEFT OUTER JOIN (SELECT DISTINCT PL_CLASS, SUM(QTY) AS bbCurNewQty, SUM(AMT) AS bbCurNewAmt 
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
