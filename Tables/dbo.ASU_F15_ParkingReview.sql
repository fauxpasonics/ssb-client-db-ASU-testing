CREATE TABLE [dbo].[ASU_F15_ParkingReview]
(
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ITEM] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[I_PT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[I_PL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[I_MARK] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[SeatBlock] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LEVEL] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Section] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Row] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seat] [bigint] NULL,
[TicketPrice] [numeric] (18, 2) NULL,
[DonationAmount] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL
)
GO
