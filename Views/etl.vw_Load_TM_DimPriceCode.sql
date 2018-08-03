SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_Load_TM_DimPriceCode] AS (



	SELECT 
		CONCAT(pc.event_id,':',pc.price_code) ETL__SSID
		, pc.event_id AS [ETL__SSID_TM_Event_id]
		, pc.price_code AS [ETL__SSID_TM_Price_Code]
		, s.name AS Season
		, e.event_name AS Item
		, pc.price_code AS PriceCode
		, pc.price_code_desc AS PriceCodeDesc
		, NULL AS PriceCodeClass
		, CASE WHEN LEN(pc.price_code) >= 1 THEN  SUBSTRING(pc.price_code,1,1) END AS PC1
		, CASE WHEN LEN(pc.price_code) >= 2 THEN  SUBSTRING(pc.price_code,2,1) END AS PC2
		, CASE WHEN LEN(pc.price_code) >= 3 THEN  SUBSTRING(pc.price_code,3,1) END AS PC3
		, CASE WHEN LEN(pc.price_code) >= 4 THEN  SUBSTRING(pc.price_code,4,1) END AS PC4
		, pc.price_code_group AS PriceCodeGroup
		, pc.price FullPrice

		, pc.[price] [TM_price]
		, pc.[parent_price_code] [TM_parent_price_code]
		, pc.[ticket_type_code] [TM_ticket_type_code]
		, pc.[full_price_ticket_type_code] [TM_full_price_ticket_type_code]
		, pc.[tt_code] [TM_tt_code]
		, pc.[ticket_type] [TM_ticket_type]
		, pc.[ticket_type_desc] [TM_ticket_type_desc]
		, pc.[ticket_type_category] [TM_ticket_type_category]
		, pc.[comp_ind] [TM_comp_ind]
		, pc.[default_host_offer_id] [TM_default_host_offer_id]
		, pc.[ticket_type_relationship] [TM_ticket_type_relationship]
		, pc.[upd_user] [TM_upd_user]
		, pc.[upd_datetime] [TM_upd_datetime]
		, pc.[pricing_method] [TM_pricing_method]
		, pc.[tm_price_level] [TM_host_price_level]
		, pc.[tm_ticket_type] [TM_host_ticket_type]
		, pc.[ticket_template_override] [TM_ticket_template_override]
		, pc.[ticket_template] [TM_ticket_template]
		, pc.[code] [TM_code]
		, pc.[price_code_group] [TM_price_code_group]
		, pc.[price_code_desc] [TM_price_code_desc]
		, pc.[price_code_info1] [TM_price_code_info1]
		, pc.[price_code_info2] [TM_price_code_info2]
		, pc.[price_code_info3] [TM_price_code_info3]
		, pc.[price_code_info4] [TM_price_code_info4]
		, pc.[price_code_info5] [TM_price_code_info5]
		, pc.[color] [TM_color]
		, pc.[printed_price] [TM_printed_price]
		, pc.[pc_ticket] [TM_pc_ticket]
		, pc.[pc_tax] [TM_pc_tax]
		, pc.[pc_licfee] [TM_pc_licfee]
		, pc.[pc_other1] [TM_pc_other1]
		, pc.[pc_other2] [TM_pc_other2]
		, pc.[tax_rate_a] [TM_tax_rate_a]
		, pc.[tax_rate_b] [TM_tax_rate_b]
		, pc.[tax_rate_c] [TM_tax_rate_c]
		, pc.[onsale_datetime] [TM_onsale_datetime]
		, pc.[offsale_datetime] [TM_offsale_datetime]
		, pc.[inet_onsale_datetime] [TM_inet_onsale_datetime]
		, pc.[inet_offsale_datetime] [TM_inet_offsale_datetime]
		, pc.[inet_price_code_name] [TM_inet_price_code_name]
		, pc.[inet_offer_text] [TM_inet_offer_text]
		, pc.[inet_full_price] [TM_inet_full_price]
		, pc.[inet_min_tickets_per_tran] [TM_inet_min_tickets_per_tran]
		, pc.[inet_max_tickets_per_tran] [TM_inet_max_tickets_per_tran]
		, pc.[tid_family_id] [TM_tid_family_id]
		, pc.[on_purch_add_to_acct_group_id] [TM_on_purch_add_to_acct_group_id]
		, pc.[auto_add_membership_name] [TM_auto_add_membership_name]
		, pc.[required_membership_list] [TM_required_membership_list]
		, pc.[card_template_override] [TM_card_template_override]
		, pc.[card_template] [TM_card_template]
		, pc.[ledger_id] [TM_ledger_id]
		, pc.[merchant_id] [TM_merchant_id]
		, pc.[merchant_code] [TM_merchant_code]
		, pc.[merchant_color] [TM_merchant_color]
		, pc.[membership_reqd_for_purchase] [TM_membership_reqd_for_purchase]
		, pc.[membership_id_for_membership_event] [TM_membership_id_for_membership_event]
		, pc.[membership_name] [TM_membership_name]
		, pc.[membership_expiration_date] [TM_membership_expiration_date]
		, pc.[club_group_enabled] [TM_club_group_enabled]


	FROM ods.TM_PriceCode pc (NOLOCK)
	LEFT OUTER JOIN ods.TM_Evnt e (NOLOCK) ON pc.event_id = e.Event_id
	LEFT OUTER JOIN ods.TM_Season s (NOLOCK) ON e.Season_id = s.season_id



)






GO
