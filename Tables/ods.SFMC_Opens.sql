CREATE TABLE [ods].[SFMC_Opens]
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
[IsUnique] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[SFMC_Opens] ADD CONSTRAINT [PK__SFMC_Ope__7EF6BFCDD5485FBE] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
CREATE NONCLUSTERED INDEX [IDX_Key] ON [ods].[SFMC_Opens] ([ClientID], [SendID], [SubscriberID], [EventDate], [IsUnique])
GO
