CREATE TABLE [dbo].[SFMC_TicketHistory]
(
[EmailAddress] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactID] [varchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeasonCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceLevel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ItemQuantity] [int] NULL,
[OrderID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PacID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eVenuePIN] [bigint] NULL,
[LinkedStatus] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
