SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







--exec rptCustSeasonTicketWBRenew2_2015Prod


CREATE  PROCEDURE [rpt].[CustSeasonTicketWBRenew2_2016Prod] 
    (
      @startDate DATE
    , @endDate DATE
    , @dateRange VARCHAR(20)
    )
AS


IF object_id('tempdb..#reportBase')IS NOT NULL
	DROP TABLE #reportBase
IF object_id('tempdb..#seasonSummary')IS NOT NULL
	DROP TABLE #seasonSummary
IF object_id('tempdb..#PriceLevelMap')IS NOT NULL
	DROP TABLE #PriceLevelMap

/*
DROP TABLE #ReportBase
DROP TABLE #SeasonSummary
*/

BEGIN

set transaction isolation level read uncommitted
      
declare @curSeason varchar(50)
declare @prevSeason varchar(50)


Set @prevSeason = 'WB15'
Set @curSeason = 'WB16'

--DECLARE	@dateRange VARCHAR(20)= 'AllData1'
--DECLARE @startDate DATE = DATEADD(month,-1,GETDATE())
--DECLARE @endDate DATE = GETDATE()



--------------------------Build Price Level Map--------------------------------------------
 
 SELECT DISTINCT x.SEASON
			,x.PL_CLASS
              , x.ITEM
			  , x.I_PT
			  , x.I_PL
        INTO    #PriceLevelMap 
        FROM    ( SELECT    SEASON
								,CASE WHEN SeatSeat.PL = 1 THEN 'Floor'
                                 WHEN SeatSeat.PL = 2 THEN 'Floor'
                                 WHEN SeatSeat.PL = 3 THEN 'Reserved'
                                 WHEN SeatSeat.PL = 4 THEN 'General Admission'
                                 ELSE 'Unknown'
                            END AS PL_CLASS
                          , SeatSeat.ITEM
						  ,SeatSeat.I_PT
						  , SeatSeat.I_PL
                  FROM      dbo.TK_SEAT_SEAT SeatSeat
                  WHERE     1 = 1
                            AND SeatSeat.SEASON IN ( @curSeason )
							AND SeatSeat.ITEM IN ('FS', 'GA')
                  GROUP BY  SeatSeat.SEASON
							,SeatSeat.PL
                          , SeatSeat.SECTION
						  , SeatSeat.ROW
						  , SeatSeat.ITEM
						  ,SeatSeat.I_PT
						  , SeatSeat.I_PL
                ) x
				GROUP BY  x.SEASON, x.PL_CLASS, x.ITEM, x.I_PT, x.I_PL
UNION 
 SELECT DISTINCT x.SEASON
			,x.PL_CLASS
              , x.ITEM
			  , x.I_PT
			  , x.I_PL
        FROM    ( SELECT    SEASON
								,CASE WHEN SeatSeat.PL = 1 THEN 'Floor'
                                 WHEN SeatSeat.PL = 2 THEN 'Reserved'
                                 WHEN SeatSeat.PL = 3 THEN 'General Admission'
                                 ELSE 'Unknown'
                            END AS PL_CLASS
                           , SeatSeat.ITEM
						  ,  SeatSeat.I_PT
						  , SeatSeat.I_PL
						  ,SeatSeat.ROW
                  FROM      dbo.TK_SEAT_SEAT SeatSeat
                  WHERE     1 = 1
                            AND SeatSeat.SEASON IN ( @prevSeason )
                            AND SeatSeat.ITEM = 'FS'
                  GROUP BY  SeatSeat.SEASON
							,SeatSeat.PL
                          , SeatSeat.SECTION
						  , SeatSeat.ITEM
						  ,SeatSeat.I_PT
						  , SeatSeat.I_PL
						  ,SeatSeat.ROW
                ) x
				GROUP BY  x.SEASON, x.PL_CLASS, x.ITEM, x.I_PT, x.I_PL


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
      rb.SEASON
      ,'Season' SALETYPENAME
       , PL_CLASS 
        ,CASE WHEN rb.I_PT LIKE '%N' THEN 0
             WHEN rb.I_PT LIKE '%A' THEN 0
             ELSE 1
         END AS RENEWAL 
      ,SUM(ORDQTY) QTY 
      ,SUM(ORDTOTAL) AMT
from #ReportBase rb
			LEFT join #PriceLevelMap plm ON rb.SEASON = plm.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS 
											AND rb.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS  = plm.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS
										    AND rb.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS = plm.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
											AND rb.E_PL = plm.I_PL COLLATE SQL_Latin1_General_CP1_CS_AS 
where rb.ITEM IN ('FS', 'GA')  AND rb.SEASON in (@curSeason, @prevSeason)
	AND ( PAIDTOTAL > 0 )
		--AND CUSTOMER <> '137398'
GROUP BY	rb.SEASON, rb.I_PT , rb.E_PL,  PL_CLASS 


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
	        ,CASE WHEN ISNULL(PL.pl_class, '') IN ( 'Floor',
                                                'Reserved',
                                               'General Admission' )
             THEN 0
             ELSE 1
        END AS HideRow
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
LEFT OUTER JOIN dbo.TIPRICELEVELCAPACITY Capacity 
	ON PL.PL_CLASS=CAPACITY.PL_CLASS AND CAPACITY.SEASON = @curSeason		
ORDER BY sortOrder

	




END 








GO
