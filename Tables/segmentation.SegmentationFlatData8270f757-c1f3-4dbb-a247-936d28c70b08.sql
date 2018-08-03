CREATE TABLE [segmentation].[SegmentationFlatData8270f757-c1f3-4dbb-a247-936d28c70b08]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID_NUMBER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PACIOLAN_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CAMPAIGN_CODE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DATE_OF_RECORD] [date] NULL,
[ATHLETIC_FUND_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GYPMD_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRANS_TYPE_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CREDIT_AMOUNT] [float] NULL,
[NET_LEGAL_AMOUNT] [float] NULL,
[ALLOC_CODE] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ALLOC_DESC] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AGENCY_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PAYMENT_TYPE_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MATCHING_COMPANY_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatData8270f757-c1f3-4dbb-a247-936d28c70b08] ON [segmentation].[SegmentationFlatData8270f757-c1f3-4dbb-a247-936d28c70b08]
GO
