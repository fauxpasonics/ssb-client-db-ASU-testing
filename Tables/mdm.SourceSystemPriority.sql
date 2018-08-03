CREATE TABLE [mdm].[SourceSystemPriority]
(
[ElementID] [int] NOT NULL,
[SourceSystemID] [int] NOT NULL,
[SourceSystemPriority] [int] NULL,
[DateCreated] [date] NULL CONSTRAINT [DF__SourceSys__DateC__6754599E] DEFAULT (getdate()),
[DateUpdated] [date] NULL CONSTRAINT [DF__SourceSys__DateU__68487DD7] DEFAULT (getdate())
)
GO
