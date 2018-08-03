CREATE TYPE [dbo].[SingleSummary] AS TABLE
(
[eventCode] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eventName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eventDate] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[visitingTicketQty] [bigint] NULL,
[visitingTicketAmt] [numeric] (18, 2) NULL,
[studentTicketQty] [bigint] NULL,
[studentTicketAmt] [numeric] (18, 2) NULL,
[groupTicketQty] [bigint] NULL,
[groupTicketAmt] [numeric] (18, 2) NULL,
[suiteTicketQty] [bigint] NULL,
[suiteTicketAmt] [numeric] (18, 2) NULL,
[publicTicketQty] [bigint] NULL,
[publicTicketAmt] [numeric] (18, 2) NULL,
[budgetedQuantity] [bigint] NULL,
[budgetedAmount] [numeric] (18, 2) NULL,
[TotalTickets] [bigint] NULL,
[TotalRevenue] [numeric] (18, 2) NULL,
[PercentToGoal] [numeric] (18, 2) NULL,
[VarianceToGoal] [numeric] (18, 2) NULL
)
GO
