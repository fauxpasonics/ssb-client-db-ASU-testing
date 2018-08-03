SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





Create view [dbo].[vwSFDC_Salecode__c_OLD] AS 
SELECT
	 SALECODE as ZID__c
	,SALECODE as  Salecode__c
	,NAME as Name
	,EXPORT_DATETIME as  Export_Datetime__c
	
	FROM TK_SALECODE with (nolock) 





GO
