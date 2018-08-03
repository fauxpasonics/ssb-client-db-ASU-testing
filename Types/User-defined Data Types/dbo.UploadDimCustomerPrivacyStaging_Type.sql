CREATE TYPE [dbo].[UploadDimCustomerPrivacyStaging_Type] AS TABLE
(
[SessionId] [uniqueidentifier] NULL,
[DimCustomerId] [int] NULL,
[SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Verified_Consent_TS] [datetime] NULL,
[Verified_Consent_Source] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data_Deletion_Request_TS] [datetime] NULL,
[Data_Deletion_Request_Reason] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data_Deletion_Request_Source] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject_Access_Request_TS] [datetime] NULL,
[Subject_Access_Request_Source] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Direct_Marketing_OptOut_TS] [datetime] NULL,
[Direct_Marketing_OptOut_Reason] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Direct_Marketing_OptOut_Source] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
