SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create proc [rpt].[prompt_FBHOBSeason]
AS

SELECT '2018' Season, '2018' Value
UNION ALL
SELECT '2017' Season, '2017' Value
UNION ALL
SELECT '2016' Season, '2016' Value
UNION ALL
SELECT '2015' Season, '2015' Value
GO
