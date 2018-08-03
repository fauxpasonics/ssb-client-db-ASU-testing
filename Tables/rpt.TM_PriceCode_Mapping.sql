CREATE TABLE [rpt].[TM_PriceCode_Mapping]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SPORT] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEASONYEAR] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TICKETTYPECODE] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PRICECODE] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[REQCONTRIB] [int] NOT NULL,
[INSERT_DATE] [date] NOT NULL
)
GO
