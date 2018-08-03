CREATE TABLE [dbo].[ADVAllocationLevels]
(
[MembID] [int] NOT NULL,
[TransYear] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProgramID] [int] NOT NULL,
[LoadDate] [datetime] NULL,
[UpdateDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[ADVAllocationLevels] ADD CONSTRAINT [PK_AllocationLevels] PRIMARY KEY CLUSTERED  ([ProgramID], [MembID], [TransYear])
GO
