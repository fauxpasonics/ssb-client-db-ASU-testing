SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[TM_Stage_FactTicketSales] 
( 
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000', 
	@Options NVARCHAR(max) = NULL 
) 
 
AS 
BEGIN 
 

DECLARE @OptionsXML XML = TRY_CAST(@Options AS XML)


DECLARE @LoadDate DATETIME = (GETDATE() - 2)

SELECT @LoadDate = t.x.value('LoadDate[1]','DateTime')
FROM @OptionsXML.nodes('options') t(x)

PRINT @LoadDate


SELECT tkt.*
, CAST(CASE WHEN tkt.order_num IS NULL THEN 1 ELSE 0 END AS BIT) ssbIsHost
, REPLACE(tkt.price_code, '*','') ssbPriceCode
INTO #tkt
FROM ods.TM_vw_Ticket tkt
INNER JOIN ods.TM_Evnt e ON tkt.event_id = e.Event_id
LEFT OUTER JOIN etl.vw_DimItem dItem ON CASE WHEN ISNULL(tkt.plan_event_id,0) = 0 THEN tkt.event_id ELSE tkt.plan_event_id END = dItem.ETL__SSID_TM_event_id AND dItem.ETL__SourceSystem = 'TM' AND dItem.DimItemId > 0
WHERE ISNULL(dItem.Config_IsFactSalesEligible,1) = 1 AND ISNULL(dItem.Config_IsClosed,0) = 0
and tkt.UpdateDate >= @LoadDate



CREATE NONCLUSTERED INDEX IDX_event_id ON #tkt (event_id)
CREATE NONCLUSTERED INDEX IDX_plan_event_id ON #tkt (plan_event_id)
CREATE NONCLUSTERED INDEX IDX_acct_id ON #tkt (acct_id)
CREATE NONCLUSTERED INDEX IDX_acct_Rep_id ON #tkt (acct_Rep_id, orig_acct_rep_id)
CREATE NONCLUSTERED INDEX IDX_sell_location ON #tkt (sell_location)
CREATE NONCLUSTERED INDEX IDX_ssbIsHost ON #tkt (ssbIsHost)
CREATE NONCLUSTERED INDEX IDX_ssbPriceCode ON #tkt (ssbPriceCode)
CREATE NONCLUSTERED INDEX IDX_promo_code ON #tkt (promo_code)
CREATE NONCLUSTERED INDEX IDX_price_code ON #tkt (price_code)
CREATE NONCLUSTERED INDEX IDX_ledger_id ON #tkt (ledger_id)
CREATE NONCLUSTERED INDEX IDX_srs ON #tkt (section_id, row_id, seat_num)



TRUNCATE TABLE stg.TM_FactTicketSales

INSERT INTO stg.TM_FactTicketSales
( 
	ETL__SSID, ETL__SSID_TM_event_id, ETL__SSID_TM_section_id, ETL__SSID_TM_row_id,
	ETL__SSID_TM_seat_num, ETL__SSID_TM_acct_id, ETL__SSID_TM_price_code, DimDateId, DimTimeId, DimTicketCustomerId, DimArenaId, DimSeasonId, DimItemId,
	DimEventId, DimPlanId, DimPriceLevelId, DimPriceTypeId, DimPriceCodeId, DimLedgerId, DimSeatId_Start, DimSeatStatusId, DimRepId, DimSalesCodeId,
	DimPromoId, DimEventZoneId, DimOfferId, DimPlanTypeId, DimTicketTypeId, DimSeatTypeId, DimTicketClassId, OrderDate, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate,
	QtySeat, QtySeatFSE, QtySeatRenewable, RevenueTicket, RevenueFees, RevenueSurcharge, RevenueTax, RevenueTotal, FullPrice, Discount, PaidStatus,
	PaidAmount, OwedAmount, PaymentDateFirst, PaymentDateLast, IsSold, IsReserved, IsReturned, IsPremium, IsDiscount, IsComp, IsHost, IsPlan, IsPartial,
	IsSingleEvent, IsGroup, IsBroker, IsRenewal, IsExpanded, IsAutoRenewalNextSeason, TM_order_num, TM_order_line_item, TM_order_line_item_seq,
	TM_purchase_price, TM_block_purchase_price, TM_pc_ticket, TM_pc_tax, TM_pc_licfee, TM_pc_other1, TM_pc_other2, TM_pc_other3, TM_pc_other4,
	TM_pc_other5, TM_pc_other6, TM_pc_other7, TM_pc_other8, TM_comp_code, TM_comp_name, TM_surchg_code_desc, TM_group_sales_name, TM_Ticket_Type,
	TM_tran_type, TM_sales_source_name, TM_retail_ticket_type, TM_retail_qualifiers, TM_retail_mask, TM_ticket_seq_id 
)


SELECT 

	CONCAT(tkt.event_id, ':', tkt.section_id, ':', tkt.row_id, ':', tkt.seat_num) ETL__SSID
	, tkt.event_id ETL__SSID_TM_event_id
	, tkt.section_id ETL__SSID_TM_section_id
	, tkt.row_id ETL__SSID_TM_row_id
	, tkt.seat_num ETL__SSID_TM_seat_num
	, tkt.acct_id ETL__SSID_TM_acct_id
	, tkt.price_code ETL__SSID_TM_price_code

	, CONVERT(VARCHAR, tkt.add_datetime, 112) DimDateId
	, datediff(second, cast(tkt.add_datetime as date), tkt.add_datetime) DimTimeId
	, ISNULL(dTicketCustomer.DimTicketCustomerId, -1) DimTicketCustomerId
	, COALESCE(dArena.DimArenaId, dSeason.DimArenaId, dEvent.DimArenaId, -1) DimArenaId
	, COALESCE(dSeason.DimSeasonId,dItem.dimSeasonId, -1) DimSeasonId
	, isnull(dItem.DimItemId, -1) DimItemId
	, case when tkt.event_id = tkt.plan_event_id THEN 0 else isnull(dEvent.DimEventId, -1) end DimEventId
	, case when ISNULL(tkt.plan_event_id,0) = 0 then 0 else isnull(dPlan.DimPlanId, -1) end	DimPlanId
	, 0 DimPriceLevelId
	, 0 DimPriceTypeId
	, isnull(isnull(dPriceCode.DimPriceCodeId, dPriceCodePlan.DimPriceCodeId), -1) DimPriceCodeId	
	, ISNULL(CASE 
		WHEN tkt.ssbIsHost = 1 THEN 0
		WHEN tkt.ssbIsHost = 0 and tkt.ledger_id = 0 THEN 1
		WHEN tkt.ssbIsHost = 0 AND tkt.ledger_id IS NOT NULL THEN ISNULL(dLedger.DimLedgerId, -1)
		ELSE -1
	END, 0) DimLedgerId
	, isnull(dSeat.DimSeatId, -1) DimSeatId_Start
	, isnull(dSeatStatus.DimSeatStatusId, -1) DimSeatStatusId	
	, case when ISNULL(tkt.orig_acct_rep_id,0) = 0 then 0 else isnull(dRep.DimRepId, -1) end	DimRepId
	, case when isnull(tkt.sell_location,'') = '' then 0 else COALESCE(dSalesCode.DimSalesCodeId, dSalesCodeName.DimSalesCodeId, -1) end DimSalesCodeId
	, case when isnull(tkt.promo_code,'') = '' then 0 else isnull(dPromo.DimPromoId, -1) end DimPromoId

	, -1 DimEventZoneId
	, -1 DimOfferId

	, -1 DimPlanTypeId
	, -1 DimTicketTypeId
	, -1 DimSeatTypeId
	, -1 DimTicketClassId
	
	, tkt.add_datetime OrderDate
	, tkt.add_user SSCreatedBy
	, tkt.upd_user SSUpdatedBy
	, tkt.add_datetime SSCreatedDate
	, tkt.upd_datetime SSUpdatedDate

	, tkt.num_seats QtySeat
	, CAST (
		CASE 
			WHEN dplan.DimPlanId > 0 AND ISNULL(dEvent.Config_IsFseEligible, 1) = 1 THEN tkt.num_seats / CAST(ISNULL(dSeason.Config_SeasonEventCntFSE, dSeason.SeasonEventCntFSE) AS DECIMAL(18,6)) 
			WHEN dplan.DimPlanId > 0 AND dEvent.DimEventId IS NULL AND ISNULL(dplan.PlanFSE,0) > 0 THEN tkt.num_seats * dplan.PlanFSE
			ELSE 0 
		END 
	AS DECIMAL(18,6)) QtySeatFSE
	, CAST(CASE WHEN dplan.DimPlanId > 0 AND dEvent.DimEventId = ISNULL(dPlan.Config_PlanRenewableDimEventId, dPlan.PlanRenewableDimEventId) THEN tkt.num_seats ELSE 0 END AS INT) QtySeatRenewable
	

	, CAST(0 AS DECIMAL(18,6)) RevenueTicket
	, CAST(0 AS DECIMAL(18,6)) RevenueFees
	, CAST(0 AS DECIMAL(18,6)) RevenueSurcharge
	, CAST(0 AS DECIMAL(18,6)) RevenueTax
	, tkt.block_purchase_price RevenueTotal

	, (tkt.full_price * tkt.num_seats) FullPrice
	, ((tkt.full_price * tkt.num_seats) - tkt.block_purchase_price) Discount
	
	, tkt.Paid PaidStatus
	, CASE 
		WHEN tkt.block_purchase_price = 0 OR ((CAST(paid_amount AS DECIMAL(18,6)) + CAST(owed_amount AS DECIMAL(18,6))) = 0) THEN CAST(0 AS DECIMAL(18,6))
		WHEN tkt.Paid = 'Y' then CAST(tkt.block_purchase_price AS DECIMAL(18,6))
		WHEN tkt.Paid = 'N' then CAST(0 AS DECIMAL(18,6))				 
		WHEN tkt.Paid = 'P' then CAST(tkt.block_purchase_price AS DECIMAL(18,6)) * (CAST(paid_amount AS DECIMAL(18,6)) / (CAST(paid_amount AS DECIMAL(18,6)) + CAST(owed_amount AS DECIMAL(18,6))))
		ELSE CAST(ISNULL(tkt.paid_amount, 0) AS DECIMAL(18,6))
	END PaidAmount
	, CASE 
		WHEN tkt.block_purchase_price = 0 OR ((CAST(paid_amount AS DECIMAL(18,6)) + CAST(owed_amount AS DECIMAL(18,6))) = 0) THEN CAST(0 AS DECIMAL(18,6))
		WHEN tkt.Paid = 'Y' then CAST(0 AS DECIMAL(18,6))
		WHEN tkt.Paid = 'N' then CAST(tkt.block_purchase_price AS DECIMAL(18,6))	
		WHEN tkt.Paid = 'P' then CAST(tkt.block_purchase_price AS DECIMAL(18,6)) * (CAST(owed_amount AS DECIMAL(18,6)) / (CAST(paid_amount AS DECIMAL(18,6)) + CAST(owed_amount AS DECIMAL(18,6))))
		ELSE CAST(tkt.owed_amount AS DECIMAL(18,6))
	END OwedAmount
	, CAST(NULL AS DATETIME) PaymentDateFirst
	, CAST(NULL AS DATETIME) PaymentDateLast

	, CAST(1 AS BIT) IsSold
	, CAST(0 AS BIT) IsReserved
	, CAST(0 AS BIT)  IsReturned
	, CAST(NULL AS BIT) IsPremium
	, CAST(NULL AS BIT)  IsDiscount
	, CAST(CASE WHEN tkt.comp_code > 0 THEN 1 ELSE 0 END AS bit) as IsComp
	, tkt.ssbIsHost as IsHost
	, CAST(CASE WHEN ISNULL(tkt.plan_event_id,0) > 0 THEN 1 ELSE 0 END AS bit) as IsPlan
	, CAST(NULL AS BIT) IsPartial
	, CAST(CASE WHEN dplan.DimPlanId IS NULL THEN 1 ELSE 0 END AS bit) IsSingleEvent
	, CAST(CASE WHEN tkt.group_flag = 'Y' THEN 1 ELSE 0 END AS bit) IsGroup
	, CAST(NULL AS BIT)  IsBroker
	, CAST(NULL AS BIT)  IsRenewal
	, CAST(NULL AS BIT)  IsExpanded
	, CAST(CASE WHEN tkt.renewal_ind = 'Y' THEN 1 ELSE 0 END AS bit) IsAutoRenewalNextSeason	

	, tkt.order_num TM_OrderNum
	, tkt.order_line_item TM_OrderLineItem
	, tkt.order_line_item_seq TM_OrderLineItemSeq
	, tkt.purchase_price TM_PurchasePrice
	, tkt.block_purchase_price TM_BlockPurchasePrice
	, tkt.pc_ticket TM_PcTicket
	, tkt.pc_tax TM_PcTax
	, tkt.pc_licfee TM_PcLicenseFee
	, tkt.pc_other1 TM_PcOther1
	, tkt.pc_other2 TM_PcOther2
	, tkt.pc_other3 TM_PcOther3
	, tkt.pc_other4 TM_PcOther4
	, tkt.pc_other5 TM_PcOther5
	, tkt.pc_other6 TM_PcOther6
	, tkt.pc_other7 TM_PcOther7
	, tkt.pc_other8 TM_PcOther8
	, tkt.comp_code TM_CompCode
	, tkt.comp_name TM_CompName
	, tkt.surchg_code_desc TM_SurchargeCode
	, tkt.group_sales_name TM_GroupSalesName
	, tkt.Ticket_Type TM_TicketType
	, tkt.tran_type TM_TranType
	, tkt.sales_source_name TM_SalesSource
	, tkt.retail_ticket_type TM_RetailTicketType
	, tkt.retail_qualifiers TM_RetailQualifiers
	, tkt.retail_mask TM_RetailMask
	, tkt.ticket_seq_id TM_TicketSeqId

--SELECT COUNT(*)
FROM #tkt tkt

LEFT OUTER JOIN etl.vw_DimEvent (nolock) dEvent ON tkt.event_id = dEvent.ETL__SSID_TM_event_id
	AND dEvent.ETL__SourceSystem = 'TM' AND dEvent.DimEventId > 0 AND dEvent.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimItem (nolock) dItem ON CASE WHEN ISNULL(tkt.plan_event_id,0) = 0 THEN tkt.event_id ELSE tkt.plan_event_id END = dItem.ETL__SSID_TM_event_id
	AND dItem.ETL__SourceSystem = 'TM' AND dItem.DimItemId > 0 AND dItem.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimPlan (nolock) dPlan ON tkt.plan_event_id = dPlan.ETL__SSID_TM_event_id
	AND dPlan.ETL__SourceSystem = 'TM' AND dPlan.DimPlanId > 0 AND dPlan.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimArena (nolock) dArena ON dEvent.TM_arena_id = dArena.ETL__SSID_TM_arena_id
	AND dArena.ETL__SourceSystem = 'TM' AND dArena.DimArenaId > 0 AND dArena.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimSeason (nolock) dSeason ON ISNULL(dEvent.TM_season_id, dItem.TM_season_id) = dSeason.ETL__SSID_TM_season_Id
	AND dSeason.ETL__SourceSystem = 'TM' AND dSeason.DimSeasonId > 0 AND dSeason.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimPromo (nolock) dPromo ON tkt.promo_code = dPromo.ETL__SSID_TM_promo_code
	AND dPromo.ETL__SourceSystem = 'TM' AND dPromo.DimPromoId > 0 AND dPromo.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimSalesCode (nolock) dSalesCode ON tkt.sell_location = CAST(dSalesCode.ETL__SSID_TM_sell_location_id AS NVARCHAR(255))
	AND dSalesCode.ETL__SourceSystem = 'TM' AND dSalesCode.DimSalesCodeId > 0 AND dSalesCode.ETL__IsDeleted = 0
	
LEFT OUTER JOIN (
	SELECT a.DimSalesCodeId, a.ETL__IsDeleted, a.ETL__SourceSystem, a.ETL__SSID_TM_sell_location_id, a.SalesCodeName
	FROM (
		SELECT DimSalesCodeId, ETL__IsDeleted, ETL__SourceSystem, ETL__SSID_TM_sell_location_id, SalesCodeName
		, ROW_NUMBER() OVER (PARTITION BY SalesCodeName ORDER BY ETL__UpdatedDate DESC) RowRank
		FROM etl.vw_DimSalesCode
		WHERE ETL__IsDeleted = 0
	) a 
	WHERE RowRank = 1	
) dSalesCodeName ON tkt.sell_location = dSalesCodeName.SalesCodeName
	AND dSalesCodeName.ETL__SourceSystem = 'TM' AND dSalesCodeName.DimSalesCodeId > 0 AND dSalesCodeName.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimPriceCode (nolock) dPriceCode ON tkt.event_id = dPriceCode.ETL__SSID_TM_event_id AND tkt.ssbPriceCode = dPriceCode.ETL__SSID_TM_price_code
	AND dPriceCode.ETL__SourceSystem = 'TM' AND dPriceCode.DimPriceCodeId > 0 AND dPriceCode.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimPriceCode (nolock) dPriceCodePlan ON tkt.plan_event_id = dPriceCodePlan.ETL__SSID_TM_event_id AND tkt.ssbPriceCode = dPriceCodePlan.ETL__SSID_TM_price_code
	AND dPriceCodePlan.ETL__SourceSystem = 'TM' AND dPriceCodePlan.DimPriceCodeId > 0 AND dPriceCodePlan.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimTicketCustomer (nolock) dTicketCustomer ON tkt.acct_id = dTicketCustomer.ETL__SSID_TM_acct_id
	AND dTicketCustomer.ETL__SourceSystem = 'TM' AND dTicketCustomer.DimTicketCustomerId > 0 AND dTicketCustomer.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimSeat (nolock) dSeat ON ISNULL(dEvent.TM_manifest_id, dSeason.TM_manifest_id) = dSeat.ETL__SSID_TM_Manifest_Id AND tkt.section_id = dSeat.ETL__SSID_TM_Section_Id AND tkt.row_id = dSeat.ETL__SSID_TM_Row_Id AND tkt.seat_num = dSeat.ETL__SSID_TM_Seat
	AND dSeat.ETL__SourceSystem = 'TM' AND dSeat.DimSeatId > 0 AND dSeat.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimSeatStatus (nolock) dSeatStatus ON tkt.class_name = dSeatStatus.SeatStatusName
	AND dSeatStatus.ETL__SourceSystem = 'TM' AND dSeatStatus.DimSeatStatusId > 0 AND dSeatStatus.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimRep (nolock) dRep ON tkt.orig_acct_rep_id = dRep.ETL__SSID_TM_acct_id
	AND dRep.ETL__SourceSystem = 'TM' AND dRep.DimRepId > 0 AND dRep.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimLedger (nolock) dLedger ON tkt.ledger_id = dLedger.ETL__SSID_TM_ledger_id
	AND dLedger.ETL__SourceSystem = 'TM' AND dLedger.DimLedgerId > 0 AND dLedger.ETL__IsDeleted = 0

 
DROP TABLE #tkt

END 




GO
