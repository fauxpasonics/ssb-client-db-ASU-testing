CREATE TABLE [mdm].[AttributeGroup]
(
[AttributeGroupID] [int] NOT NULL IDENTITY(1, 1),
[AttributeGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [mdm].[AttributeGroup] ADD CONSTRAINT [PK_AttributeGroup] PRIMARY KEY CLUSTERED  ([AttributeGroupID])
GO
