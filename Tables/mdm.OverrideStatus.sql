CREATE TABLE [mdm].[OverrideStatus]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[StatusID] [int] NULL,
[Status] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NULL CONSTRAINT [DF_OverrideStatus_Active] DEFAULT ((1)),
[DateCreated] [datetime] NULL CONSTRAINT [DF_OverrideStatus_DateCreated] DEFAULT (getdate()),
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_OverrideStatus_CreatedBy] DEFAULT (suser_sname()),
[DateUpdated] [datetime] NULL,
[UpdatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [mdm].[OverrideStatus] ADD CONSTRAINT [PK_OverrideStatus_ID] PRIMARY KEY CLUSTERED  ([ID])
GO
