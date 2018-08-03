SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [etl].[vw_Load_TM_DimPlan] AS (

	SELECT  
		CAST(p.event_id AS NVARCHAR(255)) AS ETL__SSID 
		, p.event_id AS ETL__SSID_TM_event_id

		, p.event_name AS PlanCode
		, p.team AS PlanName
		, p.event_name_long AS PlanDesc
		, p.plan_abv AS PlanClass
		, dSeason.SeasonName AS Season
		, p.FSE AS PlanFSE
		, p.plan_type AS PlanType
		, p.total_events AS PlanEventCnt
		, p.Season_id TM_season_id
		, dEvent.DimEventId PlanRenewableDimEventId
		, CAST(CASE WHEN pe.plan_event_id IS NULL THEN 0 ELSE 1 END AS BIT) IsExpanded

		, p.Upd_user UpdatedBy
		, p.Add_date CreatedDate
		, p.Upd_date UpdatedDate

		, p.event_name TM_event_name
		, p.Team TM_Team
		, p.event_name_long TM_event_name_long
		, p.Tm_event_name TM__host_event_name
		, p.event_report_group TM_event_report_group
		, p.plan_type TM_plan_type
		, p.Event_Type TM_Event_Type
		, p.Major_Category TM_Major_Category
		, p.Minor_Category TM_Minor_Category
		, p.[Enabled] TM_Enabled
		, p.Returnable TM_Returnable
		, p.Barcode_Status TM_Barcode_Status
		, p.Print_Ticket_Ind TM_Print_Ticket_Ind
		, p.exchange_price_opt TM_exchange_price_opt

		, p.plan_abv TM_plan_abv
		, p.Min_events TM_Min_events
		, p.total_events TM_total_events
		, p.FSE TM_FSE
		, p.Dsps_allowed TM_Dsps_allowed
		, p.MaxEventDate TM_MaxEventDate

		, dSeason.DimSeasonId

	--SELECT *
	FROM ods.TM_Evnt p (NOLOCK) 
	LEFT OUTER JOIN etl.vw_DimSeason dSeason (NOLOCK) ON p.Season_id = dSeason.ETL__SSID_TM_season_Id
	LEFT OUTER JOIN etl.vw_TM_PlanEvents pe ON p.Event_id = pe.plan_event_id AND pe.PlanRenewableRowRank = 1
	LEFT OUTER JOIN etl.vw_DimEvent dEvent ON pe.event_id = dEvent.ETL__SSID_TM_event_id
	WHERE p.[Plan] = 'Y'

)







GO
