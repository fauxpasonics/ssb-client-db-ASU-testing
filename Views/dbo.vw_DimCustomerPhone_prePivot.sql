SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_DimCustomerPhone_prePivot] 
AS 
SELECT a.DimCustomerID, a.CreatedDate, a.UpdatedDate, ISNULL(c.Phone,b.Phone) AS Phone, b.PhoneDirtyHash, ISNULL(c.PhoneStatus,'Dirty') AS PhoneIsCleanStatus, c.PhoneLineType 
	, 'Phone' + a.PhoneType AS PhoneTypePivot 
	, 'Phone' + a.PhoneType + 'IsCleanStatus' AS PhoneIsCleanStatusPivot 
	, 'Phone' + a.PhoneType + 'LineType' AS PhoneLineTypePivot 
FROM dbo.DimCustomerPhone a WITH (NOLOCK) 
INNER JOIN dbo.Source_DimPhone b WITH (NOLOCK) ON a.Source_DimPhoneID= b.Source_DimPhoneID 
LEFT JOIN dbo.vw_DimPhone c WITH (NOLOCK) ON a.DimPhoneID = c.DimPhoneID 
GO
