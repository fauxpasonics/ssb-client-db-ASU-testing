CREATE TABLE [dbo].[ADVContactTransLineItems]
(
[PK] [int] NOT NULL,
[TransID] [int] NULL,
[ProgramID] [int] NULL,
[MatchProgramID] [int] NULL,
[TransAmount] [money] NULL,
[MatchAmount] [money] NULL,
[MatchingGift] [bit] NULL,
[Renew] [bit] NULL,
[Renewed] [bit] NULL,
[Comments] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoadDate] [datetime] NULL,
[UpdateDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[ADVContactTransLineItems] ADD CONSTRAINT [PK_ContactTransLineItems] PRIMARY KEY NONCLUSTERED  ([PK])
GO
