CREATE TABLE [ods].[SFMC_OptInFormDataExtension]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__SFMC_OptI__ETL_C__2E1C09DD] DEFAULT (getdate()),
[ETL_UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__SFMC_OptI__ETL_U__2F102E16] DEFAULT (getdate()),
[ETL_IsDeleted] [bit] NOT NULL CONSTRAINT [DF__SFMC_OptI__ETL_I__3004524F] DEFAULT ((0)),
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubmitDate] [datetime] NULL
)
GO
ALTER TABLE [ods].[SFMC_OptInFormDataExtension] ADD CONSTRAINT [PK__SFMC_Opt__7EF6BFCD543AAC03] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
