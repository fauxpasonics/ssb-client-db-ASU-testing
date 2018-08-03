SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_TM_FactAvailSeats] AS (

	SELECT  
		ETL__SSID, ETL__SSID_TM_ods_id, ETL__SSID_TM_event_id, ETL__SSID_TM_section_id, ETL__SSID_TM_row_id, ETL__SSID_TM_seat_num,
		ETL__SSID_TM_price_code, DimDateId, DimTimeId, DimArenaId, DimSeasonId, DimItemId, DimEventId, DimPlanId, DimPriceLevelId, DimPriceTypeId, DimPriceCodeId,
		DimSeatId_Start, DimSeatStatusId, DimPlanTypeId, DimTicketTypeId, DimSeatTypeId, DimTicketClassId, PostedDateTime, QtySeat, SubTotal, Fees, Taxes, Total,
		TM_price, TM_block_full_price, TM_printed_price, TM_pc_ticket, TM_pc_tax, TM_pc_licfee, TM_pc_other1, TM_pc_other2, TM_pc_other3, TM_pc_other4,
		TM_pc_other5, TM_pc_other6, TM_pc_other7, TM_pc_other8, TM_tax_rate_a, TM_tax_rate_b, TM_tax_rate_c, TM_direction, TM_quality, TM_attribute, TM_aisle,
		TM_section_type, TM_section_sort, TM_row_sort, TM_row_index, TM_block_id, TM_config_id, TM_plan_type, TM_sellable, TM_onsale_datetime, TM_offsale_datetime,
		TM_block_purchase_price, TM_sell_type, TM_status, TM_display_status, TM_unsold_type, TM_unsold_qual_id, TM_reserved, TM_oss_onsale_datetime,
		TM_oss_offsale_datetime, TM_row_barcode_index, TM_row_barcode_index_high, TM_barcode_season_key, TM_barcode_event_slot_min, TM_barcode_event_slot_max,
		TM_barcode_seatcode_adjustment, TM_access_control_system_ip, TM_access_control_system_port, TM_seat_code_low, TM_seat_code_high, TM_digit_server_id,
		TM_im_mode, TM_host_integration_enabled, TM_host_synch_status, TM_action

	FROM stg.TM_FactAvailSeats (NOLOCK)

)



GO
