CREATE TABLE [dbo].[SourceExtractControl]
(
[SourceExtractControlId] [int] NOT NULL IDENTITY(1, 1),
[Source] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IntegrationName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceTable] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DestinationTable] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsFactData] [bit] NOT NULL CONSTRAINT [DF_SourceExtractControl_IsFactData] DEFAULT ((0)),
[FullLoad] [bit] NOT NULL,
[IsDateExtractable] [bit] NOT NULL CONSTRAINT [DF_SourceExtractControl_IsDateExtractable] DEFAULT ((0)),
[FullLoadSql] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateExtractSql] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtractColumns] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active] [bit] NOT NULL,
[MergeProc] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[run_export_datetime] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[SourceExtractControl] ADD CONSTRAINT [PK_SourceExtractControlId] PRIMARY KEY CLUSTERED  ([SourceExtractControlId])
GO
