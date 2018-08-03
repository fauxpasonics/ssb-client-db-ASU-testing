CREATE TABLE [ods].[TM_PaySchdPayment]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[payment_Schedule_id] [int] NULL,
[payment_number] [int] NULL,
[due_date] [datetime] NULL,
[percent_due] [decimal] (18, 6) NULL,
[payment_description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__TM_PaySchdPayment] ON [ods].[TM_PaySchdPayment]
GO
