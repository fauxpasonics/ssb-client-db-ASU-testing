CREATE TABLE [pac12].[DimSeatStatus]
(
[DimSeatStatusId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__DimSeatSt__ETL____342A86AA] DEFAULT (suser_name()),
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimSeatSt__ETL____351EAAE3] DEFAULT (getdate()),
[ETL__StartDate] [datetime] NOT NULL CONSTRAINT [DF__DimSeatSt__ETL____3612CF1C] DEFAULT (getdate()),
[ETL__EndDate] [datetime] NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_SEASON] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_SSTAT] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SeatStatusCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeatStatusName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeatStatusDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeatStatusClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsKill] [bit] NOT NULL,
[Season] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [pac12].[DimSeatStatus] ADD CONSTRAINT [PK__DimSeatS__CC2366CD95CD2C97] PRIMARY KEY CLUSTERED  ([DimSeatStatusId])
GO
