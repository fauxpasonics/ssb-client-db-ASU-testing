SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [etl].[vw_Load_TM_FactTicketActivity] AS (

	SELECT  
		ETL__SSID, ETL__SSID_TM_ods_id, ETL__SSID_TM_activity, ETL__SSID_TM_event_id, ETL__SSID_TM_section_id, ETL__SSID_TM_row_id, ETL__SSID_TM_seat_num,
        ETL__SSID_TM_num_seats, ETL__SSID_TM_add_datetime, DimDateId, DimTimeId, DimArenaId, DimSeasonId, DimItemId, DimEventId, DimPlanId, DimSeatId_Start, DimTicketCustomerId,
        DimTicketCustomerId_Recipient, DimActivityId, TransDateTime, QtySeat, SubTotal, Fees, Taxes, Total, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate,
        TM_order_num, TM_order_line_item, TM_order_line_item_seq, TM_forward_to_name, TM_forward_to_email_addr, TM_Orig_purchase_price, TM_te_seller_credit_amount,
        TM_te_seller_fees, TM_te_posting_price, TM_te_buyer_fees_hidden, TM_te_purchase_price, TM_te_buyer_fees_not_hidden, TM_inet_delivery_fee,
        TM_inet_transaction_amount, TM_delivery_method, TM_activity, TM_activity_name

	FROM stg.TM_FactTicketActivity (NOLOCK)

)



GO
