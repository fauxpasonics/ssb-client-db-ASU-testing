CREATE TABLE [dbo].[DimEvent_V2]
(
[DimEventId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__UpdatedDate] [datetime] NOT NULL,
[ETL__IsDeleted] [bit] NOT NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[TM_minor_category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventStatus] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_retail_event_id] [int] NULL,
[TM_host_event_id] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_host_event_code] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_Category1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_Category2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_Category3] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_Category4] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_Category5] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventOpenDateTime] [datetime] NULL,
[EventCloseDateTime] [datetime] NULL,
[Config_EventDateTime] [datetime] NULL,
[Config_EventOnSaleDateTime] [datetime] NULL,
[Config_IsRealtimeAttendanceEnabled] [bit] NULL,
[Config_EventOpenDateTime] [datetime] NULL,
[Config_EventCloseDateTime] [datetime] NULL,
[Config_Capacity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_IsFseEligible] [bit] NULL,
[EventType] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_IsFactInventoryEligible] [bit] NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[UpdatedDate] [datetime] NULL,
[Custom_Int_1] [int] NULL,
[Custom_Int_2] [int] NULL,
[Custom_Int_3] [int] NULL,
[Custom_Int_4] [int] NULL,
[Custom_Int_5] [int] NULL,
[Custom_Dec_1] [decimal] (18, 6) NULL,
[Custom_Dec_2] [decimal] (18, 6) NULL,
[Custom_Dec_3] [decimal] (18, 6) NULL,
[Custom_Dec_4] [decimal] (18, 6) NULL,
[Custom_Dec_5] [decimal] (18, 6) NULL,
[Custom_DateTime_1] [datetime] NULL,
[Custom_DateTime_2] [datetime] NULL,
[Custom_DateTime_3] [datetime] NULL,
[Custom_DateTime_4] [datetime] NULL,
[Custom_DateTime_5] [datetime] NULL,
[Custom_Bit_1] [bit] NULL,
[Custom_Bit_2] [bit] NULL,
[Custom_Bit_3] [bit] NULL,
[Custom_Bit_4] [bit] NULL,
[Custom_Bit_5] [bit] NULL,
[Custom_nVarChar_1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom_nVarChar_2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom_nVarChar_3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom_nVarChar_4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom_nVarChar_5] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_Team] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_event_name_long] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM__host_event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_event_report_group] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_plan_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_Event_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_plan_abv] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_Enabled] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_Returnable] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_Barcode_Status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_Print_Ticket_Ind] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_exchange_price_opt] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimEventHeaderId] [int] NULL,
[DimArenaId] [int] NULL,
[DimSeasonId] [int] NULL
)
GO
ALTER TABLE [dbo].[DimEvent_V2] ADD CONSTRAINT [PK_dbo__DimEvent_V2] PRIMARY KEY CLUSTERED  ([DimEventId])
GO
CREATE NONCLUSTERED INDEX [IX_Config_EventCloseDateTime] ON [dbo].[DimEvent_V2] ([Config_EventCloseDateTime] DESC)
GO
CREATE NONCLUSTERED INDEX [IX_Config_EventOpenDateTime] ON [dbo].[DimEvent_V2] ([Config_EventOpenDateTime] DESC)
GO
CREATE NONCLUSTERED INDEX [IX_ETL__IsDeleted] ON [dbo].[DimEvent_V2] ([ETL__IsDeleted])
GO
CREATE NONCLUSTERED INDEX [IX_ETL__SourceSystem] ON [dbo].[DimEvent_V2] ([ETL__SourceSystem])
GO
CREATE NONCLUSTERED INDEX [IX_KEY_PAC] ON [dbo].[DimEvent_V2] ([ETL__SSID_PAC_SEASON], [ETL__SSID_PAC_EVENT])
GO
CREATE NONCLUSTERED INDEX [IX_KEY_TM] ON [dbo].[DimEvent_V2] ([ETL__SSID_TM_event_id])
GO
CREATE NONCLUSTERED INDEX [IX_ETL__UpdatedDate] ON [dbo].[DimEvent_V2] ([ETL__UpdatedDate] DESC)
GO
CREATE NONCLUSTERED INDEX [IX_EventCloseDateTime] ON [dbo].[DimEvent_V2] ([EventCloseDateTime] DESC)
GO
CREATE NONCLUSTERED INDEX [IX_EventCode] ON [dbo].[DimEvent_V2] ([EventCode])
GO
CREATE NONCLUSTERED INDEX [IX_EventDate] ON [dbo].[DimEvent_V2] ([EventDate] DESC)
GO
CREATE NONCLUSTERED INDEX [IX_EventDateTime] ON [dbo].[DimEvent_V2] ([EventDateTime] DESC)
GO
CREATE NONCLUSTERED INDEX [IX_EventOpenDateTime] ON [dbo].[DimEvent_V2] ([EventOpenDateTime] DESC)
GO
