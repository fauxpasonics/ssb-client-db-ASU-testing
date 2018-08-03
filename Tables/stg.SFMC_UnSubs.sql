CREATE TABLE [stg].[SFMC_UnSubs]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SendID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ListID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TriggeredSendExternalKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnsubReason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [stg].[SFMC_UnSubs] ADD CONSTRAINT [PK__SFMC_UnS__7EF6BFCD9F8E74ED] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
