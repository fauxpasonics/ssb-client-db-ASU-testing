CREATE TABLE [ods].[TM_AttendApi]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NULL,
[ETL__UpdatedDate] [datetime] NULL,
[ETL_Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[event_id] [int] NULL,
[event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_date] [date] NULL,
[section_id] [int] NULL,
[section_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_id] [int] NULL,
[row_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seat_num] [int] NULL,
[acct_id] [int] NULL,
[plan_event_Id] [int] NULL,
[plan_event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[print_count] [int] NULL,
[ticket_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scan_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[result_code] [int] NULL,
[action_time] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comp] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[result_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[valid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ticket_acct_id] [int] NULL,
[source_system] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[access_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[channel_ind] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mobile] [bit] NULL,
[upd_datetime] [datetime] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__TM_AttendApi] ON [ods].[TM_AttendApi]
GO
