CREATE TABLE [ods].[Snapshot_TM_CustomerUpdate_After]
(
[TM_CustomerUpdate_AfterSK] [int] NOT NULL IDENTITY(1, 1),
[multi_query_value_for_audit] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountId] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_id] [int] NULL,
[cust_name_id] [int] NULL,
[rec_status] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[company_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_first] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_mi] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_last] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[title] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[street_addr_1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[street_addr_2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[country] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_day] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_eve] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_fax] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_cell] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[priority] [int] NULL,
[points_YTD] [decimal] (18, 2) NULL,
[points_ITD] [decimal] (18, 2) NULL,
[email] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_date] [date] NULL,
[name_type] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[owner_name] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[birth_date] [date] NULL,
[gender] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_3] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_4] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_5] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_6] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_7] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_8] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_9] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_10] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rank] [int] NULL,
[text_on_mobile_phone] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[total_donation_amount] [decimal] (18, 2) NULL,
[ITD_donations] [decimal] (18, 2) NULL,
[honorary_donor] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_access_level] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qualified_donation_amount] [decimal] (18, 2) NULL,
[phone_day_do_not_solicit] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_eve_do_not_solicit] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_cell_do_not_solicit] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_fax_do_not_solicit] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email_deliv_opt] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email_optout] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[logon_attempts] [int] NULL,
[result] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[change_pin] [int] NULL,
[account_id_list] [int] NULL,
[sql_code] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cmd] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedOn] [datetime] NULL,
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_UpdatedOn] [datetime] NULL,
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordEndDate] [datetime] NULL
)
GO
ALTER TABLE [ods].[Snapshot_TM_CustomerUpdate_After] ADD CONSTRAINT [PK__Snapshot__556BE72C59DBE171] PRIMARY KEY CLUSTERED  ([TM_CustomerUpdate_AfterSK])
GO
