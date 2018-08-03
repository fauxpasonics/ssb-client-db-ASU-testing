CREATE TABLE [ods].[TM_Season]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[season_id] [int] NULL,
[name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[arena_id] [int] NULL,
[manifest_id] [int] NULL,
[add_datetime] [datetime] NULL,
[upd_datetime] [datetime] NULL,
[upd_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[season_year] [int] NULL,
[org_id] [int] NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__TM_Season] ON [ods].[TM_Season]
GO
