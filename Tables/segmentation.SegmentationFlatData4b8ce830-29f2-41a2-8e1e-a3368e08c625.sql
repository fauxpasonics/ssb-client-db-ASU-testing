CREATE TABLE [segmentation].[SegmentationFlatData4b8ce830-29f2-41a2-8e1e-a3368e08c625]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (13) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SDT_SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SDT_SEASON_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_EVENT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SDT_EVENT_NAME] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_LEVEL] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SDT_SECTION] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SDT_ROW] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SDT_SEAT] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SDT_ITEM] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SDT_ITEM_NAME] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_I_pt] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SDT_PRICE_TYPE_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_PRICE_TYPE_CLASS] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SDT_PL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SDT_PL_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_AISLE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_ORDER_DATE] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SDT_ORDER_PRICE] [numeric] (18, 2) NULL,
[SDT_CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_TYPE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SDT_CUSTOMER_TYPE_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_SCAN_DATE] [datetime] NULL,
[SDT_SCAN_TIME] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_SCAN_LOC] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_SCAN_CLUSTER] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_SCAN_GATE] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_SCAN_RESPONSE] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SDT_REDEEMED] [smallint] NULL,
[SDT_ATTENDED] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatData4b8ce830-29f2-41a2-8e1e-a3368e08c625] ADD CONSTRAINT [pk_SegmentationFlatData4b8ce830-29f2-41a2-8e1e-a3368e08c625] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData4b8ce830-29f2-41a2-8e1e-a3368e08c625] ON [segmentation].[SegmentationFlatData4b8ce830-29f2-41a2-8e1e-a3368e08c625] ([_rn])
GO
