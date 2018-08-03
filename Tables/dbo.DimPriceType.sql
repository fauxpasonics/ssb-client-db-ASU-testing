CREATE TABLE [dbo].[DimPriceType]
(
[DimPriceTypeId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__StartDate] [datetime] NOT NULL,
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_PAC_SEASON] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_PRTYPE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[PriceTypeCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceTypeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceTypeDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceTypeClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Kind] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[DimPriceType] ADD CONSTRAINT [PK__DimPrice__1214958B9B9DD1DA] PRIMARY KEY CLUSTERED  ([DimPriceTypeId])
GO
