CREATE TABLE [stg].[FactTicketSalesBase]
(
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ITEM] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[E_PL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[E_PT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[E_PRICE] [numeric] (18, 2) NULL,
[E_DAMT] [numeric] (18, 2) NULL,
[E_STAT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ORDQTY] [bigint] NULL,
[ORDTOTAL] [numeric] (18, 2) NULL,
[ORDFEE] [numeric] (18, 2) NULL,
[OrderConvenienceFee] [numeric] (18, 2) NULL,
[E_FPRICE] [numeric] (18, 2) NULL,
[PAIDCUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MINPAYMENTDATE] [datetime] NULL,
[PAIDTOTAL] [numeric] (18, 2) NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI__stg_FactTicketSalesBase] ON [stg].[FactTicketSalesBase]
GO
