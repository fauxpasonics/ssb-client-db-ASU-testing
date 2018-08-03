SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [rpt].[DOMO_Pac12_ASU_Donation_MembershipLevel]
AS
    BEGIN

        TRUNCATE TABLE [etl].[DOMO_Pac12_ExportFile_ASU_Donation_MembershipLevel]


        INSERT  INTO [etl].[DOMO_Pac12_ExportFile_ASU_Donation_MembershipLevel]
                SELECT  ssbid.SSB_CRMSYSTEM_CONTACT_ID
                      , Gift.GIFT_CLUB_ID_NUMBER DonationSystem_ID
                      , Gift.GIFT_CLUB_YEAR TransYear
                      , Gift.GIFT_CLUB_DESC MembershipLevel
                      , Gift.QUALIFIED_AMOUNT QualifiedAmount
                FROM    dbo.FD_SDC_GIFT_CLUBS Gift
                        JOIN dbo.dimcustomerssbid ssbid ON Gift.GIFT_CLUB_ID_NUMBER = ssbid.SSID
                                                           AND ssbid.SourceSystem = 'Advance ASU'

    END
GO
