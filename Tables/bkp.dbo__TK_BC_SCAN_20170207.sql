CREATE TABLE [bkp].[dbo__TK_BC_SCAN_20170207]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[BC_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[VMC] [bigint] NOT NULL,
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEQ] [bigint] NULL,
[SCAN_DATE] [datetime] NULL,
[SCAN_TYPE] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCAN_TIME] [datetime] NULL,
[SCAN_LOCATION] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCAN_CLUSTER] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCAN_GATE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCAN_RESPONSE] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCAN_OPERATOR] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SCAN_ENTRY_STATUS] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCAN_QTY] [bigint] NULL,
[ZID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [bkp].[dbo__TK_BC_SCAN_20170207] ADD CONSTRAINT [PK_TK_BC_SCAN] PRIMARY KEY CLUSTERED  ([ETLSID], [BC_ID], [VMC])
GO
CREATE NONCLUSTERED INDEX [IDX_BC_ID] ON [bkp].[dbo__TK_BC_SCAN_20170207] ([BC_ID])
GO
CREATE NONCLUSTERED INDEX [IDX_CUSTOMER] ON [bkp].[dbo__TK_BC_SCAN_20170207] ([CUSTOMER])
GO
CREATE NONCLUSTERED INDEX [IDX_SCAN_DATE] ON [bkp].[dbo__TK_BC_SCAN_20170207] ([SCAN_DATE])
GO
CREATE NONCLUSTERED INDEX [IDX_SCAN_TIME] ON [bkp].[dbo__TK_BC_SCAN_20170207] ([SCAN_TIME])
GO
CREATE NONCLUSTERED INDEX [IDX_SEASON] ON [bkp].[dbo__TK_BC_SCAN_20170207] ([SEASON])
GO
