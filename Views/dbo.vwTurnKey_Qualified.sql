SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [dbo].[vwTurnKey_Qualified]
AS


SELECT cr.SourceSystem	
	   ,CAST(cr.SSID AS NVARCHAR(255)) SSID	
	   ,CAST(CASE WHEN cr.SourceSystem = 'TM' THEN cr.AccountId ELSE NULL END AS NVARCHAR(255)) TicketingSystemAccountID	
	   ,qs.SubmitDate
FROM (  

		--Football and Men's Basketball Ticket Buyers
		SELECT DISTINCT dc.SSB_CRMSYSTEM_CONTACT_ID, MAX(OrderDate) SubmitDate
		FROM [ro].[vw_FactTicketSalesBase] fts
		INNER JOIN [dbo].[vwDimCustomer_ModAcctId] dc 
			ON dc.SourceSystem = 'TM' AND fts.TicketingAccountId = dc.AccountId AND dc.CustomerType = 'Primary'
		WHERE fts.Sport IN ('Football', 'Basketball') 
		AND SeasonYear = '2018'
		AND (fts.TicketTypeClass IN ('Season Ticket', 'Partial Plan') 
				OR TicketTYpeName IN ('Public', 'Premium Club'))
		GROUP BY dc.SSB_CRMSYSTEM_CONTACT_ID


	 ) qs

INNER JOIN [dbo].[vwCompositeRecord_ModAcctID] cr
	ON qs.SSB_CRMSYSTEM_CONTACT_ID = cr.SSB_CRMSYSTEM_CONTACT_ID



;



GO
