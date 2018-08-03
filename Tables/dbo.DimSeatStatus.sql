CREATE TABLE [dbo].[DimSeatStatus]
(
[DimSeatStatusId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__DimSeatSt__ETL____342A86AA] DEFAULT (suser_name()),
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimSeatSt__ETL____351EAAE3] DEFAULT (getdate()),
[ETL__StartDate] [datetime] NOT NULL CONSTRAINT [DF__DimSeatSt__ETL____3612CF1C] DEFAULT (getdate()),
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_PAC_SEASON] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_SSTAT] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_TM_class_id] [int] NULL,
[SeatStatusCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeatStatusName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeatStatusDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeatStatusClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsKill] [bit] NULL,
[Season] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsCustomStatus] [bit] NULL
)
GO
ALTER TABLE [dbo].[DimSeatStatus] ADD CONSTRAINT [PK__DimSeatS__CC2366CDADEC4D31] PRIMARY KEY CLUSTERED  ([DimSeatStatusId])
GO
