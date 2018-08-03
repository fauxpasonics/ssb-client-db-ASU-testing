CREATE TABLE [dbo].[DimTicketClass]
(
[DimTicketClassId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__DimTicket__ETL____2117B236] DEFAULT (suser_name()),
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimTicket__ETL____220BD66F] DEFAULT (getdate()),
[ETL__StartDate] [datetime] NOT NULL CONSTRAINT [DF__DimTicket__ETL____22FFFAA8] DEFAULT (getdate()),
[ETL__EndDate] [datetime] NULL,
[TicketClassCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketClassName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketClassDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[DimTicketClass] ADD CONSTRAINT [PK_DimTicketClass] PRIMARY KEY CLUSTERED  ([DimTicketClassId])
GO
