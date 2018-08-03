CREATE TABLE [bkp].[dbo__TK_SEASON_20170207]
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
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [bkp].[dbo__TK_SEASON_20170207] ADD CONSTRAINT [PK_TK_SEASON_67993f2b-8c3c-4d77-9344-6a259744bb59] PRIMARY KEY CLUSTERED  ([ETLSID], [SEASON])
GO
CREATE NONCLUSTERED INDEX [IDX_SEASON] ON [bkp].[dbo__TK_SEASON_20170207] ([SEASON])
GO
