CREATE TABLE [pac12].[DimPriceCode]
(
[DimPriceCodeId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__DimPriceC__ETL____5773C2E7] DEFAULT (suser_name()),
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimPriceC__ETL____5867E720] DEFAULT (getdate()),
[ETL__StartDate] [datetime] NOT NULL CONSTRAINT [DF__DimPriceC__ETL____595C0B59] DEFAULT (getdate()),
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_Event_id] [int] NULL,
[ETL__SSID_Price_Code] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[PriceCodeGroup] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [pac12].[DimPriceCode] ADD CONSTRAINT [PK_DimPriceCode] PRIMARY KEY CLUSTERED  ([DimPriceCodeId])
GO
