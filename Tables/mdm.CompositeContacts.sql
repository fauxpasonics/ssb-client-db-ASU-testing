CREATE TABLE [mdm].[CompositeContacts]
(
[SSB_CRMSYSTEM_CONTACT_ID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_CompositeContacts_compositecontact_id] DEFAULT (newid()),
[nameaddr_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nameemail_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[namephone_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cc_id] [int] NOT NULL IDENTITY(1, 1),
[CustomerMatchkey_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FuzzyNameEmail_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameUnverifiableAddress_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [mdm].[CompositeContacts] ADD CONSTRAINT [PK_CompositeContacts] PRIMARY KEY NONCLUSTERED  ([cc_id])
GO
CREATE NONCLUSTERED INDEX [IX_CompositeContacts_CustomerMatchkey_ID] ON [mdm].[CompositeContacts] ([CustomerMatchkey_ID]) INCLUDE ([SSB_CRMSYSTEM_CONTACT_ID])
GO
CREATE NONCLUSTERED INDEX [IX_CompositeContacts_FuzzyNameEmail_ID] ON [mdm].[CompositeContacts] ([FuzzyNameEmail_ID]) INCLUDE ([SSB_CRMSYSTEM_CONTACT_ID])
GO
CREATE NONCLUSTERED INDEX [IX_CompositeContacts_NameAddr] ON [mdm].[CompositeContacts] ([nameaddr_id]) INCLUDE ([SSB_CRMSYSTEM_CONTACT_ID])
GO
CREATE NONCLUSTERED INDEX [IX_CompositeContacts_NameEmail] ON [mdm].[CompositeContacts] ([nameemail_id]) INCLUDE ([SSB_CRMSYSTEM_CONTACT_ID])
GO
CREATE NONCLUSTERED INDEX [IX_CompositeContacts_NamePhone] ON [mdm].[CompositeContacts] ([namephone_id]) INCLUDE ([SSB_CRMSYSTEM_CONTACT_ID])
GO
CREATE NONCLUSTERED INDEX [IX_CompositeContacts_NameUnverifiableAddress_ID] ON [mdm].[CompositeContacts] ([NameUnverifiableAddress_ID]) INCLUDE ([SSB_CRMSYSTEM_CONTACT_ID])
GO
CREATE CLUSTERED INDEX [IX_CompositeContacts] ON [mdm].[CompositeContacts] ([SSB_CRMSYSTEM_CONTACT_ID])
GO
