SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[sp_MDM_SeasonTicketHolders]
AS

SELECT *
INTO #tmpTrans
FROM etl.vwCRMProcess_SeasonTicketHolders

TRUNCATE TABLE etl.CRMProcess_SeasonTicketHolders

INSERT INTO etl.CRMProcess_SeasonTicketHolders (SSID, [SeasonYear], [SeasonYr], Team)
SELECT CAST(SSID AS VARCHAR(50)) SSID
, CAST(SeasonYear AS VARCHAR(50)) SeasonYear, CAST(SeasonYear + '-' + CONVERT(VARCHAR,(CAST(SeasonYear AS INT) + 1)) AS VARCHAR(50)) SeasonYr
, 'ASU' Team
FROM #tmpTrans



DROP TABLE #tmpTrans




GO
