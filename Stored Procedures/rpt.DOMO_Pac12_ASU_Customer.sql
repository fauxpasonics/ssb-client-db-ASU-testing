SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [rpt].[DOMO_Pac12_ASU_Customer]
AS
    BEGIN
        SELECT  dc.SourceDB
              , dc.SourceSystem
              , ssbid.SSB_CRMSYSTEM_CONTACT_ID
              , ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG
              , ssbid.SSB_CRMSYSTEM_ACCT_ID
              , ssbid.SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG
              , dc.ContactGUID
              , dc.SSID
              , dc.AccountId
              , dc.CustomerType
              , dc.CustomerStatus
              , dc.AccountType
              , dc.AccountRep
              , dc.Birthday
              , dc.Gender
              , dc.MergedRecordFlag
              , dc.MergedIntoSSID
              , dc.Prefix
              , dc.FirstName
              , dc.MiddleName
              , dc.LastName
              , dc.Suffix
              , dc.FullName
              , dc.NameIsCleanStatus
              , dc.CompanyName
              , dc.IsBusiness
              , dc.AddressPrimaryStreet
              , dc.AddressPrimarySuite
              , dc.AddressPrimaryCity
              , dc.AddressPrimaryState
              , dc.AddressPrimaryZip
              , dc.AddressPrimaryCounty
              , dc.AddressPrimaryCountry
              , dc.AddressPrimaryIsCleanStatus
              , dc.AddressOneStreet
              , dc.AddressOneSuite
              , dc.AddressOneCity
              , dc.AddressOneState
              , dc.AddressOneZip
              , dc.AddressOneCounty
              , dc.AddressOneCountry
              , dc.AddressOneIsCleanStatus
              , dc.AddressTwoStreet
              , dc.AddressTwoSuite
              , dc.AddressTwoCity
              , dc.AddressTwoState
              , dc.AddressTwoZip
              , dc.AddressTwoCounty
              , dc.AddressTwoCountry
              , dc.AddressTwoIsCleanStatus
              , dc.AddressThreeStreet
              , dc.AddressThreeSuite
              , dc.AddressThreeCity
              , dc.AddressThreeState
              , dc.AddressThreeZip
              , dc.AddressThreeCounty
              , dc.AddressThreeCountry
              , dc.AddressThreeIsCleanStatus
              , dc.AddressFourStreet
              , dc.AddressFourSuite
              , dc.AddressFourCity
              , dc.AddressFourState
              , dc.AddressFourZip
              , dc.AddressFourCounty
              , dc.AddressFourCountry
              , dc.AddressFourIsCleanStatus
              , dc.PhonePrimary
              , dc.PhonePrimaryIsCleanStatus
              , dc.PhoneHome
              , dc.PhoneHomeIsCleanStatus
              , dc.PhoneCell
              , dc.PhoneCellIsCleanStatus
              , dc.PhoneBusiness
              , dc.PhoneBusinessIsCleanStatus
              , dc.PhoneFax
              , dc.PhoneFaxIsCleanStatus
              , dc.PhoneOther
              , dc.PhoneOtherIsCleanStatus
              , dc.EmailPrimary
              , dc.EmailPrimaryIsCleanStatus
              , dc.EmailOne
              , dc.EmailOneIsCleanStatus
              , dc.EmailTwo
              , dc.EmailTwoIsCleanStatus
              , dc.AddressPrimaryNCOAStatus
              , dc.AddressOneStreetNCOAStatus
              , dc.AddressTwoStreetNCOAStatus
              , dc.AddressThreeStreetNCOAStatus
              , dc.AddressFourStreetNCOAStatus
              , dc.PhonePrimaryDNC
              , dc.PhoneHomeDNC
              , dc.PhoneCellDNC
              , dc.PhoneBusinessDNC
              , dc.PhoneFaxDNC
              , dc.PhoneOtherDNC
              , dc.ExtAttribute1
              , dc.ExtAttribute2
              , dc.ExtAttribute3
              , dc.ExtAttribute4
              , dc.ExtAttribute5
              , dc.ExtAttribute6
              , dc.ExtAttribute7
              , dc.ExtAttribute8
              , dc.ExtAttribute9
              , dc.ExtAttribute10
              , dc.ExtAttribute11
              , dc.ExtAttribute12
              , dc.ExtAttribute13
              , dc.ExtAttribute14
              , dc.ExtAttribute15
              , dc.ExtAttribute16
              , dc.ExtAttribute17
              , dc.ExtAttribute18
              , dc.ExtAttribute19
              , dc.ExtAttribute20
              , dc.ExtAttribute21
              , dc.ExtAttribute22
              , dc.ExtAttribute23
              , dc.ExtAttribute24
              , dc.ExtAttribute25
              , dc.ExtAttribute26
              , dc.ExtAttribute27
              , dc.ExtAttribute28
              , dc.ExtAttribute29
              , dc.ExtAttribute30
              --, dc.ExtAttribute31
              --, dc.ExtAttribute32
              --, dc.ExtAttribute33
              --, dc.ExtAttribute34
              --, dc.ExtAttribute35
              , dc.SSCreatedDate
              , dc.SSUpdatedDate
              , dc.CreatedDate
              , dc.UpdatedDate
              , dc.IsDeleted
              , dc.DeleteDate
              , dc.customer_matchkey
        FROM    dbo.DimCustomer dc WITH(NOLOCK)
                JOIN dbo.dimcustomerssbid ssbid WITH(NOLOCK) ON ssbid.DimCustomerId = dc.DimCustomerId
    END


GO
