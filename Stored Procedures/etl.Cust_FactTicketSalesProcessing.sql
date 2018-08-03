SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [etl].[Cust_FactTicketSalesProcessing]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(MAX) = NULL
)

AS



BEGIN


-------------------------------------------------------------------------------

-- Author name: Abbey Meitin
-- Created date: 2017
-- Purpose: description of the business/technical purpose
-- using multiple lines as needed
-- Copyright © 2017, SSB, All Rights Reserved

-------------------------------------------------------------------------------

-- Modification History --

-- 2018-06-07:		Kaitlyn Nelson
-- Change notes:	Added logic to tag Football 2018 transactions

-- Peer reviewed by:	Abbey Meitin
-- Peer review notes:	This looks good. (I think I already told you that via slack)
-- Peer review date:	2018-06-08

-- Deployed by:		
-- Deployment date:
-- Deployment notes:




-- 2018-06-15:		Keegan Schmitt
-- Change notes:	Added logic to tag Football 2018 transactions

-- Peer reviewed by:	
-- Peer review notes:	
-- Peer review date:	

-- Deployed by:		
-- Deployment date:
-- Deployment notes:

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------



/*****************************************************************************************************************
													TICKET TYPE
******************************************************************************************************************/



--------------FULL SEASON --------------------------------


UPDATE fts
SET fts.DimTicketTypeId = 3
--select distinct SeasonName, ItemCode, ItemDesc, PC1, PC2, DImTicketTypeId
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN etl.vw_DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		INNER JOIN etl.vw_DimPriceCode pc ON fts.DimPriceCodeId = pc.DimPriceCodeId
WHERE di.ETL__SourceSystem = 'TM' 
AND PC2 IN ('L','E','B','R', 'N') 
AND ((season.SeasonYear = '2017' AND Season.Config_Org = 'Football' AND PC1 <> 'R') --exclude MidFirst Bank Stadium Club
	OR (season.SeasonYear = '2018' AND Season.Config_Org = 'Football' AND PC1 <> 'L') --exclude MidFirst Bank Stadium Club
	OR (season.Config_Org <> 'Football'))

--UPDATE fts
--SET fts.DimTicketTypeId = 3
----select distinct SeasonName, ItemCode, ItemDesc, PriceCode, PC2, DImTicketTypeId
--FROM    stg.TM_FactTicketSales fts
--        INNER JOIN etl.vw_DimItem di ON fts.DimItemId = di.DimItemId
--		INNER JOIN etl.vw_DimSeason season ON season.DimSeasonId = fts.DimSeasonId
--		INNER JOIN etl.vw_DimPriceCode pc ON fts.DimPriceCodeId = pc.DimPriceCodeId
--WHERE (di.ETL__SourceSystem = 'TM' 
--AND (PC2 IN ('L','E','B','R', 'N') AND season.Config_Category1 = 'Regular Season')
--OR ItemCode IN ('17FBFS', '17FBFS2', '17MBFS','17VBFS','17WSFS','17WBFS'))



------FULL SEASON SUITE ----

UPDATE fts
SET fts.DimTicketTypeId = 20
--select distinct ItemCode, ItemDesc
FROM    stg.TM_FactTicketSales fts 
        INNER JOIN etl.vw_DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemCode LIKE '%FBFSS'
OR di.ItemCode = '17FBFSST'



------MIDFIRST BANK STADIUM CLUB ----

UPDATE fts
SET fts.DimTicketTypeId = 4
--SELECT distinct PriceCode, PriceCodeName, PriceCodeDesc, SeasonName, ItemCode
FROM     stg.TM_FactTicketSales  fts
        INNER JOIN etl.vw_DimPriceCode dpc ON fts.DimPriceCodeId = dpc.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
		INNER JOIN etl.vw_DimItem di ON fts.DimItemId = di.DimItemId
WHERE ((ds.SeasonYear = '2017' AND dpc.PC1 = 'R')
	OR (ds.SeasonYear = '2018' AND dpc.PC1 = 'L'))
	AND ds.Config_org = 'Football'



------PREMIUM CLUB ----

UPDATE fts
SET fts.DimTicketTypeId = 5
--SELECT distinct PriceCode, PriceCodeName, PriceCodeDesc, SeasonName, ItemCode
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode dpc ON fts.DimPriceCodeId = dpc.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
		INNER JOIN etl.vw_DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemCode LIKE '%FBFSC'
AND ds.SeasonName LIKE '%Football Clubs'
AND ((ds.SeasonYear = '2017' AND dpc.PC1 IN ('T', 'U', 'V', 'W', 'Z'))
	OR (ds.SeasonYear = '2018' AND dpc.PC1 IN ('M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y'))) -- Updates to add the extra logic



------SINGLE GAME SUITE ----


UPDATE fts
SET fts.DimTicketTypeId = 6
--select distinct ItemCode, ItemDesc
FROM    stg.TM_FactTicketSales fts 
        INNER JOIN etl.vw_DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemCode LIKE '%FBFSS[1-7]'
OR di.ItemCode LIKE '%FBSRO%'


UPDATE fts
SET fts.DimTicketTypeId = 6
--SELECT DISTINCT PriceCode, PriceCodeDesc
FROM    stg.TM_FactTicketSales fts
		INNER JOIN etl.vw_DimPriceCode dc ON dc.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
WHERE	dc.PC1 = 'G'
AND ds.Config_Org = 'Baseball'


----------MINI---------------

UPDATE fts
SET fts.DimTicketTypeId = 7
--SELECT DISTINCT ItemCode
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode dpc ON fts.DimPriceCodeId = dpc.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE dpc.PC2 = 'M'


---------FLEX----------------

--UPDATE fts
--SET fts.DimTicketTypeId = 8
--FROM    dbo.FactTicketSales fts
----        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
----        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
----        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
----		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
----WHERE	PriceCode.PriceCodeGroup LIKE  '4%'

------GROUP SINGLES----

UPDATE fts
SET fts.DimTicketTypeId = 9
--SELECT DISTINCT dc.PriceCode 
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN etl.vw_DimPriceCode dc ON dc.DimPriceCodeId = fts.DimPriceCodeId
WHERE	dc.PC2 = 'G'



------VISITING TEAM SINGLES----

UPDATE fts
SET fts.DimTicketTypeId = 10
--Select distinct PriceCode
FROM    stg.TM_FactTicketSales fts
		INNER JOIN etl.vw_DimPriceCode dc ON dc.DimPriceCodeId = fts.DimPriceCodeId
WHERE	dc.PC2 = 'Z'


------PREMIUM (SINGLES)----

UPDATE fts
SET fts.DimTicketTypeId = 18
--SELECT DISTINCT ItemCode, PriceCode, PriceCodeDesc
FROM    stg.TM_FactTicketSales fts
		INNER JOIN etl.vw_DimPriceCode dpc ON dpc.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN etl.vw_DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
WHERE	dpc.PC2 = 'S'
AND ((ds.SeasonYear = '2017' AND dpc.PC1 IN ('T', 'U', 'V', 'W', 'Z'))
	OR (ds.SeasonYear = '2018' AND dpc.PC1 IN ('X', 'M', 'N', 'Y', 'U')))



------PUBLIC (SINGLES)----
--Football
UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT ItemCode, PriceCode, PriceCodeDesc, TM_retail_ticket_type
FROM    stg.TM_FactTicketSales fts
		INNER JOIN etl.vw_DimPriceCode dpc ON dpc.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN etl.vw_DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
WHERE	di.ItemCode LIKE '%FBF0%'
AND (dpc.PC2 = 'S'
AND ((ds.SeasonYear = '2017' AND dpc.PC1 NOT IN ('T', 'U', 'V', 'W', 'Z'))
	OR (ds.SeasonYear = '2018' AND dpc.PC1 NOT IN ('X', 'M', 'N', 'Y', 'U')))
		OR fts.TM_retail_ticket_type <> '')

UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT ItemCode, PriceCode, PriceCodeDesc, TM_retail_ticket_type
FROM    stg.TM_FactTicketSales fts
		INNER JOIN etl.vw_DimPriceCode dc ON dc.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimItem di ON fts.DimItemId = di.DimItemId
WHERE	di.ItemCode LIKE '%FBF0%'
AND PC2 IS NULL AND fts.TM_comp_code <> 0

UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT ItemCode, PriceCode, PriceCodeDesc, TM_retail_ticket_type
FROM    stg.TM_FactTicketSales fts
		INNER JOIN etl.vw_DimPriceCode dc ON dc.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimItem di ON fts.DimItemId = di.DimItemId
WHERE	di.ItemCode LIKE '%FBF0%'
AND dc.PriceCode IN ('PJC', 'KAY')

--ALL OTHER SPORTS (PUBLIC)

UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT ItemCode, PriceCode, PriceCodeDesc, TM_retail_ticket_type
FROM   stg.TM_FactTicketSales fts
		INNER JOIN etl.vw_DimPriceCode dc ON dc.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN etl.vw_DimSeason ds ON fts.DimSeasonId = ds.DimseasonId
WHERE	ds.Config_Org <> 'Football'
AND (dc.PC2 = 'S' OR fts.TM_retail_ticket_type <> '')



------STUDENT (SINGLES)----


UPDATE fts
SET fts.DimTicketTypeId = 12
--SELECT DISTINCT ItemCode, PriceCode, PriceCodeDesc
FROM    stg.TM_FactTicketSales fts
		INNER JOIN etl.vw_DimPriceCode dc ON dc.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimItem di ON fts.DimItemId = di.DimItemId
WHERE	dc.PC2 = 'X'


-------------PARKING -----------------
UPDATE fts
SET fts.DimTicketTypeId = 17
FROM    stg.TM_FactTicketSales fts
		INNER JOIN etl.vw_DimSeason ds ON ds.DimSeasonId = fts.DimSeasonId
WHERE	ds.Config_Category1 = 'Parking Season'

--Football
--UPDATE fts
--SET fts.DimTicketTypeId = 17
--FROM dbo.FactTicketSales fts
--        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
--		  JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
--WHERE season.SeasonCode like 'F%'
-- AND (di.ItemCode LIKE 'FLOT%'
-- OR di.ItemCode LIKE 'GOLD%'
-- OR di.ItemCode LIKE 'LOT%'
-- OR di.ItemCode LIKE 'NORTH%'
-- OR di.ItemCode LIKE 'RL1%'
-- OR di.ItemCode LIKE 'RL3%'
-- OR di.ItemCode LIKE 'RVALPHA%'
-- OR di.ItemCode LIKE 'RVUC%'
-- OR di.ItemCode LIKE 'SL%'
-- OR di.ItemCode LIKE 'SOUTH%'
-- OR di.ItemCode LIKE 'SPD%'
-- OR di.ItemCode LIKE 'STS%'
-- OR di.ItemCode LIKE 'TLOT%'
-- OR di.ItemCode LIKE 'TVP%'
-- OR di.ItemCode LIKE 'DIS%')

------All Session Pass----

UPDATE fts
SET fts.DimTicketTypeId = 19
--SELECT * 
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode dpc ON fts.DimPriceCodeId = dpc.DimPriceCodeId
WHERE dpc.PC2 = 'K'

------MISC----

----UPDATE fts
----SET fts.DimTicketTypeId = 14
----FROM    dbo.FactTicketSales fts
----        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
----        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
----        JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
----WHERE	(season.SeasonName LIKE '%2015%' OR season.SeasonName LIKE '%2016%')
----		AND DimTicketTypeId = -1





--/*****************************************************************************************************************
--															SEAT TYPE
--******************************************************************************************************************/
--select * from dbo.DimSeatType
------Student-----

UPDATE fts
SET fts.DimSeatTypeId = 1
--select distinct PriceCode, PriceCodeDesc
FROM     stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
WHERE (ds.Config_Org = 'Football' AND ds.SeasonYear = '2017' AND PC1 = 'X')
	OR (ds.Config_Org = 'Football' AND ds.SeasonYear = '2018' AND PC1 = 'K')


------SUITES----

UPDATE fts
SET fts.DimSeatTypeId = 2
--select distinct PriceCode, PriceCodeDesc
FROM     stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
WHERE (ds.Config_Org = 'Football' AND ds.SeasonYear = '2017' AND PC1 = 'S')
	OR (ds.Config_Org = 'Football' AND ds.SeasonYear = '2018' AND PC1 = 'W')


------CLUB----

UPDATE fts
SET fts.DimSeatTypeId = 3
--select distinct PriceCode, PriceCodeDesc
FROM     stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
WHERE (ds.Config_Org = 'Football' AND ds.SeasonYear = '2017' AND PC1 = 'R')
	OR (ds.Config_Org = 'Football' AND ds.SeasonYear = '2018' AND PC1 = 'L')
	   
----LOGE ----

UPDATE fts
SET fts.DimSeatTypeId = 4
FROM     stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
WHERE (ds.Config_Org = 'Football' AND ds.SeasonYear = '2017' AND PC1 IN ('D','F'))
	OR (ds.Config_Org = 'Football' AND ds.SeasonYear = '2018' AND PC1 IN ('Q', 'S', 'T'))

----LOWER BOWL----

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM   stg.TM_FactTicketSales  fts
        INNER JOIN [etl].[vw_DimSeat] dst ON fts.DimSeatId_Start = dst.DimSeatId
		 INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
WHERE (ds.Config_Org = 'Football' AND ds.SeasonYear = '2017' AND PC1 IN ('A', 'E', 'H', 'I', 'J', 'K') AND SectionName NOT IN ('304', '305', '306'))
	OR (ds.Config_Org = 'Football' AND ds.SeasonYear = '2018' AND PC1 IN ('A', 'B', 'D', 'E', 'J', 'F') AND SectionName NOT IN ('201', '202', '206', '207', '208', '209', '210', '211', '212', '213', '214', '304', '305', '306'))
 --End Football Rules

----UPPER BOWL----

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM   stg.TM_FactTicketSales  fts
        INNER JOIN [etl].[vw_DimSeat] dst ON fts.DimSeatId_Start = dst.DimSeatId
		 INNER JOIN etl.vw_DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
		INNER JOIN etl.vw_DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
WHERE (ds.Config_Org = 'Football' AND ds.SeasonYear = '2017' AND (PC1 IN ('B', 'C', 'G', 'L', 'N', 'O', 'P', 'Q') OR PC1 = 'J' AND SectionName IN ('304', '305', '306')))
	OR (ds.Config_Org = 'Football' AND ds.SeasonYear = '2018' AND (
			PC1 IN ('C', 'G', 'H', 'I') 
			OR (PC1 = 'J' AND SectionName IN ('304', '305', '306'))
			OR (PC1 = 'D' AND SectionName IN ('201', '202', '206', '207', '210', '211', '212'))
			OR (PC1 = 'E' AND SectionName IN ('208', '209', '213', '214'))
			OR (PC1 = 'F' AND SectionName IN ('304', '305', '306'))
			)
		)
 --End Football Rules



/*****************************************************************************************************************
													FACT TAGS
******************************************************************************************************************/

----IsComp TRUE--

UPDATE fts
SET fts.IsComp = 1
--select distinct PriceCode, PriceCodeDesc, TM_Comp_Code, TM_comp_name, fts.TM_Ticket_Type
FROM stg.TM_FactTicketSales fts
	JOIN etl.vw_DimPriceCode dpc
	ON dpc.DimPriceCodeId = fts.DimPriceCodeId
WHERE fts.TM_comp_code <> '0'
OR fts.TM_Ticket_Type like '%Comp%'
OR PC2 = 'C'

----IsComp FALSE--

UPDATE fts
SET fts.IsComp = 0
--select distinct PriceCode, PriceCodeDesc, TM_Comp_Code, TM_comp_name, TM_Ticket_Type
FROM stg.TM_FactTicketSales fts
	JOIN etl.vw_DimPriceCode dpc
	ON dpc.DimPriceCodeId = fts.DimPriceCodeId
WHERE fts.TM_comp_code = '0'
AND fts.TM_Ticket_Type not like '%Comp%'

----IsPlan TRUE--

--UPDATE f
--SET f.IsPlan = 1
--, f.IsPartial = 0
--, f.IsSingleEvent = 0
--, f.IsGroup = 0
--FROM dbo.FactTicketSales f
--JOIN dbo.DimTicketType tt ON f.DimTicketTypeId = tt.DimTicketTypeId
--WHERE tt.TicketTypeClass IN ('Season Ticket')


----Is Partial Plan--

UPDATE fts
SET fts.IsPlan = 1
, fts.IsPartial = 1
, fts.IsSingleEvent = 0
, fts.IsGroup = 0
FROM stg.TM_FactTicketSales fts
JOIN [etl].[vw_DimTicketType] tt ON fts.DimTicketTypeId = tt.DimTicketTypeId
WHERE tt.TicketTypeClass IN ('Partial Plan')



----Is Group--

UPDATE fts
SET fts.IsPlan = 0
, fts.IsPartial = 0
, fts.IsSingleEvent = 1
, fts.IsGroup = 1
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN etl.vw_DimPriceCode dc ON dc.DimPriceCodeId = fts.DimPriceCodeId
WHERE	dc.PC2 = 'G'
----/*Group */

----Is Single, not Group--

UPDATE fts
SET fts.IsPlan = 0
, fts.IsPartial = 0
, fts.IsSingleEvent = 1
, fts.IsGroup = 0
FROM stg.TM_FactTicketSales fts
JOIN [etl].[vw_DimTicketType] tt ON fts.DimTicketTypeId = tt.DimTicketTypeId
WHERE TicketTypeClass = 'Single'
AND fts.DimTicketTypeId <> '9' 
----/*Single Game*/


----is Premium TRUE--

UPDATE fts
SET fts.IsPremium = 1
FROM stg.TM_FactTicketSales  fts
INNER JOIN etl.vw_DimPriceCode dpc ON dpc.DimPriceCodeId = fts.DimPriceCodeId
INNER JOIN etl.vw_DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
WHERE (dpc.PC1 IN ('R', 'S', 'T', 'U', 'V', 'W', 'Z') AND ds.Config_Org = 'Football' AND ds.SeasonYear = '2017')
	OR (dpc.PC1 IN ('L', 'W', 'X', 'M', 'N', 'Y', 'U') AND ds.Config_Org = 'Football' AND ds.SeasonYear = '2018')

----is Premium FALSE--


UPDATE fts
SET fts.IsPremium = 0
FROM stg.TM_FactTicketSales  fts
INNER JOIN etl.vw_DimPriceCode dpc ON dpc.DimPriceCodeId = fts.DimPriceCodeId
INNER JOIN etl.vw_DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
WHERE (dpc.PC1 NOT IN ('R', 'S', 'T', 'U', 'V', 'W', 'Z') AND ds.Config_Org = 'Football' AND ds.SeasonYear = '2017')
	OR (dpc.PC1 NOT IN ('L', 'W', 'X', 'M', 'N', 'Y', 'U') AND ds.Config_Org = 'Football' AND ds.SeasonYear = '2018')

----is Renewal TRUE--

UPDATE f
SET f.IsRenewal = 1
FROM stg.TM_FactTicketSales f
INNER JOIN dbo.DimPlanType_V2 dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.PlanTypeCode IN ('RENEW')



----is Renewal FALSE--

UPDATE f
SET f.IsRenewal = 0
FROM stg.TM_FactTicketSales f
INNER JOIN dbo.DimPlanType_V2 dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.PlanTypeCode NOT IN ('RENEW')


-----isBroker TRUE----

--UPDATE f
--SET f.IsBroker = 1
--FROM dbo.FactTicketSales f
--INNER JOIN dbo.DimCustomer dc ON dc.DimCustomerId = f.DimCustomerId AND dc.SourceSystem = 'TM'
--WHERE dc.AccountType = 'Broker  /E'




--/*****************************************************************************************************************
--															PLAN TYPE
--******************************************************************************************************************/

------NEW----

UPDATE fts
SET fts.DimPlanTypeId = 1
--select distinct PriceCode, PriceCodeDesc
FROM    stg.TM_FactTicketSales  fts
        INNER JOIN etl.vw_DimPriceCode pc ON pc.DimPriceCodeId = fts.DimPriceCodeId
WHERE   PC2 IN ('B', 'N')
AND  pc.PriceCode NOT LIKE '%A'


------ADD-ON----

UPDATE fts
SET fts.DimPlanTypeId = 2
--select distinct PriceCode, PriceCodeDesc
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode pc ON pc.DimPriceCodeId = fts.DimPriceCodeId
WHERE   pc.PriceCode like '%A'

------RENEW----

UPDATE fts
SET fts.DimPlanTypeId = 3
--select distinct PriceCode, PriceCodeDesc
FROM    stg.TM_FactTicketSales fts
        INNER JOIN etl.vw_DimPriceCode pc ON pc.DimPriceCodeId = fts.DimPriceCodeId
WHERE   PC2 IN ('L', 'E', 'R')
AND  pc.PriceCode NOT LIKE '%A'

------NO PLAN----


UPDATE fts
SET fts.DimPlanTypeId = 3
FROM    stg.TM_FactTicketSales fts
WHERE   IsPlan = 0

END 

GO
