CREATE TABLE [cust].[DimCustomerEmail]
(
[DimCustomerEmailID] [int] NOT NULL IDENTITY(1, 1),
[DimCustomerID] [int] NOT NULL,
[DimEmailID] [int] NULL,
[Source_DimEmailID] [int] NULL,
[DimEmailTypeID] [int] NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF__DimCustom__Creat__16FE3CC4] DEFAULT (getdate()),
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__DimCustom__Updat__17F260FD] DEFAULT (getdate()),
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [cust].[DimCustomerEmail] ADD CONSTRAINT [PK_DimCustomerEmail_DimCustomerEmailID] PRIMARY KEY CLUSTERED  ([DimCustomerEmailID])
GO
CREATE NONCLUSTERED INDEX [IX_DimCustomerEmail_DimCustomerID] ON [cust].[DimCustomerEmail] ([DimCustomerID])
GO
CREATE NONCLUSTERED INDEX [IX_DimCustomerEmail_DimEmailID] ON [cust].[DimCustomerEmail] ([DimEmailID]) INCLUDE ([DimCustomerID], [DimEmailTypeID])
GO
CREATE NONCLUSTERED INDEX [IX_DimCustomerEmail_Source_DimEmailID] ON [cust].[DimCustomerEmail] ([Source_DimEmailID]) INCLUDE ([DimCustomerID], [DimEmailTypeID])
GO
ALTER TABLE [cust].[DimCustomerEmail] ADD CONSTRAINT [FK_DimCustomerEmail_DimCustomerID] FOREIGN KEY ([DimCustomerID]) REFERENCES [dbo].[DimCustomer] ([DimCustomerId])
GO
ALTER TABLE [cust].[DimCustomerEmail] ADD CONSTRAINT [FK_DimCustomerEmail_DimEmailID] FOREIGN KEY ([DimEmailID]) REFERENCES [email].[DimEmail] ([DimEmailID])
GO
ALTER TABLE [cust].[DimCustomerEmail] ADD CONSTRAINT [FK_DimCustomerEmail_DimEmailTypeID] FOREIGN KEY ([DimEmailTypeID]) REFERENCES [email].[DimEmailType] ([DimEmailTypeID])
GO
ALTER TABLE [cust].[DimCustomerEmail] ADD CONSTRAINT [FK_DimCustomerEmail_Source_DimEmailID] FOREIGN KEY ([Source_DimEmailID]) REFERENCES [email].[Source_DimEmail] ([Source_DimEmailID])
GO
