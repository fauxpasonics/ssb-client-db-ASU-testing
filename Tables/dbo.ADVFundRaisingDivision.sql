CREATE TABLE [dbo].[ADVFundRaisingDivision]
(
[DivisionID] [int] NOT NULL,
[DivisionName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoadDate] [datetime] NULL,
[UpdateDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[ADVFundRaisingDivision] ADD CONSTRAINT [PK_Division] PRIMARY KEY CLUSTERED  ([DivisionID])
GO
