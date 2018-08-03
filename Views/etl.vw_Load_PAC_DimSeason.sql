SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [etl].[vw_Load_PAC_DimSeason] AS (

	SELECT  
		
		s.ZID COLLATE SQL_Latin1_General_CP1_CI_AS AS ETL__SSID 
		, s.ZID ETL__SSID_PAC_SEASON

		, s.SEASON SeasonCode
		, s.NAME SeasonName
		, s.NAME + ' (' + s.SEASON COLLATE SQL_Latin1_General_CP1_CI_AS + ')' SeasonDesc
		, s.ACTIVITY SeasonClass
		, s.ACTIVITY Activity
		, s.[Status] [Status]
		, CAST(CASE WHEN GETDATE() BETWEEN e.EventFirst AND e.EventLast THEN 1 ELSE 0 END AS BIT) IsActive
		, DATEPART(YEAR, e.EventFirst) SeasonYear

	--SELECT *
	FROM dbo.TK_SEASON (NOLOCK) s
	LEFT OUTER JOIN (
		SELECT e.SEASON, MIN(e.DATE) EventFirst, MAX(e.DATE) EventLast, CAST(1 AS BIT) IsActive
		FROM dbo.TK_EVENT (NOLOCK) e
		GROUP BY e.SEASON
	) e ON s.SEASON = e.SEASON

)



GO
