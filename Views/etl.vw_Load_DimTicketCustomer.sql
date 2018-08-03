SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_DimTicketCustomer] AS (

	SELECT
		'PAC' ETL__SourceSystem
		, p.PATRON ETL__SSID
		, p.PATRON ETL__SSID_PATRON
		, NULL DimRepId
		, CAST(CASE WHEN p.NAME LIKE '%,%' THEN 0 ELSE 1 END AS BIT) IsCompany
		, CAST(CASE WHEN p.NAME LIKE '%,%' THEN NULL ELSE p.NAME END AS NVARCHAR(255)) CompanyName
		, p.NAME FullName
		, NULL Prefix
		, NULL FirstName
		, NULL MiddleName
		, NULL LastName
		, p.SUFFIX Suffix
		, c.[TYPE] TicketCustomerClass
		, c.[STATUS] [Status]
		, p.PATRON CustomerId
		, p.VIP VIPCode
		, CAST(CASE WHEN p.VIP IS NULL THEN 0 ELSE 1 END AS BIT) IsVIP
		, c.TAGS Tag
		, c.[TYPE] AccountType
		, p.KEYWORDS Keywords
		, p.GENDER1 Gender
		, p.ENTRY_DATETIME AddDateTime
		, p.ENTRY_DATETIME SinceDate
		, p.BIRTH_DATE1 Birthday
		, p.EV_EMAIL Email
		, NULL Phone
		, NULL AddressStreet1
		, NULL AddressStreet2
		, NULL AddressCity
		, NULL AddressState
		, NULL AddressZip
		, NULL AddressCountry

	--SELECT top 1000 *
	FROM dbo.PD_PATRON p
	INNER JOIN dbo.TK_CUSTOMER (NOLOCK) c ON p.PATRON = c.CUSTOMER

)
GO
