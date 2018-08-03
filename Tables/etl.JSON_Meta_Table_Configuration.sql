CREATE TABLE [etl].[JSON_Meta_Table_Configuration]
(
[JSON_Meta_Table_Configuration_ID] [int] NOT NULL IDENTITY(1, 1),
[JSON_Meta_Table_ID] [int] NOT NULL,
[TargetSchema] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TargetTableName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL CONSTRAINT [DF_JSON_Meta_Table_Configuration_Active] DEFAULT ((1)),
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_JSON_Meta_Table_Configuration_CreatedOn] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[CreatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_JSON_Meta_Table_Configuration_CreatedBy] DEFAULT (suser_sname()),
[LastUpdatedOn] [datetime] NOT NULL CONSTRAINT [DF_JSON_Meta_Table_Configuration_LastUpdatedOn] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[LastUpdatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_JSON_Meta_Table_Configuration_LastUpdatedBy] DEFAULT (suser_sname())
)
WITH
(
DATA_COMPRESSION = PAGE
)
GO
ALTER TABLE [etl].[JSON_Meta_Table_Configuration] ADD CONSTRAINT [PK_JSON_Meta_Table_Configuration_JSON_Meta_Table_Configuration_ID] PRIMARY KEY CLUSTERED  ([JSON_Meta_Table_Configuration_ID]) WITH (DATA_COMPRESSION = PAGE)
GO
ALTER TABLE [etl].[JSON_Meta_Table_Configuration] ADD CONSTRAINT [UNC_JSON_Meta_Table_Configuration_TargetSchema_Target_TableName] UNIQUE NONCLUSTERED  ([TargetSchema], [TargetTableName]) WITH (DATA_COMPRESSION = PAGE)
GO
GRANT DELETE ON  [etl].[JSON_Meta_Table_Configuration] TO [db_SSB_IE_Permitted]
GO
GRANT INSERT ON  [etl].[JSON_Meta_Table_Configuration] TO [db_SSB_IE_Permitted]
GO
GRANT UPDATE ON  [etl].[JSON_Meta_Table_Configuration] TO [db_SSB_IE_Permitted]
GO
