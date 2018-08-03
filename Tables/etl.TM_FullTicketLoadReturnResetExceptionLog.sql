CREATE TABLE [etl].[TM_FullTicketLoadReturnResetExceptionLog]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NULL,
[BatchId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RuntimeSettings] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StageQty] [int] NULL,
[OdsQty] [int] NULL,
[event_id] [int] NULL
)
GO
