SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [dbo].[vw_KeyAccounts]
AS 

SELECT DISTINCT
        ssb.DimCustomerId ,
        ssb.SSB_CRMSYSTEM_CONTACT_ID SSBID,
        ssb.SSID
		, c.[Type] 
FROM    dbo.dimcustomerssbid ssb
INNER JOIN asu_reporting.[prodcopy].[vw_Account] c
ON c.id = ssb.SSID AND ssb.SourceSystem = 'ASU PC_SFDC Account'
WHERE 1=1
AND c.[Type] = 'Corporate Sponsor Account'



GO
