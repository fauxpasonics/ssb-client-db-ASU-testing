CREATE TABLE [mdm].[tmp_contactmatch_data_Contact]
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
[ContactGUID_DimCustomer] [uniqueidentifier] NULL
)
GO
