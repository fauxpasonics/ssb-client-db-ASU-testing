CREATE TABLE [src].[Athletics_MDM]
(
[ssb_crmsystem_contact_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sourcesystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssid] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prefix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[firstname] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[middlename] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastname] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[suffix] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nameiscleanstatus] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fullname] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[companyname] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarystreet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarysuite] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarycity] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarystate] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryZip] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarycountry] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimaryiscleanstatus] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressPrimaryNCOAStatus] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phoneprimary] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phoneprimaryiscleanstatus] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailPrimary] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[emailprimaryiscleanstatus] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[updateddate] [datetime] NULL,
[createddate] [datetime] NULL,
[ssupdateddate] [datetime] NULL,
[sscreateddate] [datetime] NULL,
[dimcustomerid] [int] NOT NULL,
[customerstatus] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customertype] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastpurchase] [datetime] NULL,
[isdeleted] [bit] NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_src_Athletics_MDM_Dimcustomer] ON [src].[Athletics_MDM] ([dimcustomerid])
GO
CREATE NONCLUSTERED INDEX [IX_src_Athletics_MDM_SSID_Sourcesystem] ON [src].[Athletics_MDM] ([ssid], [sourcesystem])
GO
