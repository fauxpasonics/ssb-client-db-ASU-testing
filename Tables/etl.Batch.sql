CREATE TABLE [etl].[Batch]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ParentID] [int] NULL,
[SortOrder] [int] NULL,
[BatchName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchRefID] [int] NULL,
[SourceSchema] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TargetSchema] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceQuery] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaskType] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SQL] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExecuteInParallel] [bit] NULL CONSTRAINT [DF_Batch_ExecuteInParallel] DEFAULT ((0)),
[CustomMatchOn] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExcludeColumns] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Execute] [bit] NULL CONSTRAINT [DF_Batch_Execute] DEFAULT ((1)),
[FailBatchOnFailure] [bit] NULL CONSTRAINT [DF_Batch_FailBatchOnFailure] DEFAULT ((0)),
[SuppressResults] [bit] NULL CONSTRAINT [DF_Batch_SuppressResults] DEFAULT ((0)),
[FKTables] [bit] NULL CONSTRAINT [DF_Batch_FKTables] DEFAULT ((0)),
[AddID] [bit] NULL CONSTRAINT [DF_Batch_AddID] DEFAULT ((0)),
[SnapshotTables] [bit] NULL CONSTRAINT [DF_Batch_SnapshotTables] DEFAULT ((0)),
[AzureTier] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL CONSTRAINT [DF_Batch_Active] DEFAULT ((1))
)
WITH
(
DATA_COMPRESSION = PAGE
)
GO
ALTER TABLE [etl].[Batch] ADD CONSTRAINT [PK_Batch_ID] PRIMARY KEY CLUSTERED  ([ID]) WITH (DATA_COMPRESSION = PAGE)
GO
ALTER TABLE [etl].[Batch] ADD CONSTRAINT [UNC_Batch_BatchName] UNIQUE NONCLUSTERED  ([BatchName]) WITH (DATA_COMPRESSION = PAGE)
GO
