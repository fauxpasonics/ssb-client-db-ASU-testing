CREATE TABLE [pac12].[DimPromo]
(
[DimPromoId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__DimPromo__ETL__C__65C1E23E] DEFAULT (suser_name()),
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimPromo__ETL__C__66B60677] DEFAULT (getdate()),
[ETL__StartDate] [datetime] NOT NULL CONSTRAINT [DF__DimPromo__ETL__S__67AA2AB0] DEFAULT (getdate()),
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_Promo] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_Promo_Code] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PromoCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PromoName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PromoDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PromoClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [pac12].[DimPromo] ADD CONSTRAINT [PK_DimPromo] PRIMARY KEY CLUSTERED  ([DimPromoId])
GO
