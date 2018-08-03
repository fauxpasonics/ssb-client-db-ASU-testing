CREATE TABLE [ods].[TM_PromoCode]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[promo_code_id] [int] NULL,
[promo_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_code_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_id] [bigint] NULL,
[promo_inet_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_inet_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_group_sell_flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[promo_active_flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[inet_start_datetime] [datetime] NULL,
[inet_end_datetime] [datetime] NULL,
[archtics_start_datetime] [datetime] NULL,
[archtics_end_datetime] [datetime] NULL,
[event_id] [int] NULL,
[event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tm_event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_Datetime] [datetime] NULL,
[upd_datetime] [datetime] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__TM_PromoCode] ON [ods].[TM_PromoCode]
GO
