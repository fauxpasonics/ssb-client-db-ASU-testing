CREATE TABLE [ods].[TM_EventsInPlan]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[plan_group_id] [int] NULL,
[plan_group_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[plan_event_id] [int] NULL,
[plan_event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[plan_total_events] [int] NULL,
[plan_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_id] [int] NULL,
[event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_Date] [datetime] NULL,
[event_time] [time] NULL,
[team] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[game_number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[total_events] [int] NULL,
[tm_event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[child_is_plan] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[season_id] [int] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__TM_EventsInPlan] ON [ods].[TM_EventsInPlan]
GO
