CREATE TABLE [wrk].[Transaction_Detail__c]
(
[Season__c] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Customer__c] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item__c] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price_Level__c] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price_Type__c] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item_Price__c] [numeric] (18, 2) NULL,
[Item_Discount_Amount__c] [numeric] (18, 2) NULL,
[Order_Quantity__c] [bigint] NULL,
[Order_Total__c] [numeric] (18, 2) NULL,
[Paid_Customer__c] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Min_Pmt_Date__c] [datetime] NULL,
[Paid_Total__c] [numeric] (18, 2) NULL
)
GO
