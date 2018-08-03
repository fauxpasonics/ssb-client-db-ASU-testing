SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[rptCustSeasonTicketMBBRenew3] 
    (
      @startDate DATE
    , @endDate DATE
    , @dateRange VARCHAR(20)
	, @curSeason varchar(50)
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

declare @Sport varchar(50)

--Set @curSeason = '2018'
set @Sport = 'MBB'

	--DECLARE	@dateRange VARCHAR(20)= 'AllData'
	--DECLARE @startDate DATE = DATEADD(month,-12,GETDATE())
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

	Create table #ReportBase  
(
  SeasonYear int
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

INSERT INTO #ReportBase 
(
  SeasonYear 
 ,Sport 
 ,EventCode
 ,TicketTypeCode
 ,TicketTypeClass
 ,PC1
 ,PC3
 ,QtySeat  
 ,RevenueTotal  
 ,TransDateTime 
 ,PaidAmount 
 ,IsComp
) 

SELECT 
 SeasonYear 
 ,Sport 
 ,EventCode
 ,TicketTypeCode
 ,TicketTypeClass
 ,PC1
 ,PC3
 ,SUM(QtySeat) QtySeat  
 ,SUM(RevenueTotal) RevenueTotal  
 ,TransDateTime 
 ,SUM(PaidAmount)
 ,IsComp
FROM  [ro].[vw_FactTicketSalesBase] fts 
WHERE  DimSeasonId <> 97 --exclude Paciolan 2017 MBB data
--AND EventCode <> '17MBB18' --excluding event that should be deleted from 2017 season
AND  fts.Sport = @Sport
AND ((@dateRange = 'AllData' 
AND fts.SeasonYear = @curseason)
OR (@dateRange <> 'AllData' 
AND fts.SeasonYear = @curSeason 
AND fts.TransDateTime
BETWEEN @startDate AND @endDate))
		--AND ITEM LIKE 'MB%'
GROUP BY  SeasonYear 
 ,Sport 
 ,EventCode
 ,TicketTypeCode
 ,TicketTypeClass
 ,PC1
 ,PC3  
 ,TransDateTime 
 ,IsComp
	------------------------------------------------------------------------------------------------------------------

	IF OBJECT_ID ('tempdb..#homegames')  is not null
		drop table #homegames

	create table #homegames (
		EventCode varchar(50)   
	)

	insert into #homegames (
		EventCode
	)
	select CONCAT(RIGHT(@curSeason, 2),'MBB01')  union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB02')  union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB03')  union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB04')  union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB05')  union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB06')  union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB07')  union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB08')  union all  
	select CONCAT(RIGHT(@curSeason, 2),'MBB09')  union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB10')  union all  
	select CONCAT(RIGHT(@curSeason, 2),'MBB11')  union all  
	select CONCAT(RIGHT(@curSeason, 2),'MBB12')  union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB13')  union all  
	select CONCAT(RIGHT(@curSeason, 2),'MBB14')  union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB15')  union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB16')  union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB17')  


	IF OBJECT_ID ('tempdb..#budget')  is not null
		drop table #budget

	create table #budget  (
		 EventCode varchar (10) 
		,amount float
		,quantity int
	)

	insert into #budget (
		EventCode , 
		amount, 
		quantity
	)
	select CONCAT(RIGHT(@curSeason, 2),'MBB01'),'0','0'  union all -- Update these values when ASU can provide them
	select CONCAT(RIGHT(@curSeason, 2),'MBB02'),'0','0'   union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB03'),'0','0'   union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB04'),'0','0'   union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB05'),'0','0'   union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB06'),'0','0'   union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB07'),'0','0'   union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB08'),'0','0'   union all  
	select CONCAT(RIGHT(@curSeason, 2),'MBB09'),'0','0'   union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB10'),'0','0'   union all  
	select CONCAT(RIGHT(@curSeason, 2),'MBB11'),'0','0'   union all  
	select CONCAT(RIGHT(@curSeason, 2),'MBB12'),'0','0'   union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB13'),'0','0'   union all  
	select CONCAT(RIGHT(@curSeason, 2),'MBB14'),'0','0'   union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB15'),'0','0'   union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB16'),'0','0'   union all 
	select CONCAT(RIGHT(@curSeason, 2),'MBB17'),'0','0'	

	IF OBJECT_ID ('tempdb..#eventHeader')  is not null
		drop table #eventHeader

	create table #eventHeader (
		 EventCode varchar(50)  
		,EventName  varchar(200)
		,EventDate date
	)
	insert into #eventHeader (
 		 eventCode 
		,eventName
		,eventDate
	) 
	select DISTINCT
		 fts.EventCode AS eventCode
		,fts.EventName
		,cast(fts.EventDate as date) EventDate
	FROM ro.vw_FactTicketSalesBase fts
	inner join #homegames homegames 
		on fts.EventCode = homegames.EventCode 
	where fts.SeasonYear =  @curSeason
		and fts.Sport = @Sport
		AND DimSeasonId <> 97 --exclude Paciolan 2017 MBB data
		--AND fts.EventCode <> '17MBB18' --excluding event that should be deleted from 2017 season
	ORDER BY fts.eventCode

	----------------------------------------------------------------------------------------------------------

IF OBJECT_ID ('tempdb..#singleSummary')  is not null
		drop table #singleSummary

	SELECT 
		 ISNULL(eventHeader.eventCode,'')                                                                                                eventCode 
		,ISNULL(eventHeader.eventName,'') 																								 eventName 
		,ISNULL(eventHeader.eventDate,'') 																								 eventDate
		, '0' AvailSeatCount
		--,ISNULL(AvailSeatCount,0) 																										 AvailSeatCount 
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
LEFT JOIN 
(

SELECT 
rb.EventCode 
,SUM(QtySeat) AS visitingTicketQty
,SUM(RevenueTotal) AS visitingTicketAmt

FROM #ReportBase rb  
        INNER JOIN #eventHeader eventHeaderEvent  
          ON rb.EventCode  = eventHeaderEvent.eventCode  
WHERE TicketTypeCode = 'VISIT'
AND IsComp = 0
GROUP BY rb.EventCode
) vistingticketSet ON 
eventheader.eventCode   
 = vistingticketSet.EventCode   


-------------------------------------------------------------------------------------------
	LEFT JOIN  
	(
			SELECT 
				 rb.EventCode
				,SUM(QtySeat)      AS groupTicketQty
				,SUM(RevenueTotal) AS groupTicketAmt
			FROM #ReportBase rb  
			INNER JOIN #eventHeader eventHeaderEvent
				ON rb.EventCode  = eventHeaderEvent.EventCode   
			WHERE rb.TicketTypeCode = 'GROUP' 
				 AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
				 AND IsComp = 0
			GROUP BY rb.EventCode 
	) GroupSet ON 
	eventheader.EventCode = GroupSet.EventCode

----------------------------------------------------------------------------------------------------------
	LEFT JOIN  
	(
			SELECT 
				 rb.EventCode
				,SUM(QtySeat)      AS publicTicketQty
				,SUM(RevenueTotal) AS publicTicketAmt
			FROM #ReportBase rb  
			INNER JOIN #eventHeader eventHeaderEvent
				ON rb.EventCode  = eventHeaderEvent.EventCode   
			WHERE rb.TicketTypeCode = 'PUBLIC' 
				 AND (PaidAmount > 0 OR PC3 = 'Z') --Sponsor Tickets
				 AND IsComp = 0
			GROUP BY rb.EventCode
	) publicSet 
	ON eventheader.EventCode = PublicSet.EventCode

	LEFT JOIN #budget budget
	ON budget.EventCode  =  eventHeader.EventCode 
	---------------------------------------------------------------------------------------
	/*LEFT JOIN (
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
		ON  eventHeader.eventCode = seatsavailable.EVENT COLLATE DATABASE_DEFAULT*/
	---------------------------------------------------------------------------------------

	--Result Set 
	SELECT 
		x.*
		,ISNULL(YTD.VarianceYTD,0) AS VarianceYTD
		,ISNULL(YTD.BudgetYTD,0) AS BudgetYTD
		,ISNULL(YTD.ActualYTD,0) AS ActualYTD
		,VarToProj = CASE ISNULL(ytd.budgetYTD,0)  WHEN 0 THEN 0 ELSE ISNULL(YTD.varianceYTD,0) / ISNULL(ytd.budgetYTD,0) END
	FROM #singleSummary x
	JOIN
	(SELECT a.eventCode
	,SUM(ISNULL(b.VarianceToGoal,0))  AS varianceYTD
	,SUM(ISNULL(b.budgetedAmount,0)) AS budgetYTD
	,SUM(ISNULL(b.TotalRevenue,0)) AS actualYTD 
	FROM #singleSummary a
	JOIN #singleSummary b
	ON a.eventdate >= b.eventdate
	GROUP BY a.eventCode) AS YTD
	ON x.eventcode = YTD.eventcode
	ORDER BY EventDate ASC

END 
GO
