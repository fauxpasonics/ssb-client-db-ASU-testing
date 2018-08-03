CREATE TABLE [etl].[Task]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[BatchID] [int] NOT NULL CONSTRAINT [DF_Task_BatchID] DEFAULT ((0)),
[ExecutionOrder] [int] NOT NULL CONSTRAINT [DF_Task_ExecutionOrder] DEFAULT ((1)),
[TaskName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Task_TaskName] DEFAULT ('Not Specified'),
[TaskType] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Task_TaskType] DEFAULT ('Not Specified'),
[SQL] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Task_SQL] DEFAULT (NULL),
[Target] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Task_Target] DEFAULT (NULL),
[Source] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Task_Source] DEFAULT (NULL),
[CustomMatchOn] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Task_CustomMatchOn] DEFAULT (NULL),
[ExcludeColumns] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Task_ExcludeColumns] DEFAULT (NULL),
[Execute] [bit] NULL CONSTRAINT [DF_Task_Execute] DEFAULT ((0)),
[FailBatchOnFailure] [bit] NULL CONSTRAINT [DF_Task_FailBatchOnFailure] DEFAULT ((1)),
[SuppressResults] [bit] NULL CONSTRAINT [DF_Task_SuppressResults] DEFAULT ((0)),
[RunSQL] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL CONSTRAINT [DF_Task_Active] DEFAULT ((1)),
[CREATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_Task_CREATED_DATE] DEFAULT ([etl].[ConvertToLocalTime](getdate())),
[LUPDATED_DATE] [datetime] NOT NULL CONSTRAINT [DF_Task_LUPDATED_DATE] DEFAULT ([etl].[ConvertToLocalTime](getdate()))
)
WITH
(
DATA_COMPRESSION = PAGE
)
GO
ALTER TABLE [etl].[Task] ADD CONSTRAINT [PK_Task_ID] PRIMARY KEY CLUSTERED  ([ID]) WITH (DATA_COMPRESSION = PAGE)
GO
