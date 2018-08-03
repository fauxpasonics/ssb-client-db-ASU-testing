CREATE TABLE [mdm].[CompositeExclusions]
(
[ElementID] [int] NOT NULL,
[ExclusionID] [int] NOT NULL,
[IsDeleted] [bit] NULL,
[DateCreated] [date] NULL CONSTRAINT [DF__Composite__DateC__32AB8735] DEFAULT (getdate()),
[DateUpdated] [date] NULL CONSTRAINT [DF__Composite__DateU__339FAB6E] DEFAULT (getdate())
)
GO
