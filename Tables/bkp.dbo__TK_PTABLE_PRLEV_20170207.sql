CREATE TABLE [bkp].[dbo__TK_PTABLE_PRLEV_20170207]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[PTABLE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[PL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[PL_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZID] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [bkp].[dbo__TK_PTABLE_PRLEV_20170207] ADD CONSTRAINT [PK_TK_PTABLE_PRLEV_b42a91a8-4c47-497d-970d-156e08c22862] PRIMARY KEY CLUSTERED  ([ETLSID], [SEASON], [PTABLE], [PL])
GO
