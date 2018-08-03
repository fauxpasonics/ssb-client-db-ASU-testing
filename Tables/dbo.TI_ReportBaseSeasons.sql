CREATE TABLE [dbo].[TI_ReportBaseSeasons]
(
[Id] [bigint] NOT NULL IDENTITY(1, 1),
[Season] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TI_ReportBaseSeasons] ADD CONSTRAINT [PK_ReportBaseSeasons] PRIMARY KEY CLUSTERED  ([Id])
GO
