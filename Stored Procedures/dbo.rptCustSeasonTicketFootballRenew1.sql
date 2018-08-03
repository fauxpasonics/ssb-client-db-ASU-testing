SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[rptCustSeasonTicketFootballRenew1]
    (
      @startDate DATE
    , @endDate DATE
    , @dateRange VARCHAR(20)
	, @curSeason NVARCHAR(20)
	, @Sport varchar(50)
    )
AS 

/*
DROP TABLE #budget
DROP TABLE #ReportBase	
DROP TABLE #SeasonSummary	
*/

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--declare @curSeason INT = 2018
declare @prevSeason NVARCHAR(20) = @curSeason - 1
--declare @Sport varchar(50) = 'Football'


--Set @prevSeason = '2017'
--Set @curSeason = '2018'
--Set @Sport = 'Football'

--DECLARE	@dateRange VARCHAR(20)= 'AllData'
--DECLARE @startDate DATE = DATEADD(month,-1,GETDATE())
--DECLARE @endDate DATE = GETDATE()

----------------------------------------------------------------------------------

/*********************************************************************************************************************************
	FB18 or later - after TM conversion
*********************************************************************************************************************************/

IF @curSeason >= 2018
BEGIN


			Create table   #budget 
			(
				saleTypeName varchar(100)
				,amount int
			)

			insert into #budget
			--Budget and Prior Year Revenue
			Select 'Mini Plans FSE', '0' UNION ALL
			Select 'Season', '0' UNION ALL
			Select 'Season Suite', '0' UNION ALL
			Select 'Single Game Tickets', '0' UNION ALL
			Select 'Single Game Suite', '0' UNION ALL
			Select 'MBSC', '0'
			 --SELECT * FROM #budget


			---- Build Report --------------------------------------------------------------------------------------------------



			Create table #ReportBase  
			(
			  SeasonYear int
			 ,Sport nvarchar(255)
			 ,DimSeasonId int
			 ,TicketingAccountId nvarchar(50)
			 ,ItemCode nvarchar(50)
			 , PC3 nvarchar(1)
			 ,DimPlanId int
			 ,SectionName nvarchar(50)
			 ,TicketTypeCode nvarchar(25)
			 ,TicketTypeClass varchar(100)
			 ,IsComp int
			 ,QtySeat int 
			 ,QtySeatFSE numeric (18,6)
			 ,QtySeatRenewable int
			 ,RevenueTotal numeric (18,6) 
			 ,TransDateTime datetime  
			 ,PaidAmount numeric (18,6)
			)

			INSERT INTO #ReportBase (SeasonYear, Sport, DimSeasonId, TicketingAccountId, ItemCode,  PC3
				, DimPlanId, SectionName, TicketTypeCode, TicketTypeClass, IsComp, QtySeat, QtySeatFSE
				, QtySeatRenewable, RevenueTotal, TransDateTime, PaidAmount) 

			SELECT SeasonYear, Sport, DimSeasonId, TicketingAccountId, ItemCode, PC3, DimPlanId
				, SectionName, TicketTypeCode, TicketTypeClass, IsComp, QtySeat, QtySeatFSE
				, QtySeatRenewable, RevenueTotal, TransDateTime, PaidAmount
			FROM  [ro].[vw_FactTicketSalesBase_All] fts 
			WHERE  DimSeasonId <> 134 --exclude Paciolan 2017 Football data
				AND fts.Sport = @Sport
				AND (fts.SeasonYear = @prevSeason 
					OR (@dateRange = 'AllData' AND fts.SeasonYear = @curseason)
					OR (@dateRange <> 'AllData' AND fts.SeasonYear = @curSeason 
						AND fts.TransDateTime BETWEEN @startDate AND @endDate)
					)


			-----------------------------------------------------------------------------------------

			Create table #SeasonSummary 
			(
				SeasonYear		INT 
				, saleTypeName	VARCHAR(50)
				, qty			INT
				, amt			MONEY
			)

			INSERT INTO #SeasonSummary (SeasonYear, saleTypeName, qty, amt)
			-----------------------------------------------------------------------------
			--SEASON 
			--Previous  and Current SEASON  
			SELECT SeasonYear, 'Season' AS SaleTypeName, SUM(QtySeatRenewable) QTY, SUM(RevenueTotal) AMT
			FROM #ReportBase 
			WHERE (TicketTypeCode = 'FS' OR TicketTypeCode = 'FSC')
				AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
			GROUP BY SeasonYear
			-----------------------------------------------------------------------------------------

			UNION ALL 
			--SEASON 
			--Previous  and Current SEASON  
			SELECT SeasonYear, 'MBSC' AS SaleTypeName, SUM(QtySeatFSE) QTY, SUM(RevenueTotal) AMT
			FROM #ReportBase 
			WHERE TicketTypeCode = 'MBSC'
				 AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
			GROUP BY SeasonYear 
			------------------------------------------------------------------------------------------------------

			UNION ALL 
			--MINI PLANS
			SELECT SeasonYear, 'Mini Plans FSE' AS SaleTypeName, SUM(QtySeatFSE) QTY, SUM(RevenueTotal) AMT
			FROM #ReportBase 
			WHERE TicketTypeCode = 'MINI'
				   AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
			GROUP BY SeasonYear    
			----------------------------------------------------------------------------------------------------
			
			UNION ALL 
			--SEASON SUITE
			SELECT SeasonYear, 'Season Suite', COUNT(Distinct SectionName) QTY, SUM(RevenueTotal) AMT
			FROM #ReportBase 
			WHERE TicketTypeCode = 'FSS'
				AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
				--AND SeasonYear = @curSeason
			GROUP BY SeasonYear 
			
			-----------------------------------------------------------------------------

			UNION ALL 


			SELECT SeasonYear, 'Single Game Suite', SUM(QTY) AS QTY, SUM(AMT) AS AMT 
			FROM (
					SELECT SeasonYear, 'Single Game Suite' AS SaleTypeName
						, CASE WHEN ItemCode like '%SRO%' THEN 0
							ELSE COUNT(DISTINCT SectionName) END AS QTY
						, SUM(RevenueTotal) AMT
					FROM #ReportBase rb 
					WHERE TicketTypeCode = 'SGS'
						AND RevenueTotal > 0
						AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
						--AND SeasonYear = @curSeason
					GROUP BY SeasonYear, Itemcode
				)x
			GROUP BY SeasonYear
			--------------------------------------------------------------------------------------------------------

			UNION ALL 


			--Single Game Total

			SELECT SeasonYear, 'Single Game Tickets', SUM(QtySeat) QTY, SUM(RevenueTotal) AMT
			FROM #ReportBase rb 
			WHERE TicketTypeClass = 'Single'
				AND TicketTypeCode NOT IN ('VISIT', 'SGS')
				AND RevenueTotal > 0
				AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
				AND IsComp = 0
			GROUP BY SeasonYear

			UNION ALL

			SELECT Seasonyear, 'Single Game Tickets', SUM(QtySeat) QTY, SUM(RevenueTotal) AMT
			FROM #ReportBase rb
			WHERE TicketTypeCode = 'VISIT'
				AND IsComp = 0
			GROUP BY SeasonYear
			-------------------------------------------------------------------------------------

			SELECT ISNULL(PrevYR.saleTypeName,'') AS QtyCat
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
			FROM (
					SELECT saleTypeName, SUM(qty) AS prevQty, SUM(amt) AS prevAmt
					FROM #seasonsummary a
					WHERE CAST(RIGHT(SeasonYear,2) AS INT) = RIGHT(@prevseason,2) GROUP BY saleTypeName
				) PrevYR
			LEFT OUTER JOIN (
					SELECT saleTypeName, SUM(qty) AS curQty, SUM(amt) AS curAmt
					FROM #seasonsummary a
					WHERE CAST(RIGHT(SeasonYear,2) AS INT) = RIGHT(@curseason,2) GROUP BY saleTypeName
			 ) CurYR ON PrevYR.saleTypeName = CurYR.saleTypeName
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


/*********************************************************************************************************************************
	FB17 - after TM conversion
*********************************************************************************************************************************/

IF @curSeason = 2017
BEGIN


			Create table   #budget2017 
			(
				saleTypeName varchar(100)
				,amount int
			)

			insert into #budget2017
			--Budget and Prior Year Revenue
			Select 'Mini Plans FSE', '125000' UNION ALL
			Select 'Season', '5181475' UNION ALL
			Select 'Season Suite', '0' UNION ALL
			Select 'Single Game Tickets', '4424425' UNION ALL
			Select 'Single Game Suite', '160000' UNION ALL 
			Select 'MBSC', '0'  
			 --SELECT * FROM #budget


			---- Build Report --------------------------------------------------------------------------------------------------



			Create table #ReportBase2017  
			(
			  SeasonYear int
			 ,Sport nvarchar(255)
			 ,DimSeasonId int
			 ,TicketingAccountId nvarchar(50)
			 ,ItemCode nvarchar(50)
			 , PC3 nvarchar(1)
			 ,DimPlanId int
			 ,SectionName nvarchar(50)
			 ,TicketTypeCode nvarchar(25)
			 ,TicketTypeClass varchar(100)
			 ,IsComp int
			 ,QtySeat int 
			 ,QtySeatFSE numeric (18,6)
			 ,QtySeatRenewable int
			 ,RevenueTotal numeric (18,6) 
			 ,TransDateTime datetime  
			 ,PaidAmount numeric (18,6)
			)

			INSERT INTO #ReportBase2017 (SeasonYear, Sport, DimSeasonId, TicketingAccountId, ItemCode,  PC3
				, DimPlanId, SectionName, TicketTypeCode, TicketTypeClass, IsComp, QtySeat, QtySeatFSE
				, QtySeatRenewable, RevenueTotal, TransDateTime, PaidAmount) 

			SELECT SeasonYear, Sport, DimSeasonId, TicketingAccountId, ItemCode, PC3, DimPlanId
				, SectionName, TicketTypeCode, TicketTypeClass, IsComp, QtySeat, QtySeatFSE
				, QtySeatRenewable, RevenueTotal, TransDateTime, PaidAmount
			FROM  [ro].[vw_FactTicketSalesBase_All] fts 
			WHERE  DimSeasonId <> 134 --exclude Paciolan 2017 Football data
				AND fts.Sport = @Sport
				AND (fts.SeasonYear = @prevSeason 
					OR (@dateRange = 'AllData' AND fts.SeasonYear = @curseason)
					OR (@dateRange <> 'AllData' AND fts.SeasonYear = @curSeason 
						AND fts.TransDateTime BETWEEN @startDate AND @endDate)
					)


			-----------------------------------------------------------------------------------------

			Create table #SeasonSummary2017 
			(
				SeasonYear		INT 
				, saleTypeName	VARCHAR(50)
				, qty			INT
				, amt			MONEY
			)

			INSERT INTO #SeasonSummary2017 (SeasonYear, saleTypeName, qty, amt)
			-----------------------------------------------------------------------------
			--SEASON 
			--Previous  and Current SEASON  
			SELECT SeasonYear, 'Season' AS SaleTypeName, SUM(QtySeatRenewable) QTY, SUM(RevenueTotal) AMT
			FROM #ReportBase2017 
			WHERE (TicketTypeCode = 'FS' OR TicketTypeCode = 'FSC')
				AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
			GROUP BY SeasonYear
			-----------------------------------------------------------------------------------------

			UNION ALL 
			--SEASON 
			--Previous  and Current SEASON  
			SELECT SeasonYear, 'MBSC' AS SaleTypeName, SUM(QtySeatFSE) QTY, SUM(RevenueTotal) AMT
			FROM #ReportBase2017 
			WHERE TicketTypeCode = 'MBSC'
				 AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
			GROUP BY SeasonYear 
			------------------------------------------------------------------------------------------------------

			UNION ALL 
			--MINI PLANS
			SELECT SeasonYear, 'Mini Plans FSE' AS SaleTypeName, SUM(QtySeatFSE) QTY, SUM(RevenueTotal) AMT
			FROM #ReportBase2017 
			WHERE TicketTypeCode = 'MINI'
				   AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
			GROUP BY SeasonYear    
			----------------------------------------------------------------------------------------------------

			UNION ALL 
			--SEASON SUITE
			SELECT SeasonYear, 'Season Suite', COUNT(Distinct SectionName) QTY, SUM(RevenueTotal) AMT
			FROM #ReportBase2017 
			WHERE TicketTypeCode = 'FSS'
				AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
				AND SeasonYear = @curSeason
			GROUP BY SeasonYear 

			UNION ALL 

			SELECT SeasonYear, 'Season Suite' SaleTypeName, SUM(QTY) QTY, SUM(AMT) AMT
			FROM (
					SELECT SeasonYear, 'Season Suite' AS SaleTypeName
						, CASE WHEN ItemCode LIKE '%FBFSST' THEN 0
							ELSE COUNT(ItemCode)/6 END AS QTY
						, SUM(RevenueTotal)  AMT
					FROM #ReportBase2017 
					WHERE  TicketTypeCode = 'FSS'
						AND PaidAmount > 0 
						AND SeasonYear = @PrevSeason
					GROUP BY SeasonYear, ItemCode

					UNION ALL 

					SELECT '2016' SeasonYear, 'Season Suite' SaleTypeName, '0' QTY, '174800'  AMT
				) a
			GROUP BY Seasonyear, SaleTypeName
			-----------------------------------------------------------------------------

			UNION ALL 

			SELECT SeasonYear, 'Single Game Suite' AS SaleTypeName, SUM(QTY) QTY, SUM(AMT) AMT
			FROM (
					SELECT SeasonYear, 'Single Game Suite' SaleTypeName, COUNT(TicketingAccountId) QTY, SUM(RevenueTotal) AMT
					FROM #ReportBase2017 rb 
					WHERE TicketTypeCode = 'SGS' 
						AND RevenueTotal > 0
						AND PaidAmount > 0 
						AND SeasonYear = @PrevSeason
					GROUP BY SeasonYear

					UNION ALL

					SELECT '2016' SeasonYear, 'Single Game Suite' SaleTypeName, '0' QTY, '31600'  AMT
				) a
			GROUP BY Seasonyear, SaleTypeName

			UNION ALL 


			SELECT SeasonYear, 'Single Game Suite', SUM(QTY) AS QTY, SUM(AMT) AS AMT 
			FROM (
					SELECT SeasonYear, 'Single Game Suite' AS SaleTypeName
						, CASE WHEN ItemCode like '%SRO%' THEN 0
							ELSE COUNT(DISTINCT SectionName) END AS QTY
						, SUM(RevenueTotal) AMT
					FROM #ReportBase2017 rb 
					WHERE TicketTypeCode = 'SGS'
						AND RevenueTotal > 0
						AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
						AND SeasonYear = @curSeason
					GROUP BY SeasonYear, Itemcode
				)x
			GROUP BY SeasonYear
			--------------------------------------------------------------------------------------------------------

			UNION ALL 


			--Single Game Total

			SELECT SeasonYear, 'Single Game Tickets', SUM(QtySeat) QTY, SUM(RevenueTotal) AMT
			FROM #ReportBase2017 rb 
			WHERE TicketTypeClass = 'Single'
				AND TicketTypeCode NOT IN ('VISIT', 'SGS')
				AND RevenueTotal > 0
				AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
				AND IsComp = 0
			GROUP BY SeasonYear

			UNION ALL

			SELECT Seasonyear, 'Single Game Tickets', SUM(QtySeat) QTY, SUM(RevenueTotal) AMT
			FROM #ReportBase2017 rb
			WHERE TicketTypeCode = 'VISIT'
				AND IsComp = 0
			GROUP BY SeasonYear
			-------------------------------------------------------------------------------------

			SELECT ISNULL(PrevYR.saleTypeName,'') AS QtyCat
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
			FROM (
					SELECT saleTypeName, SUM(qty) AS prevQty, SUM(amt) AS prevAmt
					FROM #seasonsummary2017 a
					WHERE CAST(RIGHT(SeasonYear,2) AS INT) = RIGHT(@prevseason,2) GROUP BY saleTypeName
				) PrevYR
			LEFT OUTER JOIN (
					SELECT saleTypeName, SUM(qty) AS curQty, SUM(amt) AS curAmt
					FROM #seasonsummary2017 a
					WHERE CAST(RIGHT(SeasonYear,2) AS INT) = RIGHT(@curseason,2) GROUP BY saleTypeName
			 ) CurYR ON PrevYR.saleTypeName = CurYR.saleTypeName
			LEFT OUTER JOIN #budget2017 budget
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


/*********************************************************************************************************************************
	FB16 - before TM conversion
*********************************************************************************************************************************/

IF @curSeason = '2016'
BEGIN


			
			SET @curSeason = CONCAT('F', RIGHT(@curSeason, 2))
			SET @prevSeason = CONCAT('F', RIGHT(@prevSeason, 2))

			
			Create table   #budget2016
			(
				saleTypeName varchar(100)
				,amount int
			)

			insert into #budget2016
			--Budget and Prior Year Revenue

			Select 'Mini Plans FSE', '0' UNION ALL
			Select 'Season', '0' UNION ALL
			Select 'Season Suite', '0' UNION ALL
			Select 'Single Game Tickets', '0' UNION ALL
			Select 'Single Game Suite', '0' UNION ALL 
			Select 'MBSC', '0'  



			---- Build Report --------------------------------------------------------------------------------------------------



			Create table #reportbase2016  
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

			INSERT INTO #reportbase2016 
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
			FROM #reportbase2016 
			where ITEM = 'FS' AND SEASON in (@prevSeason, @curSeason)
				AND ( PAIDTOTAL > 0 OR CUSTOMER in ('152760','164043','186078' ) )
				AND CUSTOMER <> '137398'
			GROUP BY CUSTOMER , SEASON 

			-----------------------------------------------------------------------------------------

			UNION ALL 
			--SEASON 

			--Previous  and Current SEASON  

			SELECT 
				  SEASON 
				 ,'MBSC'
				 ,SUM(ORDQTY)  QTY
				 ,SUM(ORDTOTAL) AMT
			FROM #reportbase2016 
			WHERE ITEM = 'FSC' AND E_PL = '20'
			AND SEASON IN (@curSeason)
				AND  PAIDTOTAL > 0
			GROUP BY CUSTOMER , ITEM, SEASON 

			UNION ALL 

			SELECT 
				  SEASON 
				 ,'MBSC'
				 , SUM(ORDQTY) QTY
				 ,SUM(ORDTOTAL) AMT
			FROM #reportbase2016 
			where( ITEM = 'FSC'  and E_PL = '11' ) 
			AND SEASON IN (@prevSeason)
				AND  PAIDTOTAL > 0
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
			FROM #reportbase2016 
			where  ITEM like '[2-5]%'  
				   AND SEASON in (@curSeason)
				   AND ( PAIDTOTAL > 0 )
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
			FROM #reportbase2016 
			where  ITEM like '[2-5]%'  
				   AND SEASON in ( @prevSeason)
				   AND ( PAIDTOTAL > 0 )
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
			FROM #reportbase2016 
			where ITEM in ('FSS','FSSUITE')  
				   AND SEASON in  (@curSeason, @prevSeason)
				AND ( PAIDTOTAL > 0 )
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

			--FROM #reportbase2016 

			--where ITEM = 'DONSUITE'  

			--       AND SEASON in  (@curSeason)

			--    AND ( PAIDTOTAL > 0 )

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
			from #reportbase2016 rb 
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
			from #reportbase2016
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
			from #reportbase2016 rb 
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
			from #reportbase2016
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
			from #reportbase2016 rb 
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
			from #reportbase2016
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
			from #reportbase2016 rb 
				WHERE rb.SEASON IN  (@curSeason) 
				and ITEM like 'F0[1-6]'
				 and rb.E_PL not in  ('16') -- deals with single game suites for now 

				and rb.I_PT not in ('V')
				and rb.I_PRICE > 0
			AND ( rb.PAIDTOTAL > 0 )
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
			from #reportbase2016 rb
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
			from #reportbase2016 rb 
				WHERE rb.SEASON IN  (@prevSeason) 
				and ITEM like 'F0[1-7]'
				 and rb.E_PL not in  ('10') -- deals with single game suites for now 

				and rb.I_PT not in ('V')
				and rb.I_PRICE > 0
			AND ( rb.PAIDTOTAL > 0 )
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
			from #reportbase2016 rb
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

    
			FROM (
					SELECT saleTypeName, SUM(qty) AS prevQty, SUM(amt) AS prevAmt
					FROM @seasonsummary a
					WHERE CAST(RIGHT(season,2) AS INT) = RIGHT(@prevseason,2)
					GROUP BY saleTypeName
				) PrevYR
			LEFT OUTER JOIN (
					SELECT saleTypeName, SUM(qty) AS curQty, SUM(amt) AS curAmt
					FROM @seasonsummary a
					WHERE CAST(RIGHT(season,2) AS INT) = RIGHT(@curseason,2)
					GROUP BY saleTypeName
				) CurYR	ON PrevYR.saleTypeName = CurYR.saleTypeName
			LEFT OUTER JOIN #budget2016 budget
				ON PrevYR.saleTypeName = budget.saleTypeName
			ORDER BY 
				(CASE PrevYR.saleTypeName
					WHEN 'Single Game Suite' THEN 3
					WHEN 'Single Game Tickets' THEN 5
					--when 'Student Guest Pass' then 2

					WHEN 'Season' THEN 7
					WHEN 'Season Suite' THEN 4
					--when 'Student Season' then 1

					WHEN 'MBSC' THEN 8 
					WHEN 'Mini Plans FSE' THEN 6 END)


END



/*********************************************************************************************************************************
	FB15 - before TM conversion
*********************************************************************************************************************************/

IF @curSeason = '2015'
BEGIN


			
			SET @curSeason = CONCAT('F', RIGHT(@curSeason, 2))
			SET @prevSeason = CONCAT('F', RIGHT(@prevSeason, 2))

			
			Create table   #budget2015 
			(
				saleTypeName varchar(100)
				,amount int
			)

			insert into #budget2015 
			--Budget and Prior Year Revenue

			Select 'Mini Plans FSE', '120000'  UNION ALL
			Select 'Season', '4715000' UNION ALL
			Select 'Season Suite', '424864'   UNION ALL
			Select 'Single Game Tickets', '5042155' UNION ALL
			Select 'Single Game Suite', '147500' UNION ALL 
			Select 'MBSC', '32675'    



			---- Build Report --------------------------------------------------------------------------------------------------



			Create table #reportbase2015   
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

			INSERT INTO #reportbase2015 
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

			/*Declare @SeasonSummary table 
			(
				season varchar(100)
				,saleTypeName  varchar(50)
				,qty  int
				,amt money
			)*/


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
			FROM #reportbase2015 
			where ITEM = 'FS' AND E_PL not in ('10')  AND SEASON in (@prevSeason, @curSeason)
				AND ( PAIDTOTAL > 0 OR CUSTOMER in ('152760','164043','186078' ) )
				AND CUSTOMER <> '137398'
			GROUP BY CUSTOMER , SEASON 

			-----------------------------------------------------------------------------------------

			UNION ALL 
			--SEASON 

			--Previous  and Current SEASON  

			SELECT 
				  SEASON 
				 ,'MBSC'
				 ,case when ITEM like 'F0[1-7]%' then  SUM(ORDQTY)/7 else 
				  SUM(ORDQTY) end QTY
				 ,SUM(ORDTOTAL) AMT
			FROM #reportbase2015 
			where( ITEM = 'FSC' or (ITEM like 'F0[1-7]%' and E_PL = '11') ) 
			AND SEASON IN (@curSeason)
				AND  PAIDTOTAL > 0
			GROUP BY CUSTOMER , ITEM, SEASON 

			UNION ALL 

			SELECT 
				  SEASON 
				 ,'MBSC'
				 ,SUM(ORDQTY) QTY
				 ,SUM(ORDTOTAL) AMT
			FROM #reportbase2015 
			where( ITEM = 'FSC' and E_PL = '11' ) 
			AND SEASON IN (@prevSeason)
				AND  PAIDTOTAL > 0
			GROUP BY CUSTOMER , ITEM, SEASON 


			-----------------------------------------------------------------------------------------

			--Student Season 

			--UNION ALL 


			--Previous  

			--SELECT 

			--     SEASON 

			--     ,'Student Season'

			--    ,SUM(ORDQTY) QTY

			--    --,SUM(ORDTOTAL) AMT

			--    ,SUM(ORDQTY * (I_PRICE - 30) - I_DAMT) AMT

			--FROM #reportbase2015 

			--where ITEM LIKE 'FSB%'

			--       AND SEASON in  (@prevSeason,@studentprevSeason)

			--    AND ( PAIDTOTAL > 0 )

			--GROUP BY SEASON 


			--Current 

			--SELECT 

			--     SEASON 

			--     ,'Student Season'

			--    --,SUM(ORDQTY) QTY

			--    ,0 as Qty

			--    --,SUM(ORDQTY * (I_PRICE - 30) - I_DAMT) AMT

			--    ,0 as AMT 

			--FROM #reportbase2015 

			--where ITEM LIKE 'FSB%'

			--       AND SEASON in  (@prevSeason,@studentprevSeason,@curSeason,@studentcurSeason)

			--    AND ( PAIDTOTAL > 0 )

			--GROUP BY SEASON 



			-------------------------------------------------------------------------------------------------

			--Student Guest Pass 

			--UNION ALL 


			--PREVIOUS AND CURRENT SEASON 

			--SELECT 

			--     SEASON 

			--     ,'Student Guest Pass'

			--    ,SUM(ORDQTY) QTY

			--    ,SUM(ORDTOTAL) AMT

			--FROM #reportbase2015 

			--where ITEM = 'FSGP'  

			--       AND SEASON in  (@prevSeason,@studentprevSeason,@curSeason,@studentcurSeason)

			--    AND ( PAIDTOTAL > 0 )

			--GROUP BY SEASON 


			------------------------------------------------------------------------------------------------------

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
			FROM #reportbase2015 
			where  ITEM like '[2-5]%'  
				   AND SEASON in (@curSeason)
				   AND ( PAIDTOTAL > 0 )
			GROUP BY SEASON , ITEM   

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
			FROM #reportbase2015 
			where  ITEM like '[2-5]%'  
				   AND SEASON in ( @prevSeason)
				   AND ( PAIDTOTAL > 0 )
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
			FROM #reportbase2015 
			where ITEM in ('FSS','FSSUITE')  
				   AND SEASON in  (@curSeason, @prevSeason)
				AND ( PAIDTOTAL > 0 )
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

			--FROM #reportbase2015 

			--where ITEM = 'DONSUITE'  

			--       AND SEASON in  (@curSeason)

			--    AND ( PAIDTOTAL > 0 )

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
			from #reportbase2015 rb 
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
			from #reportbase2015
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
			from #reportbase2015 rb 
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
			from #reportbase2015
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
			from #reportbase2015 rb 
				WHERE ITEM like 'F0[1-7]%'
				and rb.E_PL in ('10')
				and rb.I_PT in ('SP')
				and rb.SEASON in  (@curSeason)
			group by rb.CUSTOMER, rb.SEASON, rb.I_PT) suite
			left outer join 
			(select
				SEASON 
				,CUSTOMER
				,SUM(ORDTOTAL) AMT
			from #reportbase2015
			where SEASON in  (@curSeason)
				and ITEM like 'SRO%'
			group by CUSTOMER, SEASON) donation
			on suite.SEASON = donation.Season
			and suite.customer = donation.customer
			and suite.SEASON = donation.SEASON 
			group by suite.season

			--------------------------------------------------------------------------------------------------------

			UNION ALL 

			--previous year 


			--Single Game Total

			select 
				 rb.SEASON 
				,'Single Game Tickets'
			,sum(ORDQTY) as Qty
			,sum(ORDTOTAL) as Amt
			from #reportbase2015 rb 
				WHERE rb.SEASON IN  (@curSeason) 
				and ITEM like 'F0[1-7]'
				 and rb.E_PL not in  ('10') -- deals with single game suites for now 

				and rb.I_PT not in ('V')
				and rb.I_PRICE > 0
			AND ( rb.PAIDTOTAL > 0 )
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
			from #reportbase2015 rb
			  WHERE rb.SEASON IN  (@curSeason) 
			  and ITEM like 'F0[1-7]'
			  AND rb.E_PL not in  ('10') -- deals with single game suites for now  

			  AND rb.I_PT IN ('V')
			group by rb.SEASON, rb.I_PT


			----------------------------------------------------------------------------------------


			UNION ALL 
			--current  game 


			--Single Game Total

			select 
				 rb.SEASON 
				,'Single Game Tickets'
			,sum(ORDQTY) as Qty
			,sum(ORDTOTAL) as Amt
			from #reportbase2015 rb 
				WHERE rb.SEASON IN  (@prevSeason) 
				and ITEM like 'F0[1-6]'
				 and rb.E_PL not in  ('10') -- deals with single game suites for now 

				and rb.I_PT not in ('V')
				and rb.I_PRICE > 0
			AND ( rb.PAIDTOTAL > 0 )
			group by rb.Season, rb.I_PT

			UNION ALL
			select 
				 rb.Season
				,'Single Game Tickets'
			,sum(ORDQTY) as Qty
			,sum((ORDQTY * (CASE When ITEM = 'F01' THEN 50 
								 WHEN ITEM = 'F02' THEN 50
								 WHEN ITEM = 'F03' THEN 65
								 WHEN ITEM = 'F04' THEN 65  
								 WHEN ITEM = 'F05' THEN 125
								 WHEN ITEM = 'F06' THEN 50 
								 END)))as Amt
			from #reportbase2015 rb
			  WHERE rb.SEASON IN  (@prevSeason) 
			  and ITEM like 'F0[1-6]'
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

    
			FROM (
					SELECT saleTypeName, SUM(qty) AS prevQty, SUM(amt) AS prevAmt
					FROM @seasonsummary a
					WHERE CAST(RIGHT(season,2) AS INT) = RIGHT(@prevseason,2)
					GROUP BY saleTypeName
				) PrevYR
			LEFT OUTER JOIN (
					SELECT saleTypeName, SUM(qty) AS curQty, SUM(amt) AS curAmt
					FROM @seasonsummary a
					WHERE CAST(RIGHT(season,2) AS INT) = RIGHT(@curseason,2)
					GROUP BY saleTypeName
				) CurYR ON PrevYR.saleTypeName = CurYR.saleTypeName
			LEFT OUTER JOIN #budget2015 budget
				ON PrevYR.saleTypeName = budget.saleTypeName
			ORDER BY 
				(CASE PrevYR.saleTypeName
					WHEN 'Single Game Suite' THEN 3
					WHEN 'Single Game Tickets' THEN 5
					--when 'Student Guest Pass' then 2

					WHEN 'Season' THEN 7
					WHEN 'Season Suite' THEN 4
					--when 'Student Season' then 1

					WHEN 'MBSC' THEN 8 
					WHEN 'Mini Plans FSE' THEN 6 END)
END



END

GO
