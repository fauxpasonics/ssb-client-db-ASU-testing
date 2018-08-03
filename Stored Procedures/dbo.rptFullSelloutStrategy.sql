SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Created By: Payton Soicher
-- Create Date: 2018-07-11
-- Reviewed By: Abbey Meitin 
-- Reviewed Date: 2018-07-15
 --Description: New Sellout Strategy that will be dynamic for all Sports
 --=============================================

 --exec [dbo].[rptFullSelloutStrategy] '2017','Football'
CREATE   PROC [dbo].[rptFullSelloutStrategy] @SeasonYear nvarchar(15), @Sport nvarchar(50)
AS
BEGIN
    
--DECLARE @SeasonYear varchar(15) = '2018'
--DECLARE @Sport varchar(50) = 'Football'

DECLARE @Season NVARCHAR(255) = @SeasonYear+' '+@Sport  --'2018 Football'

--  ==================================================================
--  7/13/2018 3:39 PM
--  Payton Soicher
--  Subject: Distributed Tickets: Looks at comp and non comp tickets
--			that have been sold 
--  ==================================================================

	IF OBJECT_ID('tempdb..#DistributedTickets','U') IS NOT NULL
		DROP TABLE #DistributedTickets
	IF OBJECT_ID('tempdb..#Budget','U') IS NOT NULL
		DROP TABLE #Budget

	SELECT *
	INTO #DistributedTickets
	FROM (

	SELECT src.SeasonHeaderName
	, 'Total Distributed' AS Section
	, 'Sold Tickets' AS SubSection1
	,  CASE WHEN src.TicketTypeClass = 'Season Ticket' THEN 'Full Season' 
			WHEN src.TicketTypeClass = 'Single' THEN 'Single Game'
			ELSE src.TicketTypeClass END AS TicketTypeClass
	 , src.TicketTypeDesc
	 , src.EventHeaderName
	 , src.EventDate
	 , src.PriceCodeDesc
	 , src.SeatCount
	 , src.TotalRevenue 
	FROM (
	SELECT f.SeasonHeaderName, f.TicketTypeClass, tt.TicketTypeDesc, f.EventHeaderName, f.EventDate
	--, f.PriceCodeDesc
	, CASE WHEN f.TicketTypeClass = 'Partial Plan' THEN PlanName ELSE PriceCode + ':' + PriceCodeDesc  END AS PriceCodeDesc
	, SUM(f.QtySeat) AS SeatCount, SUM(f.RevenueTotal) AS TotalRevenue
	FROM ro.vw_FactTicketSalesBase_All f
	JOIN ro.vw_DimTicketType tt ON tt.DimTicketTypeId = f.DimTicketTypeId
	where f.SeasonHeaderName = @Season--'2017 Football'
	AND f.IsComp = 0
	AND f.EventHeaderName IS NOT NULL
	GROUP BY CASE WHEN f.TicketTypeClass = 'Partial Plan' THEN PlanName
		   ELSE PriceCode + ':' + PriceCodeDesc
		   END
		   , f.SeasonHeaderName
		   , f.TicketTypeClass
		   , tt.TicketTypeDesc
		   , f.EventHeaderName
		   , f.EventDate
		   ) src
	--ORDER BY 3, 4


	UNION all

	SELECT src.SeasonHeaderName
	, 'Total Distributed' AS Section
	, 'Comp Tickets' AS SubSection1
	,  CASE WHEN src.TicketTypeClass = 'Season Ticket' THEN 'Full Season Comps' 
			WHEN src.TicketTypeClass = 'Single' THEN 'Single Game Comps'
			ELSE src.TicketTypeClass+' Comps' END AS TicketTypeClass
	 , src.TicketTypeDesc+' Comps' TicketTypeDesc
	 , src.EventHeaderName
	 , src.EventDate
	 , src.PriceCodeDesc
	 , src.SeatCount
	 , src.TotalRevenue 
	FROM (
	SELECT f.SeasonHeaderName, f.TicketTypeClass, tt.TicketTypeDesc, f.EventHeaderName, f.EventDate
	--, f.PriceCodeDesc
	, CASE WHEN f.TicketTypeClass = 'Partial Plan' THEN PlanName ELSE PriceCode + ':' + PriceCodeDesc  END AS PriceCodeDesc
	, SUM(f.QtySeat) AS SeatCount, SUM(f.RevenueTotal) AS TotalRevenue
	FROM ro.vw_FactTicketSalesBase_All f
	JOIN ro.vw_DimTicketType tt ON tt.DimTicketTypeId = f.DimTicketTypeId
	where f.SeasonHeaderName = @Season--'2017 Football'
	AND f.IsComp = 1
	AND f.EventHeaderName IS NOT NULL
	GROUP BY CASE WHEN f.TicketTypeClass = 'Partial Plan' THEN PlanName
		   ELSE PriceCode + ':' + PriceCodeDesc
		   END
		   , f.SeasonHeaderName
		   , f.TicketTypeClass
		   , tt.TicketTypeDesc
		   , f.EventHeaderName
		   , f.EventDate
		   ) src
	--ORDER BY 3, 4
	) d


	-- Use the plan code logic below
	-- Include the season header as well
	--SELECT * 
	--FROM #DistributedTickets
	--ORDER BY 1,2 ,3 DESC, 4


	--  ==================================================================
	--  7/6/2018 12:00 PM
	--  Payton Soicher
	--  Subject: Open Seats and Hold Seats
	--  ==================================================================

	-- Held seats should have a "seat status"
	-- So held seats that are open, reserved, a, b, c, etc.

	-- Capacity: 53,069 (Fixed for each game)
	-- 
	-- Custom_Int_1 will be the capacity of the stadium




	IF OBJECT_ID('tempdb..#RemainingInventory','U') IS NOT NULL
		DROP TABLE #RemainingInventory

	SELECT *
	INTO #RemainingInventory
	FROM (

	SELECT r.SeasonName, 'Remaining Inventory' AS Section,'Open Seats' AS SubSection1,
	r.TicketTypeClass,
	r.TicketTypeDesc,
	r.EventHeaderName,
	r.EventDate,
	r.PriceCodeDesc,
	r.SeatCount,
	r.TotalRevenue
	FROM (
	SELECT ds.SeasonName, 'Open Seats' AS TicketTypeClass, f.TM_sell_type AS TicketTypeDesc --dtt.TicketTypeClass, dtt.TicketTypeDesc
	, h.EventName AS EventHeaderName, de.EventDate, dpc.PriceCodeDesc, SUM(f.QtySeat) AS SeatCount, SUM(f.Total) AS TotalRevenue
	FROM ro.vw_FactAvailSeats f
	JOIN ro.vw_DimTicketType dtt ON dtt.DimTicketTypeId = f.DimTicketTypeId
	JOIN ro.vw_DimSeason ds ON ds.DimSeasonId = f.DimSeasonId
	JOIN ro.vw_DimEvent de ON de.DimEventId = f.DimEventId
	JOIN ro.vw_DimEventHeader h ON h.DimEventHeaderId = de.DimEventHeaderId
	JOIN ro.vw_DimPriceCode dpc ON dpc.DimPriceCodeId = f.DimPriceCodeId
	WHERE ds.SeasonName = @Season--'2018 Football'
	AND h.EventName <> 'Season Test'
	AND f.TM_sell_type = 'OPEN'
	GROUP BY ds.SeasonName
		   , h.EventName
		   , de.EventDate
		   , dpc.PriceCodeDesc
		   , f.TM_sell_type
		) r

	UNION ALL	

	SELECT o.SeasonName
	,'Remaining Inventory', 'Held Seats', 
	o.TicketTypeClass,
	o.TicketTypeDesc,
	o.EventHeaderName,
	o.EventDate,
	o.PriceCodeDesc,
	o.SeatCount,
	o.TotalRevenue
	FROM (
	SELECT ds.SeasonName, 'Held Seats' AS TicketTypeClass, f.TM_sell_type AS TicketTypeDesc --dtt.TicketTypeClass, dtt.TicketTypeDesc
	, h.EventName AS EventHeaderName, de.EventDate, dpc.PriceCodeDesc, SUM(f.QtySeat) AS SeatCount, SUM(f.Total) AS TotalRevenue
	FROM ro.vw_FactAvailSeats f
	JOIN ro.vw_DimTicketType dtt ON dtt.DimTicketTypeId = f.DimTicketTypeId
	JOIN ro.vw_DimSeason ds ON ds.DimSeasonId = f.DimSeasonId
	JOIN ro.vw_DimEvent de ON de.DimEventId = f.DimEventId
	JOIN ro.vw_DimEventHeader h ON h.DimEventHeaderId = de.DimEventHeaderId
	JOIN ro.vw_DimPriceCode dpc ON dpc.DimPriceCodeId = f.DimPriceCodeId
	WHERE ds.SeasonName = @Season--'2018 Football'
	AND h.EventName <> 'Season Test'
	AND f.TM_sell_type <> 'OPEN'
	GROUP BY ds.SeasonName
		   , h.EventName
		   , de.EventDate
		   , dpc.PriceCodeDesc
		   , f.TM_sell_type

	UNION ALL

	SELECT ds.SeasonName,  'Held Seats' AS TicketTypeClass,'Held Seats' AS TicketTypeDesc--dtt.TicketTypeClass, dtt.TicketTypeDesc
	, h.EventName AS EventHeaderName, de.EventDate, dpc.PriceCodeDesc, SUM(f.QtySeat) AS SeatCount, SUM(f.Total) AS TotalRevenue
	FROM ro.vw_FactHeldSeats f
	JOIN ro.vw_DimTicketType dtt ON dtt.DimTicketTypeId = f.DimTicketTypeId
	JOIN ro.vw_DimSeason ds ON ds.DimSeasonId = f.DimSeasonId
	JOIN ro.vw_DimEvent de ON de.DimEventId = f.DimEventId
	JOIN ro.vw_DimEventHeader h ON h.DimEventHeaderId = de.DimEventHeaderId
	JOIN ro.vw_DimPriceCode dpc ON dpc.DimPriceCodeId = f.DimPriceCodeId
	WHERE ds.SeasonName = @Season --'2018 Football'
	AND h.EventName <> 'Season Test'
	GROUP BY ds.SeasonName,
			 h.EventName,
			 de.EventDate,
			 dpc.PriceCodeDesc
		) o	

		) r

	--  ==================================================================
	--  7/6/2018 12:17 PM
	--  Payton Soicher
	--  Subject: Sales Velocity
	-- Shows the sales for the following :
	/*
		Last 7 Days
		Last 14 days
		Last 30 days
		Sale Date
		First 7 days after sale date
	
	
	*/
	--  ==================================================================


	
	IF OBJECT_ID('tempdb..#SalesVelocity','U') IS NOT NULL
		DROP TABLE #SalesVelocity

	SELECT *
	INTO #SalesVelocity
	FROM (

	SELECT e.SeasonHeaderName
		, 'RecentSales Velocity' AS Section
		, 'RecentSales Velocity' AS SubSection1
		 , 'RecentSales Velocity' TicketTypeClass --last7.TicketTypeClass
		, 'Last 7 Days' TicketTypeDesc-- last7.TicketTypeDesc
		 , e.EventHeaderName
		 , e.EventDate
		 , NULL AS PriceCodeDesc--last7.PriceCodeDesc
		 , case when last7.SeatCount	is null then 0 else last7.SeatCount		end as SeatCount	
		 , case when last7.TotalRevenue	is null then 0 else last7.TotalRevenue	end as TotalRevenue	
	FROM (
	SELECT DISTINCT f.SeasonHeaderName, f.EventHeaderName, f.EventDate
	FROM ro.vw_FactTicketSalesBase_All f
	JOIN ro.vw_DimTicketType tt ON tt.DimTicketTypeId = f.DimTicketTypeId
	where f.SeasonName = @Season--'2017 Football'
	--AND f.IsComp = 0
	AND f.EventHeaderName IS NOT NULL ) e
	LEFT JOIN
	(
	SELECT 'Recent Sales Velocity' AS TicketTypeClass, 'Last 7 Days' TicketTypeDesc, f.EventHeaderName, f.EventDate, NULL PriceCodeDesc, SUM(f.QtySeat) AS SeatCount, SUM(f.RevenueTotal) AS TotalRevenue
	FROM ro.vw_FactTicketSalesBase_All f
	JOIN ro.vw_DimTicketType tt ON tt.DimTicketTypeId = f.DimTicketTypeId
	where f.SeasonName = @Season--'2017 Football'
	--AND f.IsComp = 0
	AND f.EventHeaderName IS NOT NULL
	AND f.OrderDate >= DATEADD(DAY, -7, GETDATE())
	GROUP BY f.EventHeaderName,
			 f.EventDate
	) last7 ON last7.EventHeaderName = e.EventHeaderName

	UNION all

	SELECT e.SeasonHeaderName
		, 'RecentSales Velocity' AS Section
		, 'RecentSales Velocity' AS SubSection1
		 , 'RecentSales Velocity' TicketTypeClass --last7.TicketTypeClass
		, 'Last 14 Days' TicketTypeDesc-- last7.TicketTypeDesc
		 , e.EventHeaderName
		 , e.EventDate
		 , NULL AS PriceCodeDesc--last7.PriceCodeDesc
		 , case when last14.SeatCount	is null then 0 else last14.SeatCount		end as SeatCount	
		 , case when last14.TotalRevenue	is null then 0 else last14.TotalRevenue	end as TotalRevenue	
	FROM (
	SELECT DISTINCT SeasonHeaderName, f.EventHeaderName, f.EventDate
	FROM ro.vw_FactTicketSalesBase_All f
	JOIN ro.vw_DimTicketType tt ON tt.DimTicketTypeId = f.DimTicketTypeId
	where f.SeasonName = @Season--'2017 Football'
	--AND f.IsComp = 0
	AND f.EventHeaderName IS NOT NULL ) e
	LEFT JOIN
	(
	SELECT 'Recent Sales Velocity' AS TicketTypeClass, 'Last 14 Days' TicketTypeDesc, f.EventHeaderName, f.EventDate, NULL PriceCodeDesc, SUM(f.QtySeat) AS SeatCount, SUM(f.RevenueTotal) AS TotalRevenue
	FROM ro.vw_FactTicketSalesBase_All f
	JOIN ro.vw_DimTicketType tt ON tt.DimTicketTypeId = f.DimTicketTypeId
	where f.SeasonName = @Season--'2018 Football'
	--AND f.IsComp = 0
	AND f.EventHeaderName IS NOT NULL
	AND f.OrderDate >= DATEADD(DAY, -14, GETDATE())
	GROUP BY f.EventHeaderName
		   , f.EventDate
	) last14 ON last14.EventHeaderName = e.EventHeaderName

	UNION all

	SELECT e.SeasonHeaderName
		, 'RecentSales Velocity' AS Section
		, 'RecentSales Velocity' AS SubSection1
		 , 'RecentSales Velocity' TicketTypeClass --last7.TicketTypeClass
		, 'Last 30 Days' TicketTypeDesc-- last7.TicketTypeDesc
		 , e.EventHeaderName
		 , e.EventDate
		 , NULL AS PriceCodeDesc--last7.PriceCodeDesc
		 , case when last30.SeatCount	is null then 0 else last30.SeatCount		end as SeatCount	
		 , case when last30.TotalRevenue	is null then 0 else last30.TotalRevenue	end as TotalRevenue	
	FROM (
	SELECT DISTINCT SeasonHeaderName, f.EventHeaderName, f.EventDate
	FROM ro.vw_FactTicketSalesBase_All f
	JOIN ro.vw_DimTicketType tt ON tt.DimTicketTypeId = f.DimTicketTypeId
	where f.SeasonName = @Season--'2017 Football'
	--AND f.IsComp = 0
	AND f.EventHeaderName IS NOT NULL ) e
	LEFT JOIN
	(
	SELECT 'Recent Sales Velocity' AS TicketTypeClass, 'Last 30 Days' TicketTypeDesc, f.EventHeaderName, f.EventDate, NULL PriceCodeDesc, SUM(f.QtySeat) AS SeatCount, SUM(f.RevenueTotal) AS TotalRevenue
	FROM ro.vw_FactTicketSalesBase_All f
	JOIN ro.vw_DimTicketType tt ON tt.DimTicketTypeId = f.DimTicketTypeId
	where f.SeasonName = @Season--'2018 Football'
	--AND f.IsComp = 0
	AND f.EventHeaderName IS NOT NULL
	AND f.OrderDate >= DATEADD(DAY, -30, GETDATE())
	GROUP BY f.EventHeaderName
		   , f.EventDate
	) last30 ON last30.EventHeaderName = e.EventHeaderName

	UNION ALL	

	SELECT e.SeasonHeaderName
		, 'RecentSales Velocity' AS Section
		, 'RecentSales Velocity' AS SubSection1
		 , 'RecentSales Velocity' TicketTypeClass --last7.TicketTypeClass
		, 'Sale Date' TicketTypeDesc-- last7.TicketTypeDesc
		 , e.EventHeaderName
		 , e.EventDate
		 --, CAST(saleDate.SaleDate AS NVARCHAR(255)) AS PriceCodeDesc--last7.PriceCodeDesc
		 , e.SaleDate PriceCodeDesc
		 , case when saleDate.SeatCount	is null then 0 else saleDate.SeatCount		end as SeatCount	
		 , case when saleDate.TotalRevenue	is null then 0 else saleDate.TotalRevenue	end as TotalRevenue	
	FROM (
		SELECT s.SeasonName AS SeasonHeaderName, e.EventName AS EventHeaderName, e.EventDate, e.Custom_DateTime_1 SaleDate
        FROM dbo.DimEventHeader_V2 e
		JOIN dbo.DimSeasonHeader_V2 s ON s.DimSeasonHeaderId = e.DimSeasonHeaderId
		WHERE s.SeasonName =  @Season
		AND e.EventName <> 'Season Test') e
	LEFT JOIN
	(
	SELECT 'Recent Sales Velocity' AS TicketTypeClass, h.Custom_Int_1 SaleDate, f.EventHeaderName, f.EventDate, NULL PriceCodeDesc, SUM(f.QtySeat) AS SeatCount, SUM(f.RevenueTotal) AS TotalRevenue
	FROM ro.vw_FactTicketSalesBase_All f
	JOIN ro.vw_DimTicketType tt ON tt.DimTicketTypeId = f.DimTicketTypeId
	JOIN ro.vw_DimEventHeader h ON f.EventHeaderName = h.EventName
	where f.SeasonName = @Season--'2018 Football'
	--AND f.IsComp = 0
	AND f.EventHeaderName IS NOT NULL
	AND f.OrderDate = h.Custom_DateTime_1 -- Sale Date
	GROUP BY h.Custom_Int_1
		   , f.EventHeaderName
		   , f.EventDate
	) saleDate ON saleDate.EventHeaderName = e.EventHeaderName

	UNION all

	SELECT e.SeasonHeaderName
		, 'RecentSales Velocity' AS Section
		, 'RecentSales Velocity' AS SubSection1
		 , 'RecentSales Velocity' TicketTypeClass --last7.TicketTypeClass
		, 'First 7 Days' TicketTypeDesc-- last7.TicketTypeDesc
		 , e.EventHeaderName
		 , e.EventDate
		 --, CAST(e.SaleDate AS nvarchar(255)) AS PriceCodeDesc--last7.PriceCodeDesc
		 , NULL PriceCodeDesc
		 , case when first7.SeatCount	is null then 0 else first7.SeatCount		end as SeatCount	
		 , case when first7.TotalRevenue	is null then 0 else first7.TotalRevenue	end as TotalRevenue	
	FROM (
		SELECT s.SeasonName AS SeasonHeaderName, e.EventName AS EventHeaderName, e.EventDate, e.Custom_DateTime_1 SaleDate
        FROM dbo.DimEventHeader_V2 e
		JOIN dbo.DimSeasonHeader_V2 s ON s.DimSeasonHeaderId = e.DimSeasonHeaderId
		WHERE s.SeasonName =  @Season
		AND e.EventName <> 'Season Test') e
	LEFT JOIN
	(
	SELECT 'Recent Sales Velocity' AS TicketTypeClass, h.Custom_DateTime_1 SaleDate, f.EventHeaderName, f.EventDate, NULL PriceCodeDesc, SUM(f.QtySeat) AS SeatCount, SUM(f.RevenueTotal) AS TotalRevenue
	FROM ro.vw_FactTicketSalesBase_All f
	JOIN ro.vw_DimTicketType tt ON tt.DimTicketTypeId = f.DimTicketTypeId
	JOIN ro.vw_DimEventHeader h ON f.EventHeaderName = h.EventName
	where f.SeasonName = @Season--'2018 Football'
	--AND f.IsComp = 0
	AND f.EventHeaderName IS NOT NULL
	AND f.OrderDate BETWEEN h.Custom_DateTime_1 AND DATEADD(DAY, 7, h.Custom_DateTime_1) -- Between sale date and the next 7 days after
	GROUP BY h.Custom_DateTime_1
		   , f.EventHeaderName
		   , f.EventDate
	) first7 ON first7.EventHeaderName = e.EventHeaderName


	) vel



	--  ==================================================================
	--  7/6/2018 12:31 PM
	--  Payton Soicher
	--  Subject: Budget
	--  ==================================================================


	IF OBJECT_ID('tempdb..#BudgetBase','U') IS NOT NULL
		DROP TABLE #BudgetBase
    
	IF OBJECT_ID('tempdb..#Budget','U') IS NOT NULL
		DROP TABLE #Budget

	SELECT d.EventHeaderName
		 , d.SoldSeats
		 , d.TotalRevenue
		 , s.BudgetSeats
		 , s.BudgetRevenue
	INTO #BudgetBase
	FROM (
	SELECT EventHeaderName, SUM(SeatCount) AS SoldSeats, SUM(TotalRevenue) AS TotalRevenue
    FROM #DistributedTickets
	GROUP BY EventHeaderName ) d
	JOIN
    (
		SELECT e.EventName AS EventHeaderName, e.Custom_Int_1 AS BudgetSeats, e.Custom_Int_2 AS BudgetRevenue
        FROM dbo.DimEventHeader_V2 e
		JOIN dbo.DimSeasonHeader_V2 s ON s.DimSeasonHeaderId = e.DimSeasonHeaderId
		WHERE s.SeasonName = @Season
	) s ON s.EventHeaderName = d.EventHeaderName



	SELECT *
    INTO #Budget
	FROM (
	SELECT e.SeasonHeaderName
		, 'Budget' AS Section
		, 'Budget' AS SubSection1
		 , 'Budget' TicketTypeClass --last7.TicketTypeClass
		, 'Budget % Sold' TicketTypeDesc-- last7.TicketTypeDesc
		 , e.EventHeaderName
		 , e.EventDate
		 , NULL AS PriceCodeDesc--last7.PriceCodeDesc
		 , case when bb.BudgetSeats	is null then 0 ELSE bb.SoldSeats / CAST(bb.BudgetSeats AS FLOAT)  	end as SeatCount	
		 , case when bb.BudgetRevenue	is null then 0 ELSE  bb.TotalRevenue / CAST(bb.BudgetRevenue AS FLOAT) 	end as TotalRevenue	  	
	FROM (
	SELECT DISTINCT SeasonHeaderName, f.EventHeaderName, f.EventDate
	FROM ro.vw_FactTicketSalesBase_All f
	JOIN ro.vw_DimTicketType tt ON tt.DimTicketTypeId = f.DimTicketTypeId
	where f.SeasonName = @Season--'2017 Football'
	--AND f.IsComp = 0
	AND f.EventHeaderName IS NOT NULL ) e
	LEFT JOIN #BudgetBase bb ON bb.EventHeaderName = e.EventHeaderName

	UNION ALL


    
		SELECT e.SeasonHeaderName
		, 'Budget' AS Section
		, 'Budget' AS SubSection1
		 , 'Budget' TicketTypeClass --last7.TicketTypeClass
		, 'Avg Price' TicketTypeDesc-- last7.TicketTypeDesc
		 , e.EventHeaderName
		 , e.EventDate
		 , NULL AS PriceCodeDesc--last7.PriceCodeDesc
		 , case when bb.TotalRevenue IS null then 0 else bb.TotalRevenue / CAST(bb.SoldSeats AS FLOAT)	end as SeatCount	
		 , case when bb.TotalRevenue IS null then 0 else bb.TotalRevenue / CAST(bb.SoldSeats AS FLOAT) END as TotalRevenue	  	
	FROM (
	SELECT DISTINCT SeasonHeaderName, f.EventHeaderName, f.EventDate
	FROM ro.vw_FactTicketSalesBase_All f
	JOIN ro.vw_DimTicketType tt ON tt.DimTicketTypeId = f.DimTicketTypeId
	where f.SeasonName = @Season--'2017 Football'
	--AND f.IsComp = 0
	AND f.EventHeaderName IS NOT NULL ) e
	LEFT JOIN #BudgetBase bb ON bb.EventHeaderName = e.EventHeaderName


	UNION ALL
    
		SELECT e.SeasonHeaderName
		, 'Budget' AS Section
		, 'Budget' AS SubSection1
		 , 'Budget' TicketTypeClass --last7.TicketTypeClass
		, 'Avg Price to budget' TicketTypeDesc-- last7.TicketTypeDesc
		 , e.EventHeaderName
		 , e.EventDate
		 , NULL AS PriceCodeDesc--last7.PriceCodeDesc
		 , case when bb.BudgetSeats	is null then 0 else (bb.BudgetRevenue - bb.TotalRevenue ) / CAST(r.RemainingSeats AS FLOAT)		end as SeatCount	
		 , case when bb.BudgetSeats	is null then 0 else (bb.BudgetRevenue - bb.TotalRevenue ) / CAST(r.RemainingSeats AS FLOAT)	end as TotalRevenue	  	
	FROM (
	SELECT DISTINCT SeasonHeaderName, f.EventHeaderName, f.EventDate
	FROM ro.vw_FactTicketSalesBase_All f
	JOIN ro.vw_DimTicketType tt ON tt.DimTicketTypeId = f.DimTicketTypeId
	where f.SeasonName = @Season--'2017 Football'
	--AND f.IsComp = 0
	AND f.EventHeaderName IS NOT NULL ) e
	LEFT JOIN #BudgetBase bb ON bb.EventHeaderName = e.EventHeaderName
	LEFT JOIN
    (
		SELECT EventHeaderName, SUM(SeatCount) AS RemainingSeats
		FROM #RemainingInventory
		GROUP BY EventHeaderName
	) r ON r.EventHeaderName = bb.EventHeaderName
	) b
	--  ==================================================================
	--  7/11/2018 9:32 AM
	--  Payton Soicher
	--  Subject: 
	--  ==================================================================


SELECT *
FROM 
(
	SELECT SeasonHeaderName
		 , Section
		 , SubSection1
		 , TicketTypeClass SubSection2
		 , TicketTypeDesc Ticket_Type
		 , EventHeaderName EventName
		 , EventDate
		 , PriceCodeDesc PriceType_Description
		 , SeatCount Qty
		 , TotalRevenue  Revenue
		 FROM #DistributedTickets
	UNION ALL
	SELECT SeasonName,
		   Section,
		   SubSection1,
		   TicketTypeClass,
		   TicketTypeDesc,
		   EventHeaderName,
		   EventDate,
		   CAST(PriceCodeDesc AS NVARCHAR(255)) AS PriceCodeDesc,
		   SeatCount,
		   TotalRevenue 
	FROM #RemainingInventory
	UNION ALL
	SELECT SeasonHeaderName,
		   Section,
		   SubSection1,
		   TicketTypeClass,
		   TicketTypeDesc,
		   EventHeaderName,
		   EventDate,
		   CAST(PriceCodeDesc AS NVARCHAR(255)) AS PriceCodeDesc,
		   SeatCount,
		   TotalRevenue FROM #SalesVelocity
	UNION ALL
		SELECT SeasonHeaderName,
		   Section,
		   SubSection1,
		   TicketTypeClass,
		   TicketTypeDesc,
		   EventHeaderName,
		   EventDate,
		   CAST(PriceCodeDesc AS NVARCHAR(255)) AS PriceCodeDesc,
		   SeatCount,
		   TotalRevenue FROM #Budget
	) f
WHERE f.SubSection2 <> 'Unknown'
ORDER BY 2,CASE WHEN Ticket_Type = 'Sale Date' THEN 1
						 WHEN Ticket_Type = 'First 7 Days' THEN 2
						 WHEN Ticket_Type = 'Last 7 Days' THEN 3
						 WHEN Ticket_Type = 'Last 14 Days' THEN 4
						 WHEN Ticket_Type = 'Last 30 Days' THEN 5 
						 ELSE 6 END, 7



END
--  ==================================================================
--  7/6/2018 12:00 PM
--  Payton Soicher
--  Subject: Abbey Query
--  ==================================================================



--select EventHeaderDesc, EventDate
--, TicketTypeClass
--, TicketTypeName
--, CASE WHEN TicketTypeClass = 'Partial Plan' THEN PlanName ELSE PriceCode + ':' + PriceCodeDesc END AS PriceCode
--, SUM(QtySeat) Qty 
--FROM [ro].[vw_FactTicketSalesBase_All] fts
--where Sport = 'Football'
--AND Seasonyear = '2018'
--AND EventHeaderDesc IS NOT NULL
--GROUP BY EventHeaderDesc, EventDate, TicketTypeClass, TicketTypeName, PlanName, PriceCode, PriceCodeDesc
--ORDER BY EventHeaderDesc, TicketTypeClass, TicketTYpeName


--SELECT f.* 
--FROM ro.vw_FactTicketSalesBase_All f
--JOIN ro.vw_DimTicketType tt ON tt.DimTicketTypeId = f.DimTicketTypeId
--WHERE f.TicketTypeClass = 'Unknown'
--AND f.SeasonHeaderName = '2018 Football'



GO
