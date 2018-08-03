CREATE TABLE [etl].[JSON_Meta_Table]
(
[JSON_Meta_Table_ID] [int] NOT NULL IDENTITY(1, 1),
[Schema] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL CONSTRAINT [DF_JSON_Meta_Table_Active] DEFAULT ((0)),
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_JSON_Meta_Table_CreatedOn] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[CreatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_JSON_Meta_Table_CreatedBy] DEFAULT (suser_sname()),
[LastUpdatedOn] [datetime] NOT NULL CONSTRAINT [DF_JSON_Meta_Table_LastUpdatedOn] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[LastUpdatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_JSON_Meta_Table_LastUpdatedBy] DEFAULT (suser_sname())
)
WITH
(
DATA_COMPRESSION = PAGE
)
GO
ALTER TABLE [etl].[JSON_Meta_Table] ADD CONSTRAINT [PK_JSON_Meta_Table_JSON_Meta_Table_ID] PRIMARY KEY CLUSTERED  ([JSON_Meta_Table_ID]) WITH (DATA_COMPRESSION = PAGE)
GO
ALTER TABLE [etl].[JSON_Meta_Table] ADD CONSTRAINT [UNC_JSON_Meta_Table_Schema_Name] UNIQUE NONCLUSTERED  ([Schema], [Name]) WITH (DATA_COMPRESSION = PAGE)
GO
GRANT DELETE ON  [etl].[JSON_Meta_Table] TO [db_SSB_IE_Permitted]
GO
GRANT INSERT ON  [etl].[JSON_Meta_Table] TO [db_SSB_IE_Permitted]
GO
GRANT UPDATE ON  [etl].[JSON_Meta_Table] TO [db_SSB_IE_Permitted]
GO
