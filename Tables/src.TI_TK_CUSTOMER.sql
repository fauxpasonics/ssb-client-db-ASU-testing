CREATE TABLE [src].[TI_TK_CUSTOMER]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETLSID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZID] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOURCE_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPORT_DATETIME] [datetime] NULL,
[LAST_USER] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_DATETIME] [datetime] NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[M_ADTYPE] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[B_ADTYPE] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEASONS] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[COMMENTS] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[C_PRIORITY] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TYPE] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STATUS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BALANCE] [numeric] (18, 2) NULL,
[EXTERNAL_NUMBER] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TAGS] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BASIS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MP_ACCESS] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD1] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD2] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD3] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD4] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD5] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD6] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD7] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UD8] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [src].[TI_TK_CUSTOMER] ADD CONSTRAINT [PK__TI_TK_CU__7EF6BFCD747A81F6] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
