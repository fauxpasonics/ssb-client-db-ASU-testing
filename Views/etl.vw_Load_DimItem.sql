SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [etl].[vw_Load_DimItem] AS (

	SELECT  
		'PAC' ETL__SourceSystem
		, i.SEASON + ':' + i.ZID COLLATE SQL_Latin1_General_CP1_CI_AS AS ETL__SSID 
		, i.SEASON ETL__SSID_SEASON
		, i.ITEM ETL__SSID_ITEM

		, i.ITEM ItemCode
		, i.NAME ItemName
		, i.NAME + ' (' + i.ITEM COLLATE SQL_Latin1_General_CP1_CI_AS + ')' ItemDesc
		, i.CLASS ItemClass
		, i.SEASON Season
		, i.BASIS Basis
		, i.KEYWORD Keywords
		, i.TAG Tag

	--SELECT *
	FROM dbo.TK_ITEM (NOLOCK) i

)
GO
