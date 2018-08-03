SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [cust].[vw_DimCustomerEmail_PIVOT] 
AS 
SELECT  
	DimCustomerID 
	,MAX(EmailPrimary) AS EmailPrimary 
	,MAX(EmailOne) AS EmailOne
	,MAX(EmailTwo) AS EmailTwo
	,MAX(EmailPrimaryIsCleanStatus) AS EmailPrimaryIsCleanStatus 
	,MAX(EmailOneIsCleanStatus) AS EmailOneIsCleanStatus 
	,MAX(EmailTwoIsCleanStatus) AS EmailTwoIsCleanStatus 
	,MAX(EmailPrimaryDirtyHash) AS EmailPrimaryDirtyHash
	,MAX(EmailOneDirtyHash) AS EmailOneDirtyHash
	,MAX(EmailTwoDirtyHash) AS EmailTwoDirtyHash
FROM ( 
	SELECT  
		DimCustomerID 
		, Email,   EmailTypePivot  
		, EmailIsCleanStatus, EmailIsCleanStatusPivot 
		, EmailDirtyHash, EmailDirtyHashPivot
	FROM [cust].[vw_DimCustomerEmail_prePivot] 
) p 
PIVOT 
( 
	MAX(Email) 
	FOR EmailTypePivot IN (EmailPrimary, EmailOne, EmailTwo) 
) AS pvt1 
PIVOT 
( 
	MAX(EmailIsCleanStatus) 
	FOR EmailIsCleanStatusPivot IN (EmailPrimaryIsCleanStatus,  EmailOneIsCleanStatus, EmailTwoIsCleanStatus) 
) AS pvt2 
PIVOT 
( 
	MAX(EmailDirtyHash) 
	FOR EmailDirtyHashPivot IN (EmailPrimaryDirtyHash, EmailOneDirtyHash, EmailTwoDirtyHash) 
) AS pvt3 
GROUP BY DimCustomerID 
;
GO
