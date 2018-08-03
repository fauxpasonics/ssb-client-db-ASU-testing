SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_TM_FactTicketSales] AS (

	SELECT  
		ETL__SSID, ETL__SSID_TM_event_id, ETL__SSID_TM_section_id, ETL__SSID_TM_row_id, ETL__SSID_TM_seat_num, ETL__SSID_TM_acct_id,
		ETL__SSID_TM_price_code, DimDateId, DimTimeId, DimTicketCustomerId, DimArenaId, DimSeasonId, DimItemId, DimEventId, DimPlanId, DimPriceLevelId,
		DimPriceTypeId, DimPriceCodeId, DimLedgerId, DimSeatId_Start, DimSeatStatusId, DimRepId, DimSalesCodeId, DimPromoId, DimEventZoneId, DimOfferId,
		DimPlanTypeId, DimTicketTypeId, DimSeatTypeId, DimTicketClassId, OrderDate, SSCreatedBy, SSUpdatedBy, SSCreatedDate, SSUpdatedDate, QtySeat, QtySeatFSE,
		QtySeatRenewable, RevenueTicket, RevenueFees, RevenueSurcharge, RevenueTax, RevenueTotal, FullPrice, Discount, PaidStatus, PaidAmount, OwedAmount,
		PaymentDateFirst, PaymentDateLast, IsSold, IsReserved, IsReturned, IsPremium, IsDiscount, IsComp, IsHost, IsPlan, IsPartial, IsSingleEvent, IsGroup,
		IsBroker, IsRenewal, IsExpanded, IsAutoRenewalNextSeason, TM_order_num, TM_order_line_item, TM_order_line_item_seq, TM_purchase_price,
		TM_block_purchase_price, TM_pc_ticket, TM_pc_tax, TM_pc_licfee, TM_pc_other1, TM_pc_other2, TM_pc_other3, TM_pc_other4, TM_pc_other5, TM_pc_other6,
		TM_pc_other7, TM_pc_other8, TM_comp_code, TM_comp_name, TM_surchg_code_desc, TM_group_sales_name, TM_ticket_type, TM_tran_type, TM_sales_source_name,
		TM_retail_ticket_type, TM_retail_qualifiers, TM_retail_mask, TM_ticket_seq_id, Custom_Int_1, Custom_Int_2, Custom_Int_3, Custom_Int_4, Custom_Int_5,
		Custom_Dec_1, Custom_Dec_2, Custom_Dec_3, Custom_Dec_4, Custom_Dec_5, Custom_DateTime_1, Custom_DateTime_2, Custom_DateTime_3, Custom_DateTime_4,
		Custom_DateTime_5, Custom_Bit_1, Custom_Bit_2, Custom_Bit_3, Custom_Bit_4, Custom_Bit_5, Custom_nVarChar_1, Custom_nVarChar_2, Custom_nVarChar_3,
		Custom_nVarChar_4, Custom_nVarChar_5

	FROM stg.TM_FactTicketSales (NOLOCK)

)


GO
