CREATE TABLE [pac12].[DimTicketCustomer]
(
[DimTicketCustomerId] [bigint] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__DimTicket__ETL____2AA11C70] DEFAULT (suser_name()),
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimTicket__ETL____2B9540A9] DEFAULT (getdate()),
[ETL__StartDate] [datetime] NOT NULL CONSTRAINT [DF__DimTicket__ETL____2C8964E2] DEFAULT (getdate()),
[ETL__EndDate] [datetime] NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_PATRON] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_acct_id] [int] NULL,
[DimRepId] [int] NULL,
[IsCompany] [bit] NOT NULL,
[CompanyName] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FullName] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prefix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketCustomerClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VIPCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsVIP] [bit] NOT NULL,
[Tag] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountType] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Keywords] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddDateTime] [datetime] NULL,
[SinceDate] [date] NULL,
[Birthday] [date] NULL,
[Email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressStreet1] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressStreet2] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressCity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressState] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressZip] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressCountry] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__DeltaHashKey] [binary] (32) NULL
)
GO
ALTER TABLE [pac12].[DimTicketCustomer] ADD CONSTRAINT [PK_DimTicketCustomer] PRIMARY KEY CLUSTERED  ([DimTicketCustomerId])
GO
CREATE NONCLUSTERED INDEX [IDX_ETL__SSID_PATRON] ON [pac12].[DimTicketCustomer] ([ETL__SSID_PATRON])
GO
