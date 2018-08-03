SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_Load_PAC_DimPromo] AS (

	SELECT  

		p.ZID ETL__SSID
		, p.PROMO ETL__SSID_PAC_PROMO
		
		, p.PROMO COLLATE SQL_Latin1_General_CP1_CI_AS PromoCode
		, p.NAME COLLATE SQL_Latin1_General_CP1_CI_AS PromoName
		, p.NAME COLLATE SQL_Latin1_General_CP1_CI_AS + ' (' + p.PROMO COLLATE SQL_Latin1_General_CP1_CI_AS + ')' PromoDesc
		--, NULL PromoClass

	--SELECT *
	FROM dbo.TK_PROMO (NOLOCK) p

)

GO
