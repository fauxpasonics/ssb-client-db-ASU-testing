CREATE TABLE [qa].[ASU_MB_2018]
(
[ETL__ID] [bigint] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[acct_id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[owner_name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[plan_event_name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seat_num] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_seat] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[num_seats] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price_code] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ticket_type] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ticket_type_category] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current_purchase_price] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current_block_purchase_price] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original_purchase_price] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original_block_purchase_price] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[full_price] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[block_full_price] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original_total_events] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original_fse] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original_fse_total] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paid_amount] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[owed_amount] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flex_plan_purchase] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[printed] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comp] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comp_name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current_total_events] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[current_fse_total] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original_acct_rep_id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original_acct_rep_full_name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_rep_id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_rep_full_name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sell_location] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[order_num] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[order_line_item] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[order_line_item_seq] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ledger_code] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[renewal_ind] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paid] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[payment_plan_name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_usr] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_datetime] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_user] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_datetime] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [qa].[ASU_MB_2018] ADD CONSTRAINT [PK__ASU_MB_2__C4EA2445B77BCAF3] PRIMARY KEY CLUSTERED  ([ETL__ID])
GO