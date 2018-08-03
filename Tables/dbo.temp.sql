CREATE TABLE [dbo].[temp]
(
[JSON_Meta_TableColumn_Configuration_ID] [int] NOT NULL IDENTITY(1, 1),
[JSON_Meta_Table_Configuration_ID] [int] NOT NULL,
[JSON_Meta_TableColumn_ID] [int] NULL,
[JSON_Meta_TableColumn_ID_MultiClause] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Order] [int] NULL,
[DataType] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Unpivot] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL,
[CreatedOn] [datetime] NOT NULL,
[CreatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastUpdatedOn] [datetime] NOT NULL,
[LastUpdatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
