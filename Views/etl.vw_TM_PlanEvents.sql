SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [etl].[vw_TM_PlanEvents] 
AS 
(
	SELECT *
	, ROW_NUMBER() OVER(PARTITION BY PlanEvents.plan_event_id ORDER BY PlanEvents.event_date, PlanEvents.game_number, PlanEvents.event_name, PlanEvents.Event_id) PlanEventOrder
	, ROW_NUMBER() OVER(PARTITION BY PlanEvents.plan_event_id ORDER BY PlanEvents.event_date DESC, PlanEvents.game_number desc, PlanEvents.event_name desc, PlanEvents.Event_id desc) PlanRenewableRowRank
	FROM (
		SELECT DISTINCT eip.plan_event_id, eip.event_id, p.event_name plan_event_name, p.plan_abv, p.total_events, p.FSE, p.plan_type, e.event_name, e.event_date, e.game_number
		FROM ods.TM_EventsInPlan eip 
		INNER JOIN ods.TM_Evnt p ON eip.event_id = p.Event_id
		INNER JOIN ods.TM_Evnt e ON eip.event_id = e.Event_id
		WHERE 1=1
		AND eip.child_is_plan = 'N'	
	) PlanEvents
)
GO
