CREATE TABLE [dbo].[ADVContactTransHeader]
(
[TransID] [int] NOT NULL,
[ContactID] [int] NULL,
[TransYear] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransDate] [datetime] NULL,
[TransGroup] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MatchingAcct] [int] NULL,
[MatchingTransID] [int] NULL,
[PaymentType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardNo] [varchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExpireDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardHolderName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardHolderAddress] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardHolderZip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthTransID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CheckNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[notes] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[renew] [bit] NULL,
[EnterDateTime] [datetime] NULL,
[EnterByUser] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchRefNo] [int] NULL,
[ReceiptID] [int] NULL,
[AltTransID1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoadDate] [datetime] NULL,
[UpdateDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[ADVContactTransHeader] ADD CONSTRAINT [PK_ContactTransHeader] PRIMARY KEY NONCLUSTERED  ([TransID])
GO
