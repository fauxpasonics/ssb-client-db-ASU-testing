CREATE TABLE [dbo].[DimEvent]
(
[DimEventId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__StartDate] [datetime] NOT NULL,
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__SSID_PAC_SEASON] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_EVENT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_TM_event_id] [int] NULL,
[EventCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventDate] [date] NULL,
[EventTime] [time] NULL,
[EventDateTime] [datetime] NULL,
[EventOnSaleDateTime] [datetime] NULL,
[Arena] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAC_ETYPE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAC_BASIS] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAC_EGROUP] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAC_KEYWORDS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAC_Tag] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_manifest_id] [int] NULL,
[TM_arena_id] [int] NULL,
[TM_season_id] [int] NULL,
[TM_major_category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_minor_category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[DimEvent] ADD CONSTRAINT [PK__DimEvent__6C32B4EA0667D148] PRIMARY KEY CLUSTERED  ([DimEventId])
GO
