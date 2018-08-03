CREATE TABLE [bkp].[dbo__TK_SEAT_SEAT_20170207]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[EVENT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[LEVEL] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SECTION] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[ROW] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[VMC] [bigint] NOT NULL,
[SEAT] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[STAT] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[DKEY] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEQ] [bigint] NULL,
[ITEM] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[I_PT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[I_PL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[PREV_STATUS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[PL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[GATE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AREA] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[AISLE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BARCODE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[MP_RESERVE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZID] [varchar] (131) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [bkp].[dbo__TK_SEAT_SEAT_20170207] ADD CONSTRAINT [PK_TK_SEAT_SEAT] PRIMARY KEY CLUSTERED  ([ETLSID], [SEASON], [EVENT], [LEVEL], [SECTION], [ROW], [VMC])
GO
CREATE NONCLUSTERED INDEX [IDX_CUSTOMER] ON [bkp].[dbo__TK_SEAT_SEAT_20170207] ([CUSTOMER])
GO
CREATE NONCLUSTERED INDEX [IDX_DKEY] ON [bkp].[dbo__TK_SEAT_SEAT_20170207] ([DKEY])
GO
CREATE NONCLUSTERED INDEX [IDX_EVENT] ON [bkp].[dbo__TK_SEAT_SEAT_20170207] ([EVENT])
GO
CREATE NONCLUSTERED INDEX [IDX_LEVEL] ON [bkp].[dbo__TK_SEAT_SEAT_20170207] ([LEVEL])
GO
CREATE NONCLUSTERED INDEX [IDX_ROW] ON [bkp].[dbo__TK_SEAT_SEAT_20170207] ([ROW])
GO
CREATE NONCLUSTERED INDEX [IDX_SEASON] ON [bkp].[dbo__TK_SEAT_SEAT_20170207] ([SEASON])
GO
CREATE NONCLUSTERED INDEX [IDX_SECTION] ON [bkp].[dbo__TK_SEAT_SEAT_20170207] ([SECTION])
GO
