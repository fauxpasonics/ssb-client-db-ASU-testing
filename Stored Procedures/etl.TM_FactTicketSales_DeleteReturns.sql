SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[TM_FactTicketSales_DeleteReturns] 
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(MAX) = null
)

AS
BEGIN


	DECLARE @TMSourceSystem NVARCHAR(255) = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))

	/* Get Ods Values */
	SELECT tkt.event_id, tkt.section_id, tkt.row_id, tkt.seat_num, tkt.num_seats, tkt.acct_id 
	INTO #tkt
	FROM ods.tm_vw_ticket tkt
	--LEFT OUTER JOIN dbo.DimItem dItem ON CASE WHEN tkt.plan_event_id = 0 THEN tkt.event_id ELSE tkt.plan_event_id END = dItem.SSID_event_id AND dItem.SourceSystem = @TMSourceSystem AND dItem.DimItemId > 0
	--WHERE ISNULL(dItem.Config_IsFactSalesEligible,1) = 1 AND ISNULL(dItem.Config_IsClosed,0) = 0


	/* Get Facts */
	SELECT f.FactTicketSalesId, f.ETL__SSID_TM_event_id event_id, f.ETL__SSID_TM_section_id section_id, f.ETL__SSID_TM_row_id row_id, f.ETL__SSID_TM_seat_num seat_num, f.QtySeat num_seats, f.ETL__SSID_TM_acct_id acct_id 
	INTO #fact
	FROM etl.vw_FactTicketSales f
	--INNER JOIN dbo.DimItem di ON f.DimItemId = di.DimItemId
	WHERE f.ETL__SourceSystem = @TMSourceSystem
	--AND ISNULL(di.Config_IsClosed,0) = 0

	CREATE NONCLUSTERED INDEX IDX_Key ON #tkt ( event_id, section_id, row_id, seat_num )
	CREATE NONCLUSTERED INDEX IDX_Key ON #fact ( event_id, section_id, row_id, seat_num )

	/* Compare 2 sets for records only in fact */
	SELECT f.* 
	INTO #ToDelete
	FROM #fact f
	LEFT OUTER JOIN #tkt tkt
		ON f.event_id = tkt.event_id
		AND f.section_id = tkt.section_id
		AND f.row_id = tkt.row_id
		AND f.seat_num = tkt.seat_num
	WHERE tkt.event_id IS NULL


	DELETE f
	FROM etl.vw_FactTicketSales f
	INNER JOIN #ToDelete td ON f.FactTicketSalesId = td.FactTicketSalesId

	

END






GO
