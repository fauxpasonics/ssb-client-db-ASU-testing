SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[Dev_Cust_FactTicketSalesProcessing]
(
	@BatchId INT = 0,
	@LoadDate DATETIME = NULL,
	@Options NVARCHAR(MAX) = NULL
)
AS



BEGIN



/*****************************************************************************************************************
													TICKET TYPE
******************************************************************************************************************/



--------------FULL SEASON --------------------------------

UPDATE fts
SET fts.DimTicketTypeId = 3
FROM    dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		  JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode = 'FS'
AND season.SeasonCode like '%16'

--Women's Basketball GA Season Ticket--
UPDATE fts
SET fts.DimTicketTypeId = 3
FROM    dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode = 'GA'
AND season.SeasonCode = 'WB16'


------FULL SEASON SUITE ----

UPDATE fts
SET fts.DimTicketTypeId = 4
FROM    dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		  JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode IN ('FSS', 'FSSUITE')
AND season.SeasonCode like 'F%'

------MIDFIRST BANK STADIUM CLUB ----

UPDATE fts
SET fts.DimTicketTypeId = 4
FROM    dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		 JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		 JOIN DimPriceLevel dpl on fts.DimPriceLevelId = dpl.DimPriceLevelId
WHERE di.ItemCode IN ('FSC')
AND dpl.PriceLevelCode = '20'
AND season.SeasonCode IN ('F15', 'F16')


------PREMIUM CLUB ----

UPDATE fts
SET fts.DimTicketTypeId = 18
FROM    dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		 JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		 JOIN DimPriceLevel dpl on fts.DimPriceLevelId = dpl.DimPriceLevelId
WHERE di.ItemCode IN ('FSC')
AND dpl.PriceLevelCode <> '20'
AND season.SeasonCode IN ('F16')

------SINGLE GAME SUITE ----


UPDATE fts
SET fts.DimTicketTypeId = 6 
FROM    dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		 JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		 JOIN DimPriceLevel dpl on fts.DimPriceLevelId = dpl.DimPriceLevelId
WHERE di.ItemCode LIKE 'F0%'
AND dpl.PriceLevelCode = '16'
AND season.SeasonCode = 'F16'


----------MINI---------------

--Football
UPDATE fts
SET fts.DimTicketTypeId = 7
FROM    dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		  JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode LIKE '[2-5]%'
AND season.SeasonCode like 'F%'

--All Other Sports
UPDATE fts
SET fts.DimTicketTypeId = 7
FROM     dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		  JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode LIKE '[1-9]%'
AND season.SeasonCode NOT LIKE 'F%'



---------FLEX----------------

--UPDATE fts
--SET fts.DimTicketTypeId = 8
--FROM    dev.FactTicketSales fts
----        INNER JOIN dev.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
----        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
----        JOIN dev.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
----		JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
----WHERE	PriceCode.PriceCodeGroup LIKE  '4%'

------GROUP SINGLES----

UPDATE fts
SET fts.DimTicketTypeId = 9
FROM    dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		JOIN dev.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE	dpt.PriceTypeCode LIKE  'G%'


------VISITING TEAM SINGLES----

UPDATE fts
SET fts.DimTicketTypeId = 10
FROM    dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		JOIN dev.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE	dpt.PriceTypeCode LIKE  'V%'


------PUBLIC (SINGLES)----

--UPDATE fts
--SET fts.DimTicketTypeId = 11
--FROM    dev.FactTicketSales  fts
----        INNER JOIN dev.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
----        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
----        JOIN dev.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
----		JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
----WHERE	PriceCode.PriceCodeGroup LIKE  '6%'


------STUDENT (SINGLES)----

--UPDATE fts
--SET fts.DimTicketTypeId = 12
--FROM    dev.FactTicketSales  fts
----        INNER JOIN dev.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
----        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
----        JOIN dev.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
----		JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
----WHERE	PriceCode.PriceCodeGroup LIKE  '6%'


------DONATIONS ----

--Football
UPDATE fts
SET fts.DimTicketTypeId = 13
FROM dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		  JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode LIKE 'DON%'
AND season.SeasonCode like 'F%'
AND di.ItemCode NOT LIKE 'DONSUITE%' 
AND di.ItemCode NOT LIKE 'DONCLUB%' 
AND di.ItemCode <> 'DONC3125+'

--Men's Basketball
UPDATE fts
SET fts.DimTicketTypeId = 13
FROM dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		  JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode LIKE 'DON%'
AND season.SeasonCode like 'BB%'


------DONATIONS SUITE ----

UPDATE fts
SET fts.DimTicketTypeId = 14
FROM dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		  JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode LIKE 'DONSUITE%' 


------DONATIONS MBSC----

UPDATE fts
SET fts.DimTicketTypeId = 15
FROM dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		  JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode LIKE 'DONCLUB%' 


------DONATIONS LEGENDS CLUB ----

--UPDATE fts
--SET fts.DimTicketTypeId = 16
--FROM    dev.FactTicketSales  fts
----        INNER JOIN dev.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
----        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
----        JOIN dev.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
----		JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
----WHERE	PriceCode.PriceCodeGroup LIKE  '7%'

-------------PARKING -----------------
--Football
UPDATE fts
SET fts.DimTicketTypeId = 17
FROM dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		  JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE season.SeasonCode like 'F%'
 AND (di.ItemCode LIKE 'FLOT%'
 OR di.ItemCode LIKE 'GOLD%'
 OR di.ItemCode LIKE 'LOT%'
 OR di.ItemCode LIKE 'NORTH%'
 OR di.ItemCode LIKE 'RL1%'
 OR di.ItemCode LIKE 'RL3%'
 OR di.ItemCode LIKE 'RVALPHA%'
 OR di.ItemCode LIKE 'RVUC%'
 OR di.ItemCode LIKE 'SL%'
 OR di.ItemCode LIKE 'SOUTH%'
 OR di.ItemCode LIKE 'SPD%'
 OR di.ItemCode LIKE 'STS%'
 OR di.ItemCode LIKE 'TLOT%'
 OR di.ItemCode LIKE 'TVP%'
 OR di.ItemCode LIKE 'DIS%')



------MISC----

----UPDATE fts
----SET fts.DimTicketTypeId = 14
----FROM    dev.FactTicketSales fts
----        INNER JOIN dev.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
----        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
----        JOIN dev.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
----WHERE	(season.SeasonName LIKE '%2015%' OR season.SeasonName LIKE '%2016%')
----		AND DimTicketTypeId = -1

------All Session Pass----

UPDATE fts
SET fts.DimTicketTypeId = 19
FROM    dev.FactTicketSales fts
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
WHERE ETL__SSID_SEASON LIKE 'SB%'
	  AND (ItemCode LIKE 'KC%' OR ItemCode LIKE 'LC%' OR ItemCode LIKE 'LS%' OR ItemCode LIKE 'DD%')



--/*****************************************************************************************************************
--															SEAT TYPE
--******************************************************************************************************************/

------Student-----

--UPDATE fts
--SET fts.DimSeatTypeId = 1
--FROM    dev.FactTicketSales fts
--        INNER JOIN dev.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
--        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
--		INNER JOIN dev.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
--        JOIN dev.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
----WHERE  PC1 = '1'

------SUITES----

--UPDATE fts
--SET fts.DimSeatTypeId = 2
--FROM    dev.FactTicketSales fts
--        INNER JOIN dev.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
--        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
--		INNER JOIN dev.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
--        JOIN dev.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
----WHERE PC1 = '2'
	   
------CLUB----

--UPDATE fts
--SET fts.DimSeatTypeId = 3
--FROM    dev.FactTicketSales fts
--        INNER JOIN dev.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
--        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
--		INNER JOIN dev.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
--        JOIN dev.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
--WHERE PC1 = '3'
	   
	   
----LOGE ----

UPDATE fts
SET fts.DimSeatTypeId = 4
FROM    dev.FactTicketSales fts
        INNER JOIN dev.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dev.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dev.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
--WHERE PC1 = '4'

----LOWER BOWL----

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM   dev.FactTicketSales fts
        INNER JOIN dev.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dev.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dev.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
--WHERE PC1 = '5'

----UPPER BOWL----

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM   dev.FactTicketSales fts
        INNER JOIN dev.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dev.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dev.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dev.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
--WHERE (SeasonName LIKE 'NHL%' OR SeasonName LIKE 'WHL%')
--	   AND  PC1 IN ('6','7')



/*****************************************************************************************************************
													FACT TAGS
******************************************************************************************************************/

----IsComp TRUE--

--UPDATE f
--SET f.IsComp = 1
--FROM dev.FactTicketSales f
--	JOIN dev.DimPriceCode dpc
--	ON dpc.DimPriceCodeId = f.DimPriceCodeId
--WHERE f.CompCode <> '0'

----IsComp FALSE--

--UPDATE f
--SET f.IsComp = 0
--FROM dev.FactTicketSales f
--	JOIN dev.DimPriceCode dpc
--	ON dpc.DimPriceCodeId = f.DimPriceCodeId
--WHERE NOT (f.compname <> 'Not Comp')
--		   --OR PriceCodeDesc = 'Comp'
--		   --OR f.TotalRevenue = 0)

----IsPlan TRUE--

UPDATE f
SET f.IsPlan = 1
, f.IsPartial = 0
, f.IsSingleEvent = 0
, f.IsGroup = 0
FROM dev.FactTicketSales f
JOIN dev.DimTicketType tt ON f.DimTicketTypeId = tt.DimTicketTypeId
WHERE tt.TicketTypeClass IN ('Season Ticket')


----Is Partial Plan--

UPDATE f
SET f.IsPlan = 1
, f.IsPartial = 1
, f.IsSingleEvent = 0
, f.IsGroup = 0
FROM dev.FactTicketSales f
JOIN dev.DimTicketType tt ON f.DimTicketTypeId = tt.DimTicketTypeId
WHERE tt.TicketTypeClass IN ('Partial Plan')



----Is Group--

UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 1
FROM dev.FactTicketSales f
WHERE DimTicketTypeId IN ('9') 
----/*Group */

----Is Single, not Group--

UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 0
FROM dev.FactTicketSales f
JOIN dev.DimTicketType tt ON f.DimTicketTypeId = tt.DimTicketTypeId
WHERE TicketTypeClass = 'Single'
AND f.DimTicketTypeId <> '9' 
----/*Single Game*/


----is Premium TRUE--

--UPDATE f
--SET f.IsPremium = 1
--FROM dev.FactTicketSales  f
--INNER JOIN dev.DimSeatType dst ON f.DimSeatTypeId = dst.DimSeatTypeId
--WHERE dst.DimSeatTypeId IN ('1', '2', '3', '4', '5')

----is Premium FALSE--

--UPDATE f
--SET f.IsPremium = 0
--FROM dev.FactTicketSales f
--INNER JOIN dev.DimSeatType dst ON f.DimSeatTypeId = dst.DimSeatTypeId
--WHERE dst.SeatTypeCode IN ('-1', '6', '7', '8', '9', '10')

----is Renewal TRUE--

UPDATE f
SET f.IsRenewal = 1
FROM dev.FactTicketSales f
INNER JOIN dev.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.PlanTypeCode IN ('RENEW')



----is Renewal FALSE--

UPDATE f
SET f.IsRenewal = 0
FROM dev.FactTicketSales f
INNER JOIN dev.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.PlanTypeCode NOT IN ('RENEW')


-----isBroker TRUE----

--UPDATE f
--SET f.IsBroker = 1
--FROM dev.FactTicketSales f
--INNER JOIN dev.DimCustomer dc ON dc.DimCustomerId = f.DimCustomerId AND dc.SourceSystem = 'TM'
--WHERE dc.AccountType = 'Broker  /E'




--/*****************************************************************************************************************
--															PLAN TYPE
--******************************************************************************************************************/

------NEW----

UPDATE fts
SET fts.DimPlanTypeId = 1
FROM    dev.FactTicketSales fts
        INNER JOIN dev.DimPriceType PriceType ON PriceType.DimPriceTypeId = fts.DimPriceTypeId
WHERE   fts.IsPlan = 1
		AND (PriceType.PriceTypeCode LIKE 'N%'
				OR PriceType.PriceTypeCode LIKE 'BN%')


------ADD-ON----

UPDATE fts
SET fts.DimPlanTypeId = 1
FROM    dev.FactTicketSales fts
        INNER JOIN dev.DimPriceType PriceType ON PriceType.DimPriceTypeId = fts.DimPriceTypeId
WHERE   fts.IsPlan = 1
		AND PriceType.PriceTypeCode LIKE '%A'

------RENEW----

UPDATE fts
SET fts.DimPlanTypeId = 3
FROM    dev.FactTicketSales fts
        INNER JOIN dev.DimPriceType PriceType ON PriceType.DimPriceTypeId = fts.DimPriceTypeId
WHERE   fts.IsPlan = 1
AND (PriceType.PriceTypeCode NOT LIKE 'N%'
OR PriceType.PriceTypeCode NOT LIKE 'BN%'
OR PriceType.PriceTypeCode NOT LIKE '%A')

------NO PLAN----


UPDATE fts
SET fts.DimPlanTypeId = 3
FROM    dev.FactTicketSales fts
WHERE   IsPlan = 0

END 






















GO
