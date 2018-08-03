SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [rpt].[vw_HOB_SeasonMenu_WBB]   --2016 Softball is labeled as year 2015 in the data, needs to be corrected
AS

SELECT ds.SeasonName, ds.SeasonYear, ds_p.SeasonName AS PreviousSeasonName, ds_p.SeasonYear AS PreviousSeasonYear
FROM dbo.DimSeason ds  -- Using DImSeason instead of DImSeasonHeader becasue DimSeasonHeader is empty
LEFT OUTER JOIN dbo.DimSeason ds_p
	ON  ds.DimSeasonId_Prev = ds_p.DimSeasonId OR (CAST(ds.SeasonYear AS INT) - 1 = CAST(ds_p.SeasonYear AS INT) AND ds.Activity = ds_p.Activity)
WHERE ds.SeasonName <> 'N/A'
	AND ds.SeasonName LIKE '%Women''s B%' AND ds.SeasonYear IS NOT NULL


GO
