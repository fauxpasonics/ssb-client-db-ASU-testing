CREATE TABLE [audit].[TaskBatchLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ParentID] [int] NULL,
[Step] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RunSQL] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecuteStart] [datetime] NULL,
[ExecuteEnd] [datetime] NULL,
[ExecutionRuntimeSeconds] AS (CONVERT([float],datediff(second,[ExecuteStart],[ExecuteEnd]),(0))),
[CreatedOn] [datetime] NULL CONSTRAINT [DF_TaskBatchLog_CreatedOn] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[CreatedBy] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_TaskBatchLog_CreatedBy] DEFAULT (suser_sname())
)
WITH
(
DATA_COMPRESSION = PAGE
)
GO
ALTER TABLE [audit].[TaskBatchLog] ADD CONSTRAINT [PK_TaskBatchLog_ID] PRIMARY KEY CLUSTERED  ([ID]) WITH (DATA_COMPRESSION = PAGE)
GO
ALTER TABLE [audit].[TaskBatchLog] ADD CONSTRAINT [FK_TaskBatchLog_ParentID] FOREIGN KEY ([ParentID]) REFERENCES [audit].[TaskBatchLog] ([ID])
GO
