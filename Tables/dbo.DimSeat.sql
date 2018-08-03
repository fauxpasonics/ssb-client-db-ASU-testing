CREATE TABLE [dbo].[DimSeat]
(
[DimSeatId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__StartDate] [datetime] NOT NULL,
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_PAC_SEASON] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_LEVEL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_SECTION] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_ROW] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_SEAT] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_TM_manifest_id] [int] NULL,
[ETL__SSID_TM_section_id] [int] NULL,
[ETL__SSID_TM_row_id] [int] NULL,
[ETL__SSID_TM_seat] [int] NULL,
[Season] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LevelName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SectionName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seat] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultPriceLevel] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_Location] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultClass] [int] NULL,
[DefaultPriceCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SortOrderLevel] [int] NULL,
[SortOrderSection] [int] NULL,
[SortOrderRow] [int] NULL,
[SortOrderSeat] [int] NULL
)
GO
ALTER TABLE [dbo].[DimSeat] ADD CONSTRAINT [PK__DimSeat__B9D7CB98A414AB5A] PRIMARY KEY CLUSTERED  ([DimSeatId])
GO
CREATE NONCLUSTERED INDEX [IDX_ETL__EndDate] ON [dbo].[DimSeat] ([ETL__EndDate])
GO
CREATE NONCLUSTERED INDEX [IDX_LoadKeyTM] ON [dbo].[DimSeat] ([ETL__SSID_TM_manifest_id], [ETL__SSID_TM_section_id], [ETL__SSID_TM_row_id], [ETL__SSID_TM_seat])
GO
