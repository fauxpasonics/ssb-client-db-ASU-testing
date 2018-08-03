CREATE TABLE [stg].[SFMC_SendJobs]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SendID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FromName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FromEmail] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchedTime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SentTime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TriggeredSendExternalKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SendDefinitionExternalKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JobStatus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreviewURL] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsMultipart] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Additional] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [stg].[SFMC_SendJobs] ADD CONSTRAINT [PK__SFMC_Sen__7EF6BFCD395A65C2] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
