CREATE TABLE [ods].[TM_CustAttrib]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[acct_id] [int] NULL,
[cust_name_id] [int] NULL,
[attrib_id] [int] NULL,
[attrib_seq_num] [int] NULL,
[Category] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attrib_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attrib_value] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attrib_comment] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_datetime] [datetime] NULL,
[upd_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[TM_CustAttrib] ADD CONSTRAINT [PK__TM_CustA__3213E83FA40CD818] PRIMARY KEY CLUSTERED  ([id])
GO
