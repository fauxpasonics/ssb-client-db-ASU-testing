CREATE TABLE [mdm].[NameEmailHash_Drop]
(
[nameemail_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[emailhash] [varchar] (585) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [mdm].[NameEmailHash_Drop] ADD CONSTRAINT [PK_NameEmailHash] PRIMARY KEY CLUSTERED  ([nameemail_id])
GO
CREATE NONCLUSTERED INDEX [ix_nameemailhash_nameemail] ON [mdm].[NameEmailHash_Drop] ([emailhash])
GO
