SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_TM_Org]
AS
(

	SELECT a.org_id, a.org_name
	FROM (
	SELECT  s.org_id, e.Org_Name
	, ROW_NUMBER() OVER(PARTITION BY s.org_id ORDER BY e.Upd_date) RowRank
	FROM ods.TM_Season (NOLOCK) s
	INNER JOIN ods.TM_Evnt(NOLOCK) e ON s.season_id = e.Season_id
	) a
	WHERE a.RowRank = 1

)
GO
