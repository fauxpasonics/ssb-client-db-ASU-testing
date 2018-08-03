CREATE TABLE [dbo].[TI_TurnKey_DataExtract_BB16_BB17]
(
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[Tenure] [int] NULL,
[EvtItem] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[EvtItemName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[EvtEvent] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[EvtEventName] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[EventDate] [datetime] NULL,
[EvtPL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[EvtPT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[EvtPTName] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[EvtQty] [bigint] NULL,
[EvtEPrice] [numeric] (18, 2) NULL,
[EvtCPrice] [numeric] (18, 2) NULL,
[EvtFPrice] [numeric] (18, 2) NULL,
[EvtEValue] [numeric] (18, 2) NULL
)
GO
