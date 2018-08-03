CREATE TABLE [dbo].[DimCustomerMatchkey]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DimCustomerID] [int] NOT NULL,
[MatchkeyID] [int] NOT NULL,
[MatchkeyValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [datetime] NULL CONSTRAINT [DF_DimCustomerMatchkey_InsertDate] DEFAULT (getdate()),
[UpdateDate] [datetime] NULL CONSTRAINT [DF_DimCustomerMatchkey_UpdateDate] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[DimCustomerMatchkey] ADD CONSTRAINT [PK_DimCustomerMatchkey_ID] PRIMARY KEY CLUSTERED  ([ID])
GO
CREATE NONCLUSTERED INDEX [IX_DimCustomerMatchkey_DimCustomerID] ON [dbo].[DimCustomerMatchkey] ([DimCustomerID]) INCLUDE ([MatchkeyID])
GO
CREATE NONCLUSTERED INDEX [IX_DimCustomerMatchkey_DimCustomerID_MatchkeyID] ON [dbo].[DimCustomerMatchkey] ([DimCustomerID], [MatchkeyID])
GO
CREATE NONCLUSTERED INDEX [IX_DimCustomerMatchkey_ID] ON [dbo].[DimCustomerMatchkey] ([ID])
GO
CREATE NONCLUSTERED INDEX [IX_DimCustomerMatchkey_MatchkeyValue] ON [dbo].[DimCustomerMatchkey] ([MatchkeyValue])
GO
