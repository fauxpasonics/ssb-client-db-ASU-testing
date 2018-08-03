CREATE TABLE [stg].[Turnkey_Models]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__Turnkey_M__ETL_C__6EAB903E] DEFAULT (getdate()),
[ETL_FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PersonID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FootballCapacity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FootballCapacityDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FootballPriority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FootballPriorityDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBBBasketballCapacity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBBBasketballCapacityDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WBBBasketballCapacity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WBBBasketballCapacityDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBBBasketballPriority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MBBBasketballPriorityDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WBBBasketballPriority] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WBBBasketballPriorityDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketingSystemAccountID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AbilitecID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
