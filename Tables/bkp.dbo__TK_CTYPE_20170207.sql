CREATE TABLE [bkp].[dbo__TK_CTYPE_20170207]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[TYPE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_USER] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[LAST_DATETIME] [datetime] NULL,
[ZID] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [bkp].[dbo__TK_CTYPE_20170207] ADD CONSTRAINT [PK_TK_CTYPE_d74e8e49-a998-40a9-92d1-d88b6ef59ac4] PRIMARY KEY CLUSTERED  ([ETLSID], [TYPE])
GO
CREATE NONCLUSTERED INDEX [IDX_TYPE] ON [bkp].[dbo__TK_CTYPE_20170207] ([TYPE])
GO