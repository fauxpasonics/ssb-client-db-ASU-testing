SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vwSFDC_Item__c_OLD] AS 
SELECT
	 SEASON Season__c
	,ITEM Item__c
	,SEASON COLLATE SQL_Latin1_General_CP1_CS_AS + ITEM as ZID__c
	,NAME Name
	,EXPORT_DATETIME Export_Datetime__c

	FROM TK_ITEM with (nolock) 


GO
