SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[rpt_LoadTI_ReportBaseEvent1]   AS 

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN 

Truncate table [dbo].[TI_ReportBaseEvent1]


Insert into [dbo].[TI_ReportBaseEvent1]
( SEASON
                , CUSTOMER
                , ITEM
                , EVENT
                , E_PL
                , E_PT
                , E_PRICE
                , E_DAMT
                , E_STAT
                , ORDQTY
                , ORDTOTAL
                , E_FPRICE
                , PAIDCUSTOMER
                , MINPAYMENTDATE
                , PAIDTOTAL
                )

exec dbo.rpt_TicketSalesBaseEventBuild1


END 



GO
