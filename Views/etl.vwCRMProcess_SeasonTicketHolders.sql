SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [etl].[vwCRMProcess_SeasonTicketHolders]
AS

SELECT DISTINCT CAST(dc.SSID AS VARCHAR(50)) SSID
, CAST(s.SeasonYear AS VARCHAR(50)) SeasonYear
, CAST(s.SeasonYear AS VARCHAR(50)) SeasonYr
 FROM [dbo].[FactTicketSales] t WITH(NOLOCK)
       INNER JOIN dbo.DimCustomer dc WITH(NOLOCK) ON t.DimTicketCustomerId = dc.SSID AND Sourcesystem = 'TI ASU'
	   INNER JOIN [dbo].[DimSeason] s WITH(NOLOCK)  ON t.DimSeasonId =s.DimSeasonId 
       INNER JOIN [dbo].[DimItem] i  WITH(NOLOCK)  ON t.DimSeasonId =s.DimSeasonId AND t.DimItemId = i.DimItemId  
WHERE i.ItemCode like 'FS%'
AND 0=1




GO
