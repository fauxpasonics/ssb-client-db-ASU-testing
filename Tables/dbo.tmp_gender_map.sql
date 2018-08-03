CREATE TABLE [dbo].[tmp_gender_map]
(
[sourcecontactid] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[input_sourcesystem] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gender] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE NONCLUSTERED INDEX [ix_ssid] ON [dbo].[tmp_gender_map] ([input_sourcesystem], [sourcecontactid])
GO
