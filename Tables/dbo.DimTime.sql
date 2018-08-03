CREATE TABLE [dbo].[DimTime]
(
[DimTimeId] [int] NOT NULL,
[Time] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Time24] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HourName] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MinuteName] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hour] [int] NULL,
[Hour24] [int] NULL,
[Minute] [int] NULL,
[Second] [int] NULL,
[AMPM] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[DimTime] ADD CONSTRAINT [PK_DimTime] PRIMARY KEY CLUSTERED  ([DimTimeId])
GO
