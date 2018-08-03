CREATE TABLE [etl].[JSON_Meta_TableColumn_Configuration]
(
[JSON_Meta_TableColumn_Configuration_ID] [int] NOT NULL IDENTITY(1, 1),
[JSON_Meta_Table_Configuration_ID] [int] NOT NULL,
[JSON_Meta_TableColumn_ID] [int] NULL,
[JSON_Meta_TableColumn_ID_MultiClause] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Order] [int] NULL,
[DataType] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Unpivot] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_JSON_Meta_TableColumn_Configuration_Active] DEFAULT ((1)),
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_JSON_Meta_TableColumn_Configuration_CreatedOn] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[CreatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_JSON_Meta_TableColumn_Configuration_CreatedBy] DEFAULT (suser_sname()),
[LastUpdatedOn] [datetime] NOT NULL CONSTRAINT [DF_JSON_Meta_TableColumn_Configuration_LastUpdatedOn] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[LastUpdatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_JSON_Meta_TableColumn_Configuration_LastUpdatedBy] DEFAULT (suser_sname())
)
WITH
(
DATA_COMPRESSION = PAGE
)
GO
ALTER TABLE [etl].[JSON_Meta_TableColumn_Configuration] ADD CONSTRAINT [PK_JSON_Meta_TableColumn_Configuration_JSON_Meta_TableColumn_Configuration_ID] PRIMARY KEY CLUSTERED  ([JSON_Meta_TableColumn_Configuration_ID]) WITH (DATA_COMPRESSION = PAGE)
GO
ALTER TABLE [etl].[JSON_Meta_TableColumn_Configuration] ADD CONSTRAINT [UNC_JSON_Meta_TableColumn_Configuration_JSON_Meta_Table_Configuration_ID_ColumnName] UNIQUE NONCLUSTERED  ([JSON_Meta_Table_Configuration_ID], [ColumnName]) WITH (DATA_COMPRESSION = PAGE)
GO
ALTER TABLE [etl].[JSON_Meta_TableColumn_Configuration] ADD CONSTRAINT [UNC_JSON_Meta_TableColumn_Configuration_JSON_Meta_Table_Configuration_ID_JSON_Meta_TableColumn_ID] UNIQUE NONCLUSTERED  ([JSON_Meta_Table_Configuration_ID], [JSON_Meta_TableColumn_ID]) WITH (DATA_COMPRESSION = PAGE)
GO
ALTER TABLE [etl].[JSON_Meta_TableColumn_Configuration] ADD CONSTRAINT [UNC_JSON_Meta_TableColumn_Configuration_JSON_Meta_Table_Configuration_ID_Order] UNIQUE NONCLUSTERED  ([JSON_Meta_Table_Configuration_ID], [Order]) WITH (DATA_COMPRESSION = PAGE)
GO
GRANT DELETE ON  [etl].[JSON_Meta_TableColumn_Configuration] TO [db_SSB_IE_Permitted]
GO
GRANT INSERT ON  [etl].[JSON_Meta_TableColumn_Configuration] TO [db_SSB_IE_Permitted]
GO
GRANT UPDATE ON  [etl].[JSON_Meta_TableColumn_Configuration] TO [db_SSB_IE_Permitted]
GO
