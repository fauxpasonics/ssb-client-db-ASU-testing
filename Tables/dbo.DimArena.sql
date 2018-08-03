CREATE TABLE [dbo].[DimArena]
(
[DimArenaId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__StartDate] [datetime] NOT NULL,
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_PAC_FACILITY] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_TM_arena_id] [int] NULL,
[ArenaCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ArenaName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ArenaDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ArenaClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[DimArena] ADD CONSTRAINT [PK__DimArena__B14B509D71D884D9] PRIMARY KEY CLUSTERED  ([DimArenaId])
GO
