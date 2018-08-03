CREATE TABLE [ods].[Turnkey_Models]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__Turnkey_M__ETL_C__6ADAFF5A] DEFAULT (getdate()),
[ETL_UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__Turnkey_M__ETL_U__6BCF2393] DEFAULT (getdate()),
[ETL_IsDeleted] [bit] NOT NULL CONSTRAINT [DF__Turnkey_M__ETL_I__6CC347CC] DEFAULT ((0)),
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PersonID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FootballCapacity] [int] NULL,
[FootballCapacityDate] [date] NULL,
[FootballPriority] [int] NULL,
[FootballPriorityDate] [date] NULL,
[MBBBasketballCapacity] [int] NULL,
[MBBBasketballCapacityDate] [date] NULL,
[WBBBasketballCapacity] [int] NULL,
[WBBBasketballCapacityDate] [date] NULL,
[MBBBasketballPriority] [int] NULL,
[MBBBasketballPriorityDate] [date] NULL,
[WBBBasketballPriority] [int] NULL,
[WBBBasketballPriorityDate] [date] NULL,
[TicketingSystemAccountID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AbilitecID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
