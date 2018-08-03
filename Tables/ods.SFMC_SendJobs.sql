CREATE TABLE [ods].[SFMC_SendJobs]
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
[FromName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FromEmail] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchedTime] [datetime] NULL,
[SentTime] [datetime] NULL,
[Subject] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TriggeredSendExternalKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SendDefinitionExternalKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobStatus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreviewURL] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsMultipart] [bit] NULL,
[Additional] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[SFMC_SendJobs] ADD CONSTRAINT [PK__SFMC_Sen__7EF6BFCD8800C9D3] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
