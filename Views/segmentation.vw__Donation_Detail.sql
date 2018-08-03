SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










CREATE VIEW [segmentation].[vw__Donation_Detail]

AS
(
SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID
        , fd.ID_NUMBER
        , fd.PACIOLAN_ID
        , fd.CAMPAIGN_CODE
        , fd.DATE_OF_RECORD
        , fd.ATHLETIC_FUND_DESC
		, fd.GYPMD_DESC
        , fd.TRANS_TYPE_DESC
		, SUM(CREDIT_AMOUNT) CREDIT_AMOUNT
        , SUM(fd.NET_LEGAL_AMOUNT) NET_LEGAL_AMOUNT
        , fd.ALLOC_CODE
        , fd.ALLOC_DESC
        , fd.AGENCY_DESC
        , fd.PAYMENT_TYPE_DESC
        , fd.MATCHING_COMPANY_ID
FROM    dbo.FD_SDA_TRANSACTION_DETAIL fd WITH (NOLOCK)
    --    JOIN (SELECT  ID_NUMBER
				--	  ,OTHER_ID
			 -- FROM dbo.FD_SDA_ENTITY_OTHER_IDS WITH (NOLOCK)
			 -- WHERE TYPE_CODE = 'SDP'
			 --)primaryID ON fd.PACIOLAN_ID = primaryID.OTHER_ID
		JOIN dbo.dimcustomerssbid ssbid WITH (NOLOCK) ON ssbid.SourceSystem = 'Advance ASU' AND fd.ID_NUMBER = ssbid.SSID
GROUP BY ssbid.SSB_CRMSYSTEM_CONTACT_ID
        , fd.ID_NUMBER
        , fd.PACIOLAN_ID
        , fd.CAMPAIGN_CODE
        , fd.DATE_OF_RECORD
        , fd.ATHLETIC_FUND_DESC
		, fd.GYPMD_DESC
        , fd.TRANS_TYPE_DESC
        , fd.ALLOC_CODE
        , fd.ALLOC_DESC
        , fd.AGENCY_DESC
        , fd.PAYMENT_TYPE_DESC
        , fd.MATCHING_COMPANY_ID


)













GO
