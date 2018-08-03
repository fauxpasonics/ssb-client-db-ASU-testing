CREATE TABLE [ods].[TestLoad]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimArena__ETL__C__26D08B8C] DEFAULT (getdate()),
[ETL__StartDate] [datetime] NOT NULL CONSTRAINT [DF__DimArena__ETL__S__27C4AFC5] DEFAULT (getdate()),
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[id] [int] NULL,
[ColA] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColB] [int] NULL,
[ColC] [decimal] (18, 6) NULL,
[ColD] [datetime] NULL,
[ColE] [bit] NULL
)
GO
ALTER TABLE [ods].[TestLoad] ADD CONSTRAINT [PK__TestLoad__C4EA24453126C2D0] PRIMARY KEY CLUSTERED  ([ETL__ID])
GO
