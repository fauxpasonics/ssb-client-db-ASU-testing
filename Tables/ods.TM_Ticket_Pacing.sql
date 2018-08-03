CREATE TABLE [ods].[TM_Ticket_Pacing]
(
[ETL_ID] [bigint] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_BusinessKey] [binary] (32) NOT NULL,
[ETL_DeltaType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[acct_id] [bigint] NOT NULL,
[acct_Rep_id] [bigint] NULL,
[orig_acct_rep_id] [bigint] NULL,
[event_id] [int] NOT NULL,
[plan_event_id] [int] NOT NULL,
[price_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sell_location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ledger_id] [int] NULL,
[class_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tran_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pricing_method] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comp_code] [int] NULL,
[section_id] [int] NOT NULL,
[row_id] [int] NOT NULL,
[seat_num] [int] NOT NULL,
[num_seats] [int] NOT NULL,
[block_purchase_price] [decimal] (18, 6) NOT NULL
)
GO
ALTER TABLE [ods].[TM_Ticket_Pacing] ADD CONSTRAINT [PK_TM_Ticket_Pacing] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
CREATE NONCLUSTERED INDEX [IDX_ETL_BusinessKey] ON [ods].[TM_Ticket_Pacing] ([ETL_BusinessKey])
GO
