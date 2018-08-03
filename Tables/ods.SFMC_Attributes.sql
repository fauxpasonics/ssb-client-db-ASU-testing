CREATE TABLE [ods].[SFMC_Attributes]
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
[FirstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ASU_ATHLETICS] [bit] NULL
)
GO
ALTER TABLE [ods].[SFMC_Attributes] ADD CONSTRAINT [PK__SFMC_Att__7EF6BFCDC2D0EA5B] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
CREATE NONCLUSTERED INDEX [IDX_ClientId] ON [ods].[SFMC_Attributes] ([ClientID])
GO
CREATE NONCLUSTERED INDEX [IDX_SubscriberId] ON [ods].[SFMC_Attributes] ([SubscriberID])
GO
