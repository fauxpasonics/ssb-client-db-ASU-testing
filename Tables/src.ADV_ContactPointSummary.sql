CREATE TABLE [src].[ADV_ContactPointSummary]
(
[PK] [int] NOT NULL IDENTITY(1, 1),
[ContactID] [int] NULL,
[DESCRIPTION] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Points] [decimal] (18, 6) NULL,
[LINKED] [bit] NULL,
[Value] [decimal] (18, 6) NULL
)
GO
ALTER TABLE [src].[ADV_ContactPointSummary] ADD CONSTRAINT [PK__ADV_Cont__3215078700C172BD] PRIMARY KEY CLUSTERED  ([PK])
GO
