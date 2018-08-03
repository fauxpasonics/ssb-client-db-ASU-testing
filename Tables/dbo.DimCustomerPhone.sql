CREATE TABLE [dbo].[DimCustomerPhone]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[CreatedDate] [datetime] NULL CONSTRAINT [DF_DimCustomerPhone_CreatedDate] DEFAULT (getdate()),
[UpdatedDate] [datetime] NULL,
[DimCustomerID] [int] NULL,
[Source_DimPhoneID] [int] NULL,
[DimPhoneID] [int] NULL,
[PhoneType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[DimCustomerPhone] ADD CONSTRAINT [PK_DimCustomerPhone_ID] PRIMARY KEY CLUSTERED  ([ID])
GO
CREATE NONCLUSTERED INDEX [IX_DimCustomerPhone_DimCustomerID] ON [dbo].[DimCustomerPhone] ([DimCustomerID])
GO
CREATE NONCLUSTERED INDEX [IX_DimCustomerPhone_DimPhoneID] ON [dbo].[DimCustomerPhone] ([DimPhoneID]) INCLUDE ([DimCustomerID], [PhoneType])
GO
CREATE NONCLUSTERED INDEX [IX_DimCustomerPhone_Source_DimPhoneID] ON [dbo].[DimCustomerPhone] ([Source_DimPhoneID]) INCLUDE ([DimCustomerID], [PhoneType])
GO
ALTER TABLE [dbo].[DimCustomerPhone] ADD CONSTRAINT [FK_DimCustomerPhone_DimPhoneID] FOREIGN KEY ([DimPhoneID]) REFERENCES [dbo].[DimPhone] ([DimPhoneID])
GO
ALTER TABLE [dbo].[DimCustomerPhone] ADD CONSTRAINT [FK_DimCustomerPhone_Source_DimPhoneID] FOREIGN KEY ([Source_DimPhoneID]) REFERENCES [dbo].[Source_DimPhone] ([Source_DimPhoneID])
GO
