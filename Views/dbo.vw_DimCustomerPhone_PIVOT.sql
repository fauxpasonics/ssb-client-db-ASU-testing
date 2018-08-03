SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[vw_DimCustomerPhone_PIVOT] 
AS 
SELECT  
	DimCustomerID 
	,MAX(PhonePrimary) AS PhonePrimary 
	,MAX(PhoneHome) AS PhoneHome 
	,MAX(PhoneCell) AS PhoneCell 
	,MAX(PhoneBusiness) AS PhoneBusiness 
	,MAX(PhoneFax) AS PhoneFax 
	,MAX(PhoneOther) AS PhoneOther 
	,MAX(PhonePrimaryIsCleanStatus) AS PhonePrimaryIsCleanStatus 
	,MAX(PhoneHomeIsCleanStatus) AS PhoneHomeIsCleanStatus 
	,MAX(PhoneCellIsCleanStatus) AS PhoneCellIsCleanStatus 
	,MAX(PhoneBusinessIsCleanStatus) AS PhoneBusinessIsCleanStatus 
	,MAX(PhoneFaxIsCleanStatus) AS PhoneFaxIsCleanStatus 
	,MAX(PhoneOtherIsCleanStatus) AS PhoneOtherIsCleanStatus 
	,MAX(PhonePrimaryLineType) AS PhonePrimaryLineType 
	,MAX(PhoneHomeLineType) AS PhoneHomeLineType 
	,MAX(PhoneCellLineType) AS PhoneCellLineType 
	,MAX(PhoneBusinessLineType) AS PhoneBusinessLineType 
	,MAX(PhoneFaxLineType) AS PhoneFaxLineType 
	,MAX(PhoneOtherLineType) AS PhoneOtherLineType 
FROM ( 
	SELECT  
		DimCustomerID 
		, Phone, PhoneTypePivot  
		, PhoneIsCleanStatus, PhoneIsCleanStatusPivot 
		, PhoneLineType, PhoneLineTypePivot 
	FROM [dbo].[vw_DimCustomerPhone_prePivot] 
) p 
PIVOT 
( 
	MAX(Phone) 
	FOR PhoneTypePivot IN (PhonePrimary, PhoneHome, PhoneCell, PhoneBusiness, PhoneFax, PhoneOther) 
) AS pvt1 
PIVOT 
( 
	MAX(PhoneIsCleanStatus) 
	FOR PhoneIsCleanStatusPivot IN (PhonePrimaryIsCleanStatus, PhoneHomeIsCleanStatus, PhoneCellIsCleanStatus, PhoneBusinessIsCleanStatus, PhoneFaxIsCleanStatus, PhoneOtherIsCleanStatus) 
) AS pvt2 
PIVOT 
( 
	MAX(PhoneLineType) 
	FOR PhoneLineTypePivot IN (PhonePrimaryLineType, PhoneHomeLineType, PhoneCellLineType, PhoneBusinessLineType, PhoneFaxLineType, PhoneOtherLineType) 
) AS pvt3 
GROUP BY DimCustomerID 
GO
