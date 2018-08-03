CREATE TABLE [dbo].[DimPriceCode]
(
[DimPriceCodeId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__StartDate] [datetime] NOT NULL,
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_TM_event_id] [int] NULL,
[ETL__SSID_TM_price_code] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceCodeName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceCodeDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceCodeClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PC1] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PC2] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PC3] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PC4] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceCodeGroup] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FullPrice] [decimal] (18, 6) NULL
)
GO
ALTER TABLE [dbo].[DimPriceCode] ADD CONSTRAINT [PK__DimPrice__ADAC66CD7A417BCC] PRIMARY KEY CLUSTERED  ([DimPriceCodeId])
GO
