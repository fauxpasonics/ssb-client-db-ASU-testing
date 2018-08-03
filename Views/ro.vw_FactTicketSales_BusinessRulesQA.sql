SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [ro].[vw_FactTicketSales_BusinessRulesQA]

AS

(

select DISTINCT ETL__SourceSystem, SeasonName, SeasonYear, Sport, EventCode, EventName, ItemCode, ItemName, PlanCode, PlanName, PlanClass,
PriceCode, pc1, PC2, PC3, PC4, PriceCodeDesc, PriceLevelCode, TicketClassCode, TicketTypeCode, TicketTypeName, PlanTypeCode, PlanTypeName, SeatTypeCode, SeatTypeName,
SUM(QtySeat) QtySeat, SUM(QtySeatFSE) QtySeatFSE, SUM(QtySeatRenewable) QtySeatRenewable, SUM(RevenueTotal) RevenueTotal,
IsPremium, IsComp, IsHost, IsPlan, IsPartial, IsSingleEvent, IsGroup, IsBroker, IsRenewal, IsExpanded, TM_comp_Code, TM_comp_name, TM_ticket_type
FROM  [ro].[vw_FactTicketSalesBase_All] fts 
WHERE Sport = 'Football'

GROUP BY ETL__SourceSystem, SeasonName, SeasonYear, Sport, EventCode, EventName, ItemCode, ItemName, PlanCode, PlanName, PlanClass,
PriceCode, pc1, PC2, PC3, PC4, PriceCodeDesc, PriceLevelCode, TicketClassCode, TicketTypeCode, TicketTypeName, PlanTypeCode, PlanTypeName, SeatTypeCode, SeatTypeName,
IsPremium, IsComp, IsHost, IsPlan, IsPartial, IsSingleEvent, IsGroup, IsBroker, IsRenewal, IsExpanded, TM_comp_Code, TM_comp_name, TM_ticket_type

)


GO
