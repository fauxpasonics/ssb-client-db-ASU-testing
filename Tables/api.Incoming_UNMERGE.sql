CREATE TABLE [api].[Incoming_UNMERGE]
(
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChildID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[New] [bit] NULL,
[LoadDate] [datetime] NULL
)
GO
GRANT DELETE ON  [api].[Incoming_UNMERGE] TO [db_SSB_IE_Permitted]
GO
GRANT INSERT ON  [api].[Incoming_UNMERGE] TO [db_SSB_IE_Permitted]
GO
GRANT UPDATE ON  [api].[Incoming_UNMERGE] TO [db_SSB_IE_Permitted]
GO
