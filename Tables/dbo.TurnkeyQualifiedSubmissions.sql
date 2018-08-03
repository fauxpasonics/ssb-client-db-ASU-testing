CREATE TABLE [dbo].[TurnkeyQualifiedSubmissions]
(
[TC_ID] [int] NULL,
[SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TicketingSystemAccountID] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubmitDate] [datetime] NULL,
[ReceiveDate] [date] NULL,
[ReSubmitDate] [date] NULL,
[LastModifiedDate] [datetime] NULL,
[FILENAME] [nvarchar] (225) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TurnkeyQualifiedSubmissions] ADD CONSTRAINT [PK_turnkey_qualifiedsubmissions] PRIMARY KEY CLUSTERED  ([SSID], [FILENAME])
GO
