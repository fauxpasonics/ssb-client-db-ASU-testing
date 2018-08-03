SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_TM_DimTicketCustomer] AS (

	SELECT
		CAST(c.acct_id AS NVARCHAR(25)) ETL__SSID
		, c.acct_id AS [ETL__SSID_TM_acct_id]
		, CAST(NULL AS INT) DimRepId
		, CAST(CASE WHEN name_type = 'C' THEN 1 ELSE 0 END AS BIT) IsCompany
		, CAST(company_name AS NVARCHAR (500)) CompanyName
		, CAST(NULL AS NVARCHAR(500)) FullName
		, CAST(NULL AS NVARCHAR(100)) Prefix
		, c.name_first AS FirstName
		, c.name_mi AS MiddleName
		, LEFT(c.name_last,100) AS LastName
		, CAST(NULL AS NVARCHAR(100)) Suffix
		, CAST(NULL AS NVARCHAR(50)) TicketCustomerClass
		, CAST(NULL AS NVARCHAR(25))  [Status]
		, CAST(c.acct_id AS NVARCHAR(50)) CustomerId
		, CAST(NULL AS NVARCHAR(50)) VIPCode
		, CAST(0 AS BIT) IsVIP
		, c.Tag Tag
		, CAST(c.acct_type_desc AS NVARCHAR (50)) AccountType
		, CAST(NULL AS NVARCHAR(max)) Keywords
		, c.gender Gender
		, c.add_date AddDateTime
		, c.Since_date SinceDate
		, c.birth_date Birthday
		
		, c.email_addr AS Email
		, LEFT(c.phone_day,25) AS Phone
		, c.street_addr_1 AS AddressStreet1
		, c.street_addr_2 AS AddressStreet2
		, c.city AS AddressCity
		, c.state AddressState
		, c.zip AddressZip
		, c.country AddressCountry

	--SELECT top 1000 *
	FROM ods.TM_Cust c (NOLOCK)
	WHERE c.Primary_code = 'Primary'
	AND c.UpdateDate > GETDATE() - 3
)




GO
