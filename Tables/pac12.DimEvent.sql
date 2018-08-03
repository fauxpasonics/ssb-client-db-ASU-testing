CREATE TABLE [pac12].[DimEvent]
(
[DimEventId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__DimEvent__ETL__C__3DB3F0E4] DEFAULT (suser_name()),
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimEvent__ETL__C__3EA8151D] DEFAULT (getdate()),
[ETL__StartDate] [datetime] NOT NULL CONSTRAINT [DF__DimEvent__ETL__S__3F9C3956] DEFAULT (getdate()),
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_SEASON] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_EVENT] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_Event_id] [int] NULL,
[EventCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Arena] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventDate] [date] NULL,
[EventTime] [time] NULL,
[EventDateTime] [datetime] NULL,
[EType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Basis] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EGroup] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Keywords] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tag] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ManifestId] [int] NULL
)
GO
ALTER TABLE [pac12].[DimEvent] ADD CONSTRAINT [PK_DimEvent] PRIMARY KEY CLUSTERED  ([DimEventId])
GO
