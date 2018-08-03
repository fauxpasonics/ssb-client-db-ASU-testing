CREATE TABLE [ods].[TM_CustRep_SCD]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__StartDate] [datetime] NOT NULL,
[ETL__EndDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_id] [int] NULL,
[acct_rep_id] [int] NULL,
[acct_rep_type] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[TM_CustRep_SCD] ADD CONSTRAINT [PK__TM_CustR__C4EA24451DD6B79E] PRIMARY KEY CLUSTERED  ([ETL__ID])
GO
