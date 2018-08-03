CREATE TABLE [ods].[TM_CustDonorLevel]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[acct_id] [int] NULL,
[current_drive_year] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[drive_year] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[donor_level_set_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[honorary_donor_level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[donor_level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qual_amount] [decimal] (18, 6) NULL,
[current_donor_level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[next_donor_level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[amount_to_next_donor_level] [decimal] (18, 6) NULL,
[start_date] [date] NULL,
[end_date] [date] NULL,
[original_end_date] [date] NULL,
[donor_level_set_sort] [int] NULL,
[expiration_date_override] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comments] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[is_end_date_Editable] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cust_donor_level_id] [int] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__TM_CustDonorLevel] ON [ods].[TM_CustDonorLevel]
GO
