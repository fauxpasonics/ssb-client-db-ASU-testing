CREATE TABLE [dbo].[ADVDonorPayUsers]
(
[UserID] [int] NOT NULL,
[Username] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PasswordHash] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADNumber] [int] NULL,
[ContactID] [int] NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConfirmSent] [datetime] NULL,
[Confirmed] [bit] NULL,
[NewMember] [bit] NULL,
[NewMemberID] [int] NULL,
[LastLoginDate] [datetime] NULL,
[IsSystemGenerated] [bit] NULL,
[LoadDate] [datetime] NULL,
[UpdateDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[ADVDonorPayUsers] ADD CONSTRAINT [PK__ADVDonor__1788CCAC923AD153] PRIMARY KEY CLUSTERED  ([UserID])
GO
