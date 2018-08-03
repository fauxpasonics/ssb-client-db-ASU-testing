CREATE TABLE [ods].[TM_PaySchedule]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[acct_id] [int] NULL,
[payment_schedule_id] [int] NULL,
[invoice_id] [int] NULL,
[payment_plan_id] [int] NULL,
[comments] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_datetime] [datetime] NULL,
[payment_plan_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[periods] [int] NULL,
[last_period_paid] [int] NULL,
[purchase_amount] [decimal] (18, 6) NULL,
[paid_amount] [decimal] (18, 6) NULL,
[percent_due] [decimal] (18, 6) NULL,
[percent_paid] [decimal] (18, 6) NULL,
[compliant] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoice_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[effective_Date] [datetime] NULL,
[expiration_date] [datetime] NULL,
[inet_effective_Date] [datetime] NULL,
[inet_expiration_Date] [datetime] NULL,
[inet_plan_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[payment_plan_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_payment_number] [int] NULL,
[period_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[start_date] [datetime] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__TM_PaySchedule] ON [ods].[TM_PaySchedule]
GO
