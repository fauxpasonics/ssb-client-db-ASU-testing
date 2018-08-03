CREATE TABLE [dbo].[TK_SEAT_SEAT]
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
ALTER TABLE [dbo].[TK_SEAT_SEAT] ADD CONSTRAINT [PK_TK_SEAT_SEAT] PRIMARY KEY CLUSTERED  ([ETLSID], [SEASON], [EVENT], [LEVEL], [SECTION], [ROW], [VMC])
GO
CREATE NONCLUSTERED INDEX [IDX_CUSTOMER] ON [dbo].[TK_SEAT_SEAT] ([CUSTOMER])
GO
CREATE NONCLUSTERED INDEX [IDX_DKEY] ON [dbo].[TK_SEAT_SEAT] ([DKEY])
GO
CREATE NONCLUSTERED INDEX [IDX_EVENT] ON [dbo].[TK_SEAT_SEAT] ([EVENT])
GO
CREATE NONCLUSTERED INDEX [IDX_LEVEL] ON [dbo].[TK_SEAT_SEAT] ([LEVEL])
GO
CREATE NONCLUSTERED INDEX [IDX_ROW] ON [dbo].[TK_SEAT_SEAT] ([ROW])
GO
CREATE NONCLUSTERED INDEX [IDX_SEASON] ON [dbo].[TK_SEAT_SEAT] ([SEASON])
GO
CREATE NONCLUSTERED INDEX [IX_TK_SEAT_SEAT_SEASON_EVENT_CUSTOMER] ON [dbo].[TK_SEAT_SEAT] ([SEASON], [EVENT], [CUSTOMER]) INCLUDE ([AISLE], [BARCODE], [DKEY], [I_PL], [I_PT], [ITEM], [LEVEL], [PL], [PREV_STATUS], [ROW], [SEAT], [SECTION], [STAT])
GO
CREATE NONCLUSTERED INDEX [IX_TK_SEAT_SEAT_SEASON_EVENT_CUSTOMER_INCLUDE] ON [dbo].[TK_SEAT_SEAT] ([SEASON], [EVENT], [CUSTOMER]) INCLUDE ([AISLE], [BARCODE], [DKEY], [I_PL], [I_PT], [ITEM], [LEVEL], [PL], [PREV_STATUS], [ROW], [SEAT], [SECTION], [STAT])
GO
CREATE NONCLUSTERED INDEX [IX_TK_SEAT_SEAT__SEASON_ITEM] ON [dbo].[TK_SEAT_SEAT] ([SEASON] DESC, [ITEM]) INCLUDE ([I_PL], [I_PT], [PL], [ROW], [SECTION])
GO
CREATE NONCLUSTERED INDEX [IX_TK_SEAT_SEAT__SEASON_STAT_COVERS] ON [dbo].[TK_SEAT_SEAT] ([SEASON], [STAT]) INCLUDE ([EVENT], [PL], [SEAT])
GO
CREATE NONCLUSTERED INDEX [IDX_SECTION] ON [dbo].[TK_SEAT_SEAT] ([SECTION])
GO