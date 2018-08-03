CREATE TABLE [segmentation].[SegmentationFlatData74636621-0ee0-403a-a9fc-7bb6ce663572]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID_NUMBER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PACIOLAN_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUN_DEVIL_CLUB_POINTS] [float] NULL,
[LETTER_WINNER_POINTS] [float] NULL,
[SEASON_TICKET_POINTS] [float] NULL,
[CONTIBUTIONS_POINTS] [float] NULL,
[MISC_ADJUSTMENT_POINTS] [float] NULL,
[TOTAL_POINTS] [float] NULL,
[RANKING] [int] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatData74636621-0ee0-403a-a9fc-7bb6ce663572] ON [segmentation].[SegmentationFlatData74636621-0ee0-403a-a9fc-7bb6ce663572]
GO
