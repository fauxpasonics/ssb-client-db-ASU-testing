CREATE TABLE [dbo].[PhoneLineTypeCode]
(
[PhoneLineTypeCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ShortDescription] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LongDescription] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertedDate] [datetime] NULL CONSTRAINT [DF_PhoneLineTypeCode_InsertedDate] DEFAULT (getdate()),
[UpdatedDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[PhoneLineTypeCode] ADD CONSTRAINT [PK_PhoneLineTypeCode] PRIMARY KEY CLUSTERED  ([PhoneLineTypeCode])
GO
CREATE NONCLUSTERED INDEX [IX_PhoneTypeCode_PhoneTypeCode] ON [dbo].[PhoneLineTypeCode] ([PhoneLineTypeCode]) INCLUDE ([ShortDescription])
GO
