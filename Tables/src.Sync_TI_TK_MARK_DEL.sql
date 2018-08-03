CREATE TABLE [src].[Sync_TI_TK_MARK_DEL]
(
[MARK] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[ETL_Sync_Id] [int] NOT NULL IDENTITY(1, 1)
)
GO
ALTER TABLE [src].[Sync_TI_TK_MARK_DEL] ADD CONSTRAINT [PK__Sync_TI___19364FD26F2D2E82] PRIMARY KEY CLUSTERED  ([ETL_Sync_Id])
GO
