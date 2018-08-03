SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






Create view [dbo].[vwSFDC_PT_Name__c_OLD] AS 
SELECT
	 SEASON COLLATE SQL_Latin1_General_CP1_CS_AS + PRTYPE AS ZID__c
	,SEASON as Season__c
	,PRTYPE Price_Type__c
	,NAME Name 
	,EXPORT_DATETIME Export_Datetime__c
	
	FROM TK_PRTYPE  with (nolock)




GO
