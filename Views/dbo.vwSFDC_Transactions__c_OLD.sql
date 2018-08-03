SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE    VIEW [dbo].[vwSFDC_Transactions__c_OLD] AS 


SELECT
	 tkOdet.SEASON AS Season_Code__c 
	,tkSeason.NAME AS Season_Name__c
	,tkOdet.SEASON +':' + tkOdet.ZID AS Order_Line_ID__c
	,tkOdet.SEQ		Sequence__c 
	,tkOdet.CUSTOMER Patron_ID__c
	,tkItem.BASIS Basis__c
	,tkOdet.I_DISP Disposition_Code__c
	, CAST(STUFF(
               (SELECT      ',' + EVENT  + ''
               FROM      TK_ODET AS subtkOdet WITH (NOLOCK) JOIN TK_ODET_EVENT_ASSOC tkOdetEventAssoc WITH (NOLOCK) ON 
							subtkOdet.SEASON = tkOdetEventAssoc.SEASON 
							AND subtkOdet.ZID  = tkOdetEventAssoc.ZID 
               WHERE      subtkOdet.ZID = tkOdet.ZID AND subtkOdet.SEASON = tkOdet.SEASON
			  --and subtkOdet.SEASON = 'F13'  
	          FOR XML PATH('')), 1, 1, '') AS VARCHAR(300)) AS Event_Code__c  
	,tkOdet.ITEM Item_Code__c
	,tkItem.NAME Item_Title__c
	,tkOdet.I_PL Price_Level__c
	,tkOdet.I_PT Price_Type__c
	,I_PRICE Item_Price__c
	,tkOdet.I_DATE Order_Date__c
	,tkOdet.I_OQTY Order_Quantity__c 
	,tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT) AS   Order_Total__c
	,tkOdet.I_PAY Amount_Paid__c
	,tkOdet.ORIG_SALECODE Orig_Salecode__c
	,tkSalecode.NAME  AS Orig_Salecode_Name__c
	,tkOdet.PROMO Promo_Code__c
	,tkPromo.NAME AS Promo_Code_Name__c
	,tkOdet.I_MARK Rep_Code__c
	,tkOdet.INREFSOURCE Inrefsource__c
	,tkOdet.INREFDATA Inrefdata__c
	,tkOdet.E_SBLS_1 AS Seat_Block__c
	
	
	
	,CASE 
	
	    WHEN tkOdet.EXPORT_DATETIME > ISNULL(tkItem.EXPORT_DATETIME,'1900-01-01') 
	     AND tkOdet.EXPORT_DATETIME > ISNULL(tkSeason.EXPORT_DATETIME,'1900-01-01')
	     AND tkOdet.EXPORT_DATETIME > ISNULL(tkSalecode.EXPORT_DATETIME,'1900-01-01') 
	     AND tkOdet.EXPORT_DATETIME > ISNULL(tkPromo.EXPORT_DATETIME,'1900-01-01') 
		THEN tkOdet.EXPORT_DATETIME
		
		WHEN ISNULL(tkItem.EXPORT_DATETIME,'1900-01-01') > tkOdet.EXPORT_DATETIME 
	     AND ISNULL(tkItem.EXPORT_DATETIME,'1900-01-01') > ISNULL(tkSeason.EXPORT_DATETIME,'1900-01-01') 
	     AND ISNULL(tkItem.EXPORT_DATETIME,'1900-01-01') > ISNULL(tkSalecode.EXPORT_DATETIME,'1900-01-01') 
	     AND ISNULL(tkItem.EXPORT_DATETIME,'1900-01-01') > ISNULL(tkPromo.EXPORT_DATETIME,'1900-01-01')  
		THEN ISNULL(tkItem.EXPORT_DATETIME,'1900-01-01')
		
		WHEN ISNULL(tkSeason.EXPORT_DATETIME,'1900-01-01') > tkOdet.EXPORT_DATETIME 
	     AND ISNULL(tkSeason.EXPORT_DATETIME,'1900-01-01') > ISNULL(tkItem.EXPORT_DATETIME,'1900-01-01') 
	     AND ISNULL(tkSeason.EXPORT_DATETIME,'1900-01-01') > ISNULL(tkSalecode.EXPORT_DATETIME,'1900-01-01') 
	     AND ISNULL(tkSeason.EXPORT_DATETIME,'1900-01-01') > ISNULL(tkPromo.EXPORT_DATETIME,'1900-01-01') 
		THEN ISNULL(tkSeason.EXPORT_DATETIME,'1900-01-01')
		
		WHEN ISNULL(tkSalecode.EXPORT_DATETIME,'1900-01-01') > tkOdet.EXPORT_DATETIME 
	     AND ISNULL(tkSalecode.EXPORT_DATETIME,'1900-01-01') > ISNULL(tkItem.EXPORT_DATETIME,'1900-01-01')  
	     AND ISNULL(tkSalecode.EXPORT_DATETIME,'1900-01-01') > ISNULL(tkSeason.EXPORT_DATETIME,'1900-01-01') 
	     AND ISNULL(tkSalecode.EXPORT_DATETIME,'1900-01-01') > ISNULL(tkPromo.EXPORT_DATETIME,'1900-01-01')
		THEN ISNULL(tkSalecode.EXPORT_DATETIME,'1900-01-01')
		
		WHEN ISNULL(tkPromo.EXPORT_DATETIME,'1900-01-01') > tkOdet.EXPORT_DATETIME 
	     AND ISNULL(tkPromo.EXPORT_DATETIME,'1900-01-01') > ISNULL(tkItem.EXPORT_DATETIME,'1900-01-01') 
	     AND ISNULL(tkPromo.EXPORT_DATETIME,'1900-01-01') > ISNULL(tkSeason.EXPORT_DATETIME,'1900-01-01') 
	     AND ISNULL(tkPromo.EXPORT_DATETIME,'1900-01-01') > ISNULL(tkSalecode.EXPORT_DATETIME,'1900-01-01') 
		THEN ISNULL(tkPromo.EXPORT_DATETIME,'1900-01-01')
				 	 
			 
			 END AS Export_Datetime__c
			 


FROM 
	TK_ODET tkOdet WITH (NOLOCK) 
	JOIN TK_ITEM  tkItem WITH (NOLOCK)  
		ON tkOdet.SEASON = tkItem.SEASON 
		AND tkOdet.ITEM = tkItem.ITEM
	JOIN TK_SEASON tkSeason WITH (NOLOCK) 
		ON tkOdet.SEASON = tkSeason.SEASON
	LEFT JOIN TK_SALECODE tkSalecode WITH (NOLOCK) 
		ON tkOdet.ORIG_SALECODE = tkSalecode.SALECODE
	LEFT JOIN TK_PROMO  tkPromo WITH (NOLOCK)
		ON tkOdet.PROMO = tkPromo.PROMO 
	

		
		
		
		
	












GO
