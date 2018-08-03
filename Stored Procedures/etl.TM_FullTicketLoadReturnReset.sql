SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[TM_FullTicketLoadReturnReset]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(MAX) = NULL
)

AS 
BEGIN


	SELECT DISTINCT CAST(event_id AS INT) event_id
	INTO #events
	FROM stg.TM_Ticket
	WHERE ticket_status = 'A'


	SELECT e.event_id, SUM(tkt.num_seats) qty
	INTO #OdsCounts
	FROM ods.TM_vw_Ticket tkt
	INNER JOIN #events e ON tkt.event_id = e.event_id
	GROUP BY e.event_id


	SELECT e.event_id, SUM(CAST(tkt.num_seats AS INT)) qty
	INTO #StageCounts
	FROM stg.TM_Ticket tkt
	INNER JOIN #events e ON tkt.event_id = e.event_id
	GROUP BY e.event_id
	

	SELECT e.event_id, sc.qty StageQty, oc.qty OdsQty
	, (CAST(sc.qty AS DECIMAL(18,6)) / CAST(NULLIF(oc.qty,0) AS DECIMAL(18,6))) StagePct	
	INTO #EventStagePct
	FROM #events e
	LEFT OUTER JOIN #StageCounts sc ON e.event_id = sc.event_id
	LEFT OUTER JOIN #OdsCounts oc ON e.event_id = oc.event_id

	SELECT DISTINCT event_id
	INTO #ValidEvents
	FROM #EventStagePct
	WHERE ISNULL(StagePct, 1) > .8


	INSERT INTO etl.TM_FullTicketLoadReturnResetExceptionLog ( ETL__CreatedDate, BatchId, RuntimeSettings, StageQty, OdsQty, event_id )
	SELECT DISTINCT GETDATE() ETL__CreatedDate, NULL BatchId, NULL RuntimeSettings, StageQty, OdsQty, event_id	
	FROM #EventStagePct
	WHERE ISNULL(StagePct, 1) <= .8


	SELECT ticket_status, event_id, section_id, row_id, seat_num, num_seats
	INTO #tkt
	FROM ods.TM_vw_Ticket
	WHERE event_id IN ( SELECT event_id FROM #ValidEvents )

	SELECT ticket_status, CAST(event_id AS INT) event_id, CAST(section_id AS DECIMAL(10,0)) section_id, CAST(row_id AS DECIMAL(10,0)) row_id, CAST(seat_num AS INT) seat_num, CAST(num_seats AS INT) num_seats
	INTO #stg
	FROM stg.TM_Ticket (NOLOCK)
	WHERE ticket_status = 'A'
	AND event_id IN ( SELECT event_id FROM #ValidEvents )

	CREATE NONCLUSTERED INDEX IDX_Key ON #tkt (ticket_status, event_id, section_id, row_id, seat_num, num_seats)
	CREATE NONCLUSTERED INDEX IDX_Key ON #stg (ticket_status, event_id, section_id, row_id, seat_num, num_seats)
	
	
	SELECT ticket_status, event_id, section_id, row_id, seat_num, num_seats
	INTO #returned
	FROM #tkt

	EXCEPT
	
	SELECT ticket_status, event_id, section_id, row_id, seat_num, num_seats
	FROM #stg
	WHERE ticket_status = 'A'


	--SELECT *
	DELETE tkt
	FROM ods.TM_Ticket tkt
	INNER JOIN #returned r ON tkt.event_id = r.event_id AND tkt.section_id = r.section_id AND tkt.row_id = r.row_id AND tkt.seat_num = r.seat_num AND tkt.num_seats = r.num_seats
	WHERE tkt.ticket_status = 'A'

END
GO
