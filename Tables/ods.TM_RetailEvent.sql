CREATE TABLE [ods].[TM_RetailEvent]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[retail_event_id] [int] NULL,
[host_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[host_event_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[host_event_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_date] [date] NULL,
[event_time] [time] NULL,
[attraction_id] [int] NULL,
[attraction_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[major_category_id] [int] NULL,
[major_category_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[minor_category_id] [int] NULL,
[minor_category_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[venue_id] [int] NULL,
[venue_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[primary_act_id] [int] NULL,
[primary_act] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[secondary_act_id] [int] NULL,
[secondary_act] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__TM_RetailEvent] ON [ods].[TM_RetailEvent]
GO
