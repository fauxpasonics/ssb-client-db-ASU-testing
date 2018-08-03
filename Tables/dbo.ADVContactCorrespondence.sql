CREATE TABLE [dbo].[ADVContactCorrespondence]
(
[PK] [int] NOT NULL,
[ContactID] [int] NULL,
[ContactedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CorrDate] [datetime] NULL,
[Contact] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Private] [bit] NULL,
[SentToTixOffice] [bit] NULL,
[DateTimeSentToTixOffice] [datetime] NULL,
[ProposedDonation] [money] NULL,
[NegotiatedDonation] [money] NULL,
[LoadDate] [datetime] NULL,
[UpdateDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[ADVContactCorrespondence] ADD CONSTRAINT [PK_ContactCorrespondence] PRIMARY KEY NONCLUSTERED  ([PK])
GO
