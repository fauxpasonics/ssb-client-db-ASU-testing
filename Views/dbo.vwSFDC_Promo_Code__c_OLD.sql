SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





Create view [dbo].[vwSFDC_Promo_Code__c_OLD] AS 
SELECT
	 PROMO AS ZID__c
	,PROMO AS  Promo__c
	,NAME AS Name
	,EXPORT_DATETIME AS Export_Datetime__c

	FROM TK_PROMO  with (nolock)




GO
