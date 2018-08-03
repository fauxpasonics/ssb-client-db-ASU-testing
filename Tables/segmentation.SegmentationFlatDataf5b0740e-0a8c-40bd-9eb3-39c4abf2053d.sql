CREATE TABLE [segmentation].[SegmentationFlatDataf5b0740e-0a8c-40bd-9eb3-39c4abf2053d]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Prefix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[First_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Middle_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Full_Name] [nvarchar] (302) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Suffix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company_Name] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name_Is_Clean_Status] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer_Status] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account_Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Address_Street] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Address_City] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Address_State] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Address_Suite] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Address_Zip] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Address_Zip3] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Address_County] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Address_Country] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_Primary_Is_Clean_Status] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Primary] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Primary_Area_Code] [int] NULL,
[Phone_Primary_Is_Clean_Status] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Home] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneHomeAreaCode] [int] NULL,
[Phone_Home_Is_Clean_Status] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Cell] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Cell_Area_Code] [int] NULL,
[Phone_Cell_Is_Clean_Status] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneBusiness] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Business_Area_Code] [int] NULL,
[Phone_Business_Is_Clean_Status] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Fax] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Fax_Area_Code] [int] NULL,
[Phone_Fax_Is_Clean_Status] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Other] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Other_Area_Code] [int] NULL,
[Phone_Other_Is_Clean_Status] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Email] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Email_Domain] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Email_Exists] [int] NOT NULL,
[Email_Primary_Is_Clean_Status] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_One] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_One_Domain] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_One_Exists] [int] NOT NULL,
[Email_One_Is_Clean_Status] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_Two] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_Two_Domain] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_Two_Exists] [int] NOT NULL,
[Email_Two_Is_Clean_Status] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Record_Source_System] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Primary_Record_Source_System_Id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Archtics_Account_Id] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone_Primary_DNC] [bit] NULL,
[Phone_Home_DNC] [bit] NULL,
[Phone_Cell_DNC] [bit] NULL,
[Phone_Business_DNC] [bit] NULL,
[Phone_Fax_DNC] [bit] NULL,
[Phone_Other_DNC] [bit] NULL,
[Birth_Date] [date] NULL,
[Birth_Year] [int] NULL,
[Birth_Month] [int] NULL,
[Birth_Day] [int] NULL,
[Age] [int] NULL,
[Is_SFMC_Contact] [int] NOT NULL,
[IsSubscribed] [int] NOT NULL,
[IsBounceback] [int] NOT NULL,
[IsUnsubscribed] [int] NOT NULL,
[DaysSince_LastEmailOpen] [int] NOT NULL,
[DaysSince_LastEmailSent] [int] NOT NULL,
[DaysSince_LastTixPurchase] [int] NOT NULL,
[DaysSince_LastDonation] [int] NOT NULL,
[Turnkey_Football_Capacity_Score__c] [int] NULL,
[Turnkey_Football_Priority_Score__c] [int] NULL,
[Turnkey_Basketball_Capacity_Score__c] [int] NULL,
[Turnkey_Basketball_Priority_Score__c] [int] NULL,
[Turnkey_WBasketball_Capacity_Score__c] [int] NULL,
[Turnkey_WBasketball_Priority_Score__c] [int] NULL,
[Turnkey_Net_Worth_Gold__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Turnkey_Discretionary_Income_Index__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Turnkey_PersonicX_Cluster__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Turnkey_Age_Input_Individual__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Turnkey_Marital_Status__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Turnkey_Presence_of_Children__c] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatDataf5b0740e-0a8c-40bd-9eb3-39c4abf2053d] ON [segmentation].[SegmentationFlatDataf5b0740e-0a8c-40bd-9eb3-39c4abf2053d]
GO
