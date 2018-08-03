CREATE TABLE [src].[Sync_TI_PD_ADDRESS]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[PATRON] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ADTYPE] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[MAIL_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDR1] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDR2] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDR3] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDR4] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SYS_ZIP] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[COUNTRY] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ORG] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[BUS_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUS_POSITION] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DATE_FROM] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DATE_TO] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_USER] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[LAST_DATETIME] [datetime] NULL,
[ZID] [varchar] (37) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_Id] [int] NOT NULL IDENTITY(1, 1)
)
GO
ALTER TABLE [src].[Sync_TI_PD_ADDRESS] ADD CONSTRAINT [PK__Sync_TI___19364FD23F080D21] PRIMARY KEY CLUSTERED  ([ETL_Sync_Id])
GO
