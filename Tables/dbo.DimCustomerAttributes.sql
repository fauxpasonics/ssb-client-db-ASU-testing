CREATE TABLE [dbo].[DimCustomerAttributes]
(
[DimCustomerAttrID] [int] NOT NULL IDENTITY(1, 1),
[DimCustomerID] [int] NULL,
[AttributeGroupID] [int] NULL,
[Attributes] [xml] NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimCustom__Creat__09592FF1] DEFAULT (getdate()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimCustom__Updat__0A4D542A] DEFAULT (getdate())
)
GO
ALTER TABLE [dbo].[DimCustomerAttributes] ADD CONSTRAINT [PK__DimCusto__ABC69402528A319B] PRIMARY KEY NONCLUSTERED  ([DimCustomerAttrID])
GO
