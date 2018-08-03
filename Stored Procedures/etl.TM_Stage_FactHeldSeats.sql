SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[TM_Stage_FactHeldSeats] 
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

SELECT *
INTO #DataSet
FROM ods.TM_HeldSeats
WHERE UpdateDate >= @LoadDate


CREATE NONCLUSTERED INDEX IDX_event_id ON #DataSet (event_id)
CREATE NONCLUSTERED INDEX IDX_acct_id ON #DataSet (acct_id)
CREATE NONCLUSTERED INDEX IDX_acct_rep_id ON #DataSet (acct_rep_id)
CREATE NONCLUSTERED INDEX IDX_ledger_id ON #DataSet (ledger_id)
CREATE NONCLUSTERED INDEX IDX_class_id ON #DataSet (class_id)
CREATE NONCLUSTERED INDEX IDX_sell_location ON #DataSet (sell_location)

CREATE NONCLUSTERED INDEX IDX_price_code ON #DataSet (price_code)
CREATE NONCLUSTERED INDEX IDX_srs ON #DataSet (section_id, row_id, seat_num)
CREATE NONCLUSTERED INDEX IDX_id ON #DataSet (id)



TRUNCATE TABLE stg.TM_FactHeldSeats

INSERT INTO stg.TM_FactHeldSeats 
(
	ETL__SSID, ETL__SSID_TM_ods_id, ETL__SSID_TM_event_id, ETL__SSID_TM_section_id, ETL__SSID_TM_row_id, ETL__SSID_TM_seat_num,
	ETL__SSID_TM_price_code, DimDateId, DimTimeId, DimTicketCustomerId, DimArenaId, DimSeasonId, DimItemId, DimEventId, DimPlanId,
	DimPriceLevelId, DimPriceTypeId, DimPriceCodeId, DimLedgerId, DimSeatId_Start, DimSeatStatusId, DimRepId, DimSalesCodeId,
	DimPlanTypeId, DimTicketTypeId, DimSeatTypeId, DimTicketClassId, IsReserved, HeldDateTime, QtySeat, SubTotal, Fees, Taxes,
	Total, TM_eip_pricing, TM_price, TM_printed_price, TM_pc_ticket, TM_pc_tax, TM_pc_licfee, TM_pc_other1, TM_pc_other2,
	TM_pc_other3, TM_pc_other4, TM_pc_other5, TM_pc_other6, TM_pc_other7, TM_pc_other8, TM_tax_rate_a, TM_tax_rate_b,
	TM_tax_rate_c, TM_pricing_method, TM_block_full_price, TM_block_purchase_price, TM_orig_price_code, TM_comp_code,
	TM_comp_name, TM_disc_code, TM_disc_amount, TM_surchg_code, TM_surchg_amount, TM_direction, TM_quality, TM_attribute,
	TM_aisle, TM_buy, TM_tag, TM_consignment, TM_group_flag, TM_group_sales_id, TM_group_sales_name, TM_group_sales_status,
	TM_order_num, TM_order_line_item, TM_request_line_item, TM_usr, TM_datetime, TM_rerate_surchg_on_acct_chg, TM_sales_source_id,
	TM_sales_source_date, TM_request_source, TM_section_type, TM_section_sort, TM_row_sort, TM_row_index, TM_block_id,
	TM_config_id, TM_print_ticket_ind, TM_sell_type, TM_status, TM_ticket_type_code, TM_ticket_type, TM_flex_plan_event_ids,
	TM_plan_type, TM_parent_plan_type, TM_acct_rep_id, TM_contract_id, TM_grouping_id, TM_other_info_1, TM_other_info_2,
	TM_other_info_3, TM_other_info_4, TM_other_info_5, TM_other_info_6, TM_other_info_7, TM_other_info_8, TM_other_info_9,
	TM_other_info_10, TM_prev_loc_id, TM_reserved_ind, TM_release_datetime, TM_hold_source, TM_invoice_id, TM_invoice_date,
	TM_invoice_due_date, TM_ticket_type_category, TM_comp_approved_by, TM_comp_comment, TM_offer_id, TM_offer_name,
	TM_merchant_id, TM_merchant_code, TM_merchant_color, TM_auto_disc_code_list, TM_man_surchg_code_list, TM_sell_location_id,
	TM_section_name_right, TM_row_barcode_index, TM_row_barcode_index_high, TM_barcode_status, TM_barcode_season_key,
	TM_barcode_event_slot_min, TM_barcode_event_slot_max, TM_barcode_seatcode_adjustment, TM_access_control_system_ip,
	TM_access_control_system_port, TM_seat_code_low, TM_seat_code_high, TM_digit_server_id, TM_im_mode, TM_comp_requested_by,
	TM_membership_cust_membership_id, TM_used_cust_membership_id, TM_membership_id_for_membership_event,
	TM_membership_number_domain_type, TM_cust_membership_number, TM_sell_rule_id, TM_report_block_purchase_price, TM_held_seq_id,
	TM_action, TM_auto_surchg_code_list, TM_man_disc_code_list, TM_rerate_disc_on_acct_chg
)



SELECT 
	CONCAT(ds.event_id, ':', ds.section_id, ':', ds.row_id, ':', ds.seat_num) ETL__SSID
	, ds.id ETL__SSID_TM_ods_id
	, ds.event_id ETL__SSID_TM_event_id
	, ds.section_id ETL__SSID_TM_section_id
	, ds.row_id ETL__SSID_TM_row_id
	, ds.seat_num ETL__SSID_TM_seat_num
	, ds.price_code ETL__SSID_TM_price_code

	, CONVERT(VARCHAR, ds.[datetime], 112) DimDateId
	, datediff(second, cast(ds.[datetime] as date), ds.[datetime]) DimTimeId
	, CASE WHEN ds.acct_id IS NULL THEN 0 ELSE ISNULL(dTicketCustomer.DimTicketCustomerId, -1) END DimTicketCustomerId
	, isnull(dArena.DimArenaId, -1) DimArenaId
	, isnull(dSeason.DimSeasonId, -1) DimSeasonId
	, isnull(dItem.DimItemId, -1) DimItemId
	, CASE WHEN ISNULL(dItem.ItemType,'') <> 'Event' THEN 0 ELSE isnull(dEvent.DimEventId, -1) END DimEventId
	, CASE WHEN ISNULL(dItem.ItemType,'') <> 'Plan' THEN 0 ELSE isnull(dPlan.DimPlanId, -1) END DimPlanId	
	, 0 DimPriceLevelId
	, 0 DimPriceTypeId
	, ISNULL(dPriceCode.DimPriceCodeId, -1) DimPriceCodeId	
	, ISNULL(dLedger.DimLedgerId, -1) DimLedgerId
	, isnull(dSeat.DimSeatId, -1) DimSeatId_Start
	, isnull(dSeatStatus.DimSeatStatusId, -1) DimSeatStatusId	
	, case when ISNULL(ds.acct_rep_id,0) = 0 then 0 else isnull(dRep.DimRepId, -1) end	DimRepId
	, case when isnull(ds.sell_location,'') = '' then 0 else COALESCE(dSalesCode.DimSalesCodeId, dSalesCodeName.DimSalesCodeId, -1) end DimSalesCodeId

	, -1 DimPlanTypeId
	, -1 DimTicketTypeId
	, -1 DimSeatTypeId
	, -1 DimTicketClassId
	
	, CAST(CASE WHEN ds.reserved_ind = 'Y' THEN 1 ELSE 0 END AS BIT) IsReserved
	, ds.[datetime] [HeldDateTime]

	, ds.num_seats QtySeat

	, (ds.block_purchase_price - ds.pc_licfee - ds.pc_tax) [SubTotal]
	, ds.pc_licfee [Fees]
	, ds.pc_tax  [Taxes]
	, ds.block_purchase_price [Total]


	, ds.[eip_pricing] [TM_eip_pricing]
	, ds.[price] [TM_price]
	, ds.[printed_price] [TM_printed_price]
	, ds.[pc_ticket] [TM_pc_ticket]
	, ds.[pc_tax] [TM_pc_tax]
	, ds.[pc_licfee] [TM_pc_licfee]
	, ds.[pc_other1] [TM_pc_other1]
	, ds.[pc_other2] [TM_pc_other2]
	, ds.[pc_other3] [TM_pc_other3]
	, ds.[pc_other4] [TM_pc_other4]
	, ds.[pc_other5] [TM_pc_other5]
	, ds.[pc_other6] [TM_pc_other6]
	, ds.[pc_other7] [TM_pc_other7]
	, ds.[pc_other8] [TM_pc_other8]
	, ds.[tax_rate_a] [TM_tax_rate_a]
	, ds.[tax_rate_b] [TM_tax_rate_b]
	, ds.[tax_rate_c] [TM_tax_rate_c]
	, ds.[pricing_method] [TM_pricing_method]
	, ds.[block_full_price] [TM_block_full_price]
	, ds.[block_purchase_price] [TM_block_purchase_price]
	, ds.[orig_price_code] [TM_orig_price_code]
	, ds.[comp_code] [TM_comp_code]
	, ds.[comp_name] [TM_comp_name]
	, ds.[disc_code] [TM_disc_code]
	, ds.[disc_amount] [TM_disc_amount]
	, ds.[surchg_code] [TM_surchg_code]
	, ds.[surchg_amount] [TM_surchg_amount]
	, ds.[direction] [TM_direction]
	, ds.[quality] [TM_quality]
	, ds.[attribute] [TM_attribute]
	, ds.[aisle] [TM_aisle]
	, ds.[buy] [TM_buy]
	, ds.[tag] [TM_tag]
	, ds.[consignment] [TM_consignment]
	, ds.[group_flag] [TM_group_flag]
	, ds.[group_sales_id] [TM_group_sales_id]
	, ds.[group_sales_name] [TM_group_sales_name]
	, ds.[group_sales_status] [TM_group_sales_status]
	, ds.[order_num] [TM_order_num]
	, ds.[order_line_item] [TM_order_line_item]
	, ds.[request_line_item] [TM_request_line_item]
	, ds.[usr] [TM_usr]
	, ds.[datetime] [TM_datetime]
	, ds.[rerate_surchg_on_acct_chg] [TM_rerate_surchg_on_acct_chg]
	, ds.[sales_source_id] [TM_sales_source_id]
	, ds.[sales_source_date] [TM_sales_source_date]
	, ds.[request_source] [TM_request_source]
	, ds.[section_type] [TM_section_type]
	, ds.[section_sort] [TM_section_sort]
	, ds.[row_sort] [TM_row_sort]
	, ds.[row_index] [TM_row_index]
	, ds.[block_id] [TM_block_id]
	, ds.[config_id] [TM_config_id]
	, ds.[print_ticket_ind] [TM_print_ticket_ind]
	, ds.[sell_type] [TM_sell_type]
	, ds.[status] [TM_status]
	, ds.[ticket_type_code] [TM_ticket_type_code]
	, ds.[ticket_type] [TM_ticket_type]
	, ds.[flex_plan_event_ids] [TM_flex_plan_event_ids]
	, ds.[plan_type] [TM_plan_type]
	, ds.[parent_plan_type] [TM_parent_plan_type]
	, ds.[acct_rep_id] [TM_acct_rep_id]
	, ds.[contract_id] [TM_contract_id]
	, ds.[grouping_id] [TM_grouping_id]
	, ds.[other_info_1] [TM_other_info_1]
	, ds.[other_info_2] [TM_other_info_2]
	, ds.[other_info_3] [TM_other_info_3]
	, ds.[other_info_4] [TM_other_info_4]
	, ds.[other_info_5] [TM_other_info_5]
	, ds.[other_info_6] [TM_other_info_6]
	, ds.[other_info_7] [TM_other_info_7]
	, ds.[other_info_8] [TM_other_info_8]
	, ds.[other_info_9] [TM_other_info_9]
	, ds.[other_info_10] [TM_other_info_10]
	, ds.[prev_loc_id] [TM_prev_loc_id]
	, ds.[reserved_ind] [TM_reserved_ind]
	, ds.[release_datetime] [TM_release_datetime]
	, ds.[hold_source] [TM_hold_source]
	, ds.[invoice_id] [TM_invoice_id]
	, ds.[invoice_date] [TM_invoice_date]
	, ds.[invoice_due_date] [TM_invoice_due_date]
	, ds.[ticket_type_category] [TM_ticket_type_category]
	, ds.[comp_approved_by] [TM_comp_approved_by]
	, ds.[comp_comment] [TM_comp_comment]
	, ds.[offer_id] [TM_offer_id]
	, ds.[offer_name] [TM_offer_name]
	, ds.[merchant_id] [TM_merchant_id]
	, ds.[merchant_code] [TM_merchant_code]
	, ds.[merchant_color] [TM_merchant_color]
	, ds.[auto_disc_code_list] [TM_auto_disc_code_list]
	, ds.[man_surchg_code_list] [TM_man_surchg_code_list]
	, ds.[sell_location_id] [TM_sell_location_id]
	, ds.[section_name_right] [TM_section_name_right]
	, ds.[row_barcode_index] [TM_row_barcode_index]
	, ds.[row_barcode_index_high] [TM_row_barcode_index_high]
	, ds.[barcode_status] [TM_barcode_status]
	, ds.[barcode_season_key] [TM_barcode_season_key]
	, ds.[barcode_event_slot_min] [TM_barcode_event_slot_min]
	, ds.[barcode_event_slot_max] [TM_barcode_event_slot_max]
	, ds.[barcode_seatcode_adjustment] [TM_barcode_seatcode_adjustment]
	, ds.[access_control_system_ip] [TM_access_control_system_ip]
	, ds.[access_control_system_port] [TM_access_control_system_port]
	, ds.[seat_code_low] [TM_seat_code_low]
	, ds.[seat_code_high] [TM_seat_code_high]
	, ds.[digit_server_id] [TM_digit_server_id]
	, ds.[im_mode] [TM_im_mode]
	, ds.[comp_requested_by] [TM_comp_requested_by]
	, ds.[membership_cust_membership_id] [TM_membership_cust_membership_id]
	, ds.[used_cust_membership_id] [TM_used_cust_membership_id]
	, ds.[membership_id_for_membership_event] [TM_membership_id_for_membership_event]
	, ds.[membership_number_domain_type] [TM_membership_number_domain_type]
	, ds.[cust_membership_number] [TM_cust_membership_number]
	, ds.[sell_rule_id] [TM_sell_rule_id]
	, ds.[report_block_purchase_price] [TM_report_block_purchase_price]
	, ds.[held_seq_id] [TM_held_seq_id]
	, ds.[action] [TM_action]
	, ds.[auto_surchg_code_list] [TM_auto_surchg_code_list]
	, ds.[man_disc_code_list] [TM_man_disc_code_list]
	, ds.[rerate_disc_on_acct_chg] [TM_rerate_disc_on_acct_chg]
	
 

--SELECT COUNT(*)
FROM #DataSet ds

LEFT OUTER JOIN etl.vw_DimItem (nolock) dItem ON ds.event_id = dItem.ETL__SSID_TM_event_id
	AND dItem.ETL__SourceSystem = 'TM' AND dItem.DimItemId > 0 AND dItem.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimEvent (nolock) dEvent ON ds.event_id = dEvent.ETL__SSID_TM_event_id
	AND dEvent.ETL__SourceSystem = 'TM' AND dEvent.DimEventId > 0 AND dEvent.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimPlan (nolock) dPlan ON ds.event_id = dPlan.ETL__SSID_TM_event_id
	AND dPlan.ETL__SourceSystem = 'TM' AND dPlan.DimPlanId > 0 AND dPlan.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimSeason (nolock) dSeason ON CASE  WHEN dEvent.DimEventId > 0 THEN dEvent.TM_season_id ELSE dPlan.TM_season_id END = dSeason.ETL__SSID_TM_season_Id
	AND dSeason.ETL__SourceSystem = 'TM' AND dSeason.DimSeasonId > 0 AND dSeason.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimArena (nolock) dArena ON dSeason.TM_arena_id = dArena.ETL__SSID_TM_arena_id
	AND dArena.ETL__SourceSystem = 'TM' AND dArena.DimArenaId > 0 AND dArena.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimPriceCode (nolock) dPriceCode ON ds.event_id = dPriceCode.ETL__SSID_TM_event_id AND ds.price_code = dPriceCode.ETL__SSID_TM_price_code
	AND dPriceCode.ETL__SourceSystem = 'TM' AND dPriceCode.DimPriceCodeId > 0 AND dPriceCode.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimSeat (nolock) dSeat ON dSeason.TM_manifest_id = dSeat.ETL__SSID_TM_Manifest_Id AND ds.section_id = dSeat.ETL__SSID_TM_Section_Id AND ds.row_id = dSeat.ETL__SSID_TM_Row_Id AND ds.seat_num = dSeat.ETL__SSID_TM_Seat
	AND dSeat.ETL__SourceSystem = 'TM' AND dSeat.DimSeatId > 0 AND dSeat.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimSeatStatus (nolock) dSeatStatus ON ds.class_name = dSeatStatus.SeatStatusName
	AND dSeatStatus.ETL__SourceSystem = 'TM' AND dSeatStatus.DimSeatStatusId > 0 AND dSeatStatus.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimRep (nolock) dRep ON ds.acct_rep_id = dRep.ETL__SSID_TM_acct_id
	AND dRep.ETL__SourceSystem = 'TM' AND dRep.DimRepId > 0 AND dRep.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimLedger (nolock) dLedger ON ds.ledger_id = dLedger.ETL__SSID_TM_ledger_id
	AND dLedger.ETL__SourceSystem = 'TM' AND dLedger.DimLedgerId > 0 AND dLedger.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimSalesCode (nolock) dSalesCode ON ds.sell_location = CAST(dSalesCode.ETL__SSID_TM_sell_location_id AS NVARCHAR(255))
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
) dSalesCodeName ON ds.sell_location = dSalesCodeName.SalesCodeName
	AND dSalesCodeName.ETL__SourceSystem = 'TM' AND dSalesCodeName.DimSalesCodeId > 0 AND dSalesCodeName.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimTicketCustomer (nolock) dTicketCustomer ON ds.acct_id = dTicketCustomer.ETL__SSID_TM_acct_id
	AND dTicketCustomer.ETL__SourceSystem = 'TM' AND dTicketCustomer.DimTicketCustomerId > 0 AND dTicketCustomer.ETL__IsDeleted = 0
 
DROP TABLE #DataSet

END 



GO
