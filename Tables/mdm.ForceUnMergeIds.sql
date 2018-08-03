CREATE TABLE [mdm].[ForceUnMergeIds]
(
[dimcustomerid] [int] NULL,
[forced_contact_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__ForceUnMe__Creat__6ECD227D] DEFAULT (getdate()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__ForceUnMe__Updat__6FC146B6] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorGrouping] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
GRANT DELETE ON  [mdm].[ForceUnMergeIds] TO [db_SSB_IE_Permitted]
GO
GRANT INSERT ON  [mdm].[ForceUnMergeIds] TO [db_SSB_IE_Permitted]
GO
GRANT UPDATE ON  [mdm].[ForceUnMergeIds] TO [db_SSB_IE_Permitted]
GO
