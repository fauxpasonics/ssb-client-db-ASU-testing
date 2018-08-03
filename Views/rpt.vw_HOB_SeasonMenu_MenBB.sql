SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [rpt].[vw_HOB_SeasonMenu_MenBB]
AS

SELECT ds.SeasonName, ds.SeasonYear, ds_p.SeasonName AS PreviousSeasonName, ds_p.SeasonYear AS PreviousSeasonYear
FROM dbo.DimSeason ds  -- Using DImSeason instead of DImSeasonHeader becasue DimSeasonHeader is empty
LEFT OUTER JOIN dbo.DimSeason ds_p
	ON  ds.DimSeasonId_Prev = ds_p.DimSeasonId OR (CAST(ds.SeasonYear AS INT) - 1 = CAST(ds_p.SeasonYear AS INT) AND ds.Activity = ds_p.Activity)
WHERE ds.SeasonName <> 'N/A'
	AND ds.SeasonName LIKE '%Men''s BB%' AND ds.SeasonYear IS NOT NULL AND ds.SeasonName NOT LIKE'%Women%'


GO
