SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_TM_FactHeldSeats] AS (

	SELECT  
		ETL__SSID, ETL__SSID_TM_ods_id, ETL__SSID_TM_event_id, ETL__SSID_TM_section_id, ETL__SSID_TM_row_id, ETL__SSID_TM_seat_num,
		ETL__SSID_TM_price_code, DimDateId, DimTimeId, DimTicketCustomerId, DimArenaId, DimSeasonId, DimItemId, DimEventId, DimPlanId, DimPriceLevelId,
		DimPriceTypeId, DimPriceCodeId, DimLedgerId, DimSeatId_Start, DimSeatStatusId, DimRepId, DimSalesCodeId, DimPlanTypeId, DimTicketTypeId, DimSeatTypeId,
		DimTicketClassId, IsReserved, HeldDateTime, QtySeat, SubTotal, Fees, Taxes, Total, TM_eip_pricing, TM_price, TM_printed_price, TM_pc_ticket, TM_pc_tax,
		TM_pc_licfee, TM_pc_other1, TM_pc_other2, TM_pc_other3, TM_pc_other4, TM_pc_other5, TM_pc_other6, TM_pc_other7, TM_pc_other8, TM_tax_rate_a, TM_tax_rate_b,
		TM_tax_rate_c, TM_pricing_method, TM_block_full_price, TM_block_purchase_price, TM_orig_price_code, TM_comp_code, TM_comp_name, TM_disc_code,
		TM_disc_amount, TM_surchg_code, TM_surchg_amount, TM_direction, TM_quality, TM_attribute, TM_aisle, TM_buy, TM_tag, TM_consignment, TM_group_flag,
		TM_group_sales_id, TM_group_sales_name, TM_group_sales_status, TM_order_num, TM_order_line_item, TM_request_line_item, TM_usr, TM_datetime,
		TM_rerate_surchg_on_acct_chg, TM_sales_source_id, TM_sales_source_date, TM_request_source, TM_section_type, TM_section_sort, TM_row_sort, TM_row_index,
		TM_block_id, TM_config_id, TM_print_ticket_ind, TM_sell_type, TM_status, TM_ticket_type_code, TM_ticket_type, TM_flex_plan_event_ids, TM_plan_type,
		TM_parent_plan_type, TM_acct_rep_id, TM_contract_id, TM_grouping_id, TM_other_info_1, TM_other_info_2, TM_other_info_3, TM_other_info_4, TM_other_info_5,
		TM_other_info_6, TM_other_info_7, TM_other_info_8, TM_other_info_9, TM_other_info_10, TM_prev_loc_id, TM_reserved_ind, TM_release_datetime, TM_hold_source,
		TM_invoice_id, TM_invoice_date, TM_invoice_due_date, TM_ticket_type_category, TM_comp_approved_by, TM_comp_comment, TM_offer_id, TM_offer_name,
		TM_merchant_id, TM_merchant_code, TM_merchant_color, TM_auto_disc_code_list, TM_man_surchg_code_list, TM_sell_location_id, TM_section_name_right,
		TM_row_barcode_index, TM_row_barcode_index_high, TM_barcode_status, TM_barcode_season_key, TM_barcode_event_slot_min, TM_barcode_event_slot_max,
		TM_barcode_seatcode_adjustment, TM_access_control_system_ip, TM_access_control_system_port, TM_seat_code_low, TM_seat_code_high, TM_digit_server_id,
		TM_im_mode, TM_comp_requested_by, TM_membership_cust_membership_id, TM_used_cust_membership_id, TM_membership_id_for_membership_event,
		TM_membership_number_domain_type, TM_cust_membership_number, TM_sell_rule_id, TM_report_block_purchase_price, TM_held_seq_id, TM_action,
		TM_auto_surchg_code_list, TM_man_disc_code_list, TM_rerate_disc_on_acct_chg

	FROM stg.TM_FactHeldSeats (NOLOCK)

)




GO
