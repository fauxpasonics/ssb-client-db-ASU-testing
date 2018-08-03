CREATE TABLE [etl].[TicketTaggingLogic]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DimSeasonID] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TagType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TagTypeTable] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TagTypeTableID] [int] NULL,
[Logic] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_etl_TicketTaggingLogic_ETL__CreatedDate] DEFAULT (getdate()),
[ETL__UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_etl_TicketTaggingLogic_ETL__UpdatedDate] DEFAULT (getdate()),
[Config_Location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TagTypeRank] [int] NULL
)
GO
