SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   VIEW [etl].[vw_TicketTaggingLogic_GenerateTestScripts]
		AS

SELECT ttl.TagType, ttl.TagTypeTableID, ttl.TagTypeRank, CONCAT(
'/*** ', ttl.TagType, ' ', ttl.TagTypeTableID, ': ', COALESCE(tt.TicketTypeName, pt.PlanTypeName, tc.TicketClassName, st.SeatTypeName), ' ***/
SELECT *
FROM dbo.FactTicketSales_V2 TicketSales (NOLOCK)
JOIN dbo.DimSeason_V2 Season (NOLOCK)
	on TicketSales.DimSeasonID = Season.DimSeasonID'
-- DimEvent --
, CASE WHEN ttl.logic LIKE 'Event.%' OR ttl.logic LIKE '% Event.%' OR ttl.logic LIKE '%(Event.%' THEN '
JOIN dbo.DimEvent_V2 Event (NOLOCK)
	on TicketSales.DimEventID = Event.DimEventID' ELSE '' END

-- DimItem --
, CASE WHEN ttl.logic LIKE 'Item.%' OR ttl.logic LIKE '% Item.%' OR ttl.logic LIKE '%(Item.%' THEN '
JOIN dbo.DimItem_V2 Item (NOLOCK)
	on TicketSales.DimItemID = Item.DimItemID' ELSE '' END

-- DimPlan --
, CASE WHEN ttl.logic LIKE 'PlanCode.%' OR ttl.logic LIKE '% PlanCode.%' OR ttl.logic LIKE '%(PlanCode.%' THEN '
JOIN dbo.DimPlan_V2 PlanCode (NOLOCK)
	on TicketSales.DimPlanID = PlanCode.DimPlanID' ELSE '' END

-- DimPriceCode --
, CASE WHEN ttl.logic LIKE 'PriceCode.%' OR ttl.logic LIKE '% PriceCode.%' OR ttl.logic LIKE '%(PriceCode.%' THEN '
JOIN dbo.DimPriceCode_V2 PriceCode (NOLOCK)
	on TicketSales.DimPriceCodeID = PriceCode.DimPriceCodeID' ELSE '' END

-- DimSeat --
, CASE WHEN ttl.logic LIKE 'Seat.%' OR ttl.logic LIKE '% Seat.%' OR ttl.logic LIKE '%(Seat.%' THEN '
JOIN dbo.DimSeat_V2 Seat (NOLOCK)
	on TicketSales.DimSeatID_Start = Seat.DimSeatID' ELSE '' END

-- DimLedger --
, CASE WHEN ttl.logic LIKE 'Ledger.%' OR ttl.logic LIKE '% Ledger.%' OR ttl.logic LIKE '%(Ledger.%' THEN '
JOIN dbo.DimLedger_V2 Ledger (NOLOCK)
	on TicketSales.DimLedgerID = Ledger.DimLedgerID' ELSE '' END

-- DimTicketType --
, CASE WHEN ttl.logic LIKE 'TicketType.%' OR ttl.logic LIKE '% TicketType.%' OR ttl.logic LIKE '%(TicketType.%' THEN '
JOIN dbo.DimTicketType_V2 TicketType (NOLOCK)
	on TicketSales.DimTicketTypeID = TicketType.DimTicketTypeID' ELSE '' END

-- DimPlanType --
, CASE WHEN ttl.logic LIKE 'PlanType.%' OR ttl.logic LIKE '% PlanType.%' OR ttl.logic LIKE '%(PlanType.%' THEN '
JOIN dbo.DimPlanType_V2 PlanType (NOLOCK)
	ON TicketSales.DimPlanTypeID = PlanType.DimPlanTypeID' ELSE '' END

-- DimTicketClass --
, CASE WHEN ttl.logic LIKE 'TicketClass.%' OR ttl.logic LIKE '% TicketClass.%' OR ttl.logic LIKE '%(TicketClass.%' THEN '
JOIN dbo.DimTicketClass_V2 TicketClass (NOLOCK)
	on TicketSales.DimTicketClassID = TicketClass.DimTicketClassID' ELSE '' END

-- DimSeatType --
, CASE WHEN ttl.logic LIKE 'SeatType.%' OR ttl.logic LIKE '% SeatType.%' OR ttl.logic LIKE '%(SeatType.%' THEN '
JOIN dbo.DimSeatType_V2 SeatType (NOLOCK)
	on TicketSales.DimSeatTypeID = SeatType.DimSeatTypeID' ELSE '' END

-- DimEventHeader --
,CASE WHEN ttl.logic LIKE 'EventHeader.%' OR ttl.logic LIKE '% EventHeader.%' OR ttl.logic LIKE '%(EventHeader.%' THEN '
JOIN dbo.DimEvent_V2 Event (NOLOCK)
	on TicketSales.DimEventID = Event.DimEventID
JOIN dbo.DimEventHeader_V2 EventHeader (NOLOCK)
	on Event.DimEventHeaderID = EventHeader.DimEventHeaderID' ELSE '' END

-- DimEventZone --
, CASE WHEN ttl.logic LIKE 'EventZone.%' OR ttl.logic LIKE '% EventZone.%' OR ttl.logic LIKE '%(EventZone.%' THEN '
JOIN dbo.DimEventZone_V2 EventZone (NOLOCK)
	on TicketSales.DimEventZoneID = EventZone.DimEventZoneID' ELSE '' END

-- DimPriceLevel --
, CASE WHEN ttl.logic LIKE 'PriceLevel.%' OR ttl.logic LIKE '% PriceLevel.%' OR ttl.logic LIKE '%(PriceLevel.%' THEN '
JOIN dbo.DimPriceLevel_V2 PriceLevel (NOLOCK)
	on TicketSales.DimPriceLevelID = PriceLevel.DimPriceLevelID' ELSE '' END

-- DimSeatStatus --
, CASE WHEN ttl.logic LIKE 'SeatStatus.%' OR ttl.logic LIKE '% SeatStatus.%' OR ttl.logic LIKE '%(SeatStatus.%' THEN '
JOIN dbo.DimSeatStatus_V2 SeatStatus (NOLOCK)
	on TicketSales.DimSeatStatusID = SeatStatus.DimPSeatStatusID' ELSE '' END

-- DimPriceType --
, CASE WHEN ttl.logic LIKE 'PriceType.%' OR ttl.logic LIKE '% PriceType.%' OR ttl.logic LIKE '%(PriceType.%' THEN '
JOIN dbo.DimPriceType_V2 PriceType (NOLOCK)
	on TicketSales.DimPriceTypeID = PriceType.DimPriceTypeID' ELSE '' END

-- DimRep --
, CASE WHEN ttl.logic LIKE 'Rep.%' OR ttl.logic LIKE '% Rep.%' OR ttl.logic LIKE '%(Rep.%' THEN '
JOIN dbo.DimRep_V2 Rep (NOLOCK)
	on TicketSales.DimRepID = Rep.DimRepID' ELSE '' END

-- DimOffer --
, CASE WHEN ttl.logic LIKE 'Offer.%' OR ttl.logic LIKE '% Offer.%' OR ttl.logic LIKE '%(Offer.%' THEN '
JOIN dbo.DimOffer_V2 Offer (NOLOCK)
	on TicketSales.DimOfferID = Offer.DimOfferID' ELSE '' END

-- DimSalesCode --
, CASE WHEN ttl.logic LIKE 'SalesCode.%' OR ttl.logic LIKE '% SalesCode.%' OR ttl.logic LIKE '%(SalesCode.%' THEN '
JOIN dbo.DimSalesCode_V2 SalesCode (NOLOCK)
	on TicketSales.DimSalesCodeID = SalesCode.DimSalesCodeID' ELSE '' END

-- DimPromo --
, CASE WHEN ttl.logic LIKE 'Promo.%' OR ttl.logic LIKE '% Promo.%' OR ttl.logic LIKE '%(Promo.%' THEN '
JOIN dbo.DimPromo_V2 Promo (NOLOCK)
	on TicketSales.DimPromoID = Promo.DimPromoID' ELSE '' END

-- TM_Ticket --
, CASE WHEN ttl.logic LIKE 'odstkt.%' OR ttl.logic LIKE '% odstkt.%' OR ttl.logic LIKE '%(odstkt.%' THEN '
JOIN ods.TM_Ticket odstkt (NOLOCK)
	ON TicketSales.TM_order_num = odstkt.order_num
	AND TicketSales.TM_order_line_item = odstkt.order_line_item' ELSE '' END
, '
WHERE (', ttl.Logic, ')
	AND Season.DimSeasonID IN (', ttl.DimSeasonID, ')




') TagUpdateScript
FROM etl.TicketTaggingLogic ttl (NOLOCK)
LEFT JOIN dbo.DimTicketType_V2 tt (NOLOCK)
	ON ttl.TagType = 'TicketType'
	AND ttl.TagTypeTableID = tt.DimTicketTypeId
LEFT JOIN dbo.DimPlanType_V2 pt (NOLOCK)
	ON ttl.TagType = 'PlanType'
	AND ttl.TagTypeTableID = pt.DimPlanTypeId
LEFT JOIN dbo.DimTicketClass_V2 tc (NOLOCK)
	ON ttl.TagType = 'TicketClass'
	AND ttl.TagTypeTableID = tc.DimTicketClassId
LEFT JOIN dbo.DimSeatType_V2 st (NOLOCK)
	ON ttl.TagType = 'SeatType'
	AND ttl.TagTypeTableID = st.DimSeatTypeId
WHERE ISNULL(ttl.Logic, '') <> ''
	AND ttl.TagType IN ('TicketType', 'PlanType', 'TicketClass', 'SeatType')

UNION ALL

SELECT ttl.TagType, ttl.TagTypeTableID, ttl.TagTypeRank, CONCAT(
'/* Seat Config_Location:', ttl.Config_Location, ' */
SELECT *
FROM dbo.DimSeat_V2 Seat
WHERE (', ttl.Logic, ')


') TagUpdateScript
FROM etl.TicketTaggingLogic ttl (NOLOCK)
WHERE ISNULL(ttl.Logic, '') <> ''
	AND ttl.TagType IN ('Config_Location')
GO
