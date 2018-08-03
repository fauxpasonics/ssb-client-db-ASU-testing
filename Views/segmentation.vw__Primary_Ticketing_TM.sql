SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE   VIEW [segmentation].[vw__Primary_Ticketing_TM]
AS 

( SELECT    dc.SSB_CRMSYSTEM_CONTACT_ID
            , TransDateTime
			, TicketingAccountId
			, ArenaName
			, SeasonHeaderName
			, SeasonName
			, SeasonYear
			, SeasonClass
			, Sport
			, EventHeaderName
			, EventCode
			, EventName
			, EventDesc
			, EventClass
			, EventDate
			, ItemCode
			, ItemName
			, PlanCode
			, PlanName
			, PlanClass
			, PlanFse
			, PlanEventCnt
			, SectionName
			, RowName
			, Seat
			, SeatLocationMapping
			, PriceCode, pc1, PC2, PC3, PC4, PriceCodeDesc, PriceCodeGroup
			, TicketClassCode, TicketClassName, TicketTypeCode, TicketTypeName, TicketTypeClass
			, PlanTypeCode, PlanTypeName, SeatTypeCode, SeatTypeName, SalesCode, SalesCodeName
			, PromoCode, PromoName
			,  QtySeat, QtySeatFSE, RevenueTotal
			, PaidAmount, OwedAmount, PaidStatus
			, IsPremium, IsComp, IsHost, IsPlan, IsPartial, IsSingleEvent, IsGroup, IsBroker
			, IsRenewal, IsExpanded, IsAutoRenewalNextSeason
			, TM_comp_code, TM_comp_name, TM_group_sales_name
			, TM_ticket_type, TM_tran_type, TM_sales_source_name
			, TM_retail_ticket_type, TM_retail_qualifiers


     FROM      [ro].[vw_FactTicketSalesBase_All] fts 
                INNER JOIN [dbo].[vwDimCustomer_ModAcctId] dc  ON dc.AccountId = fts.TicketingAccountId AND dc.CustomerType = 'Primary' AND dc.SourceSystem = 'TM'
				WHERE ETL__SourceSystem = 'TM' 

	UNION ALL

	SELECT    dc.SSB_CRMSYSTEM_CONTACT_ID
            , TransDateTime
			, TicketingAccountId
			, ArenaName
			, SeasonHeaderName
			, SeasonName
			, SeasonYear
			, SeasonClass
			, Sport
			, EventHeaderName
			, EventCode
			, EventName
			, EventDesc
			, EventClass
			, EventDate
			, ItemCode
			, ItemName
			, PlanCode
			, PlanName
			, PlanClass
			, PlanFse
			, PlanEventCnt
			, SectionName
			, RowName
			, Seat
			, SeatLocationMapping
			, PriceCode, pc1, PC2, PC3, PC4, PriceCodeDesc, PriceCodeGroup
			, TicketClassCode, TicketClassName, TicketTypeCode, TicketTypeName, TicketTypeClass
			, PlanTypeCode, PlanTypeName, SeatTypeCode, SeatTypeName, SalesCode, SalesCodeName
			, PromoCode, PromoName
			,  QtySeat, QtySeatFSE, RevenueTotal
			, PaidAmount, OwedAmount, PaidStatus
			, IsPremium, IsComp, IsHost, IsPlan, IsPartial, IsSingleEvent, IsGroup, IsBroker
			, IsRenewal, IsExpanded, IsAutoRenewalNextSeason
			, TM_comp_code, TM_comp_name, TM_group_sales_name
			, TM_ticket_type, TM_tran_type, TM_sales_source_name
			, TM_retail_ticket_type, TM_retail_qualifiers


     FROM       [ro].[vw_FactTicketSalesBase_All] fts 
                INNER JOIN [dbo].[vwDimCustomer_ModAcctId] dc 
					ON dc.SSID = fts.TicketingAccountId AND dc.SourceSystem = 'TI ASU'
				WHERE ETL__SourceSystem = 'PAC' 
					AND fts.SeasonYear >= 2016
)









GO
