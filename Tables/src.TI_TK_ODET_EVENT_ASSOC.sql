CREATE TABLE [src].[TI_TK_ODET_EVENT_ASSOC]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEQ] [bigint] NULL,
[ZID] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VMC] [smallint] NULL,
[EVENT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[E_PL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[E_PRICE] [numeric] (18, 2) NULL,
[E_DAMT] [numeric] (18, 2) NULL,
[E_STAT] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[E_PQTY] [bigint] NULL,
[E_ADATE] [datetime] NULL,
[E_SBLS] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[E_CPRICE] [numeric] (18, 2) NULL,
[E_FEE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[E_FPRICE] [numeric] (18, 2) NULL,
[E_SCAMT] [numeric] (18, 2) NULL
)
GO
