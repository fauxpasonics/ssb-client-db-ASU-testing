CREATE TABLE [stg].[SFMC_SubscriberDataExtension]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__SFMC_Data__ETL_C__2A4B78F9] DEFAULT (getdate()),
[ETL_FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PacPrimary] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PacID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdvanceID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_FirstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_LastName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Age] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BirthDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryRecordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTypes] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordStatus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Advance_OtherID_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorityPoints_Cumulative] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorityPoints_Consecutive] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorityPoints_SeasonTickets] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorityPoints_LetterWinner] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorityPoints_Misc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorityPointsTotal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriorityPoints_Rank] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Active_SDC_Member] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Current_SDC_MemberLevel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JoinDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [stg].[SFMC_SubscriberDataExtension] ADD CONSTRAINT [PK__SFMC_Dat__7EF6BFCDC4E0D085] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
