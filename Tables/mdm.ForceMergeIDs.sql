CREATE TABLE [mdm].[ForceMergeIDs]
(
[winning_dimcustomerid] [int] NULL,
[losing_dimcustomerid] [int] NULL,
[ForceMergeID] [int] NOT NULL IDENTITY(1, 1),
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__ForceMerg__Creat__6A086D60] DEFAULT (getdate()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__ForceMerg__Updat__6AFC9199] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorGrouping] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [mdm].[ForceMergeIDs] ADD CONSTRAINT [PK_ForceMergeID] PRIMARY KEY CLUSTERED  ([ForceMergeID])
GO
ALTER TABLE [mdm].[ForceMergeIDs] ADD CONSTRAINT [UK_Loser] UNIQUE NONCLUSTERED  ([losing_dimcustomerid])
GO
ALTER TABLE [mdm].[ForceMergeIDs] ADD CONSTRAINT [UK_Pair] UNIQUE NONCLUSTERED  ([winning_dimcustomerid], [losing_dimcustomerid])
GO
GRANT DELETE ON  [mdm].[ForceMergeIDs] TO [db_SSB_IE_Permitted]
GO
GRANT INSERT ON  [mdm].[ForceMergeIDs] TO [db_SSB_IE_Permitted]
GO
GRANT UPDATE ON  [mdm].[ForceMergeIDs] TO [db_SSB_IE_Permitted]
GO
