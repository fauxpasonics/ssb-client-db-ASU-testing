CREATE TABLE [dbo].[FactInventory]
(
[FactInventoryId] [bigint] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__FactInven__ETL____473D5B1E] DEFAULT (suser_name()),
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__FactInven__ETL____48317F57] DEFAULT (getdate()),
[ETL__UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__FactInven__ETL____4925A390] DEFAULT (getdate()),
[DimArenaId] [int] NOT NULL,
[DimSeasonId] [int] NOT NULL,
[DimEventId] [int] NOT NULL,
[DimSeatId] [int] NOT NULL,
[DimSeatStatusid] [int] NOT NULL,
[SeatPrice] [decimal] (18, 6) NULL,
[IsAttended] [bit] NOT NULL,
[ScanDateTime] [datetime] NULL,
[ScanGate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsResold] [int] NULL,
[ResoldDimCustomerId] [int] NULL,
[ResoldDateTime] [datetime] NULL,
[ResoldPrice] [decimal] (18, 6) NULL,
[FactTicketSalesId] [bigint] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_dbo_FactInventory] ON [dbo].[FactInventory]
GO
