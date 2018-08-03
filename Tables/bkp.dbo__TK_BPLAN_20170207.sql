CREATE TABLE [bkp].[dbo__TK_BPLAN_20170207]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BPTYPE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[VMC] [bigint] NOT NULL,
[BDATE] [datetime] NULL,
[BPERCENT] [numeric] (18, 4) NULL,
[BAMT] [numeric] (18, 2) NULL,
[INV] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_USER] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[LAST_DATETIME] [datetime] NULL,
[ZID] [varchar] (53) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [bkp].[dbo__TK_BPLAN_20170207] ADD CONSTRAINT [PK_TK_BPLAN_3930343a-d044-482d-bf2a-0edaf2cbb56b] PRIMARY KEY CLUSTERED  ([ETLSID], [SEASON], [CUSTOMER], [BPTYPE], [VMC])
GO
