CREATE TABLE [src].[Sync_TI_TK_SEASON]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREVIOUS] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ACTIVITY] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SIZE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATUS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SORT_ORDER] [bigint] NULL,
[LAST_USER] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[LAST_DATETIME] [datetime] NULL,
[ZID] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_Id] [int] NOT NULL IDENTITY(1, 1)
)
GO
ALTER TABLE [src].[Sync_TI_TK_SEASON] ADD CONSTRAINT [PK__Sync_TI___19364FD26BFE6E59] PRIMARY KEY CLUSTERED  ([ETL_Sync_Id])
GO
