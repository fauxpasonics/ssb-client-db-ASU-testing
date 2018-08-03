CREATE TABLE [pac12].[DimPlan]
(
[DimPlanId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__DimPlan__ETL__Cr__38EF3BC7] DEFAULT (suser_name()),
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimPlan__ETL__Cr__39E36000] DEFAULT (getdate()),
[ETL__StartDate] [datetime] NOT NULL CONSTRAINT [DF__DimPlan__ETL__St__3AD78439] DEFAULT (getdate()),
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_SEASON] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_ITEM] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_Event_id] [int] NULL,
[PlanCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanFSE] [decimal] (18, 6) NULL,
[PlanType] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PlanEventCnt] [int] NULL,
[Config_PlanTicketType] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_PlanName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_PlanRenewableFSE] [decimal] (18, 6) NULL,
[Config_PlanRenewableDimEventId] [int] NULL
)
GO
ALTER TABLE [pac12].[DimPlan] ADD CONSTRAINT [PK_DimPlan] PRIMARY KEY CLUSTERED  ([DimPlanId])
GO
