CREATE TABLE [dbo].[TI_ReportBase_History]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER_TYPE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ITEM] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[E_PL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_PT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_PRICE] [numeric] (18, 2) NULL,
[I_DAMT] [numeric] (18, 2) NULL,
[ORDQTY] [bigint] NULL,
[ORDTOTAL] [numeric] (18, 2) NULL,
[PAIDCUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MINPAYMENTDATE] [datetime] NULL,
[PAIDTOTAL] [numeric] (18, 2) NULL,
[INSERTDATE] [datetime] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [IDX_CS_TI_ReportBase_History] ON [dbo].[TI_ReportBase_History]
GO
