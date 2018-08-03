CREATE TABLE [pac12].[DimSalesCode]
(
[DimSalesCodeId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__DimSalesC__ETL____78D4B6B2] DEFAULT (suser_name()),
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimSalesC__ETL____79C8DAEB] DEFAULT (getdate()),
[ETL__StartDate] [datetime] NOT NULL CONSTRAINT [DF__DimSalesC__ETL____7ABCFF24] DEFAULT (getdate()),
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_SALECODE] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_Sell_Location_Id] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalesCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalesCodeName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalesCodeDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SalesCodeClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [pac12].[DimSalesCode] ADD CONSTRAINT [PK_DimSalesCode] PRIMARY KEY CLUSTERED  ([DimSalesCodeId])
GO
