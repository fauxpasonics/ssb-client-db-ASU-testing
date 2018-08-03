CREATE TABLE [dbo].[DimCustomerPrivacy]
(
[DimCustomerPrivacyID] [int] NOT NULL IDENTITY(1, 1),
[DimCustomerID] [int] NULL,
[Verified_Consent_TS] [datetime] NULL,
[Verified_Consent_Source] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data_Deletion_Request_TS] [datetime] NULL,
[Data_Deletion_Request_Reason] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data_Deletion_Request_Source] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Data_Deletion_Completed_TS] [datetime] NULL,
[Data_Deletion_Incomplete_Reason] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject_Access_Request_TS] [datetime] NULL,
[Subject_Access_Request_Source] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Direct_Marketing_OptOut_TS] [datetime] NULL,
[Direct_Marketing_OptOut_Reason] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Direct_Marketing_OptOut_Source] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[createddate] [datetime] NULL,
[updateddate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[DimCustomerPrivacy] ADD CONSTRAINT [PK__DimCusto__8217EA22AB3BDA09] PRIMARY KEY CLUSTERED  ([DimCustomerPrivacyID])
GO
