SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE PROCEDURE [etl].[Cust_FactTicketSalesProcessing_Paciolan]
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
--SELECT DISTINCT season.SeasonName, di.ItemCode, di.ItemName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode = 'FS'
AND season.SeasonCode like '%16'

--SELECT * FROM dbo.DimTicketType_V2

--Women's Basketball GA Season Ticket--
UPDATE fts
SET fts.DimTicketTypeId = 3
FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode = 'GA'
AND season.SeasonCode = 'WB16'

--Old Season Items
UPDATE fts
SET fts.DimTicketTypeId = 3
--SELECT DISTINCT season.SeasonName, di.ItemCode, di.ItemName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
WHERE 1=1
AND Itemcode IN ('VBS', 'SBS', 'BBS', 'TS', 'GS', 'BS')

------FULL SEASON SUITE ----

UPDATE fts
SET fts.DimTicketTypeId = 4
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode IN ('FSS', 'FSSUITE')
AND season.SeasonCode like 'F%'

------MIDFIRST BANK STADIUM CLUB ----

UPDATE fts
SET fts.DimTicketTypeId = 4
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		 JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		 JOIN DimPriceLevel dpl on fts.DimPriceLevelId = dpl.DimPriceLevelId
WHERE di.ItemCode IN ('FSC')
AND dpl.PriceLevelCode = '20'
AND season.SeasonCode IN ('F15', 'F16')


------PREMIUM CLUB ----

UPDATE fts
SET fts.DimTicketTypeId = 18
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		 JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
		 JOIN DimPriceLevel dpl on fts.DimPriceLevelId = dpl.DimPriceLevelId
WHERE di.ItemCode IN ('FSC')
AND dpl.PriceLevelCode <> '20'
AND season.SeasonCode IN ('F16')

------SINGLE GAME SUITE ----


UPDATE fts
SET fts.DimTicketTypeId = 6 
FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		 JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
		 JOIN DimPriceLevel_V2 dpl on fts.DimPriceLevelId = dpl.DimPriceLevelId
WHERE di.ItemCode LIKE 'F0%'
AND dpl.PriceLevelCode = '16'
AND season.SeasonCode = 'F16'


----------MINI---------------

--Football
UPDATE fts
SET fts.DimTicketTypeId = 7
FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode LIKE '[2-5]%'
AND season.SeasonCode like 'F%'

--All Other Sports
UPDATE fts
SET fts.DimTicketTypeId = 7
--SELECT DISTINCT season.SeasonName, di.ItemCode, di.ItemName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode LIKE '[1-9]%'
AND season.SeasonCode NOT LIKE 'F%'


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
--SELECT DISTINCT season.Seasoncode, season.SeasonName, di.ItemCode, di.ItemName, PriceTYpeCode, PriceTypeName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
		INNER JOIN dbo.DimPriceType_V2 pt ON fts.DimpriceTypeId = pt.DimPriceTypeId
WHERE 1=1
AND SeasonCode LIKE 'S1%'
AND ItemCode LIKE 'S0[1-9]'
AND PriceTypeCode IN ('G', 'GG', 'GDG')


------VISITING TEAM SINGLES----

UPDATE fts
SET fts.DimTicketTypeId = 10
--SELECT DISTINCT season.SeasonName, di.ItemCode, di.ItemName, dpt.PriceTypeCode, dpt.PriceTypeName 
FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
		INNER JOIN dbo.DimPriceType_V2 dpt ON fts.DimPriceTypeId = dpt.DimPriceTypeId
WHERE	dpt.PriceTypeCode LIKE  'V%'
AND PriceTypeName NOT LIKE '%Valley%'



------PUBLIC (SINGLES)----
--Men's basketball
UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT season.SeasonName, di.ItemCode, di.ItemName, dpt.PriceTypeCode, dpt.PriceTypeName 
FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
		INNER JOIN dbo.DimPriceType_V2 dpt ON fts.DimPriceTypeId = dpt.DimPriceTypeId
WHERE	season.SeasonCode = 'BB16'
AND ItemCode LIKE 'MB%'
AND PriceTypeCode NOT LIKE 'V%'
AND PriceTypeCode NOT LIKE 'G%'

------PUBLIC (SINGLES)----
--Women's basketball
UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT season.SeasonName, di.ItemCode, di.ItemName, dpt.PriceTypeCode, dpt.PriceTypeName, DimticketTYpeid
FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
		INNER JOIN dbo.DimPriceType_V2 dpt ON fts.DimPriceTypeId = dpt.DimPriceTypeId
WHERE	season.SeasonCode = 'WB16'
AND ItemCode LIKE 'WB%'
AND PriceTypeCode NOT LIKE 'V%'
AND PriceTypeCode NOT LIKE 'G%'
AND PriceTypeCode <> 'AP'

--Soccer
UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT season.Seasoncode, season.SeasonName, di.ItemCode, di.ItemName, PriceTYpeCode, PriceTypeName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
		INNER JOIN dbo.DimPriceType_V2 pt ON fts.DimpriceTypeId = pt.DimPriceTypeId
WHERE 1=1
AND SeasonCode LIKE 'S1%'
AND ItemCode LIKE 'S0[1-9]'
AND PriceTypeCode NOT IN ('G', 'GG', 'GDG')

--Baseball
UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT season.Seasoncode, season.SeasonName, di.ItemCode, di.ItemName, PriceTYpeCode, PriceTypeName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
WHERE 1=1
AND DimticketTypeID <= '0'
AND SeasonCode LIKE 'B1%'
AND ItemCode LIKE 'B[0-9]%'

--Men's Basketball

UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT season.Seasoncode, season.SeasonName, di.ItemCode, di.ItemName, PriceTYpeCode, PriceTypeName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
		INNER JOIN dbo.DimPriceType_V2 pt ON fts.DimpriceTypeId = pt.DimPriceTypeId
WHERE 1=1
AND DimticketTypeID <= '0'
AND SeasonCode LIKE 'BB%'
AND ItemCode LIKE 'MB%'

--Softball
UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT season.Seasoncode, season.SeasonName, di.ItemCode, di.ItemName, PriceTYpeCode, PriceTypeName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
		INNER JOIN dbo.DimPriceType_V2 pt ON fts.DimpriceTypeId = pt.DimPriceTypeId
WHERE 1=1
AND DimticketTypeID <= '0'
AND SeasonCode LIKE 'SB%'
AND ItemCode LIKE 'SB%'

--Football
UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT season.Seasoncode, season.SeasonName, di.ItemCode, di.ItemName, PriceTYpeCode, PriceTypeName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
		INNER JOIN dbo.DimPriceType_V2 pt ON fts.DimpriceTypeId = pt.DimPriceTypeId
WHERE 1=1
AND DimticketTypeID <= '0'
AND SeasonCode LIKE 'F%'
AND ItemCode LIKE 'F0%'
AND ItemName NOT LIKE '%@%'

--Olympic Sports
UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT season.Seasoncode, season.SeasonName, di.ItemCode, di.ItemName, PriceTYpeCode, PriceTypeName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
		INNER JOIN dbo.DimPriceType_V2 pt ON fts.DimpriceTypeId = pt.DimPriceTypeId
WHERE 1=1
AND DimticketTypeID <= '0'
AND SeasonCode LIKE 'OS%'

--Women's Basketball

UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT season.Seasoncode, season.SeasonName, di.ItemCode, di.ItemName, PriceTYpeCode, PriceTypeName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
		INNER JOIN dbo.DimPriceType_V2 pt ON fts.DimpriceTypeId = pt.DimPriceTypeId
WHERE 1=1
AND DimticketTypeID <= '0'
AND SeasonCode LIKE 'WB%'
AND ItemCode LIKE 'WB%'

--Volleyball

UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT season.Seasoncode, season.SeasonName, di.ItemCode, di.ItemName, PriceTYpeCode, PriceTypeName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
		INNER JOIN dbo.DimPriceType_V2 pt ON fts.DimpriceTypeId = pt.DimPriceTypeId
WHERE 1=1
AND DimticketTypeID <= '0'
AND SeasonCode LIKE 'V%'

--Hockey

UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT season.Seasoncode, season.SeasonName, di.ItemCode, di.ItemName, PriceTYpeCode, PriceTypeName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
		INNER JOIN dbo.DimPriceType_V2 pt ON fts.DimpriceTypeId = pt.DimPriceTypeId
WHERE 1=1
AND DimticketTypeID <= '0'
AND SeasonCode LIKE 'H%'

--Gymnastics
UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT season.Seasoncode, season.SeasonName, di.ItemCode, di.ItemName, PriceTYpeCode, PriceTypeName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
		INNER JOIN dbo.DimPriceType_V2 pt ON fts.DimpriceTypeId = pt.DimPriceTypeId
WHERE 1=1
AND DimticketTypeID <= '0'
AND SeasonCode LIKE 'GM%'

--Wrestling

UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT season.Seasoncode, season.SeasonName, di.ItemCode, di.ItemName, PriceTYpeCode, PriceTypeName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
WHERE 1=1
AND DimticketTypeID <= '0'
AND SeasonCode LIKE 'W%'
AND Itemcode LIKE 'W%'

--Track & Field

UPDATE fts
SET fts.DimTicketTypeId = 11
--SELECT DISTINCT season.Seasoncode, season.SeasonName, di.ItemCode, di.ItemName, PriceTYpeCode, PriceTypeName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
WHERE 1=1
AND DimticketTypeID <= '0'
AND SeasonCode LIKE 'TF%'


------STUDENT (SINGLES)----

--UPDATE fts
--SET fts.DimTicketTypeId = 12
--FROM    dbo.FactTicketSales  fts
----        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
----        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
----        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
----		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
----WHERE	PriceCode.PriceCodeGroup LIKE  '6%'


------DONATIONS ----

--Football
UPDATE fts
SET fts.DimTicketTypeId = 13
FROM dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode LIKE 'DON%'
AND season.SeasonCode like 'F%'
AND di.ItemCode NOT LIKE 'DONSUITE%' 
AND di.ItemCode NOT LIKE 'DONCLUB%' 
AND di.ItemCode <> 'DONC3125+'

--Men's Basketball
UPDATE fts
SET fts.DimTicketTypeId = 13
FROM dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode LIKE 'DON%'
AND season.SeasonCode like 'BB%'


------DONATIONS SUITE ----

UPDATE fts
SET fts.DimTicketTypeId = 14
FROM dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeaso season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode LIKE 'DONSUITE%' 


------DONATIONS MBSC----

UPDATE fts
SET fts.DimTicketTypeId = 15
FROM dbo.FactTicketSales_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
WHERE di.ItemCode LIKE 'DONCLUB%' 


------DONATIONS LEGENDS CLUB ----

--UPDATE fts
--SET fts.DimTicketTypeId = 16
--FROM    dbo.FactTicketSales  fts
----        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
----        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
----        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId	
----		JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
----WHERE	PriceCode.PriceCodeGroup LIKE  '7%'

-------------PARKING -----------------
--Football
UPDATE fts
SET fts.DimTicketTypeId = 17
FROM dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
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

 --Basketball Parking
  UPDATE fts
SET fts.DimTicketTypeId = 17
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
WHERE 1=1
AND ItemCode IN ('PDS', 'SS', 'DLOT')
AND SeasonCode LIKE 'BB%'


 --Other Parking
 UPDATE fts
SET fts.DimTicketTypeId = 17
 --SELECT DISTINCT season.SeasonName, di.ItemCode, di.ItemName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
WHERE DimticketTypeID <= '0'
AND (ItemName LIKE '%Lot%' OR ItemName LIKE '%Parking%')




------MISC----

----UPDATE fts
----SET fts.DimTicketTypeId = 14
----FROM    dbo.FactTicketSales fts
----        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
----        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
----        JOIN dbo.DimSeason season ON season.DimSeasonId = fts.DimSeasonId
----WHERE	(season.SeasonName LIKE '%2015%' OR season.SeasonName LIKE '%2016%')
----		AND DimTicketTypeId = -1

------All Session Pass----

UPDATE fts
SET fts.DimTicketTypeId = 19
FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason_V2 ds ON fts.DimSeasonId = ds.DimSeasonId
WHERE ds.SeasonCode LIKE 'SB%'
	  AND (ItemCode LIKE 'KC%' OR ItemCode LIKE 'LC%' OR ItemCode LIKE 'LS%' OR ItemCode LIKE 'DD%')

---Away Games-----

UPDATE fts
SET fts.DimTicketTypeId = 21
--SELECT DISTINCT season.Seasoncode, season.SeasonName, di.ItemCode, di.ItemName, PriceTYpeCode, PriceTypeName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
WHERE 1=1
AND ItemName LIKE '%@%'

---Postseason--
UPDATE fts
SET fts.DimTicketTypeId = 22
--SELECT DISTINCT season.Seasoncode, season.SeasonName, di.ItemCode, di.ItemName, PriceTYpeCode, PriceTypeName
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
WHERE 1=1
AND DimticketTypeID <= '0'
AND (SeasonCode LIKE 'B1%' OR SeasonCode LIKE 'SB%')
AND (ItemCode LIKE 'R%' OR ItemCode LIKE 'SR%')
OR ItemCode IN ('FCG', 'PAC12', 'SUN', 'CB', 'NCAA', 'FF', 'RB', 'NIT1', 'NIT3', 'P10', 'NCAA1')

UPDATE fts
SET fts.DimTicketTypeId = 22
 FROM    dbo.FactTicketSales_History_V2 fts
        INNER JOIN dbo.DimItem_V2 di ON fts.DimItemId = di.DimItemId
		  JOIN dbo.DimSeason_V2 season ON season.DimSeasonId = fts.DimSeasonId
WHERE 1=1
AND (SeasonCode LIKE 'BB%' OR Seasoncode LIKE 'WB%')
AND ItemCode LIKE 'S[1-9]%' 



--/*****************************************************************************************************************
--															SEAT TYPE
--******************************************************************************************************************/

------Student-----

--UPDATE fts
--SET fts.DimSeatTypeId = 1
--FROM    dbo.FactTicketSales fts
--        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
--        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
--		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
--        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
----WHERE  PC1 = '1'

------SUITES----

--UPDATE fts
--SET fts.DimSeatTypeId = 2
--FROM    dbo.FactTicketSales fts
--        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
--        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
--		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
--        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
----WHERE PC1 = '2'
	   
------CLUB----

--UPDATE fts
--SET fts.DimSeatTypeId = 3
--FROM    dbo.FactTicketSales fts
--        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
--        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
--		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
--        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
--WHERE PC1 = '3'
	   
	   
----LOGE ----

UPDATE fts
SET fts.DimSeatTypeId = 4
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
--WHERE PC1 = '4'

----LOWER BOWL----

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM   dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
--WHERE PC1 = '5'

----UPPER BOWL----

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM   dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceCode PriceCode ON PriceCode.DimPriceCodeId = fts.DimPriceCodeId
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
		INNER JOIN dbo.DimSeason ds ON ds.DimSeasonId = fts.dimseasonID
        JOIN dbo.DimDate DimDate ON DimDate.DimDateId = fts.DimDateId
--WHERE (SeasonName LIKE 'NHL%' OR SeasonName LIKE 'WHL%')
--	   AND  PC1 IN ('6','7')



/*****************************************************************************************************************
													FACT TAGS
******************************************************************************************************************/

----IsComp TRUE--

--UPDATE f
--SET f.IsComp = 1
--FROM dbo.FactTicketSales f
--	JOIN dbo.DimPriceCode dpc
--	ON dpc.DimPriceCodeId = f.DimPriceCodeId
--WHERE f.CompCode <> '0'

----IsComp FALSE--

--UPDATE f
--SET f.IsComp = 0
--FROM dbo.FactTicketSales f
--	JOIN dbo.DimPriceCode dpc
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
FROM dbo.FactTicketSales f
JOIN dbo.DimTicketType tt ON f.DimTicketTypeId = tt.DimTicketTypeId
WHERE tt.TicketTypeClass IN ('Season Ticket')


----Is Partial Plan--

UPDATE f
SET f.IsPlan = 1
, f.IsPartial = 1
, f.IsSingleEvent = 0
, f.IsGroup = 0
FROM dbo.FactTicketSales f
JOIN dbo.DimTicketType tt ON f.DimTicketTypeId = tt.DimTicketTypeId
WHERE tt.TicketTypeClass IN ('Partial Plan')



----Is Group--

UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 1
FROM dbo.FactTicketSales f
WHERE DimTicketTypeId IN ('9') 
----/*Group */

----Is Single, not Group--

UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 0
FROM dbo.FactTicketSales f
JOIN dbo.DimTicketType tt ON f.DimTicketTypeId = tt.DimTicketTypeId
WHERE TicketTypeClass = 'Single'
AND f.DimTicketTypeId <> '9' 
----/*Single Game*/


----is Premium TRUE--

--UPDATE f
--SET f.IsPremium = 1
--FROM dbo.FactTicketSales  f
--INNER JOIN dbo.DimSeatType dst ON f.DimSeatTypeId = dst.DimSeatTypeId
--WHERE dst.DimSeatTypeId IN ('1', '2', '3', '4', '5')

----is Premium FALSE--

--UPDATE f
--SET f.IsPremium = 0
--FROM dbo.FactTicketSales f
--INNER JOIN dbo.DimSeatType dst ON f.DimSeatTypeId = dst.DimSeatTypeId
--WHERE dst.SeatTypeCode IN ('-1', '6', '7', '8', '9', '10')

----is Renewal TRUE--

UPDATE f
SET f.IsRenewal = 1
FROM dbo.FactTicketSales f
INNER JOIN dbo.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.PlanTypeCode IN ('RENEW')



----is Renewal FALSE--

UPDATE f
SET f.IsRenewal = 0
FROM dbo.FactTicketSales f
INNER JOIN dbo.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
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
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType PriceType ON PriceType.DimPriceTypeId = fts.DimPriceTypeId
WHERE   fts.IsPlan = 1
		AND (PriceType.PriceTypeCode LIKE 'N%'
				OR PriceType.PriceTypeCode LIKE 'BN%')


------ADD-ON----

UPDATE fts
SET fts.DimPlanTypeId = 1
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType PriceType ON PriceType.DimPriceTypeId = fts.DimPriceTypeId
WHERE   fts.IsPlan = 1
		AND PriceType.PriceTypeCode LIKE '%A'

------RENEW----

UPDATE fts
SET fts.DimPlanTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType PriceType ON PriceType.DimPriceTypeId = fts.DimPriceTypeId
WHERE   fts.IsPlan = 1
AND (PriceType.PriceTypeCode NOT LIKE 'N%'
OR PriceType.PriceTypeCode NOT LIKE 'BN%'
OR PriceType.PriceTypeCode NOT LIKE '%A')

------NO PLAN----


UPDATE fts
SET fts.DimPlanTypeId = 3
FROM    dbo.FactTicketSales fts
WHERE   IsPlan = 0

END 























GO
