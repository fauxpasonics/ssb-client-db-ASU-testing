CREATE TABLE [ods].[SFMC_Subscribers]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_UpdatedDate] [datetime] NOT NULL,
[ETL_IsDeleted] [bit] NOT NULL,
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientID] [bigint] NULL,
[SubscriberKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberID] [bigint] NULL,
[Status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateHeld] [datetime] NULL,
[DateCreated] [datetime] NULL,
[DateUnsubscribed] [datetime] NULL
)
GO
ALTER TABLE [ods].[SFMC_Subscribers] ADD CONSTRAINT [PK__SFMC_Sub__7EF6BFCD6319ED7E] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
CREATE NONCLUSTERED INDEX [IDX_Key] ON [ods].[SFMC_Subscribers] ([SubscriberID])
GO
