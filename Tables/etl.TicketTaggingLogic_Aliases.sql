CREATE TABLE [etl].[TicketTaggingLogic_Aliases]
(
[AliasID] [int] NOT NULL IDENTITY(1, 1),
[SchemaName] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TableName] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Alias] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketModelVersion] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TableNickname] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
