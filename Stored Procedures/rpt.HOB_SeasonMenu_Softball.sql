SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Select top 1000* from dbo.DimSeason WHERE SeasonName LIKE '%Softball%' ORDER BY SeasonYear
--Select * from [rpt].[vw_HOB_SeasonMenu_Football]
/*************************************************************/
/*************************************************************/
CREATE PROCEDURE [rpt].[HOB_SeasonMenu_Softball]
AS
BEGIN
SELECT *
FROM rpt.vw_HOB_SeasonMenu_Softball
ORDER BY SeasonYear
END
GO
