CREATE TABLE [segmentation].[SegmentationFlatData92356f63-c9d5-413a-ba20-915a27e069b2]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_ID_NUMBER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_QUALIFIED_AMOUNT] [float] NOT NULL,
[GIFT_CLUB_YEAR] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_STATUS] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_DATE_ADDED] [date] NULL,
[GIFT_CLUB_DATE_MODIFIED] [date] NULL,
[SEATGIVING] [float] NOT NULL,
[PHILANTHROPIC_AMOUNT] [float] NOT NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatData92356f63-c9d5-413a-ba20-915a27e069b2] ADD CONSTRAINT [pk_SegmentationFlatData92356f63-c9d5-413a-ba20-915a27e069b2] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData92356f63-c9d5-413a-ba20-915a27e069b2] ON [segmentation].[SegmentationFlatData92356f63-c9d5-413a-ba20-915a27e069b2] ([_rn])
GO
