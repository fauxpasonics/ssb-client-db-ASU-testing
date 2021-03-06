SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [api].[GetTIReportBase_BB14]

AS

BEGIN
	
	select  
		 ISNULL(SEASON,'') SEASON
		,ISNULL(CUSTOMER,'') CUSTOMER 
		,ISNULL (ITEM,'') ITEM 
		,ISNULL(E_PL,'') E_PL 
		,ISNULL(I_PT,'') I_PT 
		,ISNULL(I_PRICE,0) I_PRICE
		,ISNULL(ORDQTY,0) ORDQTY 
		,ISNULL(ORDTOTAL,0) ORDTOTAL 
	 from [172.31.17.15].asutif1.dbo.vwtireportbase  WITH (NOLOCK) 
	where season = 'BB14' 
	FOR XML PATH('TIReportBase'), ROOT('TIReportBases')

END






GO
