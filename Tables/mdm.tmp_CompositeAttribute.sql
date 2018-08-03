CREATE TABLE [mdm].[tmp_CompositeAttribute]
(
[DimCustomerID] [int] NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimCustomerAttrValsID] [int] NOT NULL,
[DimCustomerAttrID] [int] NULL,
[AttributeName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttributeValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_tmp_CompositeAttribute] ON [mdm].[tmp_CompositeAttribute] ([SSB_CRMSYSTEM_CONTACT_ID], [AttributeName])
GO
