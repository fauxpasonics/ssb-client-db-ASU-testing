CREATE TABLE [pac12].[DimSeat]
(
[DimSeatId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__DimSeat__ETL__Cr__18826C35] DEFAULT (suser_name()),
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimSeat__ETL__Cr__1976906E] DEFAULT (getdate()),
[ETL__StartDate] [datetime] NOT NULL CONSTRAINT [DF__DimSeat__ETL__St__1A6AB4A7] DEFAULT (getdate()),
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_SEASON] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_LEVEL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_SECTION] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_ROW] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PacSeat] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_Manifest_Id] [int] NULL,
[ETL__SSID_Section_Id] [int] NULL,
[ETL__SSID_Row_Id] [int] NULL,
[ETL__SSID_Seat] [int] NULL,
[Season] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LevelName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SectionName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seat] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultPriceLevel] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_Location] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_dbo_DimSeat] ON [pac12].[DimSeat]
GO
