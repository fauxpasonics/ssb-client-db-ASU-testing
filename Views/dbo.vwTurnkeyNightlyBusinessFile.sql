SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vwTurnkeyNightlyBusinessFile] 

AS

-- =============================================
-- Created By: Abbey Meitin
-- Create Date: 2018-07-06
-- Reviewed By: 
-- Reviewed Date: 
-- Description: Turnkey Nightly Automation Process
-- =============================================
 
/***** Revision History
 

*****/

--TM
SELECT  ts.TicketingSystemAccountID AS TicketingAccountID,
		CONVERT(VARCHAR(50), CONCAT(RTRIM(DC.SourceSystem),':',LTRIM(DC.SSID))) AS PersonID,	--	updated 11/11/16 ameitin
		DC.Firstname AS FirstName,
		DC.LastName AS LastName,
		COALESCE(DC.EmailPrimary, DC.EmailTwo) AS WorkEmailAddress,
		CompanyName AS Business_Name,
		DC.[AddressPrimaryStreet] AS BusinessAddress1,
		DC.[AddressPrimaryCity] AS BusinessCity,
		DC.[AddressPrimaryState] AS BusinessState,
		DC.[AddressPrimaryZip] AS BusinessPostalCode,
		DC.[AddressPrimaryCountry] AS BusinessCountry,
		DC.[PhonePrimary] AS Phone
FROM [dbo].[vwDimCustomer_ModAcctId] DC
	JOIN dbo.TurnkeyQualifiedSubmissions ts ON ts.SourceSystem = dc.sourcesystem
												AND ts.SSID = dc.SSID
WHERE dc.isbusiness = 1
	  --AND ts.SubmitDate > DATEADD(DAY,-2,GETDATE())			--	un-comment after first run DCH 2017-04-14
	  AND ReceiveDate IS NULL

GO
