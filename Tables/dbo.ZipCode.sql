CREATE TABLE [dbo].[ZipCode]
(
[InsertDate] [datetime] NULL CONSTRAINT [DF_ZipCode_InsertDate] DEFAULT (getdate()),
[ZipCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CBSA_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MSA_Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Latitude] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Longitude] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED INDEX [IX_ZipCode_ZipCode] ON [dbo].[ZipCode] ([ZipCode])
GO
