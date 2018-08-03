SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [etl].[vwTI_PatronMDM] AS
(

	SELECT  DISTINCT
	patron.PATRON Patron
	, cust.TYPE CustomerTypeCode
	, tkCTYPE.NAME CustomerType	
	, patron.STATUS CustomerStatus
	, patron.Title
	, patron.NAME FullName
	, patron.Suffix
	  --pa primary address is now where adtype=m
	, pa.ADTYPE PrimaryAddressType
	, CASE WHEN CAST(ISNULL(pa.ADDR1,'') + ' ' + ISNULL(pa.ADDR2,'') + ' ' + ISNULL(pa.ADDR3,'') + ' ' + ISNULL(pa.ADDR4,'') AS VARCHAR(500)) = '' THEN NULL ELSE CAST(ISNULL(pa.ADDR1,'') + ' ' + ISNULL(pa.ADDR2,'') + ' ' + ISNULL(pa.ADDR3,'') + ' ' + ISNULL(pa.ADDR4,'') AS VARCHAR(500)) END AS  PrimaryAddressStreet
	, CAST(dbo.city(zip.CSZ) AS VARCHAR(200)) PrimaryAddressCity, CAST(dbo.State(zip.CSZ) AS VARCHAR(200)) PrimaryAddressState, CAST(dbo.Zip(zip.CSZ) AS VARCHAR(200)) PrimaryAddressZipCode, CAST(pa.COUNTRY AS VARCHAR(200)) PrimaryAddressCountry
	
	, pa2.AddressType Address2Type, CAST(pa2.Address AS VARCHAR(500)) Address2Street, CAST(pa2.City AS VARCHAR(200)) Address2City, CAST(pa2.State AS VARCHAR(200)) Address2State, CAST(pa2.ZipCode AS VARCHAR(200)) Address2ZipCode, CAST(pa2.AddressCountry AS VARCHAR(200)) Address2Country
	, pa3.AddressType Address3Type, CAST(pa3.Address  AS VARCHAR(500)) Address3Street, CAST(pa3.City AS VARCHAR(200)) Address3City, CAST(pa3.State AS VARCHAR(200)) Address3State, CAST(pa3.ZipCode AS VARCHAR(200)) Address3ZipCode, CAST(pa3.AddressCountry AS VARCHAR(200)) Address3Country
	, pa4.AddressType Address4Type, CAST(pa4.Address  AS VARCHAR(500)) Address4Street, CAST(pa4.City AS VARCHAR(200)) Address4City, CAST(pa4.State AS VARCHAR(200)) Address4State, CAST(pa4.ZipCode AS VARCHAR(200)) Address4ZipCode, CAST(pa4.AddressCountry AS VARCHAR(200)) Address4Country
	, pa5.AddressType Address5Type, CAST(pa5.Address  AS VARCHAR(500)) Address5Street, CAST(pa5.City AS VARCHAR(200)) Address5City, CAST(pa5.State AS VARCHAR(200)) Address5State, CAST(pa5.ZipCode AS VARCHAR(200)) Address5ZipCode, CAST(pa5.AddressCountry AS VARCHAR(200)) Address5Country

	, CASE WHEN hp.HomePhone = '(999) 999-9999' THEN NULL
		   WHEN hp.HomePhone = '999-999-9999'   THEN NULL ELSE hp.HomePhone END AS HomePhone
	, CASE WHEN cp.CellPhone = '(999) 999-9999' THEN NULL 
	       WHEN cp.CellPhone = '999-999-9999'   THEN NULL ELSE cp.CellPhone END AS CellPhone
	, CASE WHEN bp.BusinessPhone = '(999) 999-9999' THEN NULL 
		   WHEN bp.BusinessPhone = '999-999-9999'  THEN NULL ELSE bp.BusinessPhone END BusinessPhone
	, fp.Fax
	, op.OtherPhoneType
	, op.OtherPhone
	
	, patron.EV_Email EvEmail
	, perEmail.PersonalEmail
	, busEmail.BusinessEmail
	, otherEmail.OtherEmailType
	, otherEmail.OtherEmail
	
	, NULL AS DonorID
	, patron.STATUS PatronStatusCode
	, pdStatus.Name PatronStatus
	, Patron.vip AS VIP
	, ISNULL(cust.C_PRIORITY, 0) PriorityPtsTix	
	, NULL AS Donor_Level
	, NULL AS Donor_Type
	, patron.internet_profile
	, attribute.ATTRIBUTE
	, attribute.NOTE

	--, fdon.UD1
	--, fdon.UD2

	, cust.EXTERNAL_NUMBER

	, sal.SALUTATION AS SAL_F
	--, sal.SAL_TYPE_F
	, sal2.SALUTATION AS SAL_N1

	--, pt.phone AS BPhone
--	, pt.PHONE_TYPE
	
	, epdAccount.PIN 
	
	, patron.TAG
	, NULL AS Donor_Comments
	, cust.comments
	
	, patron.ENTRY_DATETIME PacCreateDate
	, ISNULL(PatronUpdateDate.UpdatedDate, '1900-01-01') UpdatedDate
	--SELECT COUNT(*)
	FROM [dbo].PD_PATRON (NOLOCK) patron
	LEFT JOIN dbo.TK_CUSTOMER (NOLOCK) cust ON patron.PATRON = cust.CUSTOMER
	LEFT OUTER JOIN dbo.PD_STATUS (NOLOCK) pdStatus ON patron.STATUS = pdSTATUS.STATUS
	LEFT JOIN dbo.TK_CTYPE (NOLOCK) tkCTYPE ON cust.TYPE COLLATE SQL_Latin1_General_CP1_CS_AS = tkCTYPE.TYPE COLLATE SQL_Latin1_General_CP1_CS_AS
	LEFT JOIN dbo.PD_PATRON_ATTRIBUTE (NOLOCK) attribute ON attribute.PATRON COLLATE SQL_Latin1_General_CP1_CS_AS = patron.PATRON COLLATE SQL_Latin1_General_CP1_CS_AS AND attribute.VMC = 1
	LEFT JOIN dbo.EPD_ACCOUNT (NOLOCK) epdAccount ON epdAccount.CUSTOMER COLLATE SQL_Latin1_General_CP1_CS_AS = patron.PATRON COLLATE SQL_Latin1_General_CP1_CS_AS
	--LEFT JOIN dbo.FD_DONOR (NOLOCK) fdon ON fdon.DONOR = patron.PATRON
	LEFT JOIN dbo.PD_PATRON_SAL_TYPE (NOLOCK) sal ON sal.patron = patron.PATRON COLLATE SQL_Latin1_General_CP1_CS_AS AND sal.sal_type = 'F' COLLATE SQL_Latin1_General_CP1_CS_AS
	LEFT JOIN dbo.PD_PATRON_SAL_TYPE (NOLOCK) sal2 ON sal2.patron = patron.patron  COLLATE SQL_Latin1_General_CP1_CS_AS AND sal2.sal_type = 'N1' COLLATE SQL_Latin1_General_CP1_CS_AS
	--LEFT JOIN dbo.PD_PATRON_PHONE_TYPE (NOLOCK) pt ON pt.patron = patron.PATRON AND pt.PHONE_TYPE = 'B'
	
	LEFT OUTER JOIN ( 
		SELECT * 
		FROM (
			SELECT a.*
			, ROW_NUMBER() OVER(PARTITION BY a.PATRON ORDER BY t.PriorityRank) AS RowRank
			FROM dbo.PD_ADDRESS (NOLOCK) a
			INNER JOIN dbo.fnContactTypeRank('A') t ON a.ADTYPE COLLATE SQL_Latin1_General_CP1_CS_AS = t.ContactType COLLATE SQL_Latin1_General_CP1_CS_AS
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
		WHERE PHONE_TYPE = 'PAH' AND PHONE LIKE '%@%'
	) busEmail ON patron.PATRON = busEmail.PATRON	
	LEFT OUTER JOIN (
		SELECT Patron, OtherEmail, PHONE_TYPE OtherEmailType
		FROM (
			SELECT Patron, PHONE OtherEmail, PHONE_TYPE
			, ROW_NUMBER() OVER (PARTITION BY Patron ORDER BY VMC) RowRank
			FROM dbo.PD_PATRON_PHONE_TYPE (NOLOCK)
			WHERE PHONE_TYPE NOT IN ('E', 'PAH') AND PHONE LIKE '%@%'
		) op
		WHERE op.RowRank = 1
	) otherEmail ON patron.Patron = otherEmail.Patron

	
		LEFT OUTER JOIN (
	SELECT * FROM (		
		SELECT a2.Patron, a2.adtype AddressType
		, CAST(ISNULL(a2.ADDR1,'') + ' ' + ISNULL(a2.ADDR2,'') + ' ' + ISNULL(a2.ADDR3,'') + ' ' + ISNULL(a2.ADDR4,'') AS VARCHAR(500)) Address	
		, dbo.city(zip.CSZ) City, dbo.State(zip.CSZ) State, dbo.Zip(zip.CSZ) ZipCode
		, a2.COUNTRY AddressCountry
		, t.priorityrank	
		FROM dbo.pd_address (NOLOCK) a2
		INNER JOIN dbo.SYS_ZIP (NOLOCK) zip ON CASE WHEN CHARINDEX('-', a2.SYS_ZIP) = 0 THEN a2.SYS_ZIP ELSE LEFT(a2.SYS_ZIP, CHARINDEX('-', a2.SYS_ZIP) - 1) END = zip.SYS_ZIP
		INNER JOIN dbo.fnContactTypeRank('A') t ON a2.ADTYPE COLLATE SQL_Latin1_General_CP1_CS_AS = t.ContactType COLLATE SQL_Latin1_General_CP1_CS_AS
) paa2
WHERE paa2.PriorityRank = 1
	) pa2 ON patron.PATRON = pa2.PATRON

	LEFT OUTER JOIN (
	SELECT * FROM (		
		SELECT a3.Patron, a3.adtype AddressType
		, CAST(ISNULL(a3.ADDR1,'') + ' ' + ISNULL(a3.ADDR2,'') + ' ' + ISNULL(a3.ADDR3,'') + ' ' + ISNULL(a3.ADDR4,'') AS VARCHAR(500)) Address	
		, dbo.city(zip.CSZ) City, dbo.State(zip.CSZ) State, dbo.Zip(zip.CSZ) ZipCode
		, a3.COUNTRY AddressCountry
		, t.priorityrank	
		FROM dbo.pd_address (NOLOCK) a3
		INNER JOIN dbo.SYS_ZIP (NOLOCK) zip ON CASE WHEN CHARINDEX('-', a3.SYS_ZIP) = 0 THEN a3.SYS_ZIP ELSE LEFT(a3.SYS_ZIP, CHARINDEX('-', a3.SYS_ZIP) - 1) END = zip.SYS_ZIP
		INNER JOIN dbo.fnContactTypeRank('A') t ON a3.ADTYPE COLLATE SQL_Latin1_General_CP1_CS_AS = t.ContactType COLLATE SQL_Latin1_General_CP1_CS_AS
) paa3
WHERE paa3.PriorityRank = 2
	) pa3 ON patron.PATRON = pa3.PATRON

	LEFT OUTER JOIN (
	SELECT * FROM (		
		SELECT a4.Patron, a4.adtype AddressType
		, CAST(ISNULL(a4.ADDR1,'') + ' ' + ISNULL(a4.ADDR2,'') + ' ' + ISNULL(a4.ADDR3,'') + ' ' + ISNULL(a4.ADDR4,'') AS VARCHAR(500)) Address	
		, dbo.city(zip.CSZ) City, dbo.State(zip.CSZ) State, dbo.Zip(zip.CSZ) ZipCode
		, a4.COUNTRY AddressCountry
		, t.priorityrank	
		FROM dbo.pd_address (NOLOCK) a4
		INNER JOIN dbo.SYS_ZIP (NOLOCK) zip ON CASE WHEN CHARINDEX('-', a4.SYS_ZIP) = 0 THEN a4.SYS_ZIP ELSE LEFT(a4.SYS_ZIP, CHARINDEX('-', a4.SYS_ZIP) - 1) END = zip.SYS_ZIP
		INNER JOIN dbo.fnContactTypeRank('A') t ON a4.ADTYPE COLLATE SQL_Latin1_General_CP1_CS_AS = t.ContactType COLLATE SQL_Latin1_General_CP1_CS_AS
) paa4
WHERE paa4.PriorityRank = 3
	) pa4 ON patron.PATRON = pa4.PATRON

	LEFT OUTER JOIN (
	SELECT * FROM (		
		SELECT a5.Patron, a5.adtype AddressType
		, CAST(ISNULL(a5.ADDR1,'') + ' ' + ISNULL(a5.ADDR2,'') + ' ' + ISNULL(a5.ADDR3,'') + ' ' + ISNULL(a5.ADDR4,'') AS VARCHAR(500)) Address	
		, dbo.city(zip.CSZ) City, dbo.State(zip.CSZ) State, dbo.Zip(zip.CSZ) ZipCode
		, a5.COUNTRY AddressCountry
		, t.priorityrank	
		FROM dbo.pd_address (NOLOCK) a5
		INNER JOIN dbo.SYS_ZIP (NOLOCK) zip ON CASE WHEN CHARINDEX('-', a5.SYS_ZIP) = 0 THEN a5.SYS_ZIP ELSE LEFT(a5.SYS_ZIP, CHARINDEX('-', a5.SYS_ZIP) - 1) END = zip.SYS_ZIP
		INNER JOIN dbo.fnContactTypeRank('A') t ON a5.ADTYPE COLLATE SQL_Latin1_General_CP1_CS_AS = t.ContactType COLLATE SQL_Latin1_General_CP1_CS_AS
) paa5
WHERE paa5.PriorityRank = 4
	) pa5 ON patron.PATRON = pa5.PATRON

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
)





























GO
