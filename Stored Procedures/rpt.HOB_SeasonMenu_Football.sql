SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Select top 1000* from dbo.DimSeason WHERE SeasonName LIKE '%Football%' ORDER BY SeasonYear
--Select * from [rpt].[vw_HOB_SeasonMenu_Football]
/*************************************************************/
/*************************************************************/
CREATE PROCEDURE [rpt].[HOB_SeasonMenu_Football]
AS
BEGIN
SELECT *
FROM rpt.vw_HOB_SeasonMenu_Football
ORDER BY SeasonYear
END
GO
