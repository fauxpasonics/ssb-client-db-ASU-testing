CREATE TABLE [mdm].[RecognitionAuditFailure]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DimCustomerID] [int] NULL,
[RecognitionType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FailureType] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MostRecent] [bit] NULL CONSTRAINT [DF_RecognitionAuditFailure_MostRecent] DEFAULT ((1)),
[CreateDate] [datetime] NULL CONSTRAINT [DF_RecognitionAuditFailure_CreateDate] DEFAULT (getdate())
)
GO
CREATE CLUSTERED INDEX [IX_RecognitionAuditFailure_DimCustomerID_CreateDate] ON [mdm].[RecognitionAuditFailure] ([DimCustomerID], [CreateDate])
GO
