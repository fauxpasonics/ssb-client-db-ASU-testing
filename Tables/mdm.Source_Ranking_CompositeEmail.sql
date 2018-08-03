CREATE TABLE [mdm].[Source_Ranking_CompositeEmail]
(
[dimEmailId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DimCustomerID] [int] NULL,
[SSID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystem] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Element] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessRuleIDList] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rankingLogic] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ranking] [int] NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF_tmp_source_ranking_compositeEmail_CreatedDate] DEFAULT (getdate())
)
GO
CREATE NONCLUSTERED INDEX [NCI_SourceRankingCompositeEmail_Element] ON [mdm].[Source_Ranking_CompositeEmail] ([Element]) INCLUDE ([dimEmailId], [SourceSystem], [SSID])
GO
