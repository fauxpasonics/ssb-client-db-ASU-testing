CREATE TABLE [src].[Sync_TI_PD_PATRON_DEL]
(
[PATRON] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_Sync_Id] [int] NOT NULL IDENTITY(1, 1)
)
GO
ALTER TABLE [src].[Sync_TI_PD_PATRON_DEL] ADD CONSTRAINT [PK__Sync_TI___19364FD27A560EC9] PRIMARY KEY CLUSTERED  ([ETL_Sync_Id])
GO
