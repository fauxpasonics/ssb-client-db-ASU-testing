CREATE TABLE [mdm].[tmp_override_dimcustomer_compositerecord]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DimCustomerID] [int] NULL,
[SSID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystem] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ElementID] [int] NULL,
[Element] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Field] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OverrideID] [int] NULL,
[InsertDate] [datetime] NULL CONSTRAINT [DF_compositerecord_override_InsertDate] DEFAULT (getdate()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF_compositerecord_override_UpdatedDate] DEFAULT (getdate()),
[AppliedToDimCustomer_TS] [datetime] NULL,
[AppliedToComposite_TS] [datetime] NULL
)
GO
