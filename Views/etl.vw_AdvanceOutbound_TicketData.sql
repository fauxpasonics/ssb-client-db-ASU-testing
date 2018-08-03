SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/****** 
Created by AMeitin October 2017

The purpose of this view is to provide the ASU Foundation with summarized ticket transaction data 
for use in Advance and Priority Points.

This view is synced nightly to server 10.90.2.3 controlled by the ASU Foundation ******/

CREATE VIEW  [etl].[vw_AdvanceOutbound_TicketData] 

AS 
(

SELECT 

  f.FactTicketSalesId AS TRANSNUMBER
, ISNULL(CAST(f.ETL__SSID_TM_acct_id AS VARCHAR(50)), CAST(f.ETL__SSID_PAC_CUSTOMER AS VARCHAR(50))) AS ACCTNUMBER 
, ISNULL(ds.Config_SeasonYear, ds.SeasonYear) AS TICKET_YEAR
, ds.Config_Org AS TICKET_SPORT
, di.ItemName AS ITEM_LABEL 
, dtt.TicketTypeClass AS ITEM_CATEGORY
, SUM(f.QtySeat) AS QTY
, CASE WHEN f.ETL__SourceSystem = 'TM' THEN dpc.PriceCode + ' (' + dpc.PriceCodeDesc  + ')' 
	   ELSE dprt.PriceTypeCode + ' (' + dprt.PriceTypeName  + ')' 
	   END AS PRICETYPE
, dst.SectionName + ' ' + dst.RowName + ' ' + dst.Seat AS SEAT_LABEL
 
,CASE WHEN f.PaidAmount > 0 THEN 1 ELSE 0 END AS PAID 

FROM [ro].[vw_FactTicketSales] f
INNER JOIN [ro].[vw_DimSeason] ds ON f.DimSeasonid = ds.DimSeasonId
INNER JOIN [ro].[vw_DimItem] di ON f.DimItemId = di.DimItemId
INNER JOIN [ro].[vw_DimTicketType] dtt ON f.DimTicketTypeId = dtt.DimTicketTypeId
INNER JOIN [ro].[vw_DimPriceType] dprt ON f.DimPriceTypeId = dprt.DimPriceTypeId
INNER JOIN [ro].[vw_DimPriceCode] dpc ON f.DimPriceCodeId = dpc.DimPriceCodeId
INNER JOIN [ro].[vw_DimSeat] dst ON f.DimSeatId_Start = dst.DimSeatId


WHERE ds.Config_Org IS NOT NULL
AND f.DimTicketTypeId > 0
AND f.DimSeasonId NOT IN ('97', '134') --exclude PAC seasons 2017 Football & MBB

GROUP BY FactTicketSalesId, f.ETL__SSID_TM_acct_id, f.ETL__SSID_PAC_CUSTOMER, ISNULL(Config_SeasonYear, SeasonYear), ds.Config_Org, ItemName, TicketTypeClass
, DimPlanId, PriceCode, PriceCodeDesc, SectionName, RowName, Seat, PaidAmount
, f.ETL__SourceSystem, PriceTypeCode, PriceTypeName


)






GO
