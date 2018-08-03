CREATE TABLE [segmentation].[SegmentationFlatData179bc8e4-b618-4906-a93b-4e398392e7fc]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
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
ALTER TABLE [segmentation].[SegmentationFlatData179bc8e4-b618-4906-a93b-4e398392e7fc] ADD CONSTRAINT [pk_SegmentationFlatData179bc8e4-b618-4906-a93b-4e398392e7fc] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData179bc8e4-b618-4906-a93b-4e398392e7fc] ON [segmentation].[SegmentationFlatData179bc8e4-b618-4906-a93b-4e398392e7fc] ([_rn])
GO
