CREATE TABLE [mdm].[BusinessRules]
(
[ElementID] [int] NOT NULL,
[CriteriaID] [int] NULL,
[priority] [int] NULL,
[IsDeleted] [bit] NULL,
[DateCreated] [date] NULL CONSTRAINT [DF__BusinessR__DateC__3C9A7383] DEFAULT (getdate()),
[DateUpdated] [date] NULL CONSTRAINT [DF__BusinessR__DateU__3D8E97BC] DEFAULT (getdate()),
[RuleType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogicalOperator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GroupID] [int] NULL,
[BusinessRuleID] [int] NOT NULL IDENTITY(1, 1)
)
GO
ALTER TABLE [mdm].[BusinessRules] ADD CONSTRAINT [CK_LogicalOperator] CHECK (([LogicalOperator]='OR' OR [LogicalOperator]='AND'))
GO
ALTER TABLE [mdm].[BusinessRules] ADD CONSTRAINT [PK_BusinessRuleID] PRIMARY KEY CLUSTERED  ([BusinessRuleID])
GO
ALTER TABLE [mdm].[BusinessRules] ADD CONSTRAINT [UQ_BusinessRule1] UNIQUE NONCLUSTERED  ([ElementID], [CriteriaID], [RuleType], [IsDeleted])
GO
ALTER TABLE [mdm].[BusinessRules] ADD CONSTRAINT [UQ_BusinessRule2] UNIQUE NONCLUSTERED  ([ElementID], [priority], [RuleType], [IsDeleted])
GO
ALTER TABLE [mdm].[BusinessRules] ADD CONSTRAINT [FK_BusinessRules_RuleType] FOREIGN KEY ([RuleType]) REFERENCES [mdm].[BusinessRuleType] ([RuleType])
GO
GRANT DELETE ON  [mdm].[BusinessRules] TO [db_SSB_IE_Permitted]
GO
GRANT INSERT ON  [mdm].[BusinessRules] TO [db_SSB_IE_Permitted]
GO
GRANT UPDATE ON  [mdm].[BusinessRules] TO [db_SSB_IE_Permitted]
GO
