CREATE TABLE [bkp].[dbo__TK_EVENT_20170207]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[EVENT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[NAME] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETYPE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[PRINT_LINES] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CODE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MSG] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CLASS] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[BASIS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[EGROUP] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[DATE] [datetime] NULL,
[TIME] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KEYWORD] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TAG] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ITEM] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SMAP_TS] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FACILITY] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[CONFIG] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[HOLD_OK] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CAPACITY] [bigint] NULL,
[NREMAIN] [bigint] NULL,
[NALLOC] [bigint] NULL,
[NPRINT] [bigint] NULL,
[NHELD] [bigint] NULL,
[NKILL] [bigint] NULL,
[NCOMP] [bigint] NULL,
[FFEE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[XMIT] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RECEIVED] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EVENT_LOGO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AP_ALLOW] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AP_LIMIT] [int] NULL,
[AP_REENTRY] [int] NULL,
[DATE_END] [datetime] NULL,
[TIME_END] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ALLOCATED] [bigint] NULL,
[EXT] [numeric] (18, 2) NULL,
[ORDERED] [bigint] NULL,
[PRINTED] [bigint] NULL,
[LAST_USER] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[LAST_DATETIME] [datetime] NULL,
[ZID] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [bkp].[dbo__TK_EVENT_20170207] ADD CONSTRAINT [PK_TK_EVENT_d999fbb8-3c42-4447-891e-0af9afbf9eb0] PRIMARY KEY CLUSTERED  ([ETLSID], [SEASON], [EVENT])
GO
CREATE NONCLUSTERED INDEX [IDX_DATE] ON [bkp].[dbo__TK_EVENT_20170207] ([DATE])
GO
CREATE NONCLUSTERED INDEX [IDX_EGROUP] ON [bkp].[dbo__TK_EVENT_20170207] ([EGROUP])
GO
CREATE NONCLUSTERED INDEX [IDX_EVENT] ON [bkp].[dbo__TK_EVENT_20170207] ([EVENT])
GO
CREATE NONCLUSTERED INDEX [IDX_SEASON] ON [bkp].[dbo__TK_EVENT_20170207] ([SEASON])
GO
