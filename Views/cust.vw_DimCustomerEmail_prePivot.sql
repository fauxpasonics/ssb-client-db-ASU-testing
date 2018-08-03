SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [cust].[vw_DimCustomerEmail_prePivot] 
AS 
SELECT a.DimCustomerID, a.Source_DimEmailId, a.DimEmailID, a.CreatedDate, a.UpdatedDate, ISNULL(c.Email,b.Email) AS Email, b.EmailDirtyHash, 
ISNULL(c.EmailStatus,'Dirty') AS EmailIsCleanStatus
	,  et.EmailType AS EmailTypePivot 
	,  et.EmailType + 'IsCleanStatus' AS EmailIsCleanStatusPivot 
	,  et.EmailType + 'DirtyHash' AS EmailDirtyHashPivot 
FROM cust.DimCustomerEmail a WITH (NOLOCK) 
INNER JOIN email.Source_DimEmail b WITH (NOLOCK) ON a.Source_DimEmailID= b.Source_DimEmailID 
inner join email.DimEmailType et with (nolock) on a.DimEmailTypeID = et.DimEmailTypeID
LEFT JOIN email.vw_DimEmail c WITH (NOLOCK) ON a.DimEmailID = c.DimEmailID 
;
GO
