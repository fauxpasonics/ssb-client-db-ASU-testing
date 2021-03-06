CREATE TABLE [bkp].[dbo__SYS_ZIP_20170207]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SYS_ZIP] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[CSZ] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_USER] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[LAST_DATETIME] [datetime] NULL,
[ZID] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [bkp].[dbo__SYS_ZIP_20170207] ADD CONSTRAINT [PK_SYS_ZIP_192496bf-6e72-4d82-bccb-03fb1cfe5f81] PRIMARY KEY CLUSTERED  ([ETLSID], [SYS_ZIP])
GO
