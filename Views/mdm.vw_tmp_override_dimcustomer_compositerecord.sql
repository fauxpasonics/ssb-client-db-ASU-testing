SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [mdm].[vw_tmp_override_dimcustomer_compositerecord] 
AS 
SELECT b.SSB_CRMSYSTEM_CONTACT_ID, a.* 
	, ROW_NUMBER() OVER (PARTITION BY b.SSB_CRMSYSTEM_CONTACT_ID, a.ElementID, a.Field ORDER BY a.InsertDate DESC, b.UpdatedDate DESC, a.OverrideID DESC) AS override_ranking 
FROM mdm.tmp_override_dimcustomer_compositerecord a 
INNER JOIN mdm.vw_Overrides b ON a.OverrideID = b.OverrideID 
WHERE 1=1 
AND b.StatusID = 1 
GO
