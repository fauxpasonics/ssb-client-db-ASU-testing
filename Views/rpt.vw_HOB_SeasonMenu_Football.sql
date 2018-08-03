SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [rpt].[vw_HOB_SeasonMenu_Football]
AS

SELECT ds.SeasonName, ds.SeasonYear, ds_p.SeasonName AS PreviousSeasonName, ds_p.SeasonYear AS PreviousSeasonYear
FROM dbo.DimSeason ds  -- Using DImSeason instead of DImSeasonHeader becasue DimSeasonHeader is empty
LEFT OUTER JOIN dbo.DimSeason ds_p
	ON  ds.DimSeasonId_Prev = ds_p.DimSeasonId OR (CAST(ds.SeasonYear AS INT) - 1 = CAST(ds_p.SeasonYear AS INT) AND ds.Activity = ds_p.Activity)
WHERE ds.SeasonName <> 'N/A'
	AND ds.SeasonName IN
		(
		'2010 Football'
		,'2011 Football'
		,'2012 Football'
		,'2013 Football'
		,'2014 Football'
		,'2015 Football'
		,'2016 Football'
		,'Football 2017'
		,'2017 Football'
		,'2018 Football'
		)
	AND ds_p.SeasonName IN
		(
		'2010 Football'
		,'2011 Football'
		,'2012 Football'
		,'2013 Football'
		,'2014 Football'
		,'2015 Football'
		,'2016 Football'
		,'Football 2017'
		,'2017 Football'
		,'2018 Football'
		)


GO
