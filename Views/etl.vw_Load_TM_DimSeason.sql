SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [etl].[vw_Load_TM_DimSeason] AS (

	SELECT  
		s.season_id AS ETL__SSID 
		,  s.season_id ETL__SSID_TM_Season_Id

		, s.name SeasonName
		, s.name SeasonDesc

		, CAST(CASE WHEN GETDATE() BETWEEN e.EventFirst AND e.EventLast THEN 1 ELSE 0 END AS BIT) IsActive
		, s.season_year SeasonYear
		, s.arena_id TM_arena_id
		, s.manifest_id TM_manifest_id
		, e.SeasonEventCntFSE
		, o.org_id TM_org_id
		, o.org_name TM_org_name
		, s.upd_user UpdatedBy
		, s.add_datetime CreatedDate
		, s.upd_datetime UpdatedDate

		, dArena.DimArenaId
		, dArena.ArenaName Arena

	--SELECT *
	FROM ods.TM_Season s (NOLOCK)
	LEFT OUTER JOIN dbo.DimArena_V2 dArena ON s.arena_id = dArena.ETL__SSID_TM_arena_id
	LEFT OUTER JOIN (
		SELECT e.season_id, MIN(e.event_date) EventFirst, MAX(e.event_date) EventLast, CAST(1 AS BIT) IsActive, MAX(total_events) SeasonEventCntFSE
		FROM ods.TM_Evnt e (NOLOCK)
		GROUP BY e.season_id
	) e ON e.season_id = s.season_id
	LEFT OUTER JOIN etl.vw_TM_Org o ON s.org_id = o.org_id



)








GO
