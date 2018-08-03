CREATE TABLE [src].[Sync_TI_TK_ODET_EVENT_ASSOC]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SEQ] [bigint] NOT NULL,
[VMC] [bigint] NOT NULL,
[EVENT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[E_PL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[E_PRICE] [numeric] (18, 2) NULL,
[E_DAMT] [numeric] (18, 2) NULL,
[E_STAT] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[E_AQTY] [bigint] NULL,
[E_PQTY] [bigint] NULL,
[E_ADATE] [datetime] NULL,
[E_SBLS] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[E_CPRICE] [numeric] (18, 2) NULL,
[E_FEE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[E_FPRICE] [numeric] (18, 2) NULL,
[TOT_EPAY] [numeric] (18, 2) NULL,
[TOT_CPAY] [numeric] (18, 2) NULL,
[TOT_FPAY] [numeric] (18, 2) NULL,
[E_SCAMT] [numeric] (18, 2) NULL,
[TOT_SCPAY] [numeric] (18, 2) NULL,
[ZID] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_Id] [int] NOT NULL IDENTITY(1, 1)
)
GO
ALTER TABLE [src].[Sync_TI_TK_ODET_EVENT_ASSOC] ADD CONSTRAINT [PK__Sync_TI___19364FD2750DF8F4] PRIMARY KEY CLUSTERED  ([ETL_Sync_Id])
GO
