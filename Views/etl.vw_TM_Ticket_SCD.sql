SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_TM_Ticket_SCD] AS (
	SELECT CAST('etl.vw_TM_Ticket_SCD' AS NVARCHAR(255)) ETL__Source
		, event_name, section_name, row_name, num_seats, ticket_status, acct_id, upd_datetime, seq_num, block_purchase_price,
          order_num, order_line_item, order_line_item_seq, info, total_events, price_code, pricing_method, comp_code, comp_name, paid, disc_code, disc_amount,
          surchg_code_desc, surchg_amount, group_flag, upd_user, class_name, sell_location, full_price, purchase_price, sales_source_name, sales_source_date,
          ticket_type, price_code_desc, event_id, plan_event_id, plan_event_name, seat_num, last_seat, other_info_1, other_info_2, other_info_3, other_info_4,
          other_info_5, other_info_6, other_info_7, other_info_8, other_info_9, other_info_10, acct_rep_id, acct_rep_full_name, tran_type, section_id, row_id,
          promo_code, retail_ticket_type, retail_qualifiers, paid_amount, owed_amount, add_datetime, add_user, renewal_ind, return_reason, return_reason_desc,
          expanded, delivery_method, delivery_method_name, delivery_instructions, delivery_name_first, delivery_name_last, delivery_addr1, delivery_addr2,
          delivery_addr3, delivery_city, delivery_state, delivery_zip, delivery_zip_formatted, delivery_country, delivery_phone, delivery_phone_formatted,
          delivered_date, group_sales_name, ledger_id, pc_ticket, pc_tax, pc_licfee, pc_other1, pc_other2, pc_other3, pc_other4, pc_other5, pc_other6, pc_other7,
          pc_other8, tax_rate_a, tax_rate_b, tax_rate_c, orig_acct_rep_id, ticket_seq_id, retail_system_name, retail_acct_num, retail_acct_add_date, retail_mask,
          retail_price_level, retail_face_value, retail_face_value_tax, retail_facility_fee, retail_service_charge, retail_service_charge_tax, retail_distance_charge,
          return_datetime, ticket_type_category, seq_id, contract_id
		  , ETL__ID
	FROM stg.TM_Ticket (NOLOCK)
	
)

GO
