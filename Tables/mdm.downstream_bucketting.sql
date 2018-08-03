CREATE TABLE [mdm].[downstream_bucketting]
(
[new] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[old] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[actiontype] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[processed] [int] NOT NULL,
[mdm_run_dt] [datetime] NOT NULL,
[processed_dt] [datetime] NULL,
[accepted] [int] NULL,
[downstream_id] [int] NOT NULL IDENTITY(1, 1),
[processing_response] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dimcustomerid] [int] NULL,
[primaryflag] [int] NULL,
[ssb_crmsystem_contact_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
