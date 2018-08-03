SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[rptCustSeasonTicketFootballRenew3] 
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
DROP TABLE #eventHeader
DROP TABLE #homegames
DROP TABLE #ReportBase
*/

 
BEGIN

set transaction isolation level read uncommitted

--declare @curSeason varchar(50)
--declare @Sport varchar(50)

--Set @curSeason = '2018'
--set @Sport = 'Football'

--DECLARE	@dateRange VARCHAR(20)= 'AllData'
--DECLARE @startDate DATE = DATEADD(month,-1,GETDATE())
--DECLARE @endDate DATE = GETDATE()

/*********************************************************************************************************************************
	FB18 or later - after TM conversion
*********************************************************************************************************************************/

IF @curSeason >= 2017
BEGIN
		---- Build Report --------------------------------------------------------------------------------------------------

		--Report Base 

		Create table #ReportBase  
		(
		  SeasonHeaderYear int
		 ,Sport nvarchar(255)
		 ,TicketingAccountId int
		 ,EventCode nvarchar(50)
		 ,TicketTypeCode nvarchar(25)
		 ,TicketTypeClass varchar(100)
		 ,PC1 nvarchar(1)
		 ,PC3 nvarchar(1)
		 ,QtySeat int 
		 ,RevenueTotal numeric (18,6) 
		 ,TransDateTime datetime  
		 ,PaidAmount numeric (18,6)
		 ,IsComp int
		)

		INSERT INTO #ReportBase (SeasonHeaderYear, Sport, TicketingAccountId, EventCode, TicketTypeCode
			, TicketTypeClass, PC1, PC3, QtySeat, RevenueTotal, TransDateTime, PaidAmount, IsComp) 

		SELECT SeasonHeaderYear, Sport, TicketingAccountId, EventHeaderCode AS EventCode, TicketTypeCode
			, TicketTypeClass, PC1, PC3, QtySeat, RevenueTotal, TransDateTime, PaidAmount, IsComp
		FROM  [ro].[vw_FactTicketSalesBase] fts 
		WHERE  fts.Sport = @Sport
			AND TicketTypeClass = 'Single'
			AND ((@dateRange = 'AllData' AND fts.SeasonYear = @curseason)
				OR (@dateRange <> 'AllData' AND fts.SeasonYear = @curSeason AND fts.TransDateTime BETWEEN @startDate AND @endDate)
				)


		------------------------------------------------------------------------------------------------------------------


		CREATE TABLE #homegames
		(EventCode VARCHAR(50)   )

		insert into #homegames (EventCode)
		SELECT CONCAT(RIGHT(@curSeason,2),'FBF01') UNION ALL 
		SELECT CONCAT(RIGHT(@curSeason,2),'FBF02') UNION ALL 
		SELECT CONCAT(RIGHT(@curSeason,2),'FBF03') UNION ALL 
		SELECT CONCAT(RIGHT(@curSeason,2),'FBF04') UNION ALL 
		SELECT CONCAT(RIGHT(@curSeason,2),'FBF05') UNION ALL 
		SELECT CONCAT(RIGHT(@curSeason,2),'FBF06') UNION ALL
		SELECT CONCAT(RIGHT(@curSeason,2),'FBF07')


		CREATE TABLE #budget
		(
		  EventCode		VARCHAR (10) 
		, amount		FLOAT
		, quantity		INT
		)

		INSERT INTO #budget
		(EventCode , amount, quantity)

		SELECT CONCAT(RIGHT(@curSeason,2),'FBF01'),0,0 UNION ALL 
		SELECT CONCAT(RIGHT(@curSeason,2),'FBF02'),0,0 UNION ALL 
		SELECT CONCAT(RIGHT(@curSeason,2),'FBF03'),0,0 UNION ALL 
		SELECT CONCAT(RIGHT(@curSeason,2),'FBF04'),0,0 UNION ALL 
		SELECT CONCAT(RIGHT(@curSeason,2),'FBF05'),0,0 UNION ALL 
		SELECT CONCAT(RIGHT(@curSeason,2),'FBF06'),0,0 UNION ALL
		SELECT CONCAT(RIGHT(@curSeason,2),'FBF07'),0,0

		CREATE TABLE #eventHeader
		(
		  EventCode		VARCHAR(50)  
		, EventName		VARCHAR(200)
		, EventDate		DATE
		)

		INSERT INTO #eventHeader (EventCode, EventName, EventDate)

		SELECT DISTINCT fts.EventHeaderCode AS EventCode, EventHeaderName AS EventName, EventDate 
		FROM [ro].[vw_FactTicketSalesBase] fts 
		INNER JOIN #homegames homegames 
			ON fts.EventCode = homegames.EventCode
		WHERE fts.SeasonYear = @curSeason
			AND fts.Sport = @Sport



		----------------------------------------------------------------------------------------------------------


		--Single Game Breakout:

		declare @singleSummary as SingleSummary


		INSERT INTO  @singleSummary (EventCode, EventName, EventDate, VisitingTicketQty, VisitingTicketAmt
			, StudentTicketQty, StudentTicketAmt, GroupTicketQty, GroupTicketAmt, SuiteTicketQty, SuiteTicketAmt
			, PublicTicketQty, PublicTicketAmt, BudgetedQuantity, BudgetedAmount, TotalTickets, TotalRevenue
			, PercentToGoal, VarianceToGoal) 


		SELECT ISNULL(eventHeader.EventCode,'')
			, ISNULL(eventHeader.eventName,'')
			, ISNULL(eventHeader.eventDate,'')
			, ISNULL(vistingticketSet.visitingTicketQty,0)
			, ISNULL(vistingticketSet.visitingTicketAmt,0)
			, ISNULL(studentSet.studentTicketQty,0)
			, ISNULL(studentSet.studentTicketAmt,0)
			, ISNULL(groupSet.groupTicketQty,0)
			, ISNULL(groupSet.groupTicketAmt,0)
			, ISNULL(suiteSet.suiteTicketQty, 0)--,suiteSet.suiteTicketQty
			, ISNULL(suiteSet.suiteTicketAmt, 0)--,suiteSet.suiteTicketAmt
			, ISNULL(publicSet.publicTicketQty,0)
			, ISNULL(publicSet.publicTicketAmt,0)
			, ISNULL(budget.quantity,0) AS budgetedQuantity
			, ISNULL(budget.amount,0) AS budgetedAmount
			, ISNULL(vistingticketSet.visitingTicketQty,0) + ISNULL(studentSet.studentTicketQty,0) + ISNULL(groupSet.groupTicketQty,0)
				+ ISNULL(publicSet.publicTicketQty,0) + ISNULL(suiteSet.suiteTicketQty,0) AS TotalTickets    
			, ISNULL(vistingticketSet.visitingTicketAmt,0) + ISNULL(studentSet.studentTicketAmt,0) + ISNULL(groupSet.groupTicketAmt,0)
			  + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0) AS TotalRevenue       
			, CASE WHEN budget.amount = 0 THEN 0
				ELSE (
						ISNULL(vistingticketSet.visitingTicketAmt,0) + ISNULL(studentSet.studentTicketAmt,0) + ISNULL(groupSet.groupTicketAmt,0)
						+ ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0)
					)/ budget.amount
				END  AS PercentToGoal 
			, (ISNULL(vistingticketSet.visitingTicketAmt,0) + ISNULL(studentSet.studentTicketAmt,0) + ISNULL(groupSet.groupTicketAmt,0)
				+ ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0)) - budget.amount  AS VarianceToGoal
		FROM #eventHeader eventHeader
		LEFT JOIN  (
				SELECT rb.EventCode, SUM(QtySeat) AS visitingTicketQty, SUM(RevenueTotal) AS visitingTicketAmt
				--,SUM((QtySeat * (CASE  WHEN rb.EventCode IN ('17FBF01', '17FBF02') AND PC1 = 'M' THEN 30
				--					  WHEN rb.EventCode IN ('17FBF01', '17FBF02') AND PC1 = 'P' THEN 20
				--                      WHEN rb.EventCode = '17FBF03' THEN 50
				--                      WHEN rb.EventCode = '17FBF04' THEN 50  
				--                      WHEN rb.EventCode = '17FBF05' THEN 50
				--                      WHEN rb.EventCode = '17FBF06' THEN 50 
				--                       END))) AS visitingTicketAmt
				FROM #ReportBase rb  
				INNER JOIN #eventHeader eventHeaderEvent  
					ON rb.EventCode  = eventHeaderEvent.EventCode  
				WHERE TicketTypeCode = 'VISIT'
					AND IsComp = 0
				GROUP BY rb.EventCode
			) vistingticketSet ON eventheader.eventCode = vistingticketSet.EventCode  
		-------------------------------------------------------------------------------------------
		LEFT JOIN (
				SELECT CONCAT(RIGHT(@curSeason,2),'FBF01') AS EventCode, 0 AS studentTicketQty, 0 AS studentTicketAmt
			) studentSet ON eventheader.eventCode = studentSet.EventCode   
		-------------------------------------------------------------------------------------------------
		LEFT JOIN (
				SELECT rb.EventCode, SUM(QtySeat) AS groupTicketQty, SUM(RevenueTotal) AS groupTicketAmt
				FROM #ReportBase rb  
				INNER JOIN #eventHeader eventHeaderEvent
					ON rb.EventCode = eventHeaderEvent.EventCode   
				WHERE rb.TicketTypeCode = 'GROUP' 
					AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
				GROUP BY rb.EventCode 
			) GroupSet ON eventheader.EventCode = GroupSet.EventCode
		------------------------------------------------------------------------------------------
		LEFT JOIN (
				SELECT rb.EventCode, SUM(QtySeat) AS suiteTicketQty, SUM(RevenueTotal) AS suiteTicketAmt
				FROM #ReportBase rb  
				INNER JOIN #eventHeader eventHeaderEvent
					ON rb.EventCode = eventHeaderEvent.EventCode   
				WHERE rb.TicketTypeCode = 'CLUB' -- premium price levels
					AND rb.RevenueTotal > 0
					AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
				GROUP BY rb.EventCode 
			) SuiteSet ON eventheader.EventCode = SuiteSet.EventCode 
		----------------------------------------------------------------------------------------------------------
		LEFT JOIN (
				SELECT rb.EventCode, SUM(QtySeat) AS publicTicketQty, SUM(RevenueTotal) AS publicTicketAmt
				FROM #ReportBase rb  
				INNER JOIN #eventHeader eventHeaderEvent
					ON rb.EventCode  = eventHeaderEvent.EventCode   
				WHERE rb.TicketTypeCode IN ('PUBLIC', 'STUDENT')
					AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
				GROUP BY rb.EventCode
			) publicSet ON eventheader.EventCode = PublicSet.EventCode
		LEFT JOIN #budget budget
			ON budget.EventCode = eventHeader.EventCode 
		--------------- ------------------------------------------------------------------------

		--Result Set 

		SELECT x.*
			,ISNULL(YTD.VarianceYTD,0) AS VarianceYTD
			,ISNULL(YTD.BudgetYTD,0) AS BudgetYTD
			,ISNULL(YTD.ActualYTD,0) AS ActualYTD
			,VarToProj = CASE ISNULL(ytd.budgetYTD,0)  WHEN 0 THEN 0 ELSE ISNULL(YTD.varianceYTD,0) / ISNULL(ytd.budgetYTD,0) END
		FROM @singleSummary x
		JOIN (
				SELECT a.EventCode
					, SUM(ISNULL(b.VarianceToGoal,0))  AS varianceYTD
					, SUM(ISNULL(b.budgetedAmount,0)) AS budgetYTD
					, SUM(ISNULL(b.TotalRevenue,0)) AS actualYTD 
				FROM @singleSummary a
				JOIN @singleSummary b
					ON a.eventdate >= b.eventdate
				GROUP BY a.EventCode
			) AS YTD ON x.EventCode = YTD.EventCode
		ORDER BY x.eventDate
END

/*********************************************************************************************************************************
	FB16 - before TM conversion
*********************************************************************************************************************************/

IF @curSeason = '2016'
BEGIN


			
			SET @curSeason = CONCAT('F', RIGHT(@curSeason, 2))

			
			---- Build Report --------------------------------------------------------------------------------------------------

			--Report Base 



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
			WHERE   (@dateRange = 'AllData' 
					 AND rb.season = @curseason)
					OR (@dateRange <> 'AllData' 
						AND rb.season = @curSeason 
						AND rb.MINPAYMENTDATE 
							BETWEEN @startDate AND @endDate)

			------------------------------------------------------------------------------------------------------------------


			create table #homegames2016
			(event varchar(50)   )

			insert into #homegames2016
			(event)
			select 'F01'  union all 
			select 'F02'  union all 
			select 'F03'  union all 
			select 'F04'  union all 
			select 'F05'  union all 
			select 'F06'  


			create table #budget2016 
			(
			event varchar (10) 
			,amount float
			,quantity int
			)

			insert into #budget2016
			(event , amount, quantity)

			Select 'F01',0,0  UNION ALL
			Select 'F02',0,0 UNION ALL
			Select 'F03',0,0  UNION ALL
			Select 'F04',0,0  UNION ALL
			Select 'F05',0,0  UNION ALL
			Select 'F06',0,0  


			create table #EventHeader2016
			(
			eventCode varchar(50)  
			,eventName  varchar(200)
			,eventDate date
			)

			insert into #EventHeader2016
			(
			eventCode 
			,eventName
			,eventDate
			)
			select 
			 tkEvent.event 
			,tkEvent.name
			--,' ' EventDate

			,cast (date as date) EventDate
			from 
					TK_EVENT tkEvent with (nolock) 
					inner join #homegames2016 homegames 
							  on tkEvent.event   COLLATE SQL_Latin1_General_CP1_CS_AS
							   = homegames.event COLLATE SQL_Latin1_General_CP1_CS_AS 
			where tkEvent.season  =  @curSeason
			and tkEvent.name not like '%@%'

			----------------------------------------------------------------------------------------------------------



			--Single Game Breakout:

			--declare @singleSummary as SingleSummary
			--create table #singleSummary

			--( 

			-- eventCode varchar(100)

			--,eventName varchar(500)

			--,eventDate varchar(100)

			--,visitingTicketQty bigint 

			--,visitingTicketAmt numeric (18,2)

			--,studentTicketQty bigint 

			--,studentTicketAmt numeric (18,2)

			--,groupTicketQty bigint

			--,groupTicketAmt numeric (18,2)

			--,suiteTicketQty bigint

			--,suiteTicketAmt numeric (18,2) 

			--,publicTicketQty bigint

			--,publicTicketAmt numeric (18,2)

			--,budgetedQuantity bigint 

			--,budgetedAmount numeric (18,2)

			--,TotalTickets bigint 

			--,TotalRevenue numeric (18,2)

			--,PercentToGoal numeric (18,2)

			--,VarianceToGoal numeric (18,2)


			--)


			INSERT INTO  @singleSummary 
			(
			EventCode 
			,EventName 
			,EventDate 
			,VisitingTicketQty 
			,VisitingTicketAmt
			,StudentTicketQty 
			,StudentTicketAmt 
			,GroupTicketQty 
			,GroupTicketAmt 
			,SuiteTicketQty 
			,SuiteTicketAmt  
			,PublicTicketQty 
			,PublicTicketAmt 
			,BudgetedQuantity 
			,BudgetedAmount
			,TotalTickets  
			,TotalRevenue 
			,PercentToGoal 
			,VarianceToGoal 
			) 


			SELECT 
			 ISNULL(eventHeader.eventCode,'')
			,ISNULL(eventHeader.eventName,'')
			,ISNULL(eventHeader.eventDate,'')
			,ISNULL(vistingticketSet.visitingTicketQty,0)
			,ISNULL(vistingticketSet.visitingTicketAmt,0)
			,ISNULL(studentSet.studentTicketQty,0)
			,ISNULL(studentSet.studentTicketAmt,0)
			,ISNULL(groupSet.groupTicketQty,0)
			,ISNULL(groupSet.groupTicketAmt,0)
			,ISNULL(suiteSet.suiteTicketQty, 0)--,suiteSet.suiteTicketQty
			,ISNULL(suiteSet.suiteTicketAmt, 0)--,suiteSet.suiteTicketAmt
			,ISNULL(publicSet.publicTicketQty,0)
			,ISNULL(publicSet.publicTicketAmt,0)
			,ISNULL(budget.quantity,0) AS budgetedQuantity
			,ISNULL(budget.amount,0) AS budgetedAmount

			,ISNULL(vistingticketSet.visitingTicketQty,0) + 
					 ISNULL(studentSet.studentTicketQty,0) + ISNULL(groupSet.groupTicketQty,0)
				  + ISNULL(publicSet.publicTicketQty,0) + ISNULL(suiteSet.suiteTicketQty,0) AS TotalTickets
      
			,ISNULL(vistingticketSet.visitingTicketAmt,0) + 
					 ISNULL(studentSet.studentTicketAmt,0) + ISNULL(groupSet.groupTicketAmt,0)
				  + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0) AS TotalRevenue 
       
			,CASE WHEN budget.amount = 0 THEN 0 ELSE (ISNULL(vistingticketSet.visitingTicketAmt,0) + 
					 ISNULL(studentSet.studentTicketAmt,0) + ISNULL(groupSet.groupTicketAmt,0)
				  + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0))/ budget.amount END  AS PercentToGoal 
       
			,   (ISNULL(vistingticketSet.visitingTicketAmt,0) + 
					 ISNULL(studentSet.studentTicketAmt,0) + ISNULL(groupSet.groupTicketAmt,0)
				  + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0)) - budget.amount  AS VarianceToGoal

			FROM
			#EventHeader2016 eventHeader
			LEFT JOIN 
			(

			SELECT 
				   rb.ITEM 
			,SUM(ORDQTY) AS visitingTicketQty
			,SUM((ORDQTY * (CASE WHEN ITEM = 'F01' THEN 0 
								 WHEN ITEM = 'F02' AND E_PL = '11' THEN 75
								 WHEN ITEM = 'F02' AND E_PL = '13' THEN 50
								 WHEN ITEM = 'F03' THEN 65
								 WHEN ITEM = 'F04' THEN 65  
								 WHEN ITEM = 'F05' THEN 65
								 WHEN ITEM = 'F06' THEN 60 
								   END))) AS visitingTicketAmt


			FROM #ReportBase2016 rb  
					INNER JOIN #EventHeader2016 eventHeaderEvent  
					  ON rb.ITEM    
					   = eventHeaderEvent.eventCode  
			  WHERE ITEM LIKE 'F0[1-6]'
			  --AND rb.E_PL NOT IN   ('20', '18', '19', '16') -- premium price levels

			  AND rb.I_PT IN ('V')
			GROUP BY rb.ITEM 
			) vistingticketSet ON 
			eventheader.eventCode   
			 = vistingticketSet.ITEM   

			-------------------------------------------------------------------------------------------

			LEFT JOIN  
			(
			SELECT 
				   'F01'  AS ITEM 
				   ,0 AS studentTicketQty
				  ,0 AS studentTicketAmt
			) studentSet ON 
			eventheader.eventCode   
			 = studentSet.ITEM   
			------------------------------------------------------------------------------------------


			LEFT JOIN  
			(
			SELECT 
				   rb.ITEM 
			,SUM(ORDQTY) AS groupTicketQty
			,SUM(ORDTOTAL) AS groupTicketAmt
			FROM #ReportBase2016 rb  
					INNER JOIN #EventHeader2016 eventHeaderEvent  
							ON rb.ITEM   
							 = eventHeaderEvent.eventCode   
				WHERE ITEM LIKE 'F0[1-6]%'
				 AND rb.E_PL NOT IN  ('20', '18', '19', '16') -- premium price levels

				  AND rb.I_PT LIKE 'G%' --UPDATED FROM LAST YEAR 

				  AND rb.I_PRICE > 0
			AND ( rb.PAIDTOTAL > 0 )
			GROUP BY rb.ITEM 
			) GroupSet ON 
			eventheader.eventCode   
			= GroupSet.ITEM  

			------------------------------------------------------------------------------------------


			LEFT JOIN  
			(
			SELECT 
				   rb.ITEM 
			,SUM(ORDQTY) AS suiteTicketQty
			,SUM(ORDTOTAL) AS suiteTicketAmt
			FROM #ReportBase2016 rb  
					INNER JOIN #EventHeader2016 eventHeaderEvent  
							ON rb.ITEM   
							 = eventHeaderEvent.eventCode   
				WHERE ITEM LIKE 'F0[1-6]%'
				 AND rb.E_PL IN  ('20', '18', '19') -- premium price levels
				 AND rb.I_PRICE > 0
			AND ( rb.PAIDTOTAL > 0 )
			GROUP BY rb.ITEM 
			) SuiteSet ON 
			eventheader.eventCode   
			= SuiteSet.ITEM  

			----------------------------------------------------------------------------------------------------------


			LEFT JOIN  
			(
			SELECT 
				   rb.ITEM 
			,SUM(ORDQTY) AS publicTicketQty
			,SUM(ORDTOTAL) AS publicTicketAmt
			FROM #ReportBase2016 rb  
					INNER JOIN #EventHeader2016 eventHeaderEvent  
				   ON rb.ITEM  
				   = eventHeaderEvent.eventCode   
				WHERE ITEM LIKE 'F0[1-6]%'
				AND rb.E_PL NOT IN  ('20', '18', '19', '16') -- premium price levels 

				  AND rb.I_PT NOT LIKE 'G%' 
				  --and rb.I_PT NOT IN  ('S', 'STN', 'SSR')

				  AND rb.I_PT NOT IN  ('V')
				  AND rb.I_PRICE > 0
			AND ( rb.PAIDTOTAL > 0 )
			GROUP BY rb.ITEM 
			) publicSet 
			ON eventheader.eventCode  
			  = PublicSet.ITEM  

			LEFT JOIN #budget2016 budget
			ON budget.event  
			=  eventHeader.eventCode 

			---------------------------------------------------------------------------------------

			--Result Set 



			SELECT 
				x.*
				,ISNULL(YTD.VarianceYTD,0) AS VarianceYTD
				,ISNULL(YTD.BudgetYTD,0) AS BudgetYTD
				,ISNULL(YTD.ActualYTD,0) AS ActualYTD
				,VarToProj = CASE ISNULL(ytd.budgetYTD,0)  WHEN 0 THEN 0 ELSE ISNULL(YTD.varianceYTD,0) / ISNULL(ytd.budgetYTD,0) END
			FROM @singleSummary x
			JOIN
			(SELECT a.eventCode
			,SUM(ISNULL(b.VarianceToGoal,0))  AS varianceYTD
			,SUM(ISNULL(b.budgetedAmount,0)) AS budgetYTD
			,SUM(ISNULL(b.TotalRevenue,0)) AS actualYTD 
			FROM @singleSummary a
			JOIN @singleSummary b
			ON a.eventdate >= b.eventdate
			GROUP BY a.eventCode) AS YTD
			ON x.eventcode = YTD.eventcode

END


/*********************************************************************************************************************************
	FB15 - before TM conversion
*********************************************************************************************************************************/

IF @curSeason = '2015'
BEGIN

			SET @curSeason = CONCAT('F', RIGHT(@curSeason, 2))

			---- Build Report --------------------------------------------------------------------------------------------------

			--Report Base 

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
			WHERE   (@dateRange = 'AllData' 
					 AND rb.season = @curseason)
					OR (@dateRange <> 'AllData' 
						AND rb.season = @curSeason 
						AND rb.MINPAYMENTDATE 
							BETWEEN @startDate AND @endDate)

			------------------------------------------------------------------------------------------------------------------


			create table #HomeGame2015s
			(event varchar(50)   )

			insert into #HomeGame2015s
			(event)
			select 'F01'  union all 
			select 'F02'  union all 
			select 'F03'  union all 
			select 'F04'  union all 
			select 'F05'  union all 
			select 'F06'  union all 
			select 'F07'  


			create table #budget2015 
			(
			event varchar (10) 
			,amount float
			,quantity int
			)

			insert into #budget2015
			(event , amount, quantity)

			Select 'F01',50000,1500  UNION ALL
			Select 'F02',50000, 1500 UNION ALL
			Select 'F03',1334865, 15907  UNION ALL
			Select 'F04',468780, 6289  UNION ALL
			Select 'F05',1334865, 15907  UNION ALL
			Select 'F06',468780, 6289  UNION ALL
			Select 'F07',1334865, 15907


			create table #EventHeader2015
			(
			eventCode varchar(50)  
			,eventName  varchar(200)
			,eventDate date
			)

			insert into #EventHeader2015
			(
			eventCode 
			,eventName
			,eventDate
			)
			select 
			 tkEvent.event 
			,tkEvent.name
			--,' ' EventDate

			,cast (date as date) EventDate
			from 
					TK_EVENT tkEvent with (nolock) 
					inner join #HomeGame2015s homegames 
							  on tkEvent.event   COLLATE SQL_Latin1_General_CP1_CS_AS
							   = homegames.event COLLATE SQL_Latin1_General_CP1_CS_AS 
			where tkEvent.season  =  @curSeason
			and tkEvent.name not like '%@%'

			----------------------------------------------------------------------------------------------------------



			--Single Game Breakout:

			--declare @singleSummary as SingleSummary
			--create table #singleSummary

			--( 

			-- eventCode varchar(100)

			--,eventName varchar(500)

			--,eventDate varchar(100)

			--,visitingTicketQty bigint 

			--,visitingTicketAmt numeric (18,2)

			--,studentTicketQty bigint 

			--,studentTicketAmt numeric (18,2)

			--,groupTicketQty bigint

			--,groupTicketAmt numeric (18,2)

			--,suiteTicketQty bigint

			--,suiteTicketAmt numeric (18,2) 

			--,publicTicketQty bigint

			--,publicTicketAmt numeric (18,2)

			--,budgetedQuantity bigint 

			--,budgetedAmount numeric (18,2)

			--,TotalTickets bigint 

			--,TotalRevenue numeric (18,2)

			--,PercentToGoal numeric (18,2)

			--,VarianceToGoal numeric (18,2)


			--)


			INSERT INTO  @singleSummary 
			(
			EventCode 
			,EventName 
			,EventDate 
			,VisitingTicketQty 
			,VisitingTicketAmt
			,StudentTicketQty 
			,StudentTicketAmt 
			,GroupTicketQty 
			,GroupTicketAmt 
			,SuiteTicketQty 
			,SuiteTicketAmt  
			,PublicTicketQty 
			,PublicTicketAmt 
			,BudgetedQuantity 
			,BudgetedAmount
			,TotalTickets  
			,TotalRevenue 
			,PercentToGoal 
			,VarianceToGoal 
			) 


			SELECT 
			 ISNULL(eventHeader.eventCode,'')
			,ISNULL(eventHeader.eventName,'')
			,ISNULL(eventHeader.eventDate,'')
			,ISNULL(vistingticketSet.visitingTicketQty,0)
			,ISNULL(vistingticketSet.visitingTicketAmt,0)
			,ISNULL(studentSet.studentTicketQty,0)
			,ISNULL(studentSet.studentTicketAmt,0)
			,ISNULL(groupSet.groupTicketQty,0)
			,ISNULL(groupSet.groupTicketAmt,0)
			,ISNULL(suiteSet.suiteTicketQty,0)
			,ISNULL(suiteSet.suiteTicketAmt,0)

			,ISNULL(publicSet.publicTicketQty,0)
			,ISNULL(publicSet.publicTicketAmt,0)
			,ISNULL(budget.quantity,0) AS budgetedQuantity
			,ISNULL(budget.amount,0) AS budgetedAmount

			,ISNULL(vistingticketSet.visitingTicketQty,0) + 
					 ISNULL(studentSet.studentTicketQty,0) + ISNULL(groupSet.groupTicketQty,0)
				  + ISNULL(publicSet.publicTicketQty,0) + ISNULL(suiteSet.suiteTicketQty,0) AS TotalTickets
      
			,ISNULL(vistingticketSet.visitingTicketAmt,0) + 
					 ISNULL(studentSet.studentTicketAmt,0) + ISNULL(groupSet.groupTicketAmt,0)
				  + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0) AS TotalRevenue 
       
			,CASE WHEN budget.amount = 0 THEN 0 ELSE (ISNULL(vistingticketSet.visitingTicketAmt,0) + 
					 ISNULL(studentSet.studentTicketAmt,0) + ISNULL(groupSet.groupTicketAmt,0)
				  + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0))/ budget.amount END  AS PercentToGoal 
       
			,   (ISNULL(vistingticketSet.visitingTicketAmt,0) + 
					 ISNULL(studentSet.studentTicketAmt,0) + ISNULL(groupSet.groupTicketAmt,0)
				  + ISNULL(publicSet.publicTicketAmt,0) + ISNULL(suiteSet.suiteTicketAmt,0)) - budget.amount  AS VarianceToGoal

			FROM
			#EventHeader2015 eventHeader
			LEFT JOIN 
			(

			SELECT 
				   rb.ITEM 
			,SUM(ORDQTY) AS visitingTicketQty
			,SUM((ORDQTY * (CASE WHEN ITEM = 'F01' THEN 50 
								 WHEN ITEM = 'F02' THEN 50
								 WHEN ITEM = 'F03' THEN 55
								 WHEN ITEM = 'F04' THEN 50  
								 WHEN ITEM = 'F05' THEN 55
								 WHEN ITEM = 'F06' THEN 50 
								 WHEN ITEM = 'F07' THEN 55 
								   END))) AS visitingTicketAmt


			FROM #ReportBase2015 rb  
					INNER JOIN #EventHeader2015 eventHeaderEvent  
					  ON rb.ITEM    
					   = eventHeaderEvent.eventCode  
			  WHERE ITEM LIKE 'F0[1-7]'
			  AND rb.E_PL NOT IN  ('10', '11') -- deals with single game suites for now  

			  AND rb.I_PT IN ('V')
			GROUP BY rb.ITEM 
			) vistingticketSet ON 
			eventheader.eventCode   
			 = vistingticketSet.ITEM   

			-------------------------------------------------------------------------------------------

			LEFT JOIN  
			(
			SELECT 
				   'F01'  AS ITEM 
				   ,0 AS studentTicketQty
				  ,0 AS studentTicketAmt
			) studentSet ON 
			eventheader.eventCode   
			 = studentSet.ITEM   
			------------------------------------------------------------------------------------------


			LEFT JOIN  
			(
			SELECT 
				   rb.ITEM 
			,SUM(ORDQTY) AS groupTicketQty
			,SUM(ORDTOTAL) AS groupTicketAmt
			FROM #ReportBase2015 rb  
					INNER JOIN #EventHeader2015 eventHeaderEvent  
							ON rb.ITEM   
							 = eventHeaderEvent.eventCode   
				WHERE ITEM LIKE 'F0[1-7]%'
				 AND rb.E_PL NOT IN  ('10', '11') -- deals with single game suites for now 

				  AND rb.I_PT LIKE 'G%' --UPDATED FROM LAST YEAR 

				  AND rb.I_PRICE > 0
			AND ( rb.PAIDTOTAL > 0 )
			GROUP BY rb.ITEM 
			) GroupSet ON 
			eventheader.eventCode   
			= GroupSet.ITEM  

			------------------------------------------------------------------------------------------


			LEFT JOIN  
			(
			SELECT 
				   rb.ITEM 
			,SUM(ORDQTY) AS suiteTicketQty
			,SUM(ORDTOTAL) AS suiteTicketAmt
			FROM #ReportBase2015 rb  
					INNER JOIN #EventHeader2015 eventHeaderEvent  
							ON rb.ITEM   
							 = eventHeaderEvent.eventCode   
				WHERE ITEM LIKE 'F0[1-6]%'
				 AND rb.E_PL IN  ('11') -- premium price levels
				 AND rb.I_PRICE > 0
			AND ( rb.PAIDTOTAL > 0 )
			GROUP BY rb.ITEM 
			) SuiteSet ON 
			eventheader.eventCode   
			= SuiteSet.ITEM  

			----------------------------------------------------------------------------------------------------------


			LEFT JOIN  
			(
			SELECT 
				   rb.ITEM 
			,SUM(ORDQTY) AS publicTicketQty
			,SUM(ORDTOTAL) AS publicTicketAmt
			FROM #ReportBase2015 rb  
					INNER JOIN #EventHeader2015 eventHeaderEvent  
				   ON rb.ITEM  
				   = eventHeaderEvent.eventCode   
				WHERE ITEM LIKE 'F0[1-7]%'
				AND rb.E_PL NOT IN ('10', '11') -- deals with single game suites for now 

				  AND rb.I_PT NOT LIKE 'G%' 
				  --and rb.I_PT NOT IN  ('S', 'STN', 'SSR')

				  AND rb.I_PT NOT IN  ('V')
				  AND rb.I_PRICE > 0
			AND ( rb.PAIDTOTAL > 0 )
			GROUP BY rb.ITEM 
			) publicSet 
			ON eventheader.eventCode  
			  = PublicSet.ITEM  

			LEFT JOIN #budget2015 budget
			ON budget.event  
			=  eventHeader.eventCode 

			---------------------------------------------------------------------------------------

			--Result Set 



			SELECT 
				x.*
				,ISNULL(YTD.VarianceYTD,0) AS VarianceYTD
				,ISNULL(YTD.BudgetYTD,0) AS BudgetYTD
				,ISNULL(YTD.ActualYTD,0) AS ActualYTD
				,VarToProj = CASE ISNULL(ytd.budgetYTD,0)  WHEN 0 THEN 0 ELSE ISNULL(YTD.varianceYTD,0) / ISNULL(ytd.budgetYTD,0) END
			FROM @singleSummary x
			JOIN
			(SELECT a.eventCode
			,SUM(ISNULL(b.VarianceToGoal,0))  AS varianceYTD
			,SUM(ISNULL(b.budgetedAmount,0)) AS budgetYTD
			,SUM(ISNULL(b.TotalRevenue,0)) AS actualYTD 
			FROM @singleSummary a
			JOIN @singleSummary b
			ON a.eventdate >= b.eventdate
			GROUP BY a.eventCode) AS YTD
			ON x.eventcode = YTD.eventcode

END



END 
GO
