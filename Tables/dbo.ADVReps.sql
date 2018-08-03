CREATE TABLE [dbo].[ADVReps]
(
[RepID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FullName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Password] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SecurityLevel] [int] NULL,
[EmailProgram] [int] NULL,
[LogOnProfile] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogOnPassword] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LogOnProxy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Pwd2] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoadDate] [datetime] NULL,
[UpdateDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[ADVReps] ADD CONSTRAINT [PK_Reps] PRIMARY KEY NONCLUSTERED  ([RepID])
GO
