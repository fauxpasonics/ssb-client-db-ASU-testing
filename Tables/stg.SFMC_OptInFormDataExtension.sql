CREATE TABLE [stg].[SFMC_OptInFormDataExtension]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__SFMC_OptI__ETL_C__32E0BEFA] DEFAULT (getdate()),
[ETL_FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubmitDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [stg].[SFMC_OptInFormDataExtension] ADD CONSTRAINT [PK__SFMC_Opt__7EF6BFCDF0D31DBC] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
