SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [ro].[vw_FactTicketSales_All] AS 

( SELECT f.SSCreatedDate 
		, f.ETL__SSID_TM_acct_id, f.ETL__SSID_PAC_CUSTOMER, f.ETL__SourceSystem
		, f.TM_Order_Num, f.TM_Order_Line_Item, f.TM_Order_Line_Item_Seq
		, f.QtySeat, f.QtySeatFSE, f.QtySeatRenewable
		, f.RevenueTotal, f.RevenueTicket, RevenueFees
		, f.TM_purchase_price, f.TM_block_purchase_price, f.TM_pc_ticket, f.TM_Pc_Tax , f.TM_pc_licfee, f.TM_Pc_Other1 , f.TM_Pc_Other2 
		, f.PaidAmount, f.OwedAmount, f.PaidStatus
		, f.IsPremium, f.IsComp, f.IsHost, f.IsPlan, f.IsPartial, f.IsSingleEvent, f.IsGroup, f.IsBroker, f.IsRenewal, f.IsExpanded, f.IsAutoRenewalNextSeason
		, f.TM_comp_code, f.TM_comp_name, f.TM_group_sales_name, f.TM_ticket_type, f.TM_tran_type, f.TM_sales_source_name, f.TM_retail_ticket_type, f.TM_retail_qualifiers
		, f.FactTicketSalesId, f.DimDateId, f.DimTimeId, f.DimTicketCustomerId, f.DimArenaId, f.DimSeasonId, f.DimItemId, f.DimEventId, f.DimPlanId
		, f.DimPriceCodeId, f.DimPriceTypeId, f.DimSeatId_Start, f.DimSalesCodeId, f.DimPromoId, f.DimPriceLevelId
		,  f.DimTicketTypeId, f.DimPlanTypeId, f.DimSeatTypeId, f.DimTicketClassId
		, f.DimRepId
		, f.TM_ticket_seq_id
  FROM dbo.FactTicketSales_V2 (NOLOCK) f

UNION ALL

  SELECT fts.SSCreatedDate 
		, fts.ETL__SSID_TM_acct_id, fts.ETL__SSID_PAC_CUSTOMER, fts.ETL__SourceSystem
		, fts.TM_Order_Num, fts.TM_Order_Line_Item, fts.TM_Order_Line_Item_Seq
		, fts.QtySeat, fts.QtySeatFSE, fts.QtySeatRenewable
		, fts.RevenueTotal, fts.RevenueTicket, RevenueFees
		, fts.TM_purchase_price, fts.TM_block_purchase_price, fts.TM_pc_ticket, fts.TM_Pc_Tax , fts.TM_pc_licfee, fts.TM_Pc_Other1, fts.TM_Pc_Other2
		, fts.PaidAmount, fts.OwedAmount, fts.PaidStatus
		, fts.IsPremium, fts.IsComp, fts.IsHost, fts.IsPlan, fts.IsPartial, fts.IsSingleEvent, fts.IsGroup, fts.IsBroker, fts.IsRenewal, fts.IsExpanded, fts.IsAutoRenewalNextSeason
		, fts.TM_comp_code, fts.TM_comp_name, fts.TM_group_sales_name, fts.TM_ticket_type, fts.TM_tran_type, fts.TM_sales_source_name, fts.TM_retail_ticket_type, fts.TM_retail_qualifiers
		, fts.FactTicketSalesId, fts.DimDateId, fts.DimTimeId, fts.DimTicketCustomerId, fts.DimArenaId, fts.DimSeasonId, fts.DimItemId, fts.DimEventId, fts.DimPlanId
		, fts.DimPriceCodeId, fts.DimPriceTypeId, fts.DimSeatId_Start, fts.DimSalesCodeId, fts.DimPromoId, fts.DimPriceLevelId
		,  fts.DimTicketTypeId, fts.DimPlanTypeId, fts.DimSeatTypeId, fts.DimTicketClassId
		, fts.DimRepId
		, fts.TM_ticket_seq_id 
  FROM dbo.FactTicketSales_History_V2 fts (NOLOCK)
  INNER JOIN [ro].[vw_DimSeason] ds ON fts.DimSeasonId = ds.DimSeasonId
  WHERE ds.SeasonYear >= DATEPART(YEAR,GETDATE())-4

)







GO
