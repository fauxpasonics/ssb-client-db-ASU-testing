CREATE TABLE [mdm].[SourceSystems]
(
[SourceSystemID] [int] NOT NULL IDENTITY(1, 1),
[SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDeleted] [bit] NULL,
[DateCreated] [date] NULL CONSTRAINT [DF__SourceSys__DateC__693CA210] DEFAULT (getdate()),
[DateUpdated] [date] NULL CONSTRAINT [DF__SourceSys__DateU__6A30C649] DEFAULT (getdate()),
[NameForReporting] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [mdm].[SourceSystems] ADD CONSTRAINT [PK__SourceSy__8F4FFBF42BEBFB26] PRIMARY KEY CLUSTERED  ([SourceSystemID])
GO
GRANT DELETE ON  [mdm].[SourceSystems] TO [db_SSB_IE_Permitted]
GO
GRANT INSERT ON  [mdm].[SourceSystems] TO [db_SSB_IE_Permitted]
GO
GRANT UPDATE ON  [mdm].[SourceSystems] TO [db_SSB_IE_Permitted]
GO
