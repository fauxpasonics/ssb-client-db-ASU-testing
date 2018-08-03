CREATE TABLE [ods].[SFMC_UnSubs]
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
[BatchID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TriggeredSendExternalKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UnsubReason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[SFMC_UnSubs] ADD CONSTRAINT [PK__SFMC_UnS__7EF6BFCD5BB2E6D6] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
