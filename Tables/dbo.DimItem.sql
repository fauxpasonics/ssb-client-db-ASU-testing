CREATE TABLE [dbo].[DimItem]
(
[DimItemId] [int] NOT NULL IDENTITY(1, 1),
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
[ItemCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAC_BASIS] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAC_KEYWORDS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAC_TAG] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_season_id] [int] NULL
)
GO
ALTER TABLE [dbo].[DimItem] ADD CONSTRAINT [PK__DimItem__AC721C4BF0006C5C] PRIMARY KEY CLUSTERED  ([DimItemId])
GO
