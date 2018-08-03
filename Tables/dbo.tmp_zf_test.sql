CREATE TABLE [dbo].[tmp_zf_test]
(
[SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEASON_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER_TYPE] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER_TYPE_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TICKET_TYPE] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ITEM] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ITEM_NAME] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_PT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_PT_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[E_PL] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PL_NAME] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[I_PRICE] [numeric] (18, 2) NULL,
[I_DAMT] [numeric] (18, 2) NULL,
[ORDQTY] [bigint] NULL,
[ORDTOTAL] [numeric] (18, 2) NULL,
[PAIDTOTAL] [numeric] (18, 2) NULL,
[MINPAYMENTDATE] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[calendarMonthName] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[calendarDayOfWeekName] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[calendarWeekOfYearNum] [int] NULL,
[calendarDayOfWeekNum] [int] NULL,
[calendarDayOfYearNum] [int] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
