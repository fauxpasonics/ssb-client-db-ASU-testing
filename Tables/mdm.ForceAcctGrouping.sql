CREATE TABLE [mdm].[ForceAcctGrouping]
(
[DimCustomerid] [int] NULL,
[GroupingID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__ForceAcct__Creat__6BF0B5D2] DEFAULT (getdate()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__ForceAcct__Updat__6CE4DA0B] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifiedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorGrouping] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
GRANT DELETE ON  [mdm].[ForceAcctGrouping] TO [db_SSB_IE_Permitted]
GO
GRANT INSERT ON  [mdm].[ForceAcctGrouping] TO [db_SSB_IE_Permitted]
GO
GRANT UPDATE ON  [mdm].[ForceAcctGrouping] TO [db_SSB_IE_Permitted]
GO
