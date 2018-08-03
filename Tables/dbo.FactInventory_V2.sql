CREATE TABLE [dbo].[FactInventory_V2]
(
[FactInventoryId] [bigint] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__UpdatedDate] [datetime] NOT NULL,
[ETL__SSID_PAC_SEASON] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_EVENT] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_LEVEL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_SECTION] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_ROW] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_SEAT] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_TM_event_id] [int] NULL,
[ETL__SSID_TM_section_id] [int] NULL,
[ETL__SSID_TM_row_id] [int] NULL,
[ETL__SSID_TM_seat] [int] NULL,
[DimArenaId] [int] NOT NULL,
[DimSeasonId] [int] NOT NULL,
[DimEventId] [int] NOT NULL,
[DimSeatId] [int] NOT NULL,
[DimSeatStatusId] [int] NOT NULL,
[SeatValue] [decimal] (18, 6) NULL,
[FactTicketSalesId] [bigint] NULL,
[FactAttendanceId] [bigint] NULL,
[FactTicketActivityId_Resold] [bigint] NULL,
[FactTicketActivityId_Tranferred] [bigint] NULL,
[FactOdetId] [bigint] NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FactAvailSeatsId] [bigint] NULL,
[FactHeldSeatsId] [bigint] NULL
)
WITH
(
DATA_COMPRESSION = PAGE
)
GO
ALTER TABLE [dbo].[FactInventory_V2] ADD CONSTRAINT [PK_dbo__FactInventory_V2] PRIMARY KEY CLUSTERED  ([FactInventoryId]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IX_DimEventId] ON [dbo].[FactInventory_V2] ([DimEventId]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IX_DimSeasonId] ON [dbo].[FactInventory_V2] ([DimSeasonId]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IX_DimSeatId] ON [dbo].[FactInventory_V2] ([DimSeatId]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IX_DimSeatStatusid] ON [dbo].[FactInventory_V2] ([DimSeatStatusId]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IX_TM_Key] ON [dbo].[FactInventory_V2] ([ETL__SourceSystem], [ETL__SSID_TM_event_id], [ETL__SSID_TM_section_id], [ETL__SSID_TM_row_id], [ETL__SSID_TM_seat]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IX_ETL_UpdatedDate] ON [dbo].[FactInventory_V2] ([ETL__UpdatedDate] DESC)
GO
CREATE NONCLUSTERED INDEX [IX_FactAttendanceId] ON [dbo].[FactInventory_V2] ([FactAttendanceId]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [NCIX_FactInventory_V2_FactAvailSeatsId_DimSeatStatusId] ON [dbo].[FactInventory_V2] ([FactAvailSeatsId], [DimSeatStatusId]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IX_FactOdetId] ON [dbo].[FactInventory_V2] ([FactOdetId]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IX_FactTicketActivityId_Resold] ON [dbo].[FactInventory_V2] ([FactTicketActivityId_Resold]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IX_FactTicketActivityId_Tranferred] ON [dbo].[FactInventory_V2] ([FactTicketActivityId_Tranferred]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IX_FactTicketSalesId] ON [dbo].[FactInventory_V2] ([FactTicketSalesId]) WITH (DATA_COMPRESSION = PAGE)
GO
