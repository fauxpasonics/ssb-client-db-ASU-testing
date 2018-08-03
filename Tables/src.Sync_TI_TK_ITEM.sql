CREATE TABLE [src].[Sync_TI_TK_ITEM]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[ITEM] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[NAME] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BASIS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[CLASS] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[KEYWORD] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TAG] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SELL_DATE_FROM] [datetime] NULL,
[SELL_DATE_TO] [datetime] NULL,
[SELL_TIME_FROM] [datetime] NULL,
[SELL_TIME_TO] [datetime] NULL,
[PTABLE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[PRINT_LINE] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INTERNET_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_USER] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[LAST_DATETIME] [datetime] NULL,
[ZID] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_Id] [int] NOT NULL IDENTITY(1, 1)
)
GO
ALTER TABLE [src].[Sync_TI_TK_ITEM] ADD CONSTRAINT [PK__Sync_TI___19364FD2FA44297B] PRIMARY KEY CLUSTERED  ([ETL_Sync_Id])
GO
