CREATE TABLE [audit].[TaskLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[BatchID] [int] NOT NULL,
[Created] [datetime] NULL CONSTRAINT [DF_TaskLog_Created] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[User] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaskName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Target] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SQL] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecuteStart] [datetime] NULL,
[ExecuteEnd] [datetime] NULL,
[ExecutionRuntimeSeconds] AS (CONVERT([float],datediff(second,[ExecuteStart],[ExecuteEnd]),(0))),
[RowCountBefore] [int] NULL CONSTRAINT [DF_TaskLog_RowCountBefore] DEFAULT ((0)),
[RowCountAfter] [int] NULL CONSTRAINT [DF_TaskLog_RowCountAfter] DEFAULT ((0)),
[Inserted] [int] NULL CONSTRAINT [DF_TaskLog_Inserted] DEFAULT ((0)),
[Updated] [int] NULL CONSTRAINT [DF_TaskLog_Updated] DEFAULT ((0)),
[Deleted] [int] NULL CONSTRAINT [DF_TaskLog_Deleted] DEFAULT ((0)),
[Truncated] [int] NULL CONSTRAINT [DF_TaskLog_Truncated] DEFAULT ((0)),
[IsCommitted] [bit] NULL CONSTRAINT [DF_TaskLog_IsCommitted] DEFAULT ((0)),
[IsError] [bit] NULL CONSTRAINT [DF_TaskLog_IsError] DEFAULT ((0)),
[ErrorMessage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorSeverity] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ErrorState] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
WITH
(
DATA_COMPRESSION = PAGE
)
GO
ALTER TABLE [audit].[TaskLog] ADD CONSTRAINT [PK_TaskLog_ID] PRIMARY KEY CLUSTERED  ([ID]) WITH (DATA_COMPRESSION = PAGE)
GO
