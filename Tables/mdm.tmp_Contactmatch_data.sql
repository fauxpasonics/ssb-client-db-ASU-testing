CREATE TABLE [mdm].[tmp_Contactmatch_data]
(
[DimCustomerId] [int] NULL,
[SSID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactGUID] [uniqueidentifier] NULL,
[EmailPrimary] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_matchkey] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FuzzyNameGUID] [uniqueidentifier] NULL,
[hashplaintext_1] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hash_1] [varbinary] (32) NULL,
[hashplaintext_2] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hash_2] [varbinary] (32) NULL,
[hashplaintext_3] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hash_3] [varbinary] (32) NULL,
[hashplaintext_9] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hash_9] [varbinary] (32) NULL
)
GO
