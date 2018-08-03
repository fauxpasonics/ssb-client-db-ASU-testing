CREATE TABLE [dbo].[ADVFundRaisingTeam]
(
[TeamID] [int] NOT NULL,
[DivisionID] [int] NULL,
[TeamName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoadDate] [datetime] NULL,
[UpdateDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[ADVFundRaisingTeam] ADD CONSTRAINT [PK_Team] PRIMARY KEY CLUSTERED  ([TeamID])
GO
