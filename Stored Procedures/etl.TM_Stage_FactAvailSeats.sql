SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[TM_Stage_FactAvailSeats] 
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
INTO #DataSet
FROM ods.TM_AvailSeats
WHERE UpdateDate >= @LoadDate


CREATE NONCLUSTERED INDEX IDX_event_id ON #DataSet (event_id)
CREATE NONCLUSTERED INDEX IDX_price_code ON #DataSet (price_code)
CREATE NONCLUSTERED INDEX IDX_class_id ON #DataSet (class_id)
CREATE NONCLUSTERED INDEX IDX_srs ON #DataSet (section_id, row_id, seat_num)
CREATE NONCLUSTERED INDEX IDX_id ON #DataSet (id)



TRUNCATE TABLE stg.TM_FactAvailSeats

INSERT INTO stg.TM_FactAvailSeats 
(
    ETL__SSID, ETL__SSID_TM_ods_id, ETL__SSID_TM_event_id, ETL__SSID_TM_section_id, ETL__SSID_TM_row_id, ETL__SSID_TM_seat_num,
    ETL__SSID_TM_price_code, DimDateId, DimTimeId, DimArenaId, DimSeasonId, DimItemId, DimEventId, DimPlanId, DimPriceLevelId,
    DimPriceTypeId, DimPriceCodeId, DimSeatId_Start, DimSeatStatusId, DimPlanTypeId, DimTicketTypeId, DimSeatTypeId,
    DimTicketClassId, PostedDateTime, QtySeat, SubTotal, Fees, Taxes, Total, TM_price, TM_block_full_price, TM_printed_price,
    TM_pc_ticket, TM_pc_tax, TM_pc_licfee, TM_pc_other1, TM_pc_other2, TM_pc_other3, TM_pc_other4, TM_pc_other5, TM_pc_other6,
    TM_pc_other7, TM_pc_other8, TM_tax_rate_a, TM_tax_rate_b, TM_tax_rate_c, TM_direction, TM_quality, TM_attribute, TM_aisle,
    TM_section_type, TM_section_sort, TM_row_sort, TM_row_index, TM_block_id, TM_config_id, TM_plan_type, TM_sellable,
    TM_onsale_datetime, TM_offsale_datetime, TM_block_purchase_price, TM_sell_type, TM_status, TM_display_status, TM_unsold_type,
    TM_unsold_qual_id, TM_reserved, TM_oss_onsale_datetime, TM_oss_offsale_datetime, TM_row_barcode_index,
    TM_row_barcode_index_high, TM_barcode_season_key, TM_barcode_event_slot_min, TM_barcode_event_slot_max,
    TM_barcode_seatcode_adjustment, TM_access_control_system_ip, TM_access_control_system_port, TM_seat_code_low,
    TM_seat_code_high, TM_digit_server_id, TM_im_mode, TM_host_integration_enabled, TM_host_synch_status, TM_action
)



SELECT 
	CONCAT(ds.event_id, ':', ds.section_id, ':', ds.row_id, ':', ds.seat_num) ETL__SSID
	, ds.id ETL__SSID_TM_ods_id
	, ds.event_id ETL__SSID_TM_event_id
	, ds.section_id ETL__SSID_TM_section_id
	, ds.row_id ETL__SSID_TM_row_id
	, ds.seat_num ETL__SSID_TM_seat_num
	, ds.price_code ETL__SSID_TM_price_code

	, CONVERT(VARCHAR, ds.InsertDate, 112) DimDateId
	, datediff(second, cast(ds.InsertDate as date), ds.InsertDate) DimTimeId
	
	, isnull(dArena.DimArenaId, -1) DimArenaId
	, isnull(dSeason.DimSeasonId, -1) DimSeasonId
	, isnull(dItem.DimItemId, -1) DimItemId
	, CASE WHEN ISNULL(dItem.ItemType,'') <> 'Event' THEN 0 ELSE isnull(dEvent.DimEventId, -1) END DimEventId
	, CASE WHEN ISNULL(dItem.ItemType,'') <> 'Plan' THEN 0 ELSE isnull(dPlan.DimPlanId, -1) END DimPlanId	
	, 0 DimPriceLevelId
	, 0 DimPriceTypeId
	, ISNULL(dPriceCode.DimPriceCodeId, -1) DimPriceCodeId	
	, isnull(dSeat.DimSeatId, -1) DimSeatId_Start
	, isnull(dSeatStatus.DimSeatStatusId, -1) DimSeatStatusId	

	, -1 DimPlanTypeId
	, -1 DimTicketTypeId
	, -1 DimSeatTypeId
	, -1 DimTicketClassId
	
	, ds.InsertDate [PostedDateTime]

	, ds.num_seats QtySeat

	, (ds.block_purchase_price - ds.pc_licfee - ds.pc_tax) [SubTotal]
	, ds.pc_licfee [Fees]
	, ds.pc_tax  [Taxes]
	, ds.block_purchase_price [Total]
	
	, ds.[price] [TM_price]
	, ds.[block_full_price] [TM_block_full_price]
	, ds.[printed_price] [TM_printed_price]
	, ds.[pc_ticket] [TM_pc_ticket]
	, ds.[pc_tax] [TM_pc_tax]
	, ds.[pc_licfee] [TM_pc_licfee]
	, ds.[pc_other1] [TM_pc_other1]
	, ds.[pc_other2] [TM_pc_other2]
	, ds.[pc_other3] [TM_pc_other3]
	, ds.[pc_other4] [TM_pc_other4]
	, ds.[pc_other5] [TM_pc_other5]
	, ds.[pc_other6] [TM_pc_other6]
	, ds.[pc_other7] [TM_pc_other7]
	, ds.[pc_other8] [TM_pc_other8]
	, ds.[tax_rate_a] [TM_tax_rate_a]
	, ds.[tax_rate_b] [TM_tax_rate_b]
	, ds.[tax_rate_c] [TM_tax_rate_c]
	, ds.[direction] [TM_direction]
	, ds.[quality] [TM_quality]
	, ds.[attribute] [TM_attribute]
	, ds.[aisle] [TM_aisle]
	, ds.[section_type] [TM_section_type]
	, ds.[section_sort] [TM_section_sort]
	, ds.[row_sort] [TM_row_sort]
	, ds.[row_index] [TM_row_index]
	, ds.[block_id] [TM_block_id]
	, ds.[config_id] [TM_config_id]
	, ds.[plan_type] [TM_plan_type]
	, ds.[sellable] [TM_sellable]
	, ds.[onsale_datetime] [TM_onsale_datetime]
	, ds.[offsale_datetime] [TM_offsale_datetime]
	, ds.[block_purchase_price] [TM_block_purchase_price]
	, ds.[sell_type] [TM_sell_type]
	, ds.[status] [TM_status]
	, ds.[display_status] [TM_display_status]
	, ds.[unsold_type] [TM_unsold_type]
	, ds.[unsold_qual_id] [TM_unsold_qual_id]
	, ds.[reserved] [TM_reserved]
	, ds.[oss_onsale_datetime] [TM_oss_onsale_datetime]
	, ds.[oss_offsale_datetime] [TM_oss_offsale_datetime]
	, ds.[row_barcode_index] [TM_row_barcode_index]
	, ds.[row_barcode_index_high] [TM_row_barcode_index_high]
	, ds.[barcode_season_key] [TM_barcode_season_key]
	, ds.[barcode_event_slot_min] [TM_barcode_event_slot_min]
	, ds.[barcode_event_slot_max] [TM_barcode_event_slot_max]
	, ds.[barcode_seatcode_adjustment] [TM_barcode_seatcode_adjustment]
	, ds.[access_control_system_ip] [TM_access_control_system_ip]
	, ds.[access_control_system_port] [TM_access_control_system_port]
	, ds.[seat_code_low] [TM_seat_code_low]
	, ds.[seat_code_high] [TM_seat_code_high]
	, ds.[digit_server_id] [TM_digit_server_id]
	, ds.[im_mode] [TM_im_mode]
	, ds.[host_integration_enabled] [TM_host_integration_enabled]
	, ds.[host_synch_status] [TM_host_synch_status]
	, ds.[action] [TM_action]
	


--SELECT COUNT(*)
FROM #DataSet ds


LEFT OUTER JOIN etl.vw_DimItem (nolock) dItem ON ds.event_id = dItem.ETL__SSID_TM_event_id
	AND dItem.ETL__SourceSystem = 'TM' AND dItem.DimItemId > 0 AND dItem.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimEvent (nolock) dEvent ON ds.event_id = dEvent.ETL__SSID_TM_event_id
	AND dEvent.ETL__SourceSystem = 'TM' AND dEvent.DimEventId > 0 AND dEvent.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimPlan (nolock) dPlan ON ds.event_id = dPlan.ETL__SSID_TM_event_id
	AND dPlan.ETL__SourceSystem = 'TM' AND dPlan.DimPlanId > 0 AND dPlan.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimSeason (nolock) dSeason ON CASE  WHEN dEvent.DimEventId > 0 THEN dEvent.TM_season_id ELSE dPlan.TM_season_id END = dSeason.ETL__SSID_TM_season_Id
	AND dSeason.ETL__SourceSystem = 'TM' AND dSeason.DimSeasonId > 0 AND dSeason.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimArena (nolock) dArena ON dSeason.TM_arena_id = dArena.ETL__SSID_TM_arena_id
	AND dArena.ETL__SourceSystem = 'TM' AND dArena.DimArenaId > 0 AND dArena.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimPriceCode (nolock) dPriceCode ON ds.event_id = dPriceCode.ETL__SSID_TM_event_id AND ds.price_code = dPriceCode.ETL__SSID_TM_price_code
	AND dPriceCode.ETL__SourceSystem = 'TM' AND dPriceCode.DimPriceCodeId > 0 AND dPriceCode.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimSeat (nolock) dSeat ON dSeason.TM_manifest_id = dSeat.ETL__SSID_TM_Manifest_Id AND ds.section_id = dSeat.ETL__SSID_TM_Section_Id AND ds.row_id = dSeat.ETL__SSID_TM_Row_Id AND ds.seat_num = dSeat.ETL__SSID_TM_Seat
	AND dSeat.ETL__SourceSystem = 'TM' AND dSeat.DimSeatId > 0 AND dSeat.ETL__IsDeleted = 0

LEFT OUTER JOIN etl.vw_DimSeatStatus (nolock) dSeatStatus ON ds.class_name = dSeatStatus.SeatStatusName
	AND dSeatStatus.ETL__SourceSystem = 'TM' AND dSeatStatus.DimSeatStatusId > 0 AND dSeatStatus.ETL__IsDeleted = 0


 
--DROP TABLE #DataSet

END 
 
 
 
 











GO
