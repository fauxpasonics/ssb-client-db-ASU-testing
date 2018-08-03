SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








/*****Hash Rules for Reference******
WHEN 'int' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ')),''DBNULL_INT'')'
WHEN 'bigint' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ')),''DBNULL_BIGINT'')'
WHEN 'datetime' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),' + COLUMN_NAME + ')),''DBNULL_DATETIME'')'  
WHEN 'datetime2' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),' + COLUMN_NAME + ')),''DBNULL_DATETIME'')'
WHEN 'date' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ',112)),''DBNULL_DATE'')' 
WHEN 'bit' THEN 'ISNULL(RTRIM(CONVERT(varchar(10),' + COLUMN_NAME + ')),''DBNULL_BIT'')'  
WHEN 'decimal' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),'+ COLUMN_NAME + ')),''DBNULL_NUMBER'')' 
WHEN 'numeric' THEN 'ISNULL(RTRIM(CONVERT(varchar(25),'+ COLUMN_NAME + ')),''DBNULL_NUMBER'')' 
ELSE 'ISNULL(RTRIM(' + COLUMN_NAME + '),''DBNULL_TEXT'')'
*****/

CREATE VIEW [etl].[vw_Load_DimCustomer_SFMC]
AS
    (
      SELECT    *
/*Name*/
, HASHBYTES('sha2_256',
							ISNULL(RTRIM(Prefix),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(FirstName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MiddleName),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(LastName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(Suffix),'DBNULL_TEXT')
							+ ISNULL(RTRIM(Fullname),'DBNULL_TEXT')
							+ ISNULL(RTRIM(CompanyName),'DBNULL_TEXT')) AS [NameDirtyHash]
	, 'Dirty' AS [NameIsCleanStatus]
	, NULL AS [NameMasterId]

	/*Address*/
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressPrimaryStreet),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimarySuite),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressPrimaryZip),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressPrimaryCounty),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryCountry),'DBNULL_TEXT')) AS [AddressPrimaryDirtyHash]
	, 'Dirty' AS [AddressPrimaryIsCleanStatus]
	, NULL AS [AddressPrimaryMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressOneStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressOneSuite),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressOneCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressOneState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressOneZip),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressOneCounty),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressOneCountry),'DBNULL_TEXT')) AS [AddressOneDirtyHash]
	, 'Dirty' AS [AddressOneIsCleanStatus]
	, NULL AS [AddressOneMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressTwoStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressTwoSuite),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressTwoCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressTwoState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressTwoZip),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressTwoCounty),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressTwoCountry),'DBNULL_TEXT')) AS [AddressTwoDirtyHash]
	, 'Dirty' AS [AddressTwoIsCleanStatus]
	, NULL AS [AddressTwoMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressThreeStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressThreeSuite),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressThreeCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressThreeState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressThreeZip),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressThreeCounty),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressThreeCountry),'DBNULL_TEXT')) AS [AddressThreeDirtyHash]
	, 'Dirty' AS [AddressThreeIsCleanStatus]
	, NULL AS [AddressThreeMasterId]
	, HASHBYTES('sha2_256', ISNULL(RTRIM(AddressFourStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressFourSuite),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressFourCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressFourState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressFourZip),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressFourCounty),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressFourCountry),'DBNULL_TEXT')) AS [AddressFourDirtyHash]
	, 'Dirty' AS [AddressFourIsCleanStatus]
	, NULL AS [AddressFourMasterId]

	/*Contact*/
	, HASHBYTES('sha2_256', ISNULL(RTRIM(Prefix),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(FirstName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MiddleName),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(LastName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(Suffix),'DBNULL_TEXT')+ ISNULL(RTRIM(AddressPrimaryStreet),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressPrimarySuite),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryCity),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryState),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AddressPrimaryZip),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AddressPrimaryCounty),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AddressPrimaryCountry),'DBNULL_TEXT')) AS [ContactDirtyHash]
	

	/*Phone*/
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhonePrimary),'DBNULL_TEXT')) AS [PhonePrimaryDirtyHash]
	, 'Dirty' AS [PhonePrimaryIsCleanStatus]
	, NULL AS [PhonePrimaryMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneHome),'DBNULL_TEXT')) AS [PhoneHomeDirtyHash]
	, 'Dirty' AS [PhoneHomeIsCleanStatus]
	, NULL AS [PhoneHomeMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneCell),'DBNULL_TEXT')) AS [PhoneCellDirtyHash]
	, 'Dirty' AS [PhoneCellIsCleanStatus]
	, NULL AS [PhoneCellMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneBusiness),'DBNULL_TEXT')) AS [PhoneBusinessDirtyHash]
	, 'Dirty' AS [PhoneBusinessIsCleanStatus]
	, NULL AS [PhoneBusinessMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneFax),'DBNULL_TEXT')) AS [PhoneFaxDirtyHash]
	, 'Dirty' AS [PhoneFaxIsCleanStatus]
	, NULL AS [PhoneFaxMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(PhoneOther),'DBNULL_TEXT')) AS [PhoneOtherDirtyHash]
	, 'Dirty' AS [PhoneOtherIsCleanStatus]
	, NULL AS [PhoneOtherMasterId]

	/*Email*/
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(EmailPrimary),'DBNULL_TEXT')) AS [EmailPrimaryDirtyHash]
	, 'Dirty' AS [EmailPrimaryIsCleanStatus]
	, NULL AS [EmailPrimaryMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(EmailOne),'DBNULL_TEXT')) AS [EmailOneDirtyHash]
	, 'Dirty' AS [EmailOneIsCleanStatus]
	, NULL AS [EmailOneMasterId]
	, HASHBYTES('sha2_256',	ISNULL(RTRIM(EmailTwo),'DBNULL_TEXT')) AS [EmailTwoDirtyHash]
	, 'Dirty' AS [EmailTwoIsCleanStatus]
	, NULL AS [EmailTwoMasterId]
	
	/*External Attributes*/
	, HASHBYTES('sha2_256', ISNULL(RTRIM(customerType),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(CustomerStatus),'DBNULL_TEXT')
							+ ISNULL(RTRIM(AccountType),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(AccountRep),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(CompanyName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(SalutationName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(DonorMailName),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(DonorFormalName),'DBNULL_TEXT')
							+ ISNULL(RTRIM(Birthday),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(Gender),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(AccountId),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MergedRecordFlag),'DBNULL_TEXT')
							+ ISNULL(RTRIM(MergedIntoSSID),'DBNULL_TEXT')
							+ ISNULL(RTRIM(IsBusiness),'DBNULL_TEXT')) AS [contactattrDirtyHash]

	, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute1),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute2),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute3),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute4),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute5),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute6),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute7),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute8),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute9),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute10),'DBNULL_TEXT') 
							) AS [extattr1_10DirtyHash]

	, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute11),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute12),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute13),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute14),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute15),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute16),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute17),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute18),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute19),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute20),'DBNULL_TEXT') 
							) AS [extattr11_20DirtyHash]

							
	, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute21),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute22),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute23),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute24),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute25),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute26),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute27),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute28),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute29),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute30),'DBNULL_TEXT') 
							) AS [extattr21_30DirtyHash]

							
	, HASHBYTES('sha2_256', ISNULL(RTRIM(ExtAttribute31),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute32),'DBNULL_TEXT')
							+ ISNULL(RTRIM(ExtAttribute33),'DBNULL_TEXT')  
							+ ISNULL(RTRIM(ExtAttribute34),'DBNULL_TEXT') 
							+ ISNULL(RTRIM(ExtAttribute35),'DBNULL_TEXT')
							) AS [extattr31_35DirtyHash]
      FROM      (
--base set              
  SELECT 			
  CAST(DB_NAME() AS NVARCHAR(50)) AS SourceDB
      , CAST('SFMC' AS NVARCHAR(50)) AS SourceSystem
      , CAST(NULL AS INT) AS SourceSystemPriority

	  /*Standard Attributes*/
      , CAST(vsdch.SubscriberID AS NVARCHAR(100)) AS SSID 
      , CAST(NULL AS NVARCHAR(50)) AS CustomerType
      , CAST(vsdch.Status AS NVARCHAR(50)) AS CustomerStatus
      , CAST(NULL AS NVARCHAR(50)) AS AccountType
      , CAST(NULL AS NVARCHAR(50)) AS AccountRep
      , CAST(NULL AS NVARCHAR(50)) AS CompanyName
      , CAST(NULL AS NVARCHAR(50)) AS SalutationName
      , CAST(NULL AS NVARCHAR(50)) AS DonorMailName
      , CAST(NULL AS NVARCHAR(50)) AS DonorFormalName
      , CAST(NULL AS DATE) AS Birthday
      , CAST(NULL AS NVARCHAR(10)) AS Gender
      , CAST(0 AS INT) AS MergedRecordFlag
      , CAST(NULL AS NVARCHAR(100)) AS MergedIntoSSID

	/**ENTITIES**/
	/*Name*/
	  , CAST(NULL AS NVARCHAR(100)) AS Prefix
      , CAST(vsdch.FirstName AS NVARCHAR(100)) AS FirstName
      , CAST(NULL AS NVARCHAR(100)) AS MiddleName
      , CAST(vsdch.LastName AS NVARCHAR(100)) AS LastName
      , CAST(NULL AS NVARCHAR(100)) AS FullName
      , CAST(NULL AS NVARCHAR(100)) AS Suffix

	  /*AddressPrimary*/
      , CAST(NULL AS NVARCHAR(500)) AS AddressPrimaryStreet
	  , CAST(NULL AS NVARCHAR(200)) AS AddressPrimarySuite
      , CAST(NULL AS NVARCHAR(200)) AS AddressPrimaryCity
      , CAST(NULL AS NVARCHAR(200)) AS AddressPrimaryState
      , CAST(NULL AS NVARCHAR(25)) AS AddressPrimaryZip
      , CAST(NULL AS NVARCHAR(200)) AS AddressPrimaryCounty
      , CAST(NULL AS NVARCHAR(200)) AS AddressPrimaryCountry

      , CAST(NULL AS NVARCHAR(500)) AS AddressOneStreet
	  , CAST(NULL AS NVARCHAR(200)) AS AddressOneSuite
      , CAST(NULL AS NVARCHAR(200)) AS AddressOneCity
      , CAST(NULL AS NVARCHAR(200)) AS AddressOneState
      , CAST(NULL AS NVARCHAR(25)) AS AddressOneZip
      , CAST(NULL AS NVARCHAR(200)) AS AddressOneCounty
      , CAST(NULL AS NVARCHAR(200)) AS AddressOneCountry

      , CAST(NULL AS NVARCHAR(500)) AS AddressTwoStreet
      , CAST(NULL AS NVARCHAR(200)) AS AddressTwoSuite
	  , CAST(NULL AS NVARCHAR(200)) AS AddressTwoCity
      , CAST(NULL AS NVARCHAR(200)) AS AddressTwoState
      , CAST(NULL AS NVARCHAR(25)) AS AddressTwoZip
      , CAST(NULL AS NVARCHAR(200)) AS AddressTwoCounty
      , CAST(NULL AS NVARCHAR(200)) AS AddressTwoCountry

      , CAST(NULL AS NVARCHAR(500)) AS AddressThreeStreet
      , CAST(NULL AS NVARCHAR(200)) AS AddressThreeSuite
	  , CAST(NULL AS NVARCHAR(200)) AS AddressThreeCity
      , CAST(NULL AS NVARCHAR(200)) AS AddressThreeState
      , CAST(NULL AS NVARCHAR(200)) AS AddressThreeZip
      , CAST(NULL AS NVARCHAR(200)) AS AddressThreeCounty
      , CAST(NULL AS NVARCHAR(200)) AS AddressThreeCountry

      , CAST(NULL AS NVARCHAR(500)) AS AddressFourStreet
      , CAST(NULL AS NVARCHAR(200)) AS AddressFourSuite
	  , CAST(NULL AS NVARCHAR(200)) AS AddressFourCity
      , CAST(NULL AS NVARCHAR(200)) AS AddressFourState
      , CAST(NULL AS NVARCHAR(200)) AS AddressFourZip
      , CAST(NULL AS VARCHAR(200)) AS AddressFourCounty
      , CAST(NULL AS VARCHAR(200)) AS AddressFourCountry

	  /*Phone*/
      , CAST(NULL AS NVARCHAR(25)) AS PhonePrimary
      , CAST(NULL AS NVARCHAR(25)) AS PhoneHome
      , CAST(NULL AS NVARCHAR(25)) AS PhoneCell
      , CAST(NULL AS NVARCHAR(25)) AS PhoneBusiness
      , CAST(NULL AS NVARCHAR(25)) AS PhoneFax
      , CAST(NULL AS NVARCHAR(25)) AS PhoneOther

	  /*Email*/
      , CAST(vsdch.EmailAddress AS NVARCHAR(256)) AS EmailPrimary
      , CAST(NULL AS NVARCHAR(256)) AS EmailOne
      , CAST(NULL AS NVARCHAR(256)) AS EmailTwo

	  /*Extended Attributes*/
	  , NULL AS[ExtAttribute1] --nvarchar(100)
	  , NULL AS[ExtAttribute2] --nvarchar(100)
	  , NULL AS[ExtAttribute3] --nvarchar(100)
	  , NULL AS[ExtAttribute4] --nvarchar(100)
	  , NULL AS[ExtAttribute5] --nvarchar(100)
	  , NULL AS[ExtAttribute6] --nvarchar(100)
	  , NULL AS[ExtAttribute7] --nvarchar(100)
	  , NULL AS[ExtAttribute8] --nvarchar(100)
	  , NULL AS[ExtAttribute9] --nvarchar(100)
	  , NULL AS[ExtAttribute10] --nvarchar(1000)
	  
	  , NULL AS [ExtAttribute11] --decimal(18,6)
	  , NULL AS [ExtAttribute12] --decimal(18,6)
	  , NULL AS [ExtAttribute13] --decimal(18,6)
	  , NULL AS [ExtAttribute14] --decimal(18,6)
	  , NULL AS [ExtAttribute15] --decimal(18,6)
	  , NULL AS [ExtAttribute16] --decimal(18,6)
	  , NULL AS [ExtAttribute17] --decimal(18,6)
	  , NULL AS [ExtAttribute18] --decimal(18,6)
	  , NULL AS [ExtAttribute19] --decimal(18,6)
	  , NULL AS [ExtAttribute20] --decimal(18,6) 
	  
	  , vsdch.DateHeld AS [ExtAttribute21] --datetime
	  , vsdch.DateUnsubscribed AS [ExtAttribute22] --datetime
	  , NULL AS [ExtAttribute23] --datetime
	  , NULL AS [ExtAttribute24] --datetime
	  , NULL AS [ExtAttribute25] --datetime
	  , NULL AS [ExtAttribute26] --datetime
	  , NULL AS [ExtAttribute27] --datetime
	  , NULL AS [ExtAttribute28] --datetime
	  , NULL AS [ExtAttribute29] --datetime
	  , NULL AS [ExtAttribute30] --datetime 
	  , NULL AS [ExtAttribute31] --nvarchar(max)
	  , NULL AS [ExtAttribute32] --nvarchar(max)
	  , NULL AS [ExtAttribute33] --nvarchar(max)
	  , NULL AS [ExtAttribute34] --nvarchar(max)
	  , NULL AS [ExtAttribute35] --nvarchar(max)

/*Source Created and Updated*/
      , CAST(NULL AS NVARCHAR(255)) AS SSCreatedBy
      , CAST(NULL AS NVARCHAR(255)) AS SSUpdatedBy
      , CAST(vsdch.DateCreated AS DATETIME) AS SSCreatedDate
      , CAST(NULL AS DATETIME) AS SSUpdatedDate
      , CAST(NULL AS NVARCHAR(255)) AS CreatedBy
      , CAST(NULL AS NVARCHAR(255)) AS UpdatedBy
      , CAST(GETDATE() AS DATETIME) AS CreatedDate
      , CAST(GETDATE() AS DATETIME) AS UpdatedDate
      , CAST(NULL AS INT) AS AccountId
      , 0 IsBusiness
	  , 0 AS IsDeleted
	  , NULL AS CustomerMatchkey

--		select top 100 *
		FROM etl.vw_Load_DimCustomer_SFMCprep AS vsdch
		WHERE 1 = 1
		AND vsdch.contact_rank = 1
		AND (DateCreated > DATEADD(DAY,-3,GETDATE()) OR etl_updateddate >  DATEADD(DAY,-3,GETDATE())
		)


                ) a
    );







GO
