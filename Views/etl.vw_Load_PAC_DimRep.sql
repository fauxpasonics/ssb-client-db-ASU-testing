SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_Load_PAC_DimRep] AS (

	SELECT  

		m.ZID ETL__SSID
		, m.MARK ETL__SSID_PAC_MARK

		, m.NAME FullName
		--, NULL Prefix
		--, NULL FirstName
		--, NULL MiddleName
		--, NULL LastName
		--, NULL Suffix
		--, NULL RepClass
		--, NULL [Status]
		, 1 IsActive
		, m.MARK

	--SELECT *
	FROM dbo.TK_MARK (NOLOCK) m

)

GO
