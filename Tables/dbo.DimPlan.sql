CREATE TABLE [dbo].[DimPlan]
(
[DimPlanId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__StartDate] [datetime] NOT NULL,
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_PAC_SEASON] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_ITEM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_TM_event_id] [int] NULL,
[PlanCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanFSE] [decimal] (18, 6) NULL,
[PlanType] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanEventCnt] [int] NULL,
[Config_PlanTicketType] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_PlanName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_PlanRenewableFSE] [decimal] (18, 6) NULL,
[Config_PlanRenewableDimEventId] [int] NULL
)
GO
ALTER TABLE [dbo].[DimPlan] ADD CONSTRAINT [PK__DimPlan__D90F61A4F0A74236] PRIMARY KEY CLUSTERED  ([DimPlanId])
GO
