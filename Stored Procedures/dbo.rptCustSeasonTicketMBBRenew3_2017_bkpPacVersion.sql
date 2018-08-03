SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--exec [dbo].rptCustSeasonTicketMBBRenew3_2017 '3/21/2017', '4/21/2017', 'AllData'


CREATE PROCEDURE [dbo].[rptCustSeasonTicketMBBRenew3_2017_bkpPacVersion] 
    (
      @startDate DATE
    , @endDate DATE
    , @dateRange VARCHAR(20)
    )
AS 

/*
DROP TABLE #budget
DROP TABLE #eventHeader
DROP TABLE #homegames
DROP TABLE #ReportBase
DROP TABLE #singleSummary
*/

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	declare @curSeason varchar(15)

	Set @curSeason = 'BB17'

	--DECLARE	@dateRange VARCHAR(20)= 'AllData'
	--DECLARE @startDate DATE = DATEADD(month,-1,GETDATE())
	--DECLARE @endDate DATE = GETDATE()

	IF OBJECT_ID ('tempdb..#STAT_EXCLUDE')  is not null
		DROP TABLE #STAT_EXCLUDE
	CREATE TABLE #STAT_EXCLUDE (
		STAT VARCHAR(50)
	)
	INSERT INTO #STAT_EXCLUDE (
		STAT)
	SELECT '-' AS STAT UNION ALL
	SELECT 'N' UNION ALL
	SELECT 'K' UNION ALL
	SELECT 'B' UNION ALL
	SELECT 'V' UNION ALL
	SELECT 'P' UNION ALL
	SELECT 'R' UNION ALL
	SELECT 'I' UNION ALL
	SELECT 'C' UNION ALL
	SELECT 'F' UNION ALL
	SELECT 'X'

	---- Build Report --------------------------------------------------------------------------------------------------
	--Report Base 

	IF OBJECT_ID ('tempdb..#ReportBase')  is not null
		drop table #ReportBase

	Create table #ReportBase (
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

	INSERT INTO #ReportBase (
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
	 WHERE 
		(
			(@dateRange = 'AllData' 
				AND rb.season = @curseason)
			OR (@dateRange <> 'AllData' 
				AND rb.season = @curSeason 
				AND rb.MINPAYMENTDATE BETWEEN @startDate AND @endDate) 
		)
		--AND ITEM LIKE 'MB%'
	------------------------------------------------------------------------------------------------------------------

	IF OBJECT_ID ('tempdb..#homegames')  is not null
		drop table #homegames

	create table #homegames (
		event varchar(50)   
	)

	insert into #homegames (
		event
	)
	select 'MB01' union all 
	select 'MB02' union all 
	select 'MB03' union all 
	select 'MB04' union all 
	select 'MB05' union all 
	select 'MB06' union all 
	select 'MB07' union all
	select 'MB08' union all 
	select 'MB09' union all 
	select 'MB10' union all 
	select 'MB11' union all 
	select 'MB12' union all 
	select 'MB13' union all 
	select 'MB14' union all
	select 'MB15' union all 
	select 'MB16'  


	IF OBJECT_ID ('tempdb..#budget')  is not null
		drop table #budget

	create table #budget  (
		 event varchar (10) 
		,amount float
		,quantity int
	)

	insert into #budget (
		event , 
		amount, 
		quantity
	)
	select 'MB01','0','0'  union all 
	select 'MB02','0','0'   union all 
	select 'MB03','0','0'   union all 
	select 'MB04','0','0'   union all 
	select 'MB05','0','0'   union all 
	select 'MB06','0','0'   union all 
	select 'MB07','0','0'   union all 
	select 'MB08','0','0'   union all  
	select 'MB09','0','0'   union all 
	select 'MB10','0','0'   union all  
	select 'MB11','0','0'   union all  
	select 'MB12','0','0'   union all 
	select 'MB13','0','0'   union all  
	select 'MB14','0','0'   union all 
	select 'MB15','0','0'   union all 
	select 'MB16','0','0'   

	IF OBJECT_ID ('tempdb..#eventHeader')  is not null
		drop table #eventHeader

	create table #eventHeader (
		 eventCode varchar(50)  
		,eventName  varchar(200)
		,eventDate date
	)
	insert into #eventHeader (
 		 eventCode 
		,eventName
		,eventDate
	)
	select 
		 tkEvent.event 
		,tkEvent.name
		,cast(date as date) EventDate
	from dbo.TK_EVENT tkEvent with (nolock) 
	inner join #homegames homegames 
		on tkEvent.event  COLLATE SQL_Latin1_General_CP1_CS_AS = homegames.event COLLATE SQL_Latin1_General_CP1_CS_AS 
	where tkEvent.season =  @curSeason
		and tkEvent.name not like '%@%'

	----------------------------------------------------------------------------------------------------------

	IF OBJECT_ID ('tempdb..#singleSummary')  is not null
		drop table #singleSummary

	SELECT 
		 ISNULL(eventHeader.eventCode,'')                                                                                                eventCode 
		,ISNULL(eventHeader.eventName,'') 																								 eventName 
		,ISNULL(eventHeader.eventDate,'') 																								 eventDate
		,ISNULL(AvailSeatCount,0) 																										 AvailSeatCount 
		,ISNULL(vistingticketSet.visitingTicketQty,0)																					 visitingTicketQty 
		,ISNULL(vistingticketSet.visitingTicketAmt,0)																					 visitingTicketAmt
		,ISNULL(groupSet.groupTicketQty,0)																								 groupTicketQty 
		,ISNULL(groupSet.groupTicketAmt,0)																								 groupTicketAmt   
		,ISNULL(publicSet.publicTicketQty,0)																							 publicTicketQty 
		,ISNULL(publicSet.publicTicketAmt,0)																							 publicTicketAmt 
		,ISNULL(budget.quantity,0) AS budgetedQuantity																					 
		,ISNULL(budget.amount,0) AS budgetedAmount																						 
		,ISNULL(vistingticketSet.visitingTicketQty,0)  + ISNULL(groupSet.groupTicketQty,0) + ISNULL(publicSet.publicTicketQty,0) AS TotalTickets																		 
		,ISNULL(vistingticketSet.visitingTicketAmt,0)  + ISNULL(groupSet.groupTicketAmt,0) + ISNULL(publicSet.publicTicketAmt,0) AS TotalRevenue 
		,CASE WHEN budget.amount = 0 THEN 0 ELSE (ISNULL(vistingticketSet.visitingTicketAmt,0) +  ISNULL(groupSet.groupTicketAmt,0) + ISNULL(publicSet.publicTicketAmt,0))/ budget.amount END  AS PercentToGoal 
		,(ISNULL(vistingticketSet.visitingTicketAmt,0) +  ISNULL(groupSet.groupTicketAmt,0) + ISNULL(publicSet.publicTicketAmt,0)) - budget.amount  AS VarianceToGoal
	INTO #singleSummary
	FROM #eventHeader eventHeader
	LEFT JOIN  (
			SELECT 
				 rb.ITEM 
				,SUM(ORDQTY) AS visitingTicketQty
				,SUM(ORDTOTAL) AS visitingTicketAmt
			FROM #ReportBase rb  
			INNER JOIN #eventHeader eventHeaderEvent  
				ON  rb.ITEM  = eventHeaderEvent.eventCode  
			WHERE ITEM LIKE 'MB%'
				AND rb.I_PT IN ('V')
				AND rb.SEASON = @curSeason
				AND rb.I_PRICE > 0
			GROUP BY 
				rb.ITEM 
		) vistingticketSet 
		ON  eventheader.eventCode = vistingticketSet.ITEM    
	-------------------------------------------------------------------------------------------
	LEFT JOIN (
			SELECT 
				 rb.ITEM 
				,SUM(ORDQTY) AS groupTicketQty
				,SUM(ORDTOTAL) AS groupTicketAmt
			FROM #ReportBase rb  
			INNER JOIN #eventHeader eventHeaderEvent  
				ON  rb.ITEM  = eventHeaderEvent.eventCode  
			WHERE ITEM LIKE 'MB%'
				AND rb.I_PT LIKE 'G%'
				AND rb.SEASON = @curSeason
				AND rb.I_PRICE > 0
				AND ( rb.PAIDTOTAL > 0 )
			GROUP BY rb.ITEM 
		) GroupSet 
		ON  eventheader.eventCode  = GroupSet.ITEM 
	----------------------------------------------------------------------------------------------------------
	LEFT JOIN (
			SELECT 
				 rb.ITEM 
				,SUM(ORDQTY) AS publicTicketQty
				,SUM(ORDTOTAL) AS publicTicketAmt
			FROM #ReportBase rb  
			INNER JOIN #eventHeader eventHeaderEvent  
				ON  rb.ITEM  = eventHeaderEvent.eventCode  
			WHERE ITEM LIKE 'MB%'
				AND rb.I_PT NOT LIKE 'G%'
				AND rb.I_PT NOT LIKE 'V%'
				AND rb.SEASON = @curSeason
				AND rb.I_PRICE > 0
				AND ( rb.PAIDTOTAL > 0 )
			GROUP BY rb.ITEM 
		) publicSet 
		ON  eventheader.eventCode  = PublicSet.ITEM 
	LEFT JOIN #budget budget
		ON  budget.event =  eventHeader.eventCode
	---------------------------------------------------------------------------------------
	LEFT JOIN (
			SELECT 
				season, 
				event, 
				SUM(AvailSeatCount) AS AvailSeatCount 
			FROM  (
					SELECT   
						 tkSeatSeat.season
						,tkSeatSeat.event
						,COUNT(tkseatseat.seat) AS AvailSeatCount                                                         
					FROM dbo.TK_SEAT_SEAT tkSeatSeat
					INNER JOIN dbo.TK_SSTAT tkSstat 
						ON  tkSeatSeat.STAT COLLATE Latin1_General_CS_AS = tkSstat.SSTAT COLLATE Latin1_General_CS_AS 
						AND tkSeatSeat.Season = tkSstat.Season 
					LEFT OUTER JOIN #STAT_EXCLUDE exc
						ON  tkSeatSeat.Stat COLLATE SQL_Latin1_General_CP1_CS_AS = exc.Stat COLLATE SQL_Latin1_General_CP1_CS_AS
					WHERE  tkSeatSeat.SEASON = @curSeason
						AND PL <> '10' --students
						AND exc.Stat IS NULL
					GROUP BY 
						 tkSeatSeat.season
						,tkSeatSeat.event

				) a
			GROUP BY 
				season, 
				event
		) seatsavailable
		ON  eventHeader.eventCode = seatsavailable.EVENT COLLATE DATABASE_DEFAULT
	---------------------------------------------------------------------------------------

	--Result Set 
	SELECT 
		x.*
		,ISNULL(YTD.VarianceYTD,0) AS VarianceYTD
		,ISNULL(YTD.BudgetYTD,0) AS BudgetYTD
		,ISNULL(YTD.ActualYTD,0) AS ActualYTD
		,VarToProj = CASE ISNULL(ytd.budgetYTD,0)  WHEN 0 THEN 0 ELSE ISNULL(YTD.varianceYTD,0) / ISNULL(ytd.budgetYTD,0) END
	FROM #singleSummary x
	INNER JOIN (
			SELECT 
				 a.eventCode
				,SUM(ISNULL(b.VarianceToGoal,0))  AS varianceYTD
				,SUM(ISNULL(b.budgetedAmount,0)) AS budgetYTD
				,SUM(ISNULL(b.TotalRevenue,0)) AS actualYTD 
			FROM #singleSummary a
			INNER JOIN #singleSummary b
				ON  a.eventdate >= b.eventdate
			GROUP BY 
				a.eventCode
		) AS YTD
		ON  x.eventcode = YTD.eventcode
	ORDER BY eventDate, eventname

END 
GO
