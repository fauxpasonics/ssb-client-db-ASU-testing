SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [ro].[vw_Turnkey_CustomFields] AS 

(
SELECT * FROM
(
	select 
	dc.SSB_CRMSYSTEM_CONTACT_ID
	, t.TicketingSystemAccountId
	, x.Id AS AcctId
	, t.FootballCapacity AS Turnkey_Football_Capacity_Score__c
	, t.Footballpriority AS Turnkey_Football_Priority_Score__c
	, [MBBBasketballCapacity] AS Turnkey_Basketball_Capacity_Score__c
	, [MBBBasketballPriority] AS Turnkey_Basketball_Priority_Score__c
	, [WBBBasketballCapacity] AS Turnkey_WBasketball_Capacity_Score__c
	, [WBBBasketballPriority] AS Turnkey_WBasketball_Priority_Score__c
	, [NetWorthGold] AS Turnkey_Net_Worth_Gold__c
	, [DiscretionaryIncomeIndex] AS Turnkey_Discretionary_Income_Index__c
	, [PersonicxCluster] AS Turnkey_PersonicX_Cluster__c
	, [AgeInTwoYearIncrements_InputIndividual] AS 	Turnkey_Age_Input_Individual__c
	, [MaritalStatusinHousehold] AS Turnkey_Marital_Status__c
	, [PresenceofChildren] AS Turnkey_Presence_of_Children__c
	, ROW_NUMBER() OVER (PARTITION BY dc.SSB_CRMSYSTEM_CONTACT_ID ORDER BY t.FootballPriorityDate, a.TurnkeyStandardBundleDate DESC) RN
	FROM [ods].[Turnkey_Models] t (NOLOCK)
	INNER JOIN [ods].[Turnkey_Acxiom] a (NOLOCK) on t.AbilitecId = a.AbilitecId
	INNER JOIN [dbo].[vwDimCustomer_ModAcctId] dc on dc.SourceSystem = 'TM' and CAST(dc.AccountId AS Nvarchar(50)) = t.TicketingSystemAccountId and CustomerType = 'Primary'
	 INNER JOIN  (SELECT SSB_CRMSYSTEM_CONTACT_ID__c, Id, ROW_NUMBER() OVER(PARTITION BY SSB_CRMSYSTEM_CONTACT_ID__c ORDER BY LastModifiedDate DESC, CreatedDate) xRank 
					FROM ASU_Reporting.[prodcopy].[vw_Account] b ) x
					ON dc.SSB_CRMSYSTEM_CONTACT_ID = x.SSB_CRMSYSTEM_CONTACT_ID__c AND x.xRank = '1'
	WHERE t.FootballCapacity > 0 OR t.Footballpriority > 0 
	OR [MBBBasketballCapacity] > 0 OR [MBBBasketballPriority] > 0 
	OR [WBBBasketballCapacity] > 0 OR [WBBBasketballPriority] > 0
) p

WHERE p.RN = '1'

)
GO
