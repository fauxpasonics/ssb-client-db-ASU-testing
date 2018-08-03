CREATE TABLE [mdm].[BusinessRuleType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RuleType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL CONSTRAINT [DF_BusinessRuleType_Active] DEFAULT ((1)),
[DateCreated] [datetime] NULL CONSTRAINT [DF_BusinessRuleType_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NULL CONSTRAINT [DF_BusinessRuleType_DateUpdated] DEFAULT (getdate())
)
GO
ALTER TABLE [mdm].[BusinessRuleType] ADD CONSTRAINT [UC_BusinessRuleType_RuleType] UNIQUE NONCLUSTERED  ([RuleType])
GO
