SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_PAC_DimItem] AS (

	SELECT  

		i.SEASON + ':' + i.ZID COLLATE SQL_Latin1_General_CP1_CI_AS AS ETL__SSID 
		, i.SEASON ETL__SSID_PAC_SEASON
		, i.ITEM ETL__SSID_PAC_ITEM

		, i.ITEM ItemCode
		, i.NAME ItemName
		, i.NAME + ' (' + i.ITEM COLLATE SQL_Latin1_General_CP1_CI_AS + ')' ItemDesc
		, i.CLASS ItemClass
		, i.SEASON Season
		, i.BASIS PAC_BASIS
		, i.KEYWORD PAC_KEYWORD
		, i.TAG PAC_TAG

	--SELECT *
	FROM dbo.TK_ITEM (NOLOCK) i

)
GO
