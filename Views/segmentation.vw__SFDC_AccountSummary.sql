SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [segmentation].[vw__SFDC_AccountSummary] AS


SELECT 
      account.[SSB_CRMSYSTEM_CONTACT_ID__c] AS SSB_CRMSYSTEM_CONTACT_ID,
	  account.Id AS AcctId
	  ,account.Name
	  ,account.CreatedDate
	  ,account.CreatedById
	  ,createdUser.name AS CreatedByName
	  ,account.LastModifiedDate
	  ,account.LastModifiedById
	  ,account.OwnerId
	  ,accountOwner.Name OwnerName
	  ,account.Service_Owner__c
	  ,ServiceOwner.Name Service_Owner_Name
	  ,account.LastActivityDate
	  ,DATEDIFF(DAY,account.LastActivityDate,GETDATE()) DaysSinceLastActivity
	  --,LastActivityOwner /*this requires prodcopy.task to be imported*/
	  , OpenOpp.OpenOpp AS HasOpenOpportunity
	  ,LastOpportunity.CreatedDate AS LastOpportunityCreatedDate
	  ,LastOpportunity.OwnerName AS LastOpportunityOwnerName
	  ,LastOpportunity.LastModifiedDate AS LastOpportunityLastModifiedDate
	  ,lastWon.LastWinDate AS LastOpportunityClosedWonDate
	  ,LastLost.LostReason AS LastOpportunityClosedLostReason
	  ,CASE WHEN account.IsPersonAccount = 0 THEN 1 
			WHEN account.IsPersonAccount = 1 THEN 0
	   END AS IsBusiness

 FROM (SELECT SSB_CRMSYSTEM_CONTACT_ID__c, id,name,createddate,createdbyid,lastmodifieddate,lastmodifiedbyid,lastactivitydate,ispersonaccount,OwnerId, Service_Owner__c FROM ASU_Reporting.ProdCopy.Account (NOLOCK) WHERE IsDeleted = 0) account
 	 INNER JOIN  (SELECT SSB_CRMSYSTEM_CONTACT_ID__c, Id, ROW_NUMBER() OVER(PARTITION BY SSB_CRMSYSTEM_CONTACT_ID__c ORDER BY LastModifiedDate DESC, CreatedDate) xRank 
					FROM ASU_Reporting.[prodcopy].[vw_Account] b ) x
					ON account.Id = x.Id AND x.xRank = '1'
	INNER JOIN ASU_Reporting.ProdCopy.[users] (NOLOCK) createdUser ON account.CreatedById=createdUser.ID 
	INNER JOIN ASU_Reporting.ProdCopy.[users] (NOLOCK) accountOwner ON account.OwnerId=accountowner.Id
	LEFT JOIN ASU_Reporting.ProdCopy.[users] (NOLOCK) ServiceOwner ON account.Service_owner__c =serviceowner.Id
	LEFT JOIN (SELECT opportunity.AccountId
			   		 ,opportunity.CreatedDate
			   		 ,[user].Name OwnerName
			   		 ,opportunity.LastModifiedDate
					 ,RANK() OVER(PARTITION BY opportunity.accountID ORDER BY opportunity.Id) opportunityRank
			   FROM ASU_Reporting.ProdCopy.Opportunity (NOLOCK) opportunity
				JOIN (SELECT AccountId
							,MAX(CreatedDate)MaxDate
					  FROM ASU_Reporting.ProdCopy.Opportunity (NOLOCK)
					  GROUP BY AccountId
					  )x
					  ON x.AccountId = opportunity.AccountId
						AND x.MaxDate = opportunity.CreatedDate
			   	INNER JOIN ASU_Reporting.ProdCopy.[users] (NOLOCK) [user]
			   		ON [user].Id = opportunity.OwnerId
				)LastOpportunity
				ON LastOpportunity.AccountId = account.Id
				   AND LastOpportunity.opportunityRank = 1
		LEFT JOIN (SELECT AccountId, MAX(LastModifiedDate)OpenOpp
			   FROM ASU_Reporting.ProdCopy.Opportunity (NOLOCK)
			   WHERE isClosed = 0 
			   GROUP BY AccountId) OpenOpp ON OpenOpp.AccountId = account.Id
	LEFT JOIN (SELECT accountID
					  ,MAX(CreatedDate)LastWinDate 
			   FROM ASU_Reporting.ProdCopy.Opportunity (NOLOCK)
			   WHERE isClosed = 1 AND IsWon = 1
			   GROUP BY AccountId) LastWon ON LastWon.AccountId = account.Id
	LEFT JOIN (SELECT Opportunity.accountID
					  ,Reason_Lost__c LostReason
					  ,RANK() OVER(PARTITION BY opportunity.accountID ORDER BY opportunity.Id) opportunityRank
			   FROM ASU_Reporting.ProdCopy.Opportunity (NOLOCK)
					JOIN (SELECT AccountId
								,MAX(CreatedDate) AS LastLoss
						  FROM ASU_Reporting.ProdCopy.Opportunity (NOLOCK)
						  WHERE isClosed = 1 AND IsWon = 0
						  GROUP BY AccountId)LastLoss ON LastLoss.AccountId = Opportunity.AccountId
														 AND LastLoss.LastLoss = Opportunity.CreatedDate
			   ) LastLost ON LastLost.AccountId = account.Id	
							 AND LastLost.opportunityRank = 1




		





GO
