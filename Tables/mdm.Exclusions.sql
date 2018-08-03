CREATE TABLE [mdm].[Exclusions]
(
[ExclusionID] [int] NOT NULL IDENTITY(1, 1),
[ExclusionDescription] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExclusionSQL] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDeleted] [bit] NULL,
[DateCreated] [date] NULL CONSTRAINT [DF__Exclusion__DateC__3864608B] DEFAULT (getdate()),
[DateUpdated] [date] NULL CONSTRAINT [DF__Exclusion__DateU__395884C4] DEFAULT (getdate())
)
GO
