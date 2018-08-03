CREATE TABLE [dbo].[Master_DimCustomer_Deltas]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DimCustomerId] [int] NULL,
[SSID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Element] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ElementID] [int] NULL,
[Field] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FieldDisplay] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Source] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CD_Status] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Master] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplayOrder] [int] NULL,
[AcceptedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AcceptedDate] [datetime] NULL,
[ProcessedDate] [datetime] NULL,
[InsertDate] [datetime] NULL CONSTRAINT [DF__Master_Di__Inser__4A4775EB] DEFAULT (getdate())
)
GO
CREATE NONCLUSTERED INDEX [IX_Master_DimCustomer_Deltas_DimCustomerId] ON [dbo].[Master_DimCustomer_Deltas] ([DimCustomerId]) INCLUDE ([ElementID], [Field], [ProcessedDate])
GO
CREATE NONCLUSTERED INDEX [IX_Master_DimCustomer_Deltas_InsertDate] ON [dbo].[Master_DimCustomer_Deltas] ([InsertDate] DESC)
GO
CREATE CLUSTERED INDEX [IX_Master_DimCustomer_Deltas_ProcessedDate_DimCustomerId] ON [dbo].[Master_DimCustomer_Deltas] ([ProcessedDate], [DimCustomerId])
GO
