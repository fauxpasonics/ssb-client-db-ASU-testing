CREATE TABLE [dbo].[FactTicketActivity_V2]
(
[FactTicketActivityId] [bigint] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__UpdatedDate] [datetime] NOT NULL,
[ETL__IsDeleted] [bit] NOT NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__SSID_TM_ods_id] [int] NULL,
[ETL__SSID_TM_activity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_TM_event_id] [int] NULL,
[ETL__SSID_TM_section_id] [int] NULL,
[ETL__SSID_TM_row_id] [int] NULL,
[ETL__SSID_TM_seat_num] [int] NULL,
[ETL__SSID_TM_num_seats] [int] NULL,
[ETL__SSID_TM_add_datetime] [datetime] NULL,
[DimDateId] [int] NOT NULL,
[DimTimeId] [int] NOT NULL,
[DimArenaId] [int] NOT NULL,
[DimSeasonId] [int] NOT NULL,
[DimItemId] [int] NOT NULL,
[DimEventId] [int] NOT NULL,
[DimPlanId] [int] NOT NULL,
[DimSeatId_Start] [int] NOT NULL,
[DimTicketCustomerId] [bigint] NOT NULL,
[DimTicketCustomerId_Recipient] [bigint] NOT NULL,
[DimActivityId] [int] NOT NULL,
[TransDateTime] [datetime] NULL,
[QtySeat] [int] NULL,
[SubTotal] [decimal] (18, 6) NULL,
[Fees] [decimal] (18, 6) NULL,
[Taxes] [decimal] (18, 6) NULL,
[Total] [decimal] (18, 6) NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[UpdatedDate] [datetime] NULL,
[TM_order_num] [bigint] NULL,
[TM_order_line_item] [bigint] NULL,
[TM_order_line_item_seq] [int] NULL,
[TM_forward_to_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_forward_to_email_addr] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_Orig_purchase_price] [decimal] (18, 6) NULL,
[TM_te_seller_credit_amount] [decimal] (18, 6) NULL,
[TM_te_seller_fees] [decimal] (18, 6) NULL,
[TM_te_posting_price] [decimal] (18, 6) NULL,
[TM_te_buyer_fees_hidden] [decimal] (18, 6) NULL,
[TM_te_purchase_price] [decimal] (18, 6) NULL,
[TM_te_buyer_fees_not_hidden] [decimal] (18, 6) NULL,
[TM_inet_delivery_fee] [decimal] (18, 6) NULL,
[TM_inet_transaction_amount] [decimal] (18, 6) NULL,
[TM_delivery_method] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_activity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_activity_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[FactTicketActivity_V2] ADD CONSTRAINT [PK_dbo__FactTicketActivity_V2] PRIMARY KEY CLUSTERED  ([FactTicketActivityId])
GO
CREATE NONCLUSTERED INDEX [IX_DimEventId] ON [dbo].[FactTicketActivity_V2] ([DimEventId])
GO
CREATE NONCLUSTERED INDEX [IX_DimSeatId_Start] ON [dbo].[FactTicketActivity_V2] ([DimSeatId_Start])
GO
CREATE NONCLUSTERED INDEX [IX_ETL__IsDeleted] ON [dbo].[FactTicketActivity_V2] ([ETL__IsDeleted])
GO
CREATE NONCLUSTERED INDEX [IX_ETL__SourceSystem] ON [dbo].[FactTicketActivity_V2] ([ETL__SourceSystem])
GO
CREATE NONCLUSTERED INDEX [IX_TM_Key] ON [dbo].[FactTicketActivity_V2] ([ETL__SSID_TM_ods_id] DESC)
GO
CREATE NONCLUSTERED INDEX [IX_ETL__UpdatedDate] ON [dbo].[FactTicketActivity_V2] ([ETL__UpdatedDate] DESC)
GO
