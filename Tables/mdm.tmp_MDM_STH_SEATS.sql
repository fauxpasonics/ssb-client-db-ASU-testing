CREATE TABLE [mdm].[tmp_MDM_STH_SEATS]
(
[acct_id] [bigint] NULL,
[STH] [int] NULL,
[SEATS] [int] NULL,
[TRANS] [datetime] NULL,
[SDC_ID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED INDEX [ix_MDM_STH_SEATS] ON [mdm].[tmp_MDM_STH_SEATS] ([acct_id])
GO
