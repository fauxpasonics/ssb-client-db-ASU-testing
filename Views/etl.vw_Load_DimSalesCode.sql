SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_Load_DimSalesCode] AS (

	SELECT  
		'PAC' ETL__SourceSystem
		, sc.ZID ETL__SSID
		, sc.SALECODE ETL__SSID_SALECODE

		, sc.SALECODE SalesCode
		, sc.NAME SalesCodeName
		, sc.NAME + ' (' + sc.SALECODE COLLATE SQL_Latin1_General_CP1_CI_AS + ')' SalesCodeDesc
		, sc.SCGROUP SalesCodeClass

	--SELECT *
	FROM dbo.TK_SALECODE (NOLOCK) sc

)
GO
