CREATE TABLE [etl].[Row_Counts]
(
[Event_ID] [bigint] NOT NULL IDENTITY(1, 1),
[Batch_ID] [bigint] NULL,
[Task_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Event_Date] [datetime] NULL CONSTRAINT [DF_row_counts_event_date] DEFAULT (getdate()),
[Row_Count_Processed] [bigint] NULL,
[Row_Count_Inserted] [bigint] NULL,
[Row_Count_Updated] [bigint] NULL,
[Row_Count_Del] [bigint] NULL
)
GO
