CREATE TABLE [etl].[DOMO_Pac12_ExportFile_ASU_Donation]
(
[SSB_CRMSYSTEM_CONTACT_ID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TX_NUMBER] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID_NUMBER] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PACIOLAN_ID] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CAMPAIGN_CODE] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DATE_OF_RECORD] [date] NULL,
[ATHLETIC_FUND_DESC] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRANS_TYPE_DESC] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NET_LEGAL_AMOUNT] [float] NULL,
[BATCH_NUMBER] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ALLOC_CODE] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ALLOC_DESC] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AGENCY_DESC] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MATCHING_COMPANY_ID] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MATCHED_RECEIPT_NBR] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MatchAmount] [int] NULL,
[MatchingGift] [int] NULL,
[PAYMENT_TYPE_DESC] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BATCH_PROCESSED_DATE] [date] NULL,
[RECORD_OPERATOR_NAME] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
