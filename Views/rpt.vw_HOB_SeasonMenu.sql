SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [rpt].[vw_HOB_SeasonMenu]
AS

SELECT dsh.SeasonName, dsh.SeasonCode, dsh_p.SeasonName AS PreviousSeasonName, dsh_p.SeasonCode AS PreviousSeasonCode
FROM dbo.DimSeasonHeader dsh
LEFT OUTER JOIN dbo.DimSeasonHeader dsh_p
	ON  dsh.PrevSeasonHeaderId = dsh_p.DimSeasonHeaderId
WHERE dsh.SeasonName <> 'N/A'
	AND dsh.SeasonName IN
		(
		  '2016-2017 Men''s Basketball'
		, '2017-2018 Men''s Basketball'
		, '2016-2017 Women''s Basketball'
		, '2017-2018 Women''s Basketball'
		, '2016 Football'
		, '2017 Football'
		, '2018 Football'
		, '2017 Baseball'
		, '2018 Baseball'
		)


GO
