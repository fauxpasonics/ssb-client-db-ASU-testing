CREATE TABLE [mdm].[CompositeHouseholds]
(
[ch_id] [int] NOT NULL IDENTITY(1, 1),
[SSB_CRMSYSTEM_HOUSEHOLD_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastNameAddress_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [mdm].[CompositeHouseholds] ADD CONSTRAINT [PK_CompositeHouseholds] PRIMARY KEY CLUSTERED  ([ch_id])
GO
CREATE NONCLUSTERED INDEX [IX_CompositeHouseholds_LastNameAddress_ID] ON [mdm].[CompositeHouseholds] ([LastNameAddress_ID]) INCLUDE ([SSB_CRMSYSTEM_HOUSEHOLD_ID])
GO
