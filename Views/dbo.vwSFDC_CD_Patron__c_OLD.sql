SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [dbo].[vwSFDC_CD_Patron__c_OLD] AS
(

	
SELECT --distinct 
	patron.PATRON Patron	
	, patron.NAME FullName
	, patron.Title
	, patron.Suffix
	, patron.STATUS PatronStatusCode
	,Patron.vip AS VIP
	,patron.internet_profile 
	, pdStatus.Name PatronStatus
	, cust.TYPE CustomerTypeCode
	,cust.comments
	,cust.ud1
	, tkCTYPE.NAME CustomerType
	, cust.STATUS CustomerStatus
	, ISNULL(cust.C_PRIORITY, 0) PriorityPtsTix	
	, patron.ENTRY_DATETIME PacCreateDate
	, pa.ADTYPE PrimaryAddressType
	, CAST(ISNULL(pa.ADDR1,'') + ' ' + ISNULL(pa.ADDR2,'') + ' ' + ISNULL(pa.ADDR3,'') + ' ' + ISNULL(pa.ADDR4,'') AS VARCHAR(500)) PrimaryAddressStreet
	, CAST(dbo.city(zip.CSZ) AS VARCHAR(200)) PrimaryAddressCity, CAST(dbo.State(zip.CSZ) AS VARCHAR(200)) PrimaryAddressState, CAST(dbo.Zip(zip.CSZ) AS VARCHAR(200)) PrimaryAddressZipCode, CAST(pa.COUNTRY AS VARCHAR(200)) PrimaryAddressCountry
	
	, pa2.AddressType Address2Type, pa2.Address Address2Street, pa2.City Address2City, pa2.State Address2State, pa2.ZipCode Address2ZipCode, pa2.AddressCountry Address2Country
	, pa3.AddressType Address3Type, pa3.Address Address3Street, pa3.City Address3City, pa3.State Address3State, pa3.ZipCode Address3ZipCode, pa3.AddressCountry Address3Country
	
	, hp.HomePhone
	, cp.CellPhone
	, bp.BusinessPhone
	, fp.Fax
	, op.OtherPhoneType
	, op.OtherPhone
	
	, patron.EV_Email EvEmail
	, perEmail.PersonalEmail
	, busEmail.BusinessEmail
	, otherEmail.OtherEmailType
	, otherEmail.OtherEmail
		
	, ISNULL(PatronUpdateDate.UpdatedDate, '1900-01-01') UpdatedDate
	FROM [dbo].PD_PATRON (NOLOCK) patron
	INNER JOIN 
	(
		SELECT DISTINCT customer
		FROM dbo.tk_odet (NOLOCK)
		
	) patronFilter ON patron.patron = patronFilter.customer
--	INNER JOIN dbo.TK_CUSTOMER (NOLOCK) cust ON patron.PATRON = cust.CUSTOMER			2016-10-06
	LEFT JOIN dbo.TK_CUSTOMER (NOLOCK) cust ON patron.PATRON = cust.CUSTOMER
	LEFT OUTER JOIN dbo.PD_STATUS (NOLOCK) pdStatus ON patron.STATUS = pdSTATUS.STATUS
	LEFT JOIN dbo.TK_CTYPE (NOLOCK) tkCTYPE ON cust.TYPE = tkCTYPE.TYPE
	
	LEFT OUTER JOIN ( 
		SELECT * 
		FROM (
			SELECT a.*
			, ROW_NUMBER() OVER(PARTITION BY a.PATRON ORDER BY t.PriorityRank) AS RowRank
			FROM dbo.PD_ADDRESS (NOLOCK) a
			INNER JOIN dbo.fnContactTypeRank('A') t ON a.ADTYPE = t.ContactType COLLATE SQL_Latin1_General_CP1_CI_AS
		) a
		WHERE a.RowRank = 1
	)	pa ON patron.PATRON = pa.PATRON	
	
	LEFT OUTER JOIN (
		SELECT Patron, PHONE HomePhone, Export_Datetime
		FROM dbo.PD_PATRON_PHONE_TYPE (NOLOCK)
		WHERE PHONE_TYPE = 'H' AND PHONE NOT LIKE '%@%'
	) hp ON patron.PATRON = hp.PATRON	
	LEFT OUTER JOIN (
		SELECT Patron, PHONE CellPhone
		FROM dbo.PD_PATRON_PHONE_TYPE (NOLOCK)
		WHERE PHONE_TYPE = 'C' AND PHONE NOT LIKE '%@%'
	) cp ON patron.PATRON = cp.PATRON	
	LEFT OUTER JOIN (
		SELECT Patron, PHONE BusinessPhone
		FROM dbo.PD_PATRON_PHONE_TYPE (NOLOCK)
		WHERE PHONE_TYPE = 'B' AND PHONE NOT LIKE '%@%'
	) bp ON patron.PATRON = bp.PATRON	
	LEFT OUTER JOIN (
		SELECT Patron, PHONE Fax
		FROM dbo.PD_PATRON_PHONE_TYPE (NOLOCK)
		WHERE PHONE_TYPE = 'F' AND PHONE NOT LIKE '%@%'
	) fp ON patron.PATRON = fp.PATRON	
	LEFT OUTER JOIN (
		SELECT Patron, OtherPhone, PHONE_TYPE OtherPhoneType
		FROM (
			SELECT Patron, PHONE OtherPhone, PHONE_TYPE
			, ROW_NUMBER() OVER (PARTITION BY Patron ORDER BY VMC) RowRank
			FROM dbo.PD_PATRON_PHONE_TYPE (NOLOCK)
			WHERE PHONE_TYPE NOT IN ('H', 'C', 'B', 'F') AND PHONE NOT LIKE '%@%'
		) op
		WHERE op.RowRank = 1
	) op ON patron.Patron = op.Patron

	LEFT OUTER JOIN (
		SELECT Patron, PHONE PersonalEmail
		FROM dbo.PD_PATRON_PHONE_TYPE (NOLOCK)
		WHERE PHONE_TYPE = 'E' AND PHONE LIKE '%@%'
	) perEmail ON patron.PATRON = perEmail.PATRON	
	LEFT OUTER JOIN (
		SELECT Patron, PHONE BusinessEmail
		FROM dbo.PD_PATRON_PHONE_TYPE (NOLOCK)
		WHERE PHONE_TYPE = 'SE' AND PHONE LIKE '%@%'
	) busEmail ON patron.PATRON = busEmail.PATRON	
	LEFT OUTER JOIN (
		SELECT Patron, OtherEmail, PHONE_TYPE OtherEmailType
		FROM (
			SELECT Patron, PHONE OtherEmail, PHONE_TYPE
			, ROW_NUMBER() OVER (PARTITION BY Patron ORDER BY VMC) RowRank
			FROM dbo.PD_PATRON_PHONE_TYPE (NOLOCK)
			WHERE PHONE_TYPE = 'PAH' AND PHONE LIKE '%@%'
		) op
		WHERE op.RowRank = 1
	) otherEmail ON patron.Patron = otherEmail.Patron

	LEFT OUTER JOIN (
		SELECT pa.Patron, pa.adtype AddressType
		, CAST(ISNULL(pa.ADDR1,'') + ' ' + ISNULL(pa.ADDR2,'') + ' ' + ISNULL(pa.ADDR3,'') + ' ' + ISNULL(pa.ADDR4,'') AS VARCHAR(500)) Address	
		, dbo.city(zip.CSZ) City, dbo.State(zip.CSZ) State, dbo.Zip(zip.CSZ) ZipCode
		, pa.COUNTRY AddressCountry
		FROM dbo.pd_address (NOLOCK) pa
		INNER JOIN dbo.SYS_ZIP (NOLOCK) zip ON CASE WHEN CHARINDEX('-', pa.SYS_ZIP) = 0 THEN pa.SYS_ZIP ELSE LEFT(pa.SYS_ZIP, CHARINDEX('-', pa.SYS_ZIP) - 1) END = zip.SYS_ZIP
		WHERE pa.adtype = 'P'
	) pa2 ON patron.PATRON = pa2.PATRON

	LEFT OUTER JOIN (
		SELECT pa.Patron, pa.adtype AddressType
		, CAST(ISNULL(pa.ADDR1,'') + ' ' + ISNULL(pa.ADDR2,'') + ' ' + ISNULL(pa.ADDR3,'') + ' ' + ISNULL(pa.ADDR4,'') AS VARCHAR(500)) Address	
		, dbo.city(zip.CSZ) City, dbo.State(zip.CSZ) State, dbo.Zip(zip.CSZ) ZipCode
		, pa.COUNTRY AddressCountry
		FROM dbo.pd_address (NOLOCK) pa
		INNER JOIN dbo.SYS_ZIP (NOLOCK) zip ON CASE WHEN CHARINDEX('-', pa.SYS_ZIP) = 0 THEN pa.SYS_ZIP ELSE LEFT(pa.SYS_ZIP, CHARINDEX('-', pa.SYS_ZIP) - 1) END = zip.SYS_ZIP
		WHERE pa.adtype = 'B'
	) pa3 ON patron.PATRON = pa3.PATRON

	LEFT OUTER JOIN dbo.SYS_ZIP (NOLOCK) zip ON CASE WHEN CHARINDEX('-', pa.SYS_ZIP) = 0 THEN pa.SYS_ZIP ELSE LEFT(pa.SYS_ZIP, CHARINDEX('-', pa.SYS_ZIP) - 1) END = zip.SYS_ZIP COLLATE SQL_Latin1_General_CP1_CS_AS

	LEFT OUTER JOIN (
		SELECT Patron, MAX(EXPORT_DATETIME) UpdatedDate
		FROM (
			SELECT Patron, EXPORT_DATETIME
			FROM dbo.pd_patron patron (NOLOCK)

				UNION ALL 

			SELECT customer Patron, Export_DATETIME
			FROM dbo.tk_customer (NOLOCK)

				UNION ALL 

			SELECT Patron, Export_DATETIME
			FROM dbo.pd_patron_phone_type (NOLOCK)
	
				UNION ALL 

			SELECT Patron, Export_DATETIME
			FROM dbo.pd_address (NOLOCK)
		) a
		GROUP BY Patron
	) PatronUpdateDate ON patron.Patron = PatronUpdateDate.Patron
		--WHERE ((patron.PATRON IN (SELECT CUSTOMER FROM dbo.TK_ODET) AND patron.PATRON IN (SELECT CUSTOMER FROM dbo.TK_CUSTOMER)) 
		--	OR PatronUpdateDate.UpdatedDate >= '2014-07-01') --AND patron.PATRON = '298578'
)


















GO
