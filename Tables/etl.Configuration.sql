CREATE TABLE [etl].[Configuration]
(
[ConfigurationID] [int] NOT NULL,
[Name] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL,
[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_Configuration_CreatedOn] DEFAULT (getdate()),
[CreatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Configuration_CreatedBy] DEFAULT (suser_sname()),
[LastUpdatedOn] [datetime] NOT NULL CONSTRAINT [DF_Configuration_LastUpdatedOn] DEFAULT (getdate()),
[LastUpdatedBy] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Configuration_LastUpdatedBy] DEFAULT (suser_sname())
)
WITH
(
DATA_COMPRESSION = PAGE
)
GO
ALTER TABLE [etl].[Configuration] ADD CONSTRAINT [PK_Configuration_ConfigurationID] PRIMARY KEY CLUSTERED  ([ConfigurationID]) WITH (DATA_COMPRESSION = PAGE)
GO
