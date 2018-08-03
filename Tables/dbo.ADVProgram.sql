CREATE TABLE [dbo].[ADVProgram]
(
[ProgramID] [int] NOT NULL,
[ProgramCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProgramName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProgramGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorityPercent] [money] NULL,
[SpecialEvent] [bit] NULL,
[Inactive] [bit] NULL,
[GLAccount] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MoneyPoints] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LifetimeGiving] [bit] NULL,
[DonationValue] [money] NULL,
[Percentage] [bit] NULL,
[AvailableOnline] [bit] NULL,
[OnlineDescription] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BalanceOnline] [bit] NULL,
[AllowOnlinePayments] [bit] NULL,
[CapDriveYear] [bit] NULL,
[LoadDate] [datetime] NULL,
[UpdateDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[ADVProgram] ADD CONSTRAINT [PK_Program] PRIMARY KEY NONCLUSTERED  ([ProgramID])
GO
