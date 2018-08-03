CREATE TABLE [email].[FactCampaignEmailSummary]
(
[FactCampaignEmailSummaryId] [int] NOT NULL IDENTITY(-2, 1),
[DimCampaignId] [int] NULL,
[DimCampaignActivityTypeId] [int] NULL,
[DimEmailId] [int] NULL,
[ActivityTypeTotal] [int] NULL,
[ActivyTypeUnique] [bit] NULL,
[ActivityTypeMinDate] [datetime] NULL,
[ActivityTypeMaxDate] [datetime] NULL,
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__FactCampa__Creat__5A7F3E69] DEFAULT (user_name()),
[CreatedDate] [datetime] NULL CONSTRAINT [DF__FactCampa__Creat__5B7362A2] DEFAULT (getdate()),
[UpdatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__FactCampa__Updat__5C6786DB] DEFAULT (user_name()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF__FactCampa__Updat__5D5BAB14] DEFAULT (getdate())
)
GO
ALTER TABLE [email].[FactCampaignEmailSummary] ADD CONSTRAINT [PK__FactCamp__DF75612BD13DDE7E] PRIMARY KEY CLUSTERED  ([FactCampaignEmailSummaryId])
GO
CREATE NONCLUSTERED INDEX [idx_FactCampaignEmailSummary_DimCampaignActivityTypeId] ON [email].[FactCampaignEmailSummary] ([DimCampaignActivityTypeId])
GO
CREATE NONCLUSTERED INDEX [idx_FactCampaignEmailSummary_DimCampaignId] ON [email].[FactCampaignEmailSummary] ([DimCampaignId])
GO
CREATE NONCLUSTERED INDEX [idx_FactCampaignEmailSummary_DimEmailId] ON [email].[FactCampaignEmailSummary] ([DimEmailId])
GO
ALTER TABLE [email].[FactCampaignEmailSummary] ADD CONSTRAINT [FK__FactCampa__DimCa__6E863716] FOREIGN KEY ([DimCampaignId]) REFERENCES [email].[DimCampaign] ([DimCampaignId])
GO
ALTER TABLE [email].[FactCampaignEmailSummary] ADD CONSTRAINT [FK__FactCampa__DimCa__6F7A5B4F] FOREIGN KEY ([DimCampaignActivityTypeId]) REFERENCES [email].[DimCampaignActivityType] ([DimCampaignActivityTypeId])
GO
ALTER TABLE [email].[FactCampaignEmailSummary] ADD CONSTRAINT [FK__FactCampa__DimEm__706E7F88] FOREIGN KEY ([DimEmailId]) REFERENCES [email].[DimEmail] ([DimEmailID])
GO
