CREATE TABLE [ods].[SFMC_Clicks]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientID] [bigint] NULL,
[SendID] [bigint] NULL,
[SubscriberKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberID] [bigint] NULL,
[ListID] [bigint] NULL,
[EventDate] [datetime] NULL,
[EventType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SendURLID] [bigint] NULL,
[URLID] [bigint] NULL,
[URL] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Alias] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TriggeredSendExternalKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsUnique] [bit] NULL,
[IsUniqueForURL] [bit] NULL
)
GO
ALTER TABLE [ods].[SFMC_Clicks] ADD CONSTRAINT [PK__SFMC_Cli__7EF6BFCD4A0A8D69] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
CREATE NONCLUSTERED INDEX [IDX_Key] ON [ods].[SFMC_Clicks] ([ClientID], [SendID], [SubscriberID], [EventDate], [IsUnique], [IsUniqueForURL])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Specifies the Marketing Cloud account identifier associated with attribute set.', 'SCHEMA', N'ods', 'TABLE', N'SFMC_Clicks', 'COLUMN', N'ClientID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Specifes the subscriber email address.', 'SCHEMA', N'ods', 'TABLE', N'SFMC_Clicks', 'COLUMN', N'EmailAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date the event occurred.', 'SCHEMA', N'ods', 'TABLE', N'SFMC_Clicks', 'COLUMN', N'EventDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies the event type.', 'SCHEMA', N'ods', 'TABLE', N'SFMC_Clicks', 'COLUMN', N'EventType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Marketing Cloud identifier for the list that the job was sent to.', 'SCHEMA', N'ods', 'TABLE', N'SFMC_Clicks', 'COLUMN', N'ListID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Marketing Cloud identifier associated to an email send.', 'SCHEMA', N'ods', 'TABLE', N'SFMC_Clicks', 'COLUMN', N'SendID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The  Marketing Cloud-generated subscriber unique identifier for a subscriber.', 'SCHEMA', N'ods', 'TABLE', N'SFMC_Clicks', 'COLUMN', N'SubscriberID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies the subscriber.  If you do not identify your subscribers with a subscriber key, this value is the same as the email address.', 'SCHEMA', N'ods', 'TABLE', N'SFMC_Clicks', 'COLUMN', N'SubscriberKey'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The external key associated to a triggered send definition if the sent event resulted from a triggered send request.', 'SCHEMA', N'ods', 'TABLE', N'SFMC_Clicks', 'COLUMN', N'TriggeredSendExternalKey'
GO
