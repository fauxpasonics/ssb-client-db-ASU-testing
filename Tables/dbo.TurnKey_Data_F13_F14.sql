CREATE TABLE [dbo].[TurnKey_Data_F13_F14]
(
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerFirstName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerLastName] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerMailingAddress] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerCity] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerState] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerZip] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerHomePhone] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerBusinessPhone] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerEmailAddress] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tenure] [int] NULL,
[EvtItemName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EvtEvent] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EvtEventName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EventDate] [datetime] NULL,
[EvtPl] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EvtPt] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EvtPtName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EvtQty] [bigint] NULL,
[EvtEPrice] [numeric] (18, 2) NULL,
[EvtCPrice] [numeric] (18, 2) NULL,
[EvtFPrice] [numeric] (18, 2) NULL,
[EVTEvalue] [numeric] (18, 2) NULL
)
GO
