SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[TM_LoadFactTicketSales]
( 
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000', 
	@Options NVARCHAR(max) = NULL 
) 
 
AS 
BEGIN 

SELECT tkt.*
, CAST(CASE WHEN tkt.order_num IS NULL THEN 1 ELSE 0 END AS BIT) ssbIsHost
, REPLACE(tkt.price_code, '*','') ssbPriceCode
INTO #tkt
FROM ods.TM_vw_Ticket tkt


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



TRUNCATE TABLE dbo.FactTicketSales_V2

INSERT INTO dbo.FactTicketSales_V2
( 
	ETL__SourceSystem, ETL__CreatedBy, ETL__CreatedDate, ETL__UpdatedDate, ETL__SSID, ETL__SSID_TM_event_id, ETL__SSID_TM_section_id, ETL__SSID_TM_row_id,
	ETL__SSID_TM_seat_num, ETL__SSID_TM_acct_id, ETL__SSID_TM_price_code, DimDateId, DimTimeId, DimTicketCustomerId, DimArenaId, DimSeasonId, DimItemId,
	DimEventId, DimPlanId, DimPriceLevelId, DimPriceTypeId, DimPriceCodeId, DimLedgerId, DimSeatId_Start, DimSeatStatusId, DimRepId, DimSalesCodeId,
	DimPromoId, DimPlanTypeId, DimTicketTypeId, DimSeatTypeId, DimTicketClassId, OrderDate, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate,
	QtySeat, QtySeatFSE, QtySeatRenewable, RevenueTicket, RevenueFees, RevenueSurcharge, RevenueTax, RevenueTotal, FullPrice, Discount, PaidStatus,
	PaidAmount, OwedAmount, PaymentDateFirst, PaymentDateLast, IsSold, IsReserved, IsReturned, IsPremium, IsDiscount, IsComp, IsHost, IsPlan, IsPartial,
	IsSingleEvent, IsGroup, IsBroker, IsRenewal, IsExpanded, IsAutoRenewalNextSeason, TM_order_num, TM_order_line_item, TM_order_line_item_seq,
	TM_purchase_price, TM_block_purchase_price, TM_pc_ticket, TM_pc_tax, TM_pc_licfee, TM_pc_other1, TM_pc_other2, TM_pc_other3, TM_pc_other4,
	TM_pc_other5, TM_pc_other6, TM_pc_other7, TM_pc_other8, TM_comp_code, TM_comp_name, TM_surchg_code_desc, TM_group_sales_name, TM_Ticket_Type,
	TM_tran_type, TM_sales_source_name, TM_retail_ticket_type, TM_retail_qualifiers, TM_retail_mask, TM_ticket_seq_id 
)


SELECT 

	'TM' ETL__SourceSystem, SUSER_NAME() ETL__CreatedBy, GETDATE() ETL__CreatedDate, GETDATE() ETL__UpdatedDate

	, CONCAT(tkt.event_id, ':', tkt.section_id, ':', tkt.row_id, ':', tkt.seat_num) ETL__SSID
	, tkt.event_id ETL__SSID_TM_event_id
	, tkt.section_id ETL__SSID_TM_section_id
	, tkt.row_id ETL__SSID_TM_row_id
	, tkt.seat_num ETL__SSID_TM_seat_num
	, tkt.acct_id ETL__SSID_TM_acct_id
	, tkt.price_code ETL__SSID_TM_price_code

	, CONVERT(VARCHAR, tkt.add_datetime, 112) DimDateId
	, datediff(second, cast(tkt.add_datetime as date), tkt.add_datetime) DimTimeId
	, ISNULL(dTicketCustomer.DimTicketCustomerId, -1) DimTicketCustomerId
	, isnull(dArena.DimArenaId, -1) DimArenaId
	, isnull(dSeason.DimSeasonId, -1) DimSeasonId
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
	, case when isnull(tkt.sell_location,'') = '' then 0 else isnull(dSalesCode.DimSalesCodeId, -1) end DimSalesCodeId
	, case when isnull(tkt.promo_code,'') = '' then 0 else isnull(dPromo.DimPromoId, -1) end DimPromoId

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
	, CAST(0 AS DECIMAL(18,6)) QtySeatFSE
	, CAST(0 AS INT) QtySeatRenewable

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

--SELECT DISTINCT dEvent.TM_arena_id, dEvent.TM_season_id
--FROM dev.FactTicketSalesTM tkt
FROM #tkt tkt
LEFT OUTER JOIN dbo.DimEvent (nolock) dEvent ON tkt.event_id = dEvent.ETL__SSID_TM_event_id AND dEvent.ETL__SourceSystem = 'TM' AND dEvent.DimEventId > 0
	AND tkt.add_datetime BETWEEN dEvent.ETL__StartDate AND ISNULL(dEvent.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimArena (nolock) dArena ON dEvent.TM_arena_id = dArena.ETL__SSID_TM_arena_id AND dArena.ETL__SourceSystem = 'TM' AND dArena.DimArenaId > 0
	AND tkt.add_datetime BETWEEN dArena.ETL__StartDate AND ISNULL(dArena.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimSeason (nolock) dSeason ON dEvent.TM_season_id = dSeason.ETL__SSID_TM_season_Id AND dSeason.ETL__SourceSystem = 'TM' AND dSeason.DimSeasonId > 0
	AND tkt.add_datetime BETWEEN dSeason.ETL__StartDate AND ISNULL(dSeason.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimItem (nolock) dItem ON CASE WHEN ISNULL(tkt.plan_event_id,0) = 0 THEN tkt.event_id ELSE tkt.plan_event_id END = dItem.ETL__SSID_TM_event_id AND dItem.ETL__SourceSystem = 'TM' AND dItem.DimItemId > 0 
	AND tkt.add_datetime BETWEEN dItem.ETL__StartDate AND ISNULL(dItem.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimPlan (nolock) dPlan ON tkt.plan_event_id = dPlan.ETL__SSID_TM_event_id AND dPlan.ETL__SourceSystem = 'TM' AND dPlan.DimPlanId > 0
	AND tkt.add_datetime BETWEEN dPlan.ETL__StartDate AND ISNULL(dPlan.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimPromo (nolock) dPromo ON tkt.promo_code = dPromo.ETL__SSID_TM_promo_code AND dPromo.ETL__SourceSystem = 'TM' AND dPromo.DimPromoID > 0
	AND tkt.add_datetime BETWEEN dPromo.ETL__StartDate AND ISNULL(dPromo.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimSalesCode (nolock) dSalesCode ON CASE WHEN TRY_CAST(tkt.sell_location AS INT) IS NULL THEN dSalesCode.SalesCodeName ELSE CONVERT(NVARCHAR,dSalesCode.ETL__SSID_TM_sell_location_id) END = CONVERT(NVARCHAR,tkt.sell_location) AND dSalesCode.ETL__SourceSystem = 'TM' AND dSalesCode.DimSalesCodeId > 0
	AND tkt.add_datetime BETWEEN dSalesCode.ETL__StartDate AND ISNULL(dSalesCode.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimPriceCode (nolock) dPriceCode ON tkt.event_id = dPriceCode.ETL__SSID_TM_event_id AND tkt.ssbPriceCode = dPriceCode.ETL__SSID_TM_price_code AND dPriceCode.ETL__SourceSystem = 'TM' AND dPriceCode.DimPriceCodeId > 0
	AND tkt.add_datetime BETWEEN dPriceCode.ETL__StartDate AND ISNULL(dPriceCode.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimPriceCode (nolock) dPriceCodePlan ON tkt.plan_event_id = dPriceCodePlan.ETL__SSID_TM_event_id AND tkt.ssbPriceCode = dPriceCodePlan.ETL__SSID_TM_price_code AND dPriceCodePlan.ETL__SourceSystem = 'TM' AND dPriceCodePlan.DimPriceCodeId > 0
	AND tkt.add_datetime BETWEEN dPriceCodePlan.ETL__StartDate AND ISNULL(dPriceCodePlan.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimTicketCustomer (nolock) dTicketCustomer ON tkt.acct_id = dTicketCustomer.ETL__SSID_TM_acct_id AND dTicketCustomer.ETL__SourceSystem = 'TM' AND dTicketCustomer.DimTicketCustomerId > 0
	AND tkt.add_datetime BETWEEN dTicketCustomer.ETL__StartDate AND ISNULL(dTicketCustomer.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimSeat (nolock) dSeat ON dEvent.TM_manifest_id = dSeat.ETL__SSID_TM_Manifest_Id AND tkt.section_id = dSeat.ETL__SSID_TM_Section_Id AND tkt.row_id = dSeat.ETL__SSID_TM_Row_Id AND tkt.seat_num = dSeat.ETL__SSID_TM_Seat AND dSeat.ETL__SourceSystem = 'TM' AND dSeat.DimSeatId > 0
	AND tkt.add_datetime BETWEEN dSeat.ETL__StartDate AND ISNULL(dSeat.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimSeatStatus (nolock) dSeatStatus ON tkt.class_name = dSeatStatus.SeatStatusName AND dSeatStatus.ETL__SourceSystem = 'TM' AND dSeatStatus.DimSeatStatusId > 0
	AND tkt.add_datetime BETWEEN dSeatStatus.ETL__StartDate AND ISNULL(dSeatStatus.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimRep (nolock) dRep ON tkt.orig_acct_rep_id = dRep.ETL__SSID_TM_acct_id AND dRep.ETL__SourceSystem = 'TM' AND dRep.DimRepId > 0
	AND tkt.add_datetime BETWEEN dRep.ETL__StartDate AND ISNULL(dRep.ETL__EndDate, '3000-01-01')

LEFT OUTER JOIN dbo.DimLedger (nolock) dLedger ON tkt.ledger_id = dLedger.ETL__SSID_TM_ledger_id AND dLedger.ETL__SourceSystem = 'TM' AND dledger.DimLedgerId > 0
	AND tkt.add_datetime BETWEEN dLedger.ETL__StartDate AND ISNULL(dLedger.ETL__EndDate, '3000-01-01')
		


END
















GO
