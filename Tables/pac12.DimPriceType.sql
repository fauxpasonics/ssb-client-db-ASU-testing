CREATE TABLE [pac12].[DimPriceType]
(
[DimPriceTypeId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__DimPriceT__ETL____60FD2D21] DEFAULT (suser_name()),
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimPriceT__ETL____61F1515A] DEFAULT (getdate()),
[ETL__StartDate] [datetime] NOT NULL CONSTRAINT [DF__DimPriceT__ETL____62E57593] DEFAULT (getdate()),
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_SEASON] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PRTYPE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[PriceTypeCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceTypeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceTypeDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceTypeClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Kind] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [pac12].[DimPriceType] ADD CONSTRAINT [PK_DimPriceType] PRIMARY KEY CLUSTERED  ([DimPriceTypeId])
GO
