CREATE TABLE [bkp].[dbo__TK_CUSTOMER_20170207]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[M_ADTYPE] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[B_ADTYPE] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SEASONS] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMMENTS] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_PRIORITY] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TYPE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[STATUS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[BALANCE] [numeric] (18, 2) NULL,
[EXTERNAL_NUMBER] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TAGS] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BASIS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[MP_ACCESS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD1] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD2] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD3] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD4] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD5] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD6] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD7] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD8] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_USER] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[LAST_DATETIME] [datetime] NULL,
[ZID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [bkp].[dbo__TK_CUSTOMER_20170207] ADD CONSTRAINT [PK_TK_CUSTOMER_3d681065-10d0-400b-b8ff-48ff6c8f13b9] PRIMARY KEY CLUSTERED  ([ETLSID], [CUSTOMER])
GO
CREATE NONCLUSTERED INDEX [IDX_CUSTOMER] ON [bkp].[dbo__TK_CUSTOMER_20170207] ([CUSTOMER])
GO
