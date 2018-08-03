CREATE TABLE [etl].[JSON_Meta_TableColumn]
(
[JSON_Meta_TableColumn_ID] [int] NOT NULL IDENTITY(1, 1),
[JSON_Meta_Table_ID] [int] NOT NULL,
[Level] [int] NOT NULL,
[Grouping] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HierarchyName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Order] [bigint] NULL,
[DataType] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Unpivot] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_JSON_Meta_TableColumn_Active] DEFAULT ((0)),
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_JSON_Meta_TableColumn_CreatedOn] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[CreatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_JSON_Meta_TableColumn_CreatedBy] DEFAULT (suser_sname()),
[LastUpdatedOn] [datetime] NOT NULL CONSTRAINT [DF_JSON_Meta_TableColumn_LastUpdatedOn] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[LastUpdatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_JSON_Meta_TableColumn_LastUpdatedBy] DEFAULT (suser_sname()),
[Name_raw] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
WITH
(
DATA_COMPRESSION = PAGE
)
GO
ALTER TABLE [etl].[JSON_Meta_TableColumn] ADD CONSTRAINT [PK_JSON_Meta_TableColumn_JSON_Meta_Table_ID_Level_HierarchyNam] PRIMARY KEY CLUSTERED  ([JSON_Meta_Table_ID], [Level], [HierarchyName]) WITH (DATA_COMPRESSION = PAGE)
GO
GRANT DELETE ON  [etl].[JSON_Meta_TableColumn] TO [db_SSB_IE_Permitted]
GO
GRANT INSERT ON  [etl].[JSON_Meta_TableColumn] TO [db_SSB_IE_Permitted]
GO
GRANT UPDATE ON  [etl].[JSON_Meta_TableColumn] TO [db_SSB_IE_Permitted]
GO
