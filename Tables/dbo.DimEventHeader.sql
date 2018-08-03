CREATE TABLE [dbo].[DimEventHeader]
(
[DimEventHeaderId] [int] NOT NULL IDENTITY(1, 1),
[DimArenaId] [int] NOT NULL,
[DimSeasonHeaderId] [int] NOT NULL,
[OpponentDimTeamId] [int] NOT NULL,
[DimGameInfoId] [int] NOT NULL,
[EventName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventDesc] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventHierarchyL1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventHierarchyL2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventHierarchyL3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventHierarchyL4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventHierarchyL5] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventDate] [date] NULL,
[EventTime] [time] NULL,
[EventDateTime] [datetime] NULL,
[EventOpenTime] [datetime] NULL,
[EventFinishTime] [datetime] NULL,
[EventSeasonNumber] [int] NULL,
[HomeGameNumber] [int] NULL,
[GameNumber] [int] NULL,
[IsSportingEvent] [bit] NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimEventH__Creat__6A86975B] DEFAULT (getdate()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimEventH__Updat__6B7ABB94] DEFAULT (getdate()),
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF__DimEventH__IsDel__6C6EDFCD] DEFAULT ((0)),
[DeleteDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[DimEventHeader] ADD CONSTRAINT [PK_DimEventHeader] PRIMARY KEY CLUSTERED  ([DimEventHeaderId])
GO
