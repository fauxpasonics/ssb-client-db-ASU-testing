CREATE TABLE [stg].[TM_CustDonorLevel]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NULL,
[ETL__Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current_drive_year] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[drive_year] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[donor_level_set_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[honorary_donor_level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[donor_level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qual_amount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current_donor_level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[next_donor_level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[amount_to_next_donor_level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[start_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[end_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original_end_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[donor_level_set_sort] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[expiration_date_override] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comments] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[is_end_date_Editable] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cust_donor_level_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seq_num] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
