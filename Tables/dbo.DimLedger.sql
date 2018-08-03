CREATE TABLE [dbo].[DimLedger]
(
[DimLedgerId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__StartDate] [datetime] NOT NULL,
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_TM_ledger_id] [int] NULL,
[LedgerCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LedgerName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LedgerDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LedgerClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsActive] [bit] NULL,
[TM_gl_code_payment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_gl_code_refund] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[DimLedger] ADD CONSTRAINT [PK__DimLedge__D3261CC32901F3B8] PRIMARY KEY CLUSTERED  ([DimLedgerId])
GO
