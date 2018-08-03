SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create view [dbo].[vwSFDC_Season__c_OLD] AS 
SELECT
	 SEASON as ZID__c
	,SEASON as Season__c
	,NAME as Name 
	,ACTIVITY as Activity__c
	,STATUS as Status__c
	,EXPORT_DATETIME as Export_Datetime__c
	
	FROM TK_SEASON with (nolock)   




GO
