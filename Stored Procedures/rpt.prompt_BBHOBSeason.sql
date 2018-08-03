SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   proc [rpt].[prompt_BBHOBSeason]
AS

-- =============================================
-- Created By: Ashlee ONeill
-- Create Date: 2018-07-30
-- Reviewed By: Abbey Meitin
-- Reviewed Date: 2018-07-30
-- Description: ASU Baseball HOB Report Seasons
-- =============================================
 
/***** Revision History
 

 
*****/

SELECT '2019' Season, '2019' Value
UNION ALL
SELECT '2018' Season, '2018' Value
/*UNION ALL
SELECT '2017' Season, '2017' Value
UNION ALL
SELECT '2016' Season, '2016' Value
UNION ALL
SELECT '2015' Season, '2015' Value*/
GO
