CREATE TABLE [src].[TI_DEL_TK_CUSTOMER]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ZID] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [src].[TI_DEL_TK_CUSTOMER] ADD CONSTRAINT [PK__TI_DEL_T__7EF6BFCD65B9B324] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
