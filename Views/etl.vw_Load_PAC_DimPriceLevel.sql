SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_Load_PAC_DimPriceLevel] AS (

	SELECT  
		
		pl.SEASON + ':' + pl.PTABLE + ':' + pl.PL AS ETL__SSID 
		, pl.SEASON ETL__SSID_PAC_SEASON
		, pl.PTABLE ETL__SSID_PAC_PTABLE
		, pl.PL ETL__SSID_PAC_PL

		, pl.PL PriceLevelCode
		, pl.PL_NAME PriceLevelName
		--, i.NAME + ' (' + i.ITEM COLLATE SQL_Latin1_General_CP1_CI_AS + ')' PlanDesc
		, pl.PL_NAME + ' (' + pl.PTABLE COLLATE SQL_Latin1_General_CP1_CI_AS + ' - ' + pl.PL + ')' PriceLevelDesc
		--, NULL PriceLevelClass
		, pl.SEASON Season
		, pl.PTABLE PTable

	--SELECT top 1000 *
	FROM dbo.TK_PTABLE_PRLEV (NOLOCK) pl

)

GO
