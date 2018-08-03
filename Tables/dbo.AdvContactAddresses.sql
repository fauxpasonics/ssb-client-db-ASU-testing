CREATE TABLE [dbo].[AdvContactAddresses]
(
[PK] [int] NOT NULL,
[ContactID] [int] NULL,
[Code] [char] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttnName] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[Region] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryAddress] [bit] NULL,
[Salutation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketAddress] [bit] NULL
)
GO
ALTER TABLE [dbo].[AdvContactAddresses] ADD CONSTRAINT [PK_AdvContactAddresses] PRIMARY KEY CLUSTERED  ([PK])
GO
