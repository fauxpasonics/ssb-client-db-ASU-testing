SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [rpt].[vw_HOB_SeasonMenu_Baseball]
AS

SELECT ds.SeasonName, ds.SeasonYear, ds_p.SeasonName AS PreviousSeasonName, ds_p.SeasonYear AS PreviousSeasonYear
FROM dbo.DimSeason ds  -- Using DImSeason instead of DImSeasonHeader becasue DimSeasonHeader is empty
LEFT OUTER JOIN dbo.DimSeason ds_p
	ON  ds.DimSeasonId_Prev = ds_p.DimSeasonId OR (CAST(ds.SeasonYear AS INT) - 1 = CAST(ds_p.SeasonYear AS INT) AND ds.Activity = ds_p.Activity)
WHERE ds.SeasonName <> 'N/A'
	AND ds.SeasonName IN
		(
		'2010 Baseball'
		,'2011 Baseball'
		,'2012 Baseball'
		,'2013 Baseball'
		,'2014 Baseball'
		,'2015 Baseball'
		,'2016 Baseball'
		,'2017 Baseball'
		,'2018 Baseball'
		)


GO
