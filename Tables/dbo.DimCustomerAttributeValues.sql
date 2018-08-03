CREATE TABLE [dbo].[DimCustomerAttributeValues]
(
[DimCustomerAttrValsID] [int] NOT NULL IDENTITY(1, 1),
[DimCustomerAttrID] [int] NULL,
[AttributeName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttributeValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[DimCustomerAttributeValues] ADD CONSTRAINT [PK_DimCustomerAttrValsID] PRIMARY KEY CLUSTERED  ([DimCustomerAttrValsID])
GO
CREATE NONCLUSTERED INDEX [IX_DimCustomerAttrID] ON [dbo].[DimCustomerAttributeValues] ([DimCustomerAttrID])
GO
ALTER TABLE [dbo].[DimCustomerAttributeValues] ADD CONSTRAINT [FK_DimCustomerAttrID] FOREIGN KEY ([DimCustomerAttrID]) REFERENCES [dbo].[DimCustomerAttributes] ([DimCustomerAttrID])
GO
