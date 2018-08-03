SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [segmentation].[vw__Primary_Customer]
AS
    ( 
	SELECT    dimcustomer.SSB_CRMSYSTEM_CONTACT_ID
              , dimcustomer.Prefix
              , dimcustomer.FirstName AS First_Name
              , dimcustomer.MiddleName AS Middle_Name
              , dimcustomer.LastName AS Last_Name
			  , CONCAT(dimcustomer.firstname, ' ', dimcustomer.middlename, ' ', dimcustomer.lastname) AS Full_Name
              , dimcustomer.Suffix
              , dimcustomer.CompanyName AS Company_Name
              , dimcustomer.NameIsCleanStatus AS Name_Is_Clean_Status
              , dimcustomer.CustomerType AS Customer_Type
              , dimcustomer.CustomerStatus AS Customer_Status
              , dimcustomer.AccountType AS Account_Type
              , dimcustomer.AddressPrimaryStreet AS Primary_Address_Street
              , dimcustomer.AddressPrimaryCity AS Primary_Address_City
              , dimcustomer.AddressPrimaryState AS Primary_Address_State
              , dimcustomer.AddressPrimarySuite AS Primary_Address_Suite
              , dimcustomer.AddressPrimaryZip AS Primary_Address_Zip
              , LEFT(dimcustomer.AddressPrimaryZip, 3) AS Primary_Address_Zip3
              , dimcustomer.AddressPrimaryCounty AS Primary_Address_County
              , dimcustomer.AddressPrimaryCountry AS Primary_Address_Country
              , dimcustomer.AddressPrimaryIsCleanStatus AS Address_Primary_Is_Clean_Status
              , dimcustomer.PhonePrimary AS Phone_Primary
              , CAST(CASE WHEN dimcustomer.PhonePrimaryIsCleanStatus = 'Valid'
                          THEN SUBSTRING(dimcustomer.PhonePrimary, 2, 3)
                          ELSE NULL
                     END AS INT) AS Phone_Primary_Area_Code
              , dimcustomer.PhonePrimaryIsCleanStatus AS Phone_Primary_Is_Clean_Status
              , dimcustomer.PhoneHome AS Phone_Home
              , CAST(CASE WHEN dimcustomer.PhoneHomeIsCleanStatus = 'Valid'
                          THEN SUBSTRING(dimcustomer.PhoneHome, 2, 3)
                          ELSE NULL
                     END AS INT) PhoneHomeAreaCode
              , dimcustomer.PhoneHomeIsCleanStatus AS Phone_Home_Is_Clean_Status
              , dimcustomer.PhoneCell AS Phone_Cell
              , CAST(CASE WHEN dimcustomer.PhoneCellIsCleanStatus = 'Valid'
                          THEN SUBSTRING(dimcustomer.PhoneCell, 2, 3)
                          ELSE NULL
                     END AS INT) Phone_Cell_Area_Code
              , dimcustomer.PhoneCellIsCleanStatus AS Phone_Cell_Is_Clean_Status
              , dimcustomer.PhoneBusiness AS PhoneBusiness
              , CAST(CASE WHEN dimcustomer.PhoneBusinessIsCleanStatus = 'Valid'
                          THEN SUBSTRING(dimcustomer.PhoneBusiness, 2, 3)
                          ELSE NULL
                     END AS INT) Phone_Business_Area_Code
              , dimcustomer.PhoneBusinessIsCleanStatus AS Phone_Business_Is_Clean_Status
              , dimcustomer.PhoneFax AS Phone_Fax
              , CAST(CASE WHEN dimcustomer.PhoneFaxIsCleanStatus = 'Valid'
                          THEN SUBSTRING(dimcustomer.PhoneFax, 2, 3)
                          ELSE NULL
                     END AS INT) Phone_Fax_Area_Code
              , dimcustomer.PhoneFaxIsCleanStatus AS Phone_Fax_Is_Clean_Status
              , dimcustomer.PhoneOther AS Phone_Other
              , CAST(CASE WHEN dimcustomer.PhoneOtherIsCleanStatus = 'Valid'
                          THEN SUBSTRING(dimcustomer.PhoneOther, 2, 3)
                          ELSE NULL
                     END AS INT) Phone_Other_Area_Code
              , dimcustomer.PhoneOtherIsCleanStatus AS Phone_Other_Is_Clean_Status
              , dimcustomer.EmailPrimary AS Primary_Email
              , RIGHT(dimcustomer.EmailPrimary,
                      LEN(dimcustomer.EmailPrimary) - CHARINDEX('@', dimcustomer.EmailPrimary)) Primary_Email_Domain
              , CASE WHEN dimcustomer.EmailPrimary IS NOT NULL
                          AND dimcustomer.EmailPrimary LIKE '%@%' THEN 1
                     ELSE 0
                END Primary_Email_Exists
              , dimcustomer.EmailPrimaryIsCleanStatus AS Email_Primary_Is_Clean_Status
              , dimcustomer.EmailOne AS Email_One
              , RIGHT(dimcustomer.EmailOne, LEN(dimcustomer.EmailOne) - CHARINDEX('@', dimcustomer.EmailOne)) Email_One_Domain
              , CASE WHEN dimcustomer.EmailOne IS NOT NULL
                          AND dimcustomer.EmailOne LIKE '%@%' THEN 1
                     ELSE 0
                END Email_One_Exists
              , dimcustomer.EmailOneIsCleanStatus AS Email_One_Is_Clean_Status
              , dimcustomer.EmailTwo AS Email_Two
              , RIGHT(dimcustomer.EmailTwo, LEN(dimcustomer.EmailTwo) - CHARINDEX('@', dimcustomer.EmailTwo)) Email_Two_Domain
              , CASE WHEN dimcustomer.EmailTwo IS NOT NULL
                          AND dimcustomer.EmailTwo LIKE '%@%' THEN 1
                     ELSE 0
                END Email_Two_Exists
              , dimcustomer.EmailTwoIsCleanStatus AS Email_Two_Is_Clean_Status
              , dimcustomer.SourceSystem AS Primary_Record_Source_System
              , dimcustomer.SSID AS Primary_Record_Source_System_Id
              , CAST(dimcustomer.AccountId AS nvarchar(50)) AS Archtics_Account_Id
              , dimcustomer.Gender
              , dimcustomer.PhonePrimaryDNC AS Phone_Primary_DNC
              , dimcustomer.PhoneHomeDNC AS Phone_Home_DNC
              , dimcustomer.PhoneCellDNC AS Phone_Cell_DNC
              , dimcustomer.PhoneBusinessDNC AS Phone_Business_DNC
              , dimcustomer.PhoneFaxDNC AS Phone_Fax_DNC
              , dimcustomer.PhoneOtherDNC AS Phone_Other_DNC
              , dimcustomer.Birthday AS Birth_Date
              , CASE WHEN dimcustomer.Birthday = '1900-01-01' THEN NULL
                     ELSE YEAR(dimcustomer.Birthday)
                END AS Birth_Year
              , CASE WHEN dimcustomer.Birthday = '1900-01-01' THEN NULL
                     ELSE MONTH(dimcustomer.Birthday)
                END AS Birth_Month
              , CASE WHEN dimcustomer.Birthday = '1900-01-01' THEN NULL
                     ELSE DAY(dimcustomer.Birthday)
                END AS Birth_Day
              , CASE WHEN dimcustomer.Birthday = '1900-01-01' THEN NULL
                     ELSE DATEDIFF(YEAR, dimcustomer.Birthday, GETDATE())
                END AS Age
			  , CASE WHEN sfmc.IsSubscribed = 1 OR sfmc.IsUnsubscribed = 1 OR sfmc.IsBounceback = '1' THEN 1 ELSE 0 END AS Is_SFMC_Contact
			  , ISNULL(sfmc.IsSubscribed,0) IsSubscribed
			  , ISNULL(sfmc.IsBounceback,0) IsBounceback
			  , ISNULL(sfmc.IsUnsubscribed,0) IsUnsubscribed
			  , ISNULL(DATEDIFF(DAY, sfmc.MaxEmailOpenDate, GETDATE()), 100000) AS DaysSince_LastEmailOpen
			  , ISNULL(DATEDIFF(DAY, sfmc.MaxEmailSentDate, GETDATE()), 100000) AS DaysSince_LastEmailSent
			  , ISNULL(DATEDIFF(DAY, tix.MaxTixDate, GETDATE()), 100000) AS DaysSince_LastTixPurchase
			  , ISNULL(DATEDIFF(DAY, don.MaxDonationDate, GETDATE()), 100000) AS DaysSince_LastDonation
			  , turnkey.[Turnkey_Football_Capacity_Score__c]
			  , turnkey.[Turnkey_Football_Priority_Score__c]
			  , turnkey.[Turnkey_Basketball_Capacity_Score__c]
			  , turnkey.[Turnkey_Basketball_Priority_Score__c]
			  , turnkey.[Turnkey_WBasketball_Capacity_Score__c]
			  , turnkey.[Turnkey_WBasketball_Priority_Score__c]
			  , turnkey.[Turnkey_Net_Worth_Gold__c]
			  , turnkey.[Turnkey_Discretionary_Income_Index__c]
			  , turnkey.[Turnkey_PersonicX_Cluster__c]
			  , turnkey.[Turnkey_Age_Input_Individual__c]
			  , turnkey.[Turnkey_Marital_Status__c]
			  , turnkey.[Turnkey_Presence_of_Children__c]

      FROM [dbo].[vwCompositeRecord_ModAcctID] dimcustomer

	  LEFT JOIN (SELECT DISTINCT SSB_CRMSYSTEM_CONTACT_ID
						, cr.EmailPrimary
						, CASE WHEN sub.[Status] = 'Active' THEN '1' ELSE 0 END AS IsSubscribed
						, CASE WHEN MAX(sub.DateUnsubscribed) IS NULL THEN '0' ELSE 1 END AS IsUnsubscribed
						, CASE WHEN sub.[Status] IN ('Bounced', 'Undeliverable') THEN '1' ELSE 0 END AS IsBounceback
						, MAX(CAST(em.MaxEmailOpenDate AS DATE)) MaxEmailOpenDate
						, MAX(CAST(em.MaxEmailSentDate AS DATE)) MaxEmailSentDate
						, ROW_NUMBER() OVER (PARTITION BY  cr.SSB_CRMSYSTEM_CONTACT_ID ORDER BY sub.DateCreated DESC) RN
			FROM  [dbo].[vwCompositeRecord_ModAcctID]  cr
			INNER JOIN (select c.EmailAddress, [status], DateCreated, DateUnsubscribed
						 FROM [ods].[SFMC_Subscribers] c (NOLOCK) 
						) sub on cr.EmailPrimary = sub.EmailAddress
			LEFT JOIN (select s.EmailAddress, MAX(s.EventDate) AS MaxEmailSentDate, MAX(o.EventDate) AS MaxEmailOpenDate
					   FROM ods.SFMC_Sent s  (NOLOCK)
						LEFT JOIN [ods].[SFMC_Opens] o (NOLOCK) 
							on s.EmailAddress = o.EmailAddress
						GROUP BY s.EmailAddress
						) em on cr.EmailPrimary = em.EmailAddress
			GROUP BY SSB_CRMSYSTEM_CONTACT_ID, cr.EmailPrimary, [Status], DateCreated

			) sfmc on dimcustomer.SSB_CRMSYSTEM_CONTACT_ID = sfmc.SSB_CRMSYSTEM_CONTACT_ID AND sfmc.RN = 1

		LEFT JOIN (select SSB_CRMSYSTEM_CONTACT_ID, MAX(CAST(TransDateTime AS DATE)) MaxTixDate 
					FROM [segmentation].[vw__Primary_Ticketing_TM]
					GROUP BY SSB_CRMSYSTEM_CONTACT_ID
					) tix on dimcustomer.SSB_CRMSYSTEM_CONTACT_ID = tix.SSB_CRMSYSTEM_CONTACT_ID	

		LEFT JOIN (select SSB_CRMSYSTEM_CONTACT_ID, MAX(DATE_OF_RECORD) MaxDonationDate 
					FROM    dbo.FD_SDA_TRANSACTION_DETAIL fd WITH (NOLOCK)		
					JOIN dbo.dimcustomerssbid ssbid WITH (NOLOCK) ON ssbid.SourceSystem = 'Advance ASU' AND fd.ID_NUMBER = ssbid.SSID
					GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
					) don on dimcustomer.SSB_CRMSYSTEM_CONTACT_ID = don.SSB_CRMSYSTEM_CONTACT_ID	
		LEFT JOIN (select *
					FROM [ro].[vw_Turnkey_CustomFields]
				   ) turnkey on dimcustomer.SSB_CRMSYSTEM_CONTACT_ID = turnkey.SSB_CRMSYSTEM_CONTACT_ID
	
	)

	



















GO
