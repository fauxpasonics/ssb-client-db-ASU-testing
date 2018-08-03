CREATE TABLE [api].[Incoming_Merge]
(
[PK_MergeID] [int] NOT NULL IDENTITY(1, 1),
[Winning_GUID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Loser_GUID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GUIDType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Winning_DimCustomerID] [int] NULL,
[Loser_DimCustomerID] [int] NULL,
[CreatedDate] [datetime] NULL,
[LastAttemptedDate] [datetime] NULL,
[SFUserID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [api].[Incoming_Merge] ADD CONSTRAINT [PK__Incoming__B61946E348DEC7E2] PRIMARY KEY CLUSTERED  ([PK_MergeID])
GO
GRANT DELETE ON  [api].[Incoming_Merge] TO [db_SSB_IE_Permitted]
GO
GRANT INSERT ON  [api].[Incoming_Merge] TO [db_SSB_IE_Permitted]
GO
GRANT UPDATE ON  [api].[Incoming_Merge] TO [db_SSB_IE_Permitted]
GO
