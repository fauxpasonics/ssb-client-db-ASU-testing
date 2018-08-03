CREATE TABLE [src].[Sync_TI_TK_SEAT_SEAT]
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
[ETL_Sync_Id] [int] NOT NULL IDENTITY(1, 1)
)
GO
ALTER TABLE [src].[Sync_TI_TK_SEAT_SEAT] ADD CONSTRAINT [PK__Sync_TI___19364FD2838ADDFB] PRIMARY KEY CLUSTERED  ([ETL_Sync_Id])
GO
