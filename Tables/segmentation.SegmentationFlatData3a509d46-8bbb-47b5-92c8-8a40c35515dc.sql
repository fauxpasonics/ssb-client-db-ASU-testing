CREATE TABLE [segmentation].[SegmentationFlatData3a509d46-8bbb-47b5-92c8-8a40c35515dc]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatData3a509d46-8bbb-47b5-92c8-8a40c35515dc] ON [segmentation].[SegmentationFlatData3a509d46-8bbb-47b5-92c8-8a40c35515dc]
GO
