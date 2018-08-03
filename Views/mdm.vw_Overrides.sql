SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [mdm].[vw_Overrides] 
AS 
SELECT b.SSB_CRMSYSTEM_CONTACT_ID, b.SSB_CRMSYSTEM_PRIMARY_FLAG, a.* 
FROM mdm.Overrides a 
LEFT JOIN dbo.dimcustomerssbid b ON a.DimCustomerID = b.DimCustomerId 
 
GO
