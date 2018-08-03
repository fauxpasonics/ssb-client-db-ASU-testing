CREATE TABLE [dbo].[DimSeat_V2]
(
[DimSeatId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__UpdatedDate] [datetime] NOT NULL,
[ETL__IsDeleted] [bit] NOT NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__SSID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__SSID_PAC_SEASON] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_LEVEL] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_SECTION] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_ROW] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_PAC_SEAT] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
[ETL__SSID_TM_manifest_id] [int] NULL,
[ETL__SSID_TM_section_id] [int] NULL,
[ETL__SSID_TM_row_id] [int] NULL,
[ETL__SSID_TM_seat] [int] NULL,
[Season] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LevelName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SectionName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seat] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultPriceLevel] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_Location] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DefaultClass] [int] NULL,
[DefaultPriceCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SortOrderLevel] [int] NULL,
[SortOrderSection] [int] NULL,
[SortOrderRow] [int] NULL,
[SortOrderSeat] [int] NULL,
[LevelDesc] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SectionDesc] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowDesc] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_ClosestDimGateId] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_IsCapacityEligible] [bit] NULL,
[Config_LevelName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_SectionName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_RowName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_Category1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_Category2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_Category3] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_Category4] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_Category5] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_IsFactInventoryEligible] [bit] NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[UpdatedDate] [datetime] NULL,
[Custom_Int_1] [int] NULL,
[Custom_Int_2] [int] NULL,
[Custom_Int_3] [int] NULL,
[Custom_Int_4] [int] NULL,
[Custom_Int_5] [int] NULL,
[Custom_Dec_1] [decimal] (18, 6) NULL,
[Custom_Dec_2] [decimal] (18, 6) NULL,
[Custom_Dec_3] [decimal] (18, 6) NULL,
[Custom_Dec_4] [decimal] (18, 6) NULL,
[Custom_Dec_5] [decimal] (18, 6) NULL,
[Custom_DateTime_1] [datetime] NULL,
[Custom_DateTime_2] [datetime] NULL,
[Custom_DateTime_3] [datetime] NULL,
[Custom_DateTime_4] [datetime] NULL,
[Custom_DateTime_5] [datetime] NULL,
[Custom_Bit_1] [bit] NULL,
[Custom_Bit_2] [bit] NULL,
[Custom_Bit_3] [bit] NULL,
[Custom_Bit_4] [bit] NULL,
[Custom_Bit_5] [bit] NULL,
[Custom_nVarChar_1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom_nVarChar_2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom_nVarChar_3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom_nVarChar_4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom_nVarChar_5] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_section_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_section_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_section_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_section_type_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_gate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_ga] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_row_id] [int] NULL,
[TM_row_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_row_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_default_class] [int] NULL,
[TM_class_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_def_price_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_tm_section_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_tm_row_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_section_info1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_section_info2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_section_info3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_section_info4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_section_info5] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_row_info1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_row_info2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_row_info3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_row_info4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_row_info5] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_manifest_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_aisle] [smallint] NULL
)
WITH
(
DATA_COMPRESSION = PAGE
)
GO
ALTER TABLE [dbo].[DimSeat_V2] ADD CONSTRAINT [PK_dbo__DimSeat_V2] PRIMARY KEY CLUSTERED  ([DimSeatId]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [DimSeat_SeatId] ON [dbo].[DimSeat_V2] ([DimSeatId]) INCLUDE ([RowName], [SectionName])
GO
CREATE NONCLUSTERED INDEX [IX_ETL__IsDeleted] ON [dbo].[DimSeat_V2] ([ETL__IsDeleted]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IX_ETL__SourceSystem] ON [dbo].[DimSeat_V2] ([ETL__SourceSystem]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [NCIX_DimCustomer_ETL__SourceSystem_ETL__SSID_TM_section_id_ETL__SSID_TM_row_id_ETL__SSID_TM_seat] ON [dbo].[DimSeat_V2] ([ETL__SourceSystem], [ETL__SSID_TM_section_id], [ETL__SSID_TM_row_id], [ETL__SSID_TM_seat]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IX_KEY_PAC] ON [dbo].[DimSeat_V2] ([ETL__SSID_PAC_SEASON], [ETL__SSID_PAC_LEVEL], [ETL__SSID_PAC_SECTION], [ETL__SSID_PAC_ROW], [ETL__SSID_PAC_SEAT]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IX_KEY_TM] ON [dbo].[DimSeat_V2] ([ETL__SSID_TM_manifest_id], [ETL__SSID_TM_section_id], [ETL__SSID_TM_row_id], [ETL__SSID_TM_seat]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IX_ETL__UpdatedDate] ON [dbo].[DimSeat_V2] ([ETL__UpdatedDate] DESC) WITH (DATA_COMPRESSION = PAGE)
GO
