CREATE TABLE [src].[Sync_TI_TK_BC]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[BC_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[STATUS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEQ] [bigint] NULL,
[ITEM] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[I_PT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[EVENT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[LEVEL] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SECTION] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ROW] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SEAT] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SCAN_DATE] [datetime] NULL,
[SCAN_TIME] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCAN_LOC] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCAN_CLUSTER] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCAN_GATE] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCAN_RESPONSE] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[REDEEMED] [smallint] NULL,
[DELIVERY_ID] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ATTENDED] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STC] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BC_TYPE] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ZID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_Id] [int] NOT NULL IDENTITY(1, 1)
)
GO
ALTER TABLE [src].[Sync_TI_TK_BC] ADD CONSTRAINT [PK__Sync_TI___19364FD2DED39CE3] PRIMARY KEY CLUSTERED  ([ETL_Sync_Id])
GO
