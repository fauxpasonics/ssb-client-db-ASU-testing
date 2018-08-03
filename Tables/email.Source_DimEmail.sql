CREATE TABLE [email].[Source_DimEmail]
(
[Source_DimEmailID] [int] NOT NULL IDENTITY(1, 1),
[Email] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailDirtyHash] [binary] (32) NULL,
[DimEmailID] [int] NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF__Source_Di__Creat__123987A7] DEFAULT (getdate()),
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__Source_Di__Updat__132DABE0] DEFAULT (getdate()),
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [email].[Source_DimEmail] ADD CONSTRAINT [PK_Source_DimEmail_SourceDimEmailID] PRIMARY KEY CLUSTERED  ([Source_DimEmailID])
GO
CREATE NONCLUSTERED INDEX [IX_Source_DimEmail_Email] ON [email].[Source_DimEmail] ([Email]) INCLUDE ([Source_DimEmailID])
GO
CREATE NONCLUSTERED INDEX [IX_Source_DimEmail_EmailDirtyHash] ON [email].[Source_DimEmail] ([EmailDirtyHash])
GO
ALTER TABLE [email].[Source_DimEmail] ADD CONSTRAINT [FK_Source_DimEmail_DimEmailID] FOREIGN KEY ([DimEmailID]) REFERENCES [email].[DimEmail] ([DimEmailID])
GO
