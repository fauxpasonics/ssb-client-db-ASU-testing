CREATE TABLE [etl].[EventLogTM]
(
[LogId] [bigint] NOT NULL IDENTITY(1, 1),
[BatchId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LogUid] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EventDate] [datetime] NOT NULL,
[UserName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EventType] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EventClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogMessageFormat] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogMessage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
ALTER TABLE [etl].[EventLogTM] ADD CONSTRAINT [PK_EventLogTM] PRIMARY KEY CLUSTERED  ([LogId])
GO
CREATE NONCLUSTERED INDEX [IX_BatchID] ON [etl].[EventLogTM] ([BatchId])
GO
CREATE NONCLUSTERED INDEX [IX_EventClass] ON [etl].[EventLogTM] ([EventClass])
GO
CREATE NONCLUSTERED INDEX [IX_EventDate] ON [etl].[EventLogTM] ([EventDate] DESC)
GO
CREATE NONCLUSTERED INDEX [IX_EventType] ON [etl].[EventLogTM] ([EventType])
GO
