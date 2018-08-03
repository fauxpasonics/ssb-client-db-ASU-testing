SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ods].[TM_vw_TicketActive] AS (

SELECT tkt.*, 'tkt' SourceTable
FROM ods.tm_Ticket (NOLOCK) tkt
WHERE tkt.ticket_status = 'A'
AND ISNULL(tkt.plan_event_id,'') <> ISNULL(tkt.event_id, '')

UNION ALL

SELECT plans.*, 'plan' SourceTable
FROM (
	SELECT * 
	FROM ods.tm_Ticket (NOLOCK) 
	WHERE ISNULL(plan_event_id,'') = ISNULL(event_id, '')
)  plans 
LEFT OUTER JOIN (
	SELECT id, acct_id, ticket_status, plan_event_id, section_id, row_id, seat_num, num_seats
	FROM ods.tm_Ticket (NOLOCK)
	WHERE ISNULL(plan_event_id,'') <> ISNULL(event_id, '')
) tkt
	ON plans.acct_id = tkt.acct_id 
	AND plans.ticket_status = tkt.ticket_status
	AND plans.plan_event_id = tkt.plan_event_id
	AND plans.section_id = tkt.section_id
	AND plans.row_id = tkt.row_id
	AND plans.seat_num = tkt.seat_num
	AND plans.num_seats = tkt.num_seats
WHERE tkt.id IS NULL AND plans.ticket_status = 'A'

)




GO
