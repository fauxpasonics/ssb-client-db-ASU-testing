CREATE TABLE [dbo].[DimPromo]
(
[DimPromoId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__StartDate] [datetime] NOT NULL,
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_PAC_PROMO] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_TM_promo_code] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PromoCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PromoName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PromoDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PromoClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[DimPromo] ADD CONSTRAINT [PK__DimPromo__7553AA8F92ECEE58] PRIMARY KEY CLUSTERED  ([DimPromoId])
GO
