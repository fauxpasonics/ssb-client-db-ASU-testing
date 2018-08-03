CREATE TABLE [etl].[RuntimeSettings]
(
[SettingId] [int] NOT NULL IDENTITY(1, 1),
[Integration] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RuntimeSettings] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartDateRange] [datetime] NULL,
[EndDateRange] [datetime] NULL,
[IsProcessed] [bit] NULL,
[Comments] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[UpdatedDate] [datetime] NOT NULL
)
GO
ALTER TABLE [etl].[RuntimeSettings] ADD CONSTRAINT [PK__RuntimeS__54372B1DC1D89390] PRIMARY KEY CLUSTERED  ([SettingId])
GO
CREATE NONCLUSTERED INDEX [IDX_Integration] ON [etl].[RuntimeSettings] ([Integration])
GO
CREATE NONCLUSTERED INDEX [IDX_IsProcessed] ON [etl].[RuntimeSettings] ([IsProcessed])
GO
CREATE NONCLUSTERED INDEX [IDX_StartDateRange] ON [etl].[RuntimeSettings] ([StartDateRange] DESC)
GO
