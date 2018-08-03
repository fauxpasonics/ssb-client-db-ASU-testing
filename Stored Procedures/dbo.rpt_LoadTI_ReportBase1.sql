SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--exec   rpt_LoadTI_ReportBase1

CREATE PROCEDURE [dbo].[rpt_LoadTI_ReportBase1]   as 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

begin 



Truncate table [dbo].[TI_ReportBase1]


Insert into [dbo].[TI_ReportBase1]
 (
  SEASON 
 ,CUSTOMER 
 ,CUSTOMER_TYPE  
 ,ITEM 
 ,E_PL
 ,I_PT  
 ,I_PRICE  
 ,I_DAMT 
 ,ORDQTY 
 ,ORDTOTAL
 ,PAIDCUSTOMER
 ,MINPAYMENTDATE  
 ,PAIDTOTAL
 ,INSERTDATE
 ,ORDFEE
)  

exec dbo.rpt_TicketSalesBaseBuild1




end 





















GO
