SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[TM_Stage_FactTicketActivity] 
( 
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000', 
	@Options NVARCHAR(max) = NULL 
) 
 
AS 
BEGIN 
 

DECLARE @OptionsXML XML = TRY_CAST(@Options AS XML)


DECLARE @LoadDate DATETIME = (GETDATE() - 2)

SELECT @LoadDate = t.x.value('LoadDate[1]','DateTime')
FROM @OptionsXML.nodes('options') t(x)

PRINT @LoadDate

SELECT *
INTO #tex
FROM ods.TM_Tex tex
WHERE tex.UpdateDate >= @LoadDate


CREATE NONCLUSTERED INDEX IDX_event_id ON #tex (event_id)
CREATE NONCLUSTERED INDEX IDX_acct_id ON #tex (acct_id)
CREATE NONCLUSTERED INDEX IDX_assoc_acct_id ON #tex (assoc_acct_id)
CREATE NONCLUSTERED INDEX IDX_activity ON #tex (activity)
CREATE NONCLUSTERED INDEX IDX_section_id ON #tex (section_id)
CREATE NONCLUSTERED INDEX IDX_row_id ON #tex (row_id)
CREATE NONCLUSTERED INDEX IDX_seat_num ON #tex (seat_num)



TRUNCATE TABLE stg.TM_FactTicketActivity

INSERT INTO stg.TM_FactTicketActivity 
(
    ETL__SSID, ETL__SSID_TM_ods_id, ETL__SSID_TM_activity, ETL__SSID_TM_event_id, ETL__SSID_TM_section_id, ETL__SSID_TM_row_id,
    ETL__SSID_TM_seat_num, ETL__SSID_TM_num_seats, ETL__SSID_TM_add_datetime, DimDateId, DimTimeId, DimArenaId, DimSeasonId,
    DimItemId, DimEventId, DimPlanId, DimSeatId_Start, DimTicketCustomerId, DimTicketCustomerId_Recipient, DimActivityId, TransDateTime, QtySeat,
    SubTotal, Fees, Taxes, Total, CreatedBy, UpdatedBy, CreatedDate, UpdatedDate, TM_order_num, TM_order_line_item,
    TM_order_line_item_seq, TM_forward_to_name, TM_forward_to_email_addr, TM_Orig_purchase_price, TM_te_seller_credit_amount,
    TM_te_seller_fees, TM_te_posting_price, TM_te_buyer_fees_hidden, TM_te_purchase_price, TM_te_buyer_fees_not_hidden,
    TM_inet_delivery_fee, TM_inet_transaction_amount, TM_delivery_method, TM_activity, TM_activity_name
)


SELECT 
	CONCAT(tex.activity, ':', tex.event_id, ':', tex.section_id, ':', tex.row_id, ':', tex.seat_num, ':', tex.num_seats, ':', tex.add_datetime) [ETL__SSID]
	, tex.id ETL__SSID_TM_ods_id
	, tex.activity ETL__SSID_TM_activity
	, tex.event_id ETL__SSID_TM_event_id
	, tex.section_id ETL__SSID_TM_section_id
	, tex.row_id ETL__SSID_TM_row_id
	, tex.seat_num ETL__SSID_TM_seat_num
	, tex.num_seats ETL__SSID_TM_num_seats
	, tex.add_datetime ETL__SSID_TM_add_datetime
	
	, CONVERT(VARCHAR, tex.add_datetime, 112) DimDateId
	, datediff(second, cast(tex.add_datetime as date), tex.add_datetime) DimTimeId
	
	, isnull(dArena.DimArenaId, -1) DimArenaId
	, isnull(dSeason.DimSeasonId, -1) DimSeasonId
	, isnull(dItem.DimItemId, -1) DimItemId	
	, CASE WHEN ISNULL(dItem.ItemType,'') <> 'Event' THEN 0 ELSE isnull(dEvent.DimEventId, -1) END DimEventId
	, CASE WHEN ISNULL(dItem.ItemType,'') <> 'Plan' THEN 0 ELSE isnull(dPlan.DimPlanId, -1) END DimPlanId	
	, isnull(dSeat.DimSeatId, -1) DimSeatId_Start

	, ISNULL(dTicketCustomer.DimTicketCustomerId, -1) DimTicketCustomerId
	, ISNULL(dTicketCustomerRec.DimTicketCustomerId, -1) DimTicketCustomerId_Recipient
	, isnull(dActivity.DimActivityId, -1) DimActivityId	

	, tex.add_datetime TransDateTime
	
	, tex.num_seats QtySeat
	
	, ISNULL(tex.te_purchase_price, 0) SubTotal
	, (ISNULL(tex.te_buyer_fees_hidden, 0) + ISNULL(tex.te_buyer_fees_not_hidden, 0)) Fees
	, ISNULL(tex.te_buyer_sales_tax, 0) Taxes
	, ISNULL(tex.inet_transaction_amount, 0) Total

	, SUSER_NAME() CreatedBy, SUSER_NAME() UpdatedBy, GETUTCDATE() CreatedDate, GETUTCDATE() UpdatedDate

	, tex.order_num TM_order_num
	, tex.order_line_item TM_order_line_item
	, tex.order_line_item_seq TM_order_line_item_seq
	, tex.forward_to_name TM_forward_to_name
	, tex.forward_to_email_addr TM_forward_to_email_addr
	, tex.Orig_purchase_price TM_Orig_purchase_price 
	, tex.te_seller_credit_amount TM_te_seller_credit_amount
	, tex.te_seller_fees TM_te_seller_fees
	, tex.te_posting_price TM_te_posting_price
	, tex.te_buyer_fees_hidden TM_te_buyer_fees_hidden
	, tex.te_purchase_price TM_te_purchase_price
	, tex.te_buyer_fees_not_hidden TM_te_buyer_fees_not_hidden
	, tex.inet_delivery_fee TM_inet_delivery_fee
	, tex.inet_transaction_amount TM_inet_transaction_amount
	, tex.delivery_method TM_delivery_method
	, tex.activity TM_activity
	, tex.activity_name TM_activity_name

FROM #tex tex

LEFT OUTER JOIN etl.vw_DimItem (nolock) dItem ON tex.event_id = dItem.ETL__SSID_TM_event_id
	AND dItem.ETL__SourceSystem = 'TM' AND dItem.DimItemId > 0 AND dItem.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimEvent (nolock) dEvent ON tex.event_id = dEvent.ETL__SSID_TM_event_id
	AND dEvent.ETL__SourceSystem = 'TM' AND dEvent.DimEventId > 0 AND dEvent.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimPlan (nolock) dPlan ON tex.event_id = dPlan.ETL__SSID_TM_event_id
	AND dPlan.ETL__SourceSystem = 'TM' AND dPlan.DimPlanId > 0 AND dPlan.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimSeason (nolock) dSeason ON dItem.TM_season_id = dSeason.ETL__SSID_TM_season_Id
	AND dSeason.ETL__SourceSystem = 'TM' AND dSeason.DimSeasonId > 0 AND dSeason.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimArena (nolock) dArena ON dSeason.TM_arena_id = dArena.ETL__SSID_TM_arena_id
	AND dArena.ETL__SourceSystem = 'TM' AND dArena.DimArenaId > 0 AND dArena.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimActivity (nolock) dActivity ON tex.activity = dActivity.ETL__SSID_TM_activity
	AND dActivity.ETL__SourceSystem = 'TM' AND dActivity.DimActivityId > 0 AND dActivity.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimTicketCustomer (nolock) dTicketCustomer ON tex.acct_id = dTicketCustomer.ETL__SSID_TM_acct_id
	AND dTicketCustomer.ETL__SourceSystem = 'TM' AND dTicketCustomer.DimTicketCustomerId > 0 AND dTicketCustomer.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimTicketCustomer (nolock) dTicketCustomerRec ON tex.assoc_acct_id = dTicketCustomerRec.ETL__SSID_TM_acct_id
	AND dTicketCustomerRec.ETL__SourceSystem = 'TM' AND dTicketCustomerRec.DimTicketCustomerId > 0 AND dTicketCustomerRec.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimSeat (nolock) dSeat ON dseason.TM_manifest_id = dSeat.ETL__SSID_TM_Manifest_Id AND tex.section_id = dSeat.ETL__SSID_TM_Section_Id AND tex.row_id = dSeat.ETL__SSID_TM_Row_Id AND tex.seat_num = dSeat.ETL__SSID_TM_Seat
	AND dSeat.ETL__SourceSystem = 'TM' AND dSeat.DimSeatId > 0 AND dSeat.ETL__IsDeleted = 0

 
DROP TABLE #tex


END 
 
 
 
 














GO
