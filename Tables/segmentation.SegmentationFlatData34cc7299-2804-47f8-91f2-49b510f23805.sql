CREATE TABLE [segmentation].[SegmentationFlatData34cc7299-2804-47f8-91f2-49b510f23805]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerSourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ExtAttribute1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtAttribute2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtAttribute3] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtAttribute4] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtAttribute5] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtAttribute6] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtAttribute7] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtAttribute8] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtAttribute9] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtAttribute10] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExtAttribute11] [decimal] (18, 6) NULL,
[ExtAttribute12] [decimal] (18, 6) NULL,
[ExtAttribute13] [decimal] (18, 6) NULL,
[ExtAttribute14] [decimal] (18, 6) NULL,
[ExtAttribute15] [decimal] (18, 6) NULL,
[ExtAttribute16] [decimal] (18, 6) NULL,
[ExtAttribute17] [decimal] (18, 6) NULL,
[ExtAttribute18] [decimal] (18, 6) NULL,
[ExtAttribute19] [decimal] (18, 6) NULL,
[ExtAttribute20] [decimal] (18, 6) NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatData34cc7299-2804-47f8-91f2-49b510f23805] ADD CONSTRAINT [pk_SegmentationFlatData34cc7299-2804-47f8-91f2-49b510f23805] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatData34cc7299-2804-47f8-91f2-49b510f23805] ON [segmentation].[SegmentationFlatData34cc7299-2804-47f8-91f2-49b510f23805] ([_rn])
GO
