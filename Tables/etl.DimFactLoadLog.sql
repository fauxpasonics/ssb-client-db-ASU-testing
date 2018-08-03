CREATE TABLE [etl].[DimFactLoadLog]
(
[LogId] [int] NOT NULL IDENTITY(1, 1),
[CreatedDate] [datetime] NULL,
[Step] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [etl].[DimFactLoadLog] ADD CONSTRAINT [PK__DimFactL__5E548648737C7E06] PRIMARY KEY CLUSTERED  ([LogId])
GO
