CREATE TABLE [dbo].[Source_DimPhone]
(
[Source_DimPhoneID] [int] NOT NULL IDENTITY(1, 1),
[CreatedDate] [datetime] NULL CONSTRAINT [DF_Source_DimPhone_CreatedDate] DEFAULT (getdate()),
[UpdatedDate] [datetime] NULL,
[Phone] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneDirtyHash] [binary] (32) NULL,
[DimPhoneID] [int] NULL
)
GO
ALTER TABLE [dbo].[Source_DimPhone] ADD CONSTRAINT [PK_Source_DimPhone_Source_DimPhoneID] PRIMARY KEY CLUSTERED  ([Source_DimPhoneID])
GO
CREATE NONCLUSTERED INDEX [IX_Source_DimPhone_Phone] ON [dbo].[Source_DimPhone] ([Phone]) INCLUDE ([Source_DimPhoneID])
GO
CREATE NONCLUSTERED INDEX [IX_Source_DimPhone_PhoneDirtyHash] ON [dbo].[Source_DimPhone] ([PhoneDirtyHash])
GO
