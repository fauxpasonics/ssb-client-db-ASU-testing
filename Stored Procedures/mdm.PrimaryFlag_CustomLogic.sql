SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [mdm].[PrimaryFlag_CustomLogic]  AS

BEGIN

/* DEPLOY TO CLIENT DATABASE AND REMOVE _STANDARD FROM NAME */

SELECT ssbid.dimcustomerid, ssbid.sourcesystem, ssbid.ssid, 
ssbid.ssb_crmsystem_acct_id, ssbid.SSB_CRMSYSTEM_CONTACT_ID, 
NULL AS trans_dt,
NULL AS STH, dimcust.SSUpdatedDate, DIMCUST.SSCreatedDate, ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG,   
ssbid.SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG, dimcust.SourceSystemPriority
FROM dimcustomerssbid ssbid
INNER JOIN dimcustomer dimcust ON ssbid.DimCustomerId = dimcust.dimcustomerid
--LEFT JOIN USC_SFDC.stg.vw_SeasonTicketHolders_DimcustomerID sth ON ssbid.[DimCustomerId] = sth.DimCustomerId
WHERE dimcust.isdeleted = 0;

END

GO
