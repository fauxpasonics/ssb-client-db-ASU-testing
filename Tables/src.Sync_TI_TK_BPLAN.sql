CREATE TABLE [src].[Sync_TI_TK_BPLAN]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BPTYPE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VMC] [bigint] NOT NULL,
[BDATE] [datetime] NULL,
[BPERCENT] [numeric] (18, 4) NULL,
[BAMT] [numeric] (18, 2) NULL,
[INV] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_USER] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_DATETIME] [datetime] NULL,
[ZID] [varchar] (53) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_Id] [int] NOT NULL IDENTITY(1, 1)
)
GO
ALTER TABLE [src].[Sync_TI_TK_BPLAN] ADD CONSTRAINT [PK__Sync_TI___19364FD2C3535AE5] PRIMARY KEY CLUSTERED  ([ETL_Sync_Id])
GO
