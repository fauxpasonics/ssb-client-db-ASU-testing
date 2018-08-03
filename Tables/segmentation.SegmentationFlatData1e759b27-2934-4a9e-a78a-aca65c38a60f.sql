CREATE TABLE [segmentation].[SegmentationFlatData1e759b27-2934-4a9e-a78a-aca65c38a60f]
(
[id] [uniqueidentifier] NULL,
[DocumentType] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcctId] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[CreatedById] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedByName] [nvarchar] (121) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastModifiedDate] [datetime] NULL,
[LastModifiedById] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnerId] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OwnerName] [nvarchar] (121) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Service_Owner__c] [nvarchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Service_Owner_Name] [nvarchar] (121) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastActivityDate] [date] NULL,
[DaysSinceLastActivity] [int] NULL,
[HasOpenOpportunity] [datetime] NULL,
[LastOpportunityCreatedDate] [datetime] NULL,
[LastOpportunityOwnerName] [nvarchar] (121) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastOpportunityLastModifiedDate] [datetime] NULL,
[LastOpportunityClosedWonDate] [datetime] NULL,
[LastOpportunityClosedLostReason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsBusiness] [int] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [ccix_SegmentationFlatData1e759b27-2934-4a9e-a78a-aca65c38a60f] ON [segmentation].[SegmentationFlatData1e759b27-2934-4a9e-a78a-aca65c38a60f]
GO
