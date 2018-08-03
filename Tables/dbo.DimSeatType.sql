CREATE TABLE [dbo].[DimSeatType]
(
[DimSeatTypeId] [int] NOT NULL IDENTITY(1, 1),
[ETL__SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__DimSeatTy__ETL____1D472152] DEFAULT (suser_name()),
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimSeatTy__ETL____1E3B458B] DEFAULT (getdate()),
[ETL__StartDate] [datetime] NOT NULL CONSTRAINT [DF__DimSeatTy__ETL____1F2F69C4] DEFAULT (getdate()),
[ETL__EndDate] [datetime] NULL,
[SeatTypeCode] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeatTypeName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeatTypeDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeatTypeClass] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
