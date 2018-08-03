CREATE TABLE [email].[DimEmail]
(
[DimEmailID] [int] NOT NULL IDENTITY(1, 1),
[Email] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimEmailStatusID] [int] NULL,
[EmailCleanHash] [binary] (32) NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF_DimEmail_CreatedDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedDate] [datetime] NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [email].[DimEmail] ADD CONSTRAINT [PK_DimEmail_DimEmailID] PRIMARY KEY CLUSTERED  ([DimEmailID])
GO
CREATE NONCLUSTERED INDEX [IX_DimEmail_EmailStatus] ON [email].[DimEmail] ([DimEmailStatusID]) INCLUDE ([DimEmailID])
GO
CREATE NONCLUSTERED INDEX [IX_DimEmail_Email] ON [email].[DimEmail] ([Email]) INCLUDE ([DimEmailID])
GO
CREATE NONCLUSTERED INDEX [IX_DimEmail_EmailCleanHash] ON [email].[DimEmail] ([EmailCleanHash]) INCLUDE ([DimEmailID])
GO
ALTER TABLE [email].[DimEmail] ADD CONSTRAINT [FK_DimEmail_DimEmailStatusID] FOREIGN KEY ([DimEmailStatusID]) REFERENCES [email].[DimEmailStatus] ([DimEmailStatusID])
GO
