CREATE TABLE [dbo].[DimTeam]
(
[DimTeamId] [int] NOT NULL IDENTITY(1, 1),
[TeamCity] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TeamName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TeamFullName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Division] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Conference] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TeamTier] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsRival] [bit] NULL
)
GO
ALTER TABLE [dbo].[DimTeam] ADD CONSTRAINT [PK_DimTeam] PRIMARY KEY CLUSTERED  ([DimTeamId])
GO
