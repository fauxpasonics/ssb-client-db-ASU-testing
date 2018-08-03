SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[rptCustSeasonTicketFootballRenew2] 
    (
      @startDate DATE
    , @endDate DATE
    , @dateRange VARCHAR(20)
	, @curSeason NVARCHAR(20)
	, @Sport VARCHAR(50)
    )
AS  

BEGIN
      
--declare @curSeason varchar(50) = 2018
declare @prevSeason varchar(50) = @curSeason - 1

--declare @Sport varchar(50)
--Set @prevSeason = '2017'
--Set @curSeason = '2018'
--set @Sport = 'Football'

--DECLARE	@dateRange VARCHAR(20)= 'AllData'
--DECLARE @startDate DATE = DATEADD(month,-10,GETDATE())
--DECLARE @endDate DATE = GETDATE()

/*********************************************************************************************************************************
	FB18 or later - after TM conversion
*********************************************************************************************************************************/

IF @curSeason >= 2018
BEGIN

			------- Build Price Level Map -----------------------------------------

			SELECT DISTINCT  x.SeasonYear, x.PL_CLASS, x.PC1
			INTO    #PriceLevelMap 
			FROM (
					SELECT	  SeasonYear
							, CASE	WHEN fts.PC1 = 'A' THEN 'Section 7 ($1800)'
									WHEN fts.PC1 = 'B' THEN 'Section 204 ($1650)'
									WHEN fts.PC1 = 'C' THEN 'Section 203;205 ($1250)'
									WHEN fts.PC1 = 'D' THEN 'Loge 128-139 ($1200)'
									WHEN fts.PC1 = 'E' THEN 'Section 6;8 ($1200)'
									WHEN fts.PC1 = 'F' THEN 'Loge 145-149 ($900)'
									WHEN fts.PC1 = 'G' THEN 'Section 201-202,206-207 ($800)'
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
									WHEN fts.PC1 = 'V' THEN 'Legends Club'
									WHEN fts.PC1 = 'W' THEN 'Legends Club Suites'
									WHEN fts.PC1 = 'Z' THEN 'North Terrace Club'
									ELSE 'Unknown'
									END AS PL_CLASS
							, fts.PC1
					FROM      [ro].[vw_FactTicketSalesBase] fts
					WHERE     1 = 1
						AND fts.SeasonYear = @curSeason
						AND fts.Sport = @Sport
						AND fts.TicketTypeCode IN ('FS', 'FSC')
					GROUP BY  fts.SeasonYear, fts.PC1
				) x
			GROUP BY  x.SeasonYear, x.PL_CLASS, x.PC1

			UNION

			SELECT DISTINCT  x.SeasonYear, x.PL_CLASS, x.PC1
			FROM (
					SELECT SeasonYear
						, CASE WHEN fts.PC1 = 'A' THEN 'Section 7 ($1800)'
							WHEN fts.PC1 = 'B' THEN 'Section 204 ($1650)'
							WHEN fts.PC1 = 'C' THEN 'Section 203;205 ($1250)'
							WHEN fts.PC1 = 'D'THEN 'Loge 128-139 ($1200)'
							WHEN fts.PC1 = 'E' THEN 'Section 6;8 ($1200)'
							WHEN fts.PC1 = 'F' THEN 'Loge 145-149 ($900)'
							WHEN fts.PC1 = 'G' THEN 'Section 201-202,206-207 ($800)'
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
						, fts.pc1 AS PC1
					FROM [ro].[vw_FactTicketSalesBase_All] fts
					WHERE 1 = 1
						AND fts.SeasonYear = @PrevSeason
						AND fts.Sport = @Sport
						AND fts.TicketTypeCode IN ('FS', 'FSC')
					GROUP BY  fts.SeasonYear, fts.pc1, fts.PC1
				) x
			GROUP BY x.SeasonYear, x.PL_CLASS, x.PC1

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

			INSERT INTO #ReportBase (SeasonYear, Sport, DimSeasonId, TicketingAccountId, DimItemId
				, DimPriceCodeId, DimPriceTypeId, DimPlanTypeId, PC1, PC3, PriceLevelCode, TicketTypeCode
				, TicketTypeClass, IsComp, TransDateTime, QtySeatRenewable, RevenueTotal, PaidAmount) 

			SELECT SeasonYear, Sport, DimSeasonId, TicketingAccountId, DimItemId
				, DimPriceCodeId, DimPriceTypeId, DimPlanTypeId, PC1, PC3, PriceLevelCode, TicketTypeCode
				, TicketTypeClass, IsComp, TransDateTime, SUM(QtySeatRenewable) QtySeatRenewable
				, SUM(RevenueTotal) RevenueTotal, SUM(PaidAmount) PaidAmount
			FROM  [ro].[vw_FactTicketSalesBase_All] fts 
			WHERE  DimSeasonId <> 134 --exclude Paciolan 2017 Football data
				AND fts.Sport =  @Sport
				AND fts.TicketTypeCode in ('FS', 'FSC')
				AND (fts.SeasonYear = @prevSeason 
					OR (@dateRange = 'AllData' AND fts.SeasonYear = @curseason)
					OR (@dateRange <> 'AllData' AND fts.SeasonYear = @curSeason AND fts.TransDateTime BETWEEN @startDate AND @endDate)
					)
			GROUP BY SeasonYear, Sport, DimSeasonId, TicketingAccountId, DimItemId, DimPriceCodeId, DimPriceTypeId
				, DimPlanTypeId, PC1, PC3, PriceLevelCode, TicketTypeCode, TicketTypeClass, IsComp, TransDateTime
 

			----------------------------------------------------------------------------------------------


			CREATE TABLE #SeasonSummary
			(
				  season		VARCHAR(100)
				, saleTypeName  VARCHAR(50)
				, pl_class		VARCHAR(50)
				, renewal		INT
				, qty			INT
				, amt			MONEY
			)

			INSERT into #SeasonSummary (season, saleTypeName, pl_class, renewal, qty, amt)

			--Regular Season Ticket Current Season

			SELECT rb.SeasonYear, 'Season' SALETYPENAME, PL_CLASS 
				  , CASE WHEN DimPlanTypeId IN ('1','2') THEN 0 --New & Additional 
						ELSE 1 END as RENEWAL
				  , SUM(QtySeatRenewable) QTY 
				  , SUM(RevenueTotal) AMT
			FROM #ReportBase rb
			LEFT join #PriceLevelMap plm
				ON rb.PC1 = plm.PC1
				AND rb.SeasonYear = plm.SeasonYear
			WHERE rb.SeasonYear = (@curSeason)
				AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
			GROUP BY rb.SeasonYear, rb.DimPlanTypeId, PL_CLASS

			UNION

			SELECT rb.SeasonYear, 'Season' SALETYPENAME, PL_CLASS 
				  , CASE WHEN DimPlanTypeId IN ('1','2') THEN 0 --New & Additional
						ELSE 1 END as RENEWAL
				  , SUM(QtySeatRenewable) QTY 
				  , SUM(RevenueTotal) AMT
			FROM #ReportBase rb
			LEFT join #PriceLevelMap plm
				ON rb.PC1 = plm.PC1
				AND rb.SeasonYear = plm.SeasonYear
			WHERE rb.SeasonYear in (@prevSeason)
				AND (PaidAmount > 0 OR PC3 = 'Z')
			GROUP BY rb.SeasonYear, rb.DimPlanTypeId, PL_CLASS



			SELECT ISNULL(PL.PL_CLASS,'') AS QtyCat
				, ISNULL(bbPrev.bbPrevQty,0) AS PYQty
				, ISNULL(bbPrev.bbPrevAmt,0) AS PYAmt
				, ISNULL(bbCurRenew.bbCurRenewQty,0) AS CYRenewQty
				, ISNULL(bbCurRenew.bbCurRenewAmt,0) AS CYRenewAmt
				, ISNULL(bbCurNew.bbCurNewQty,0) AS CYNewQty
				, ISNULL(bbCurNew.bbCurNewAmt,0) AS CYNewAmt
				, RenewPct = CASE WHEN CAST(ISNULL(bbPrev.bbPrevQty,0) AS FLOAT) = 0 THEN 0 
					ELSE CAST(ISNULL(bbCurRenew.bbCurRenewQty,0) AS FLOAT) / CAST(bbPrev.bbPrevQty AS FLOAT) END
				, TotalQty = ISNULL(bbCurRenew.bbCurRenewQty,0)  + ISNULL(bbCurNew.bbCurNewQty,0)
				, TotalAmt = ISNULL(bbCurRenew.bbCurRenewAmt,0) + ISNULL(bbCurNew.bbCurNewAmt,0)
				, ISNULL(CAPACITY.CAPACITY,0) Capacity
				, ISNULL(CAPACITY.SORT_ORDER,998) sortOrder --998 to be last in sort order, but before 999 NOT CLASSIFIED
			FROM (SELECT DISTINCT PL_CLASS FROM #seasonsummary) PL   
			LEFT JOIN (
					SELECT DISTINCT PL_CLASS, SUM(QTY) AS bbPrevQty, SUM(AMT) AS bbPrevAmt 
					FROM #seasonsummary 
					WHERE season = @PrevSeason               
					GROUP BY PL_CLASS
				)  bbPrev ON PL.PL_CLASS = bbPrev.PL_CLASS  
			LEFT JOIN (
					SELECT DISTINCT PL_CLASS, SUM(QTY) AS bbCurRenewQty, SUM(AMT) AS bbCurRenewAmt 
					FROM #seasonsummary 
					WHERE SEASON IN (@curSeason)      
						AND renewal = '1' 
					GROUP BY PL_CLASS
				) bbCurRenew ON PL.PL_CLASS =  bbCurRenew.PL_CLASS 
			LEFT JOIN (
					SELECT DISTINCT PL_CLASS, SUM(QTY) AS bbCurNewQty, SUM(AMT) AS bbCurNewAmt 
					FROM #seasonsummary 
					WHERE season IN (@curSeason)     
						AND renewal = '0' 
					GROUP BY PL_CLASS
				) bbCurNew ON PL.PL_CLASS =  bbCurNew.PL_CLASS 
			LEFT OUTER JOIN rpt.TM_PRICELEVELCAPACITY Capacity 
				ON PL.PL_CLASS = CAPACITY.PL_CLASS
				AND CAPACITY.SeasonYear = @curSeason
				AND CAPACITY.Sport = @Sport    
			ORDER BY sortOrder

END


/*********************************************************************************************************************************
	FB17 or later - after TM conversion
*********************************************************************************************************************************/

IF @curSeason = 2017
BEGIN

			------- Build Price Level Map -----------------------------------------
			SELECT DISTINCT  x.SeasonYear, x.PL_CLASS, x.PC1
			INTO #PriceLevelMap2017
			FROM (
					SELECT SeasonYear
						, CASE WHEN fts.PC1 = 'A' THEN 'Section 7 ($1800)'
							WHEN fts.PC1 = 'B' THEN 'Section 204 ($1650)'
							WHEN fts.PC1 = 'C' THEN 'Section 203;205 ($1250)'
							WHEN fts.PC1 = 'D' THEN 'Loge 128-139 ($1200)'
							WHEN fts.PC1 = 'E' THEN 'Section 6;8 ($1200)'
							WHEN fts.PC1 = 'F' THEN 'Loge 145-149 ($900)'
							WHEN fts.PC1 = 'G' THEN 'Section 201-202,206-207 ($800)'
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
						, fts.PC1
					FROM [ro].[vw_FactTicketSalesBase] fts
					WHERE 1 = 1
						AND fts.SeasonYear = 2017
						AND fts.Sport = 'Football'
						AND fts.TicketTypeCode IN ('FS', 'FSC')
					GROUP BY  fts.SeasonYear, fts.PC1
				) x
			GROUP BY  x.SeasonYear, x.PL_CLASS, x.PC1

			UNION

			SELECT DISTINCT x.SeasonYear, x.PL_CLASS, x.PC1
			FROM (
					SELECT SeasonYear
						, CASE WHEN fts.PriceLevelCode = '1' THEN 'Section 7 ($1800)'
							WHEN fts.PriceLevelCode = '3' THEN 'Section 204 ($1650)'
							WHEN fts.PriceLevelCode = '4' THEN 'Section 203;205 ($1250)'
							WHEN fts.PriceLevelCode = '2' THEN 'Loge 128-139 ($1200)'
							WHEN fts.PriceLevelCode = '5' THEN 'Section 6;8 ($1200)'
							WHEN fts.PriceLevelCode = '6' THEN 'Loge 145-149 ($900)'
							WHEN fts.PriceLevelCode = '7' THEN 'Section 201-202,206-207 ($800)'
							WHEN fts.PriceLevelCode = '9' THEN 'Section 5;9 ($500)'
							WHEN fts.PriceLevelCode = '8' THEN 'Section 29-31 ($600)'
							WHEN fts.PriceLevelCode IN ('10', '11') THEN 'Section 1-4;10-13;304-306 ($375)'
							WHEN fts.PriceLevelCode = '12' THEN 'Section 302-303;307-308 ($235)'
							WHEN fts.PriceLevelCode = '14' THEN 'Section 301;309 ($200)'
							WHEN fts.PriceLevelCode = '13' THEN 'Section 238-240; 244-246 ($200)'
							WHEN fts.PriceLevelCode = '15' THEN 'Section 237; 247 ($150)'
							WHEN fts.PriceLevelCode = '23' THEN 'Young Alumni'
							ELSE 'Unknown'
							END AS PL_CLASS
						, fts.PriceLevelCode AS PC1
					FROM [ro].[vw_FactTicketSalesBase_All] fts
					WHERE 1 = 1
						AND fts.SeasonYear = 2016 AND fts.Sport = 'Football'
							AND fts.TicketTypeCode IN ('FS', 'FSC')
					GROUP BY  fts.SeasonYear,fts.PriceLevelCode
				) x
			GROUP BY x.SeasonYear, x.PL_CLASS, x.PC1










			---- Build Report --------------------------------------------------------------------------------------------------

			Create TABLE #ReportBase2017  
			(
			  SeasonYear int
			, Sport nvarchar(255)
			, DimSeasonId int
			, TicketingAccountId nvarchar(50)
			, DimItemId int
			, DimPriceCodeId int
			, DimPriceTypeId int
			, DimPlanTypeId int
			, PC1 nvarchar(1)
			, PC3 nvarchar(1)
			, PriceLevelCode nvarchar(25)
			, TicketTypeCode nvarchar(25)
			, TicketTypeClass varchar(100)
			, IsComp int
			, TransDateTime datetime  
			, QtySeatRenewable int
			, RevenueTotal numeric (18,6) 
			, PaidAmount numeric (18,6)
			)

			INSERT INTO #ReportBase2017 (SeasonYear, Sport, DimSeasonId, TicketingAccountId, DimItemId
				, DimPriceCodeId, DimPriceTypeId, DimPlanTypeId, PC1, PC3, PriceLevelCode, TicketTypeCode
				, TicketTypeClass, IsComp, TransDateTime, QtySeatRenewable, RevenueTotal, PaidAmount) 

			SELECT DISTINCT SeasonYear, Sport, DimSeasonId, TicketingAccountId, DimItemId
				, DimPriceCodeId, DimPriceTypeId, DimPlanTypeId, PC1, PC3, PriceLevelCode, TicketTypeCode
				, TicketTypeClass, IsComp, TransDateTime, SUM(QtySeatRenewable) QtySeatRenewable
				, SUM(RevenueTotal) RevenueTotal, SUM(PaidAmount) PaidAmount
			FROM [ro].[vw_FactTicketSalesBase_All] fts 
			WHERE DimSeasonId <> 134 --exclude Paciolan 2017 Football data
				AND fts.Sport =  'Football'
				AND fts.TicketTypeCode in ('FS', 'FSC')
				AND (fts.SeasonYear = 2016 
					OR ('AllData' = 'AllData' AND fts.SeasonYear = 2017))
			GROUP BY SeasonYear, Sport, DimSeasonId, TicketingAccountId, DimItemId, DimPriceCodeId, DimPriceTypeId
				, DimPlanTypeId, PC1, PC3, PriceLevelCode, TicketTypeCode, TicketTypeClass, IsComp, TransDateTime
 

			----------------------------------------------------------------------------------------------


			CREATE TABLE #SeasonSummary2017
			(
				  season		VARCHAR(100)
				, saleTypeName  VARCHAR(50)
				, pl_class		VARCHAR(50)
				, renewal		INT
				, qty			INT
				, amt			MONEY
			)

			INSERT INTO #SeasonSummary2017 (season, saleTypeName, pl_class, renewal, qty, amt)

			--Regular Season Ticket Current Season

			select rb.SeasonYear, 'Season' SALETYPENAME, PL_CLASS 
				, CASE WHEN DimPlanTypeId IN ('1','2') THEN 0 --New & Additional 
					ELSE 1 END as RENEWAL
				, SUM(QtySeatRenewable) QTY 
				, SUM(RevenueTotal) AMT
			from #ReportBase2017 rb
			LEFT join #PriceLevelMap2017 plm
				ON rb.PC1 = plm.PC1
				AND rb.SeasonYear = plm.SeasonYear
			WHERE rb.SeasonYear = 2017
				AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
			GROUP BY rb.SeasonYear, rb.DimPlanTypeId, PL_CLASS

			UNION ALL

			select rb.SeasonYear, 'Season' SALETYPENAME, PL_CLASS 
				, CASE WHEN DimPlanTypeId IN ('1','2') THEN 0 --New & Additional
					ELSE 1 END as RENEWAL
				, SUM(QtySeatRenewable) QTY 
				, SUM(RevenueTotal) AMT
			FROM #ReportBase2017 rb
			LEFT JOIN #PriceLevelMap2017 plm
				ON rb.PriceLevelCode = plm.PC1
				AND rb.SeasonYear = plm.SeasonYear
			WHERE rb.SeasonYear = 2016
				AND rb.PaidAmount > 0
			GROUP BY rb.SeasonYear, rb.DimPlanTypeId, PL_CLASS



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

			FROM (SELECT DISTINCT PL_CLASS FROM #seasonsummary2017) PL   
			LEFT OUTER JOIN (SELECT DISTINCT PL_CLASS, SUM(QTY) AS bbPrevQty, SUM(AMT) AS bbPrevAmt 
								FROM #seasonsummary2017 
								WHERE season IN (@PrevSeason)                
								 GROUP BY PL_CLASS)  bbPrev
					ON PL.PL_CLASS = bbPrev.PL_CLASS  

			LEFT OUTER JOIN (SELECT DISTINCT PL_CLASS, SUM(QTY) AS bbCurRenewQty, SUM(AMT) AS bbCurRenewAmt 
								FROM #seasonsummary2017 
								WHERE SEASON IN (@curSeason)      
								AND renewal = '1' 
								GROUP BY PL_CLASS) bbCurRenew
					ON PL.PL_CLASS =  bbCurRenew.PL_CLASS 

			LEFT OUTER JOIN (SELECT DISTINCT PL_CLASS, SUM(QTY) AS bbCurNewQty, SUM(AMT) AS bbCurNewAmt 
								FROM #seasonsummary2017 
								WHERE season IN (@curSeason)     
								 AND renewal = '0' 
								GROUP BY PL_CLASS ) bbCurNew
					ON PL.PL_CLASS =  bbCurNew.PL_CLASS 
			LEFT OUTER JOIN rpt.TM_PRICELEVELCAPACITY Capacity 
				ON PL.PL_CLASS = CAPACITY.PL_CLASS AND CAPACITY.SeasonYear = @curSeason  AND CAPACITY.Sport = @Sport    
			ORDER BY sortOrder

END

/*********************************************************************************************************************************
	FB16 - before TM conversion
*********************************************************************************************************************************/

IF @curSeason = '2016'
BEGIN


			
			SET @curSeason = CONCAT('F', RIGHT(@curSeason, 2))
			SET @prevSeason = CONCAT('F', RIGHT(@prevSeason, 2))


			---- Build Report --------------------------------------------------------------------------------------------------

			Create table #ReportBase2016  
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

			INSERT INTO #ReportBase2016 
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



			create table #SeasonSummary2016
			(
				season varchar(100)
				,saleTypeName  varchar(50)
				,pl_class varchar(50)
				,renewal int
				,qty  int
				,amt money
			)



			insert into #SeasonSummary2016
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
				  ,case when TIPRICELEVELMAP2.PL_CLASS IS Null then 'NOT CLASSIFIED'
						when TIPRICELEVELMAP2.PL_CLASS = '$1459/$1499/$1575' then 'Light Green'
						when TIPRICELEVELMAP2.PL_CLASS = '$179/$189/$199' then 'Light Gray'
						when TIPRICELEVELMAP2.PL_CLASS = '$1929/$1999/$2099' then 'Black'
						when TIPRICELEVELMAP2.PL_CLASS = '$279/$289/$299' then 'Maroon'
						when TIPRICELEVELMAP2.PL_CLASS = '$524/$544/$564' then 'Dark Gray'
						when TIPRICELEVELMAP2.PL_CLASS = '$899/$919/$939' then 'Gold'
						when TIPRICELEVELMAP2.PL_CLASS = '$120' then '2014 $120'
					else TIPRICELEVELMAP2.PL_CLASS
				  end as PL_CLASS 
      
				  , CASE WHEN rb.I_PT like 'N%' THEN 0 WHEN rb.I_PT like 'BN%' then 0  
				  WHEN rb.I_PT LIKE '%A' THEN 0 
				  ELSE 1 END as  RENEWAL
				  ,SUM(ORDQTY) QTY 
				  ,SUM(ORDTOTAL) AMT
			from #ReportBase2016 rb
			LEFT join TIPRICELEVELMAP2  on rb.SEASON = TIPRICELEVELMAP2.SEASON 
				  AND rb.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS 
				  = TIPRICELEVELMAP2.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS
				  AND rb.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
				  = TIPRICELEVELMAP2.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
				  AND rb.E_PL = TIPRICELEVELMAP2.I_PL 
				  AND TIPRICELEVELMAP2.REPORTCODE =  'FT'
			where rb.ITEM = 'FS' AND rb.SEASON in (@curSeason, @prevSeason)
				AND ( PAIDTOTAL > 0 OR CUSTOMER in ('152760','164043','186078' ) )
					--AND CUSTOMER <> '137398'
			GROUP BY    rb.SEASON, rb.I_PT , PL_CLASS 


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

			FROM (SELECT DISTINCT PL_CLASS FROM #seasonsummary2016) PL   
			LEFT OUTER JOIN (SELECT PL_CLASS, SUM(QTY) AS bbPrevQty, SUM(AMT) AS bbPrevAmt 
								FROM #seasonsummary2016 
								WHERE season IN (@prevSeason)                
								 GROUP BY PL_CLASS)  bbPrev
					ON PL.PL_CLASS = bbPrev.PL_CLASS  

			LEFT OUTER JOIN (SELECT PL_CLASS
				, SUM(QTY) AS bbCurRenewQty, SUM(AMT) AS bbCurRenewAmt 
								FROM #seasonsummary2016 
								WHERE SEASON IN (@curSeason)      
								AND renewal = '1' 
								GROUP BY PL_CLASS) bbCurRenew
					ON PL.PL_CLASS =  bbCurRenew.PL_CLASS 

			LEFT OUTER JOIN (SELECT PL_CLASS, SUM(QTY) AS bbCurNewQty, SUM(AMT) AS bbCurNewAmt 
								FROM #seasonsummary2016 
								WHERE season IN (@curSeason)     
								 AND renewal = '0' 
								GROUP BY PL_CLASS ) bbCurNew
					ON PL.PL_CLASS =  bbCurNew.PL_CLASS 
			LEFT OUTER JOIN dbo.TIPRICELEVELCAPACITY Capacity 
				ON PL.PL_CLASS=CAPACITY.PL_CLASS AND CAPACITY.SEASON = @curSeason        
			ORDER BY sortOrder

END


/*********************************************************************************************************************************
	FB15 - before TM conversion
*********************************************************************************************************************************/

IF @curSeason = '2015'
BEGIN


			
			SET @curSeason = CONCAT('F', RIGHT(@curSeason, 2))
			SET @prevSeason = CONCAT('F', RIGHT(@prevSeason, 2))


			
			---- Build Report --------------------------------------------------------------------------------------------------


			Create table #ReportBase2015  
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

			INSERT INTO #ReportBase2015 
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



			create table #SeasonSummary2015
			(
				season varchar(100)
				,saleTypeName  varchar(50)
				,pl_class varchar(50)
				,renewal int
				,qty  int
				,amt money
			)



			insert into #SeasonSummary2015
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
				  ,case when TIPRICELEVELMAP2.PL_CLASS IS Null then 'NOT CLASSIFIED'
						when TIPRICELEVELMAP2.PL_CLASS = '$1459/$1499/$1575' then 'Light Green'
						when TIPRICELEVELMAP2.PL_CLASS = '$179/$189/$199' then 'Light Gray'
						when TIPRICELEVELMAP2.PL_CLASS = '$1929/$1999/$2099' then 'Black'
						when TIPRICELEVELMAP2.PL_CLASS = '$279/$289/$299' then 'Maroon'
						when TIPRICELEVELMAP2.PL_CLASS = '$524/$544/$564' then 'Dark Gray'
						when TIPRICELEVELMAP2.PL_CLASS = '$899/$919/$939' then 'Gold'
						when TIPRICELEVELMAP2.PL_CLASS = '$120' then '2014 $120'
					else TIPRICELEVELMAP2.PL_CLASS
				  end as PL_CLASS 
      
				  , CASE WHEN rb.I_PT like 'N%' THEN 0 WHEN rb.I_PT like 'BN%' then 0  
				  WHEN rb.I_PT LIKE '%A' THEN 0 
				  ELSE 1 END as  RENEWAL
				  ,SUM(ORDQTY) QTY 
				  ,SUM(ORDTOTAL) AMT
			from #ReportBase2015 rb
			LEFT join TIPRICELEVELMAP2  on rb.SEASON = TIPRICELEVELMAP2.SEASON 
				  AND rb.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS 
				  = TIPRICELEVELMAP2.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS
				  AND rb.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
				  = TIPRICELEVELMAP2.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
				  AND rb.E_PL = TIPRICELEVELMAP2.I_PL 
				  AND TIPRICELEVELMAP2.REPORTCODE =  'FT'
			where rb.ITEM = 'FS' AND E_PL <> '10'  AND rb.SEASON in (@curSeason, @prevSeason)
				AND ( PAIDTOTAL > 0 OR CUSTOMER in ('152760','164043','186078' ) )
					--AND CUSTOMER <> '137398'
			GROUP BY    rb.SEASON, rb.I_PT , PL_CLASS 


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

			FROM (SELECT DISTINCT PL_CLASS FROM #seasonsummary2015) PL   
			LEFT OUTER JOIN (SELECT PL_CLASS, SUM(QTY) AS bbPrevQty, SUM(AMT) AS bbPrevAmt 
								FROM #seasonsummary2015 
								WHERE season IN (@prevSeason)                
								 GROUP BY PL_CLASS)  bbPrev
					ON PL.PL_CLASS = bbPrev.PL_CLASS  

			LEFT OUTER JOIN (SELECT PL_CLASS
				, SUM(QTY) AS bbCurRenewQty, SUM(AMT) AS bbCurRenewAmt 
								FROM #seasonsummary2015 
								WHERE SEASON IN (@curSeason)      
								AND renewal = '1' 
								GROUP BY PL_CLASS) bbCurRenew
					ON PL.PL_CLASS =  bbCurRenew.PL_CLASS 

			LEFT OUTER JOIN (SELECT PL_CLASS, SUM(QTY) AS bbCurNewQty, SUM(AMT) AS bbCurNewAmt 
								FROM #seasonsummary2015 
								WHERE season IN (@curSeason)     
								 AND renewal = '0' 
								GROUP BY PL_CLASS ) bbCurNew
					ON PL.PL_CLASS =  bbCurNew.PL_CLASS 
			LEFT OUTER JOIN dbo.TIPRICELEVELCAPACITY Capacity 
				ON PL.PL_CLASS=CAPACITY.PL_CLASS AND CAPACITY.SEASON = @curSeason        
			ORDER BY sortOrder

END


END 






/****** Object:  StoredProcedure [dbo].[rptCustSeasonTicketFootballRenew1]    Script Date: 5/23/2018 5:43:57 PM ******/
SET ANSI_NULLS ON
GO
