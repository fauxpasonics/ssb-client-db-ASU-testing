CREATE TABLE [config].[Process]
(
[ProcessID] [int] NOT NULL IDENTITY(1, 1),
[Process] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DESCRIPTION] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
