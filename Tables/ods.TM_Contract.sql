CREATE TABLE [ods].[TM_Contract]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[contract_id] [int] NULL,
[acct_id] [int] NULL,
[date_offered] [date] NULL,
[date_signed] [date] NULL,
[date_countersigned] [date] NULL,
[start_date] [date] NULL,
[end_date] [date] NULL,
[term] [int] NULL,
[add_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_datetime] [datetime] NULL,
[upd_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_datetime] [datetime] NULL,
[description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__TM_Contract] ON [ods].[TM_Contract]
GO
