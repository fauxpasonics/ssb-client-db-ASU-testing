SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE  PROCEDURE [dbo].[rptCustSeasonTicketSoftballRenew2_2016Prod] 
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

BEGIN

set transaction isolation level read uncommitted
      
declare @curSeason varchar(50)
declare @prevSeason varchar(50)
Set @prevSeason = 'SB15'
Set @curSeason = 'SB16'

--DECLARE @dateRange VARCHAR(30) = 'AllData'
--DECLARE @startDate AS DATE = DATEADD(MONTH,-1,GETDATE())
--DECLARE @endDate AS DATE = GETDATE()

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
 WHERE rb.SEASON = @prevSeason
	   OR (rb.season = @curSeason
		   AND (@dateRange = 'AllData'
				OR rb.MINPAYMENTDATE BETWEEN @startDate AND @endDate))

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
SELECT  rb.SEASON 
        ,'Season' SALETYPENAME 
        ,CASE WHEN TIPRICELEVELMAP2.PL_CLASS IS NULL THEN 'NOT CLASSIFIED'
             ELSE TIPRICELEVELMAP2.PL_CLASS
         END AS PL_CLASS 
        ,CASE WHEN rb.I_PT LIKE '%N' THEN 0
             WHEN rb.I_PT LIKE '%A' THEN 0
             ELSE 1
         END AS RENEWAL 
        ,SUM(ORDQTY) QTY 
        ,SUM(ORDTOTAL) AMT
FROM    #ReportBase rb
        LEFT JOIN TIPRICELEVELMAP2 ON rb.SEASON = TIPRICELEVELMAP2.SEASON
                                      AND rb.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS = TIPRICELEVELMAP2.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS
                                      AND rb.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS = TIPRICELEVELMAP2.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS
                                      AND rb.E_PL = TIPRICELEVELMAP2.I_PL
                                      AND TIPRICELEVELMAP2.REPORTCODE = 'SBT'
WHERE   rb.ITEM IN ( 'SBS' )
        AND rb.SEASON IN ( @prevSeason )
        AND ( PAIDTOTAL > 0 )
GROUP BY rb.SEASON 
        ,rb.I_PT 
        ,rb.E_PL 
        ,PL_CLASS 

UNION ALL 
SELECT  rb.SEASON 
        ,'Season' SALETYPENAME 
        ,CASE WHEN TIPRICELEVELMAP2.PL_CLASS IS NULL THEN 'NOT CLASSIFIED'
             ELSE TIPRICELEVELMAP2.PL_CLASS
        END AS PL_CLASS 
        ,CASE WHEN rb.I_PT LIKE 'N%' THEN 0
             WHEN rb.I_PT LIKE '%A' THEN 0
             ELSE 1
        END AS RENEWAL 
        ,SUM(ORDQTY) QTY 
        ,SUM(ORDTOTAL) AMT
FROM    #ReportBase rb
        LEFT JOIN TIPRICELEVELMAP2 ON rb.SEASON = TIPRICELEVELMAP2.SEASON
                                      AND rb.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS = TIPRICELEVELMAP2.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS
                                      AND rb.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS = TIPRICELEVELMAP2.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS
                                      AND rb.E_PL = TIPRICELEVELMAP2.I_PL
                                      AND TIPRICELEVELMAP2.REPORTCODE = 'SBT'
WHERE   rb.ITEM IN ( 'FS' )
        AND rb.SEASON IN ( @curSeason ) 
        AND ( PAIDTOTAL > 0 )
GROUP BY rb.SEASON 
        ,rb.I_PT 
        ,rb.E_PL 
        ,PL_CLASS 


SELECT  ISNULL(PL.pl_class, '') AS QtyCat 
        ,ISNULL(CASE WHEN PL.pl_class = 'NOT CLASSIFIED' THEN 0
                    ELSE bbPrev.bbPrevQty
               END, 0) AS PYQty 
        ,ISNULL(bbPrev.bbPrevQty, 0) AS PYQtyUnfiltered 
        ,ISNULL(bbPrev.bbPrevAmt, 0) AS PYAmt 
        ,ISNULL(bbCurRenew.bbCurRenewQty, 0) AS CYRenewQty 
        ,ISNULL(bbCurRenew.bbCurRenewAmt, 0) AS CYRenewAmt 
        ,ISNULL(bbCurNew.bbCurNewQty, 0) AS CYNewQty 
        ,ISNULL(bbCurNew.bbCurNewAmt, 0) AS CYNewAmt 
        ,RenewPct = CASE WHEN PL.pl_class = 'NOT CLASSIFIED' THEN NULL
                        WHEN CAST(ISNULL(bbPrev.bbPrevQty, 0) AS FLOAT) = 0
                        THEN 0
                        ELSE CAST(ISNULL(bbCurRenew.bbCurRenewQty, 0) AS FLOAT)
                             / CAST(bbPrev.bbPrevQty AS FLOAT)
                   END 
        ,TotalQty = ISNULL(bbCurRenew.bbCurRenewQty, 0)
				   + ISNULL(bbCurNew.bbCurNewQty, 0) 
        ,TotalAmt = ISNULL(bbCurRenew.bbCurRenewAmt, 0)
				   + ISNULL(bbCurNew.bbCurNewAmt, 0) 
        ,ISNULL(Capacity.CAPACITY, 0) Capacity 
        ,ISNULL(Capacity.SORT_ORDER, 998) sortOrder --998 to be last in sort order, but before 999 NOT CLASSIFIED
        ,CASE WHEN ISNULL(PL.pl_class, '') IN ( 'General Admission',
                                               'Field Level', 'Reserved Level',
                                               'Field', 'Premium Field' )
             THEN 0
             ELSE 1
        END AS HideRow
FROM    ( SELECT DISTINCT
                    pl_class
          FROM      #SeasonSummary
        ) PL
        LEFT OUTER JOIN ( SELECT    pl_class 
                                    ,SUM(qty) AS bbPrevQty 
                                    ,SUM(amt) AS bbPrevAmt
                          FROM      #SeasonSummary
                          WHERE     season IN ( @prevSeason )
                          GROUP BY  pl_class
                        ) bbPrev ON PL.pl_class = bbPrev.pl_class
        LEFT OUTER JOIN ( SELECT    pl_class 
                                    ,SUM(qty) AS bbCurRenewQty 
                                    ,SUM(amt) AS bbCurRenewAmt
                          FROM      #SeasonSummary
                          WHERE     season IN ( @curSeason )
                                    AND renewal = '1'
                          GROUP BY  pl_class
                        ) bbCurRenew ON PL.pl_class = bbCurRenew.pl_class
        LEFT OUTER JOIN ( SELECT    pl_class 
                                    ,SUM(qty) AS bbCurNewQty 
                                    ,SUM(amt) AS bbCurNewAmt
                          FROM      #SeasonSummary
                          WHERE     season IN ( @curSeason )
                                    AND renewal = '0'
                          GROUP BY  pl_class
                        ) bbCurNew ON PL.pl_class = bbCurNew.pl_class
        LEFT OUTER JOIN dbo.TIPRICELEVELCAPACITY Capacity ON PL.pl_class = Capacity.PL_CLASS
                                                             AND Capacity.SEASON = @curSeason
ORDER BY sortOrder

                




END 









GO
