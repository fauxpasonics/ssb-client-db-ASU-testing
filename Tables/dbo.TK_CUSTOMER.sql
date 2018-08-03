CREATE TABLE [dbo].[TK_CUSTOMER]
(
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[M_ADTYPE] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[B_ADTYPE] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SEASONS] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMMENTS] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_PRIORITY] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TYPE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[DEPARTMENT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SG_NUMBER] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATUS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[AR_NUMBER] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BALANCE] [numeric] (18, 2) NULL,
[EXTERNAL_NUMBER] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TAGS] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BASIS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[MP_ACCESS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD1] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD2] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD3] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD4] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD5] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD6] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD7] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD8] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_USER] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[LAST_DATETIME] [datetime] NULL,
[ZID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[ETL_Sync_DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [dbo].[TK_CUSTOMER] ADD CONSTRAINT [PK_TK_CUSTOMER] PRIMARY KEY CLUSTERED  ([ETLSID], [CUSTOMER])
GO
CREATE NONCLUSTERED INDEX [IDX_CUSTOMER] ON [dbo].[TK_CUSTOMER] ([CUSTOMER])
GO
