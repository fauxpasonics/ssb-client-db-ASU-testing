CREATE TABLE [ods].[TM_Class]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[class_id] [int] NULL,
[name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_datetime] [datetime] NULL,
[matrix_char] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[color] [int] NULL,
[return_class_id] [int] NULL,
[killed] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[valid_for_reclass] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dist_status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dist_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dist_ett] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ism_class_id] [int] NULL,
[qualifier_state_names] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[system_class] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qualifier_template] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[unsold_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[unsold_qual_id] [int] NULL,
[attrib_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attrib_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kill] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qualifier_state_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__TM_Class] ON [ods].[TM_Class]
GO
