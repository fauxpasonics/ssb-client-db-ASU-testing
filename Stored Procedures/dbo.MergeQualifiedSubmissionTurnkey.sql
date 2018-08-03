SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






-- =============================================
-- Created By: Abbey Meitin
-- Create Date: 2018-7-06
-- Reviewed By: 
-- Reviewed Date: 
-- Description: Turnkey Nightly Automation Process
-- =============================================
 
/***** Revision History
 

*****/


CREATE PROCEDURE [dbo].[MergeQualifiedSubmissionTurnkey] 


AS

BEGIN
	SET NOCOUNT ON;

SELECT vTF.SSID
,vTF.SourceSystem
, vTF.TicketingSystemAccountID 
INTO #Qualifiedturnkey
FROM dbo.vwTurnKey_Qualified vTF
	LEFT JOIN dbo.TurnkeyQualifiedSubmissions qs ON qs.SSID = vTF.SSID 
													AND qs.SourceSystem = vTF.SourceSystem
WHERE qs.SSID IS NULL


MERGE INTO [dbo].[TurnkeyQualifiedSubmissions]  AS target
USING #Qualifiedturnkey  AS SOURCE 
ON  SOURCE.SSID = target.SSID AND SOURCE.SourceSystem = target.SourceSystem
WHEN NOT MATCHED
 THEN INSERT 
(
 TC_ID,
SSID,
TicketingSystemAccountID,
SourceSystem,
[FileName],
SubmitDate,
ReceiveDate,
LastModifiedDate
)

VALUES
(
0,
source.SSID,
TicketingSystemAccountID,
Sourcesystem,
'0',
GETDATE(),
NULL,
GETDATE()
);


-- Checking for return trip people
UPDATE b 
SET [ReceiveDate] = CAST(ETL_CreatedDate AS DATE)
FROM dbo.vw_Turnkey_Acxiom a 
INNER JOIN dbo.[TurnkeyQualifiedSubmissions] b ON a.[TicketingSystemAccountID] = b.[TicketingSystemAccountID]

UPDATE b 
SET [SubmitDate] = CAST(q.SubmitDate AS DATE)
FROM [dbo].[vwTurnKey_Qualified] q 
INNER JOIN dbo.[TurnkeyQualifiedSubmissions] b ON q.[SSID] = b.[SSID] AND q.SourceSystem = b.SourceSystem



END





GO
