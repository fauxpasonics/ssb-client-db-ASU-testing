CREATE TABLE [config].[StandardLoadAuditConfig]
(
[StandardLoadAuditConfigID] [int] NOT NULL IDENTITY(1, 1),
[AuditName] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuditDescription] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoadView] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreSQL] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuditSQL] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuditFrequency] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuditFrequencyRecurrence] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL CONSTRAINT [DF_StandardLoadAuditConfig_Active] DEFAULT ((1)),
[CreatedDate] [datetime] NULL CONSTRAINT [DF_StandardLoadAuditConfig_CreatedDate] DEFAULT (getdate()),
[CreatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_StandardLoadAuditConfig_CreatedBy] DEFAULT (suser_sname()),
[UpdatedDate] [datetime] NULL,
[UpdatedBy] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastRunStartDate] [datetime] NULL,
[LastRunEndDate] [datetime] NULL,
[LastRunAuditStatus] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
