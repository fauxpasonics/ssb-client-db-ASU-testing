SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [etl].[vw_Load_TM_DimItem] AS (

	SELECT  
		i.event_id  AS ETL__SSID 
		, i.event_id AS ETL__SSID_TM_event_id

		, i.event_name AS ItemCode
		, i.team AS ItemName
		, i.event_name_long AS ItemDesc
		, dSeason.SeasonName Season
		, dSeason.ETL__SSID_TM_season_Id TM_season_id
		, CAST(CASE WHEN i.[Plan] = 'Y' THEN 'Plan' ELSE 'Event' END AS NVARCHAR(255)) ItemType
		, i.Upd_user UpdatedBy
		, i.Add_date CreatedDate
		, i.Upd_date UpdatedDate

		, i.event_name TM_event_name
		, i.Team TM_Team
		, i.event_name_long TM_event_name_long
		, i.Tm_event_name TM__host_event_name
		, i.event_report_group TM_event_report_group
		, i.plan_type TM_plan_type
		, i.Event_Type TM_Event_Type
		, i.Major_Category TM_Major_Category
		, i.Minor_Category TM_Minor_Category
		, i.[Enabled] TM_Enabled
		, i.Returnable TM_Returnable
		, i.Barcode_Status TM_Barcode_Status
		, i.Print_Ticket_Ind TM_Print_Ticket_Ind
		, i.exchange_price_opt TM_exchange_price_opt

		, dSeason.DimSeasonId

	--SELECT *
	FROM ods.TM_Evnt i (NOLOCK)
	LEFT OUTER JOIN etl.vw_DimSeason dSeason (NOLOCK) ON i.Season_id = dSeason.ETL__SSID_TM_season_Id
	
)



GO
