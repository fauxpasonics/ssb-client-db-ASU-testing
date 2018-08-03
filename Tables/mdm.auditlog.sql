CREATE TABLE [mdm].[auditlog]
(
[logdate] [datetime] NULL,
[mdm_process] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[process_step] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cnt] [bigint] NULL
)
GO
