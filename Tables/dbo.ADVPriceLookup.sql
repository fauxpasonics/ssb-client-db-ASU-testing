CREATE TABLE [dbo].[ADVPriceLookup]
(
[Season] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PriceType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PriceLevel] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Pledge] [numeric] (18, 2) NOT NULL
)
GO
