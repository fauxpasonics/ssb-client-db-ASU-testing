CREATE TABLE [mdm].[CompositeAccounts]
(
[ssb_crmsystem_acct_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressCompany_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ca_id] [int] NOT NULL IDENTITY(1, 1),
[Address_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [mdm].[CompositeAccounts] ADD CONSTRAINT [PK_CompositeAccounts] PRIMARY KEY CLUSTERED  ([ca_id])
GO
CREATE NONCLUSTERED INDEX [IX_CompositeAccounts_Address_ID] ON [mdm].[CompositeAccounts] ([Address_ID]) INCLUDE ([ssb_crmsystem_acct_id])
GO
CREATE NONCLUSTERED INDEX [IX_CompositeAccounts_AddressCompany] ON [mdm].[CompositeAccounts] ([AddressCompany_ID]) INCLUDE ([ssb_crmsystem_acct_id])
GO
