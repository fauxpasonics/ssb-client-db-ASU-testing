SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[TM_ResetOverlappingSeatBlocks]
(
	@BatchId NVARCHAR(50) = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(MAX) = null
)

AS
BEGIN

	SELECT DISTINCT tkt.id 
	INTO #DupeOdsIdLoser
	FROM (
		SELECT tkt.*, sl.Seat
		, ROW_NUMBER() OVER(PARTITION BY tkt.event_id, tkt.section_id, tkt.row_id, sl.Seat ORDER BY tkt.upd_datetime DESC, tkt.UpdateDate DESC) RowRank
		FROM   ods.TM_vw_Ticket tkt
		INNER JOIN dbo.Lkp_SeatList sl ON sl.Seat BETWEEN tkt.seat_num AND (tkt.seat_num + tkt.num_seats -1)
		WHERE tkt.ticket_status = 'A' 
	) tkt
	WHERE tkt.RowRank > 1

	CREATE NONCLUSTERED	INDEX IX_id ON #DupeOdsIdLoser (id)

	
	INSERT INTO etl.AUDIT_TM_Ticket_DeletedDuplicateSeats 	
		SELECT GETDATE() ETL__CreatedDate, tkt.*
		FROM ods.TM_Ticket tkt
		INNER JOIN #DupeOdsIdLoser d ON tkt.id = d.id
		WHERE tkt.ticket_status = 'A'


	delete tkt
	FROM ods.TM_Ticket tkt
	INNER JOIN #DupeOdsIdLoser d ON tkt.id = d.id
	WHERE tkt.ticket_status = 'A'


	DROP TABLE #DupeOdsIdLoser

END	

GO
