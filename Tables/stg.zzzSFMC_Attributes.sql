CREATE TABLE [stg].[zzzSFMC_Attributes]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubscriberID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Account_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Full_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[First_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State_Province] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZIP_Postal_Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Season_Ticket_Holder] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Birthday_Kids] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OEI_Show_Title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Weblink] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sales_Rep] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Service_Rep] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rep_Dept] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rep_Email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rep_Phone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WC_Sale_Open] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WC_Open] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WC_Closed] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WC_Sale_Closed] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subject_Line] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attribute_1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Package_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salutation] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salesperson] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Serviceperson] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Partner] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cell_Phone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Text_Updates] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Birthday] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Marital_Status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Music_Pop] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Music_Rap] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Music_Rock] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Music_Family] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Plan_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Anniversary] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Children] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[College] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRW_Kids] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRW_STH] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Product_Being_Pitched] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Kids_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRW_eAlerts] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Favorite_Player] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Favorite_Opponent] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRW_NEW] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRW_Classic] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Show_TIme] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Door_Time] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Web_Link] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Show_Date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Show_Date_2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Weblink_2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Attribute_2] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRW_Authentics] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OE_Email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Music_Hockey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Music_Other] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Music_Country] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Music_RnB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Music_Jazz] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Music_Latin] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Music_Comedy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[weblink_3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attribute_3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FromName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FromEmail] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OE_DNE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Music_College] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRW_Games] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_wc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DRW_Tickets] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rep_First_Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[STH_Protected] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address_3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WiFi_Counter] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LCA_PS_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LCA_PS_Quantity] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LCA_PS_Company] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LCA_PS_Contact] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LCA_PS_AccountID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LCA_PS_Rep] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LCA_PS_Location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [stg].[zzzSFMC_Attributes] ADD CONSTRAINT [PK__SFMC_Att__7EF6BFCD918B66B9] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
