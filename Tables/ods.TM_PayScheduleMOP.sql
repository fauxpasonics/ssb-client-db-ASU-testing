CREATE TABLE [ods].[TM_PayScheduleMOP]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[payment_Schedule_id] [int] NULL,
[seq] [int] NULL,
[acct_id] [int] NULL,
[payment_plan_id] [int] NULL,
[payment_percentage] [decimal] (18, 6) NULL,
[payment_category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cc_mask] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cc_exp] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__TM_PayScheduleMOP] ON [ods].[TM_PayScheduleMOP]
GO
