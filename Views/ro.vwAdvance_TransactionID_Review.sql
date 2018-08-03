SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
  
-- =============================================
-- Created By: Abbey Meitin
-- Create Date: before we tracked
-- Reviewed By: Kaitlyn Sniffin
-- Reviewed Date: 
-- Description: Helps the Sun Devil Club review transactions posted in Advance that may be improperly associated to SDC ID's
-- =============================================
  
/***** Revision History
  
Abbey Meitin: added ISNULL Handling in where clause, Reviewed By: 
  
*****/
 
CREATE VIEW [ro].[vwAdvance_TransactionID_Review] 
AS
select don.ID_NUMBER
, bio1.PREF_MAIL_NAME
, DATE_OF_RECORD, TX_NUMBER, NET_LEGAL_AMOUNT, ALLOC_CODE, ALLOC_DESC
, PACIOLAN_ID AS TRANS_SDCID
, oid.OTHER_ID AS BIO_SDCID 
, oid2.ID_NUMBER AS AdvanceID_of_TransSDCID
, bio2.PREF_MAIL_NAME AS PrefMailName_of_TransSDCID
, CASE WHEN tix.TicketingAccountID IS NOT NULL THEN 1 ELSE 0 END AS FootballSTH_Transaction
, CASE WHEN oid.TYPE_CODE = 'SDJ' THEN 'SDJ'
       WHEN oid2.TYPE_CODE = 'SDP' THEN 'OTHER_SDP'
       WHEN oid3.TYPE_CODE = 'SDF' THEN 'SDF'
       ELSE 'NONE' END AS SDC_TYPE
 
--select top 100 * 
from [dbo].[FD_SDA_TRANSACTION_DETAIL] don
LEFT JOIN (select ID_NUMBER, OTHER_ID, TYPE_CODE 
            FROM [dbo].[FD_SDA_ENTITY_OTHER_IDS]
            WHERE TYPE_CODE IN ('SDP', 'SDJ')
            ) oid ON oid.ID_NUMBER = don.ID_NUMBER
LEFT JOIN (select ID_NUMBER, OTHER_ID, TYPE_CODE 
            FROM [dbo].[FD_SDA_ENTITY_OTHER_IDS]
            WHERE TYPE_CODE = 'SDP'
            ) oid2 ON don.PACIOLAN_ID = oid2.OTHER_ID
LEFT JOIN (select ID_NUMBER, OTHER_ID, TYPE_CODE 
            FROM [dbo].[FD_SDA_ENTITY_OTHER_IDS]
            WHERE TYPE_CODE = 'SDF'
            ) oid3 ON don.PACIOLAN_ID = oid3.OTHER_ID
LEFT JOIN dbo.FD_SDA_ENTITY_BIOGRAPHIC bio1 on don.ID_NUMBER = bio1.ID_NUMBER
LEFT JOIN dbo.FD_SDA_ENTITY_BIOGRAPHIC bio2 on oid2.ID_NUMBER = bio2.ID_NUMBER
LEFT JOIN (select Distinct CAST(TicketingAccountId AS nvarchar(20)) TicketingAccountId
            from [ro].[vw_FactTicketSalesBase] fts
            WHERE TicketTypeClass = 'Season Ticket'
            AND Sport = 'Football'
            AND SeasonYear >= '2017'
            ) tix on don.Paciolan_ID = tix.TicketingAccountId
where 1=1
AND DATE_OF_RECORD > '2015-01-01'
AND GYPMD_DESC IN ('Gift', 'Pledge Payment')
AND don.PACIOLAN_ID <> ISNULL(oid.OTHER_ID,0) -- added ISNULL handling
AND NET_LEGAL_AMOUNT > 0
 
GO
