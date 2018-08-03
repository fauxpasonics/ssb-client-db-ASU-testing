CREATE TABLE [bkp].[dbo__TK_PRTYPE_20170207]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[PRTYPE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CLASS] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SORT] [bigint] NULL,
[STATUS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[KIND] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[LAST_USER] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[LAST_DATETIME] [datetime] NULL,
[ZID] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [bkp].[dbo__TK_PRTYPE_20170207] ADD CONSTRAINT [PK_TK_PRTYPE_44fee0de-6fa8-4abc-8dda-0245e0a7ea23] PRIMARY KEY CLUSTERED  ([ETLSID], [SEASON], [PRTYPE])
GO
