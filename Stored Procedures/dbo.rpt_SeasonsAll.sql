SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[rpt_SeasonsAll] 

AS 
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT DISTINCT 
		tkSeason.Season,
		tkSeason.NAME COLLATE SQL_Latin1_General_CP1_CS_AS + ' (' + tkSeason.Season + ')' AS SeasonName
		
	FROM 
		dbo.TK_SEASON tkSeason JOIN TK_TRANS tkTrans ON tkSeason.SEASON = tkTrans.SEASON 

ORDER BY tkSeason.SEASON  

	
END






GO
