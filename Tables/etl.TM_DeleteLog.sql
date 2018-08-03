CREATE TABLE [etl].[TM_DeleteLog]
(
[ETL__ID] [bigint] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL,
[SourceTable] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowDataXML] [xml] NULL
)
GO
ALTER TABLE [etl].[TM_DeleteLog] ADD CONSTRAINT [PK__TM_Delet__C4EA244533478CDF] PRIMARY KEY CLUSTERED  ([ETL__ID])
GO
CREATE NONCLUSTERED INDEX [IDX_ETL__CreatedDate] ON [etl].[TM_DeleteLog] ([ETL__CreatedDate] DESC)
GO
CREATE NONCLUSTERED INDEX [IDX_SourceTable] ON [etl].[TM_DeleteLog] ([SourceTable])
GO
CREATE PRIMARY XML INDEX [IDX_XML_RowDataXML]
ON [etl].[TM_DeleteLog] ([RowDataXML])
GO
