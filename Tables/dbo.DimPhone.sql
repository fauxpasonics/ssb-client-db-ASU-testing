CREATE TABLE [dbo].[DimPhone]
(
[DimPhoneID] [int] NOT NULL IDENTITY(1, 1),
[CreatedDate] [datetime] NULL CONSTRAINT [DF_DimPhone_CreatedDate] DEFAULT (getdate()),
[UpdatedDate] [datetime] NULL,
[Phone] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneLineTypeCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneStatus] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneCleanHash] [binary] (32) NULL
)
GO
ALTER TABLE [dbo].[DimPhone] ADD CONSTRAINT [PK_DimPhone_DimPhoneID] PRIMARY KEY CLUSTERED  ([DimPhoneID])
GO
CREATE NONCLUSTERED INDEX [IX_DimPhone_Phone] ON [dbo].[DimPhone] ([Phone]) INCLUDE ([DimPhoneID])
GO
CREATE NONCLUSTERED INDEX [IX_DimPhone_PhoneCleanHash] ON [dbo].[DimPhone] ([PhoneCleanHash])
GO
CREATE NONCLUSTERED INDEX [IX_DimPhone_PhoneLineTypeCode] ON [dbo].[DimPhone] ([PhoneLineTypeCode])
GO
ALTER TABLE [dbo].[DimPhone] ADD CONSTRAINT [FK_DimPhone_PhoneLineTypeCode] FOREIGN KEY ([PhoneLineTypeCode]) REFERENCES [dbo].[PhoneLineTypeCode] ([PhoneLineTypeCode])
GO
