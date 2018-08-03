CREATE TABLE [mdm].[MatchkeyHash]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MatchkeyHashID] [uniqueidentifier] NOT NULL,
[MatchkeyHashIDName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MatchkeyHashPlainText] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MatchkeyHash] [varbinary] (32) NULL,
[InsertDate] [datetime] NULL CONSTRAINT [DF__MatchkeyH__Inser__08B81302] DEFAULT (getdate())
)
GO
ALTER TABLE [mdm].[MatchkeyHash] ADD CONSTRAINT [PK_MatchkeyHash_ID] PRIMARY KEY CLUSTERED  ([ID])
GO
CREATE NONCLUSTERED INDEX [IX_MatchkeyHash_MatchkeyHashIdentifier] ON [mdm].[MatchkeyHash] ([MatchkeyHashIDName], [MatchkeyHash]) INCLUDE ([ID], [MatchkeyHashID], [MatchkeyHashPlainText])
GO
