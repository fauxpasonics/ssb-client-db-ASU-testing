SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [rpt].[Cust_CustomerLookupDetail] (@DimCustomerID BIGINT)
AS
SET NOCOUNT ON;
--rpt.Cust_CustomerLookupDetail 474947
--DECLARE @DimCustomerID BIGINT = 915496
 
IF (@DimCustomerId IS NULL)
BEGIN
    SELECT 'nothing' AS NoData
END
ELSE
BEGIN
 
        DECLARE @SSB_CONTACT_GUID VARCHAR(50)
 
        SELECT @SSB_CONTACT_GUID = SSB_CRMSYSTEM_CONTACT_ID 
        FROM dbo.DimCustomerSSBID (NOLOCK)
        WHERE DimCustomerId = @DimCustomerID
 
        SELECT
            @SSB_CONTACT_GUID AS SourceSystemID,
            'SSB Composite Record' AS SourceSystem,
            FirstName,
            LastName,
            MiddleName,
            AddressPrimaryStreet,
            AddressPrimarySuite,
            AddressPrimaryCity,
            AddressPrimaryState,
            AddressPrimaryZip,
            PhonePrimary,
            EmailPrimary,
            @SSB_CONTACT_GUID AS SSBGUID,
            0 AS IsPrimary,
            1 AS IsComposite,
            dc.CustomerType,
            NULL AS customer_matchkey,
            NULL AS ContactGUID,
            dc.SSB_CRMSYSTEM_ACCT_ID,
            dc.CD_Gender AS Gender,
            dc.CompanyName
        FROM mdm.CompositeRecord dc (NOLOCK)
        WHERE SSB_CRMSYSTEM_CONTACT_ID = @SSB_CONTACT_GUID 
        UNION
        SELECT
            SSID AS SourceSystemID,
            SourceSystem,
            FirstName,
            LastName,
            MiddleName,
            AddressPrimaryStreet,
            AddressPrimarySuite,
            AddressPrimaryCity,
            AddressPrimaryState,
            AddressPrimaryZip,
            PhonePrimary,
            EmailPrimary,
            @SSB_CONTACT_GUID AS SSBGUID,
            ds.SSB_CRMSYSTEM_PRIMARY_FLAG AS IsPrimary,
            0 AS IsComposite,
            dc.CustomerType,
            dc.customer_matchkey,
            dc.ContactGUID,
            SSB_CRMSYSTEM_ACCT_ID,
            dc.CD_Gender AS Gender,
            dc.CompanyName
        FROM dbo.DimCustomer dc (NOLOCK)
        INNER JOIN (
                SELECT DimCustomerId, SSB_CRMSYSTEM_PRIMARY_FLAG, SSB_CRMSYSTEM_ACCT_ID 
                FROM dbo.DimCustomerSSBID (NOLOCK)
                WHERE SSB_CRMSYSTEM_CONTACT_ID = @SSB_CONTACT_GUID
            ) ds
            ON  dc.DimCustomerId = ds.DimCustomerId
 
END
GO
