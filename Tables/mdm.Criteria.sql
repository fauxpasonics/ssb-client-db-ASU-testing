CREATE TABLE [mdm].[Criteria]
(
[CriteriaID] [int] NOT NULL IDENTITY(1, 1),
[Criteria] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CriteriaField] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CriteriaTable] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CriteriaJoin] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom] [bit] NULL,
[IsDeleted] [bit] NULL,
[DateCreated] [date] NULL CONSTRAINT [DF__Criteria__DateCr__3493CFA7] DEFAULT (getdate()),
[DateUpdated] [date] NULL CONSTRAINT [DF__Criteria__DateUp__3587F3E0] DEFAULT (getdate()),
[CriteriaOrder] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreSQL] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[criteriacondition] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
GRANT DELETE ON  [mdm].[Criteria] TO [db_SSB_IE_Permitted]
GO
GRANT INSERT ON  [mdm].[Criteria] TO [db_SSB_IE_Permitted]
GO
GRANT UPDATE ON  [mdm].[Criteria] TO [db_SSB_IE_Permitted]
GO
