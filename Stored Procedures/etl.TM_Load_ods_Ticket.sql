SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[TM_Load_ods_Ticket]
(
	@BatchId NVARCHAR(50),
	@Target VARCHAR(256),
	@Source VARCHAR(256),
	@BusinessKey VARCHAR(256),
	@Options NVARCHAR(MAX)
)

AS
BEGIN

DELETE stg.TM_Ticket
WHERE tran_type = 'DW'

EXEC etl.TM_StandardMerge @BatchId = @BatchId, @Target = @Target, @Source = @Source
, @BusinessKey = @BusinessKey
, @Options = '<options><LoadArchiveTable>true</LoadArchiveTable><ArchiveTableName>archive.TM_Ticket</ArchiveTableName><DedupeStage>true</DedupeStage><DedupeSortPriority>cast(upd_datetime as datetime) desc, ETL__ID</DedupeSortPriority><JoinString>t.[ticket_status] = s.[ticket_status] and t.[event_id] = s.[event_id] and t.[section_id] = s.[section_id] and t.[row_id] = s.[row_id] and t.[seat_num] = s.[seat_num] and ISNULL(t.[return_datetime],''1900-01-01'') = ISNULL(s.[return_datetime],''1900-01-01'')</JoinString></options>'



EXEC [etl].[SSB_StandardMergeSCD_DEV] @BatchId = @BatchId, @Target = 'dev.TM_Ticket', @Source = 'stg.TM_Ticket', @BusinessKey = 'ticket_status, event_id, section_id, row_id, seat_num, return_datetime'
, @Options = '<options><JoinString>t.[ticket_status] = s.[ticket_status] and t.[event_id] = s.[event_id] and t.[section_id] = s.[section_id] and t.[row_id] = s.[row_id] and t.[seat_num] = s.[seat_num] and ISNULL(t.[return_datetime],''1900-01-01'') = ISNULL(s.[return_datetime],''1900-01-01'')</JoinString></options>'



END



















GO
