SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [ods].[TM_vw_TicketReturn_Dev] AS (

	SELECT *
	FROM ods.TM_Ticket (NOLOCK)
	WHERE ticket_status = 'R' 
	AND ISNULL(return_reason, '') NOT IN ('R','P')

)
GO
