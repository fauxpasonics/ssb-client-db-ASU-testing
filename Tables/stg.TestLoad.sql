CREATE TABLE [stg].[TestLoad]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimArena__ETL__C__26D08B8C] DEFAULT (getdate()),
[id] [int] NULL,
[ColA] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColC] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [stg].[TestLoad] ADD CONSTRAINT [PK__TestLoad__C4EA24451BD448FA] PRIMARY KEY CLUSTERED  ([ETL__ID])
GO
