CREATE TABLE [segmentation].[SegmentationFlatDataf9254cfe-57b7-4763-8c78-24c54f21d499]
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
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatDataf9254cfe-57b7-4763-8c78-24c54f21d499] ON [segmentation].[SegmentationFlatDataf9254cfe-57b7-4763-8c78-24c54f21d499]
GO
