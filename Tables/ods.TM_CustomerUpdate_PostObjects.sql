CREATE TABLE [ods].[TM_CustomerUpdate_PostObjects]
(
[multi_query_value_for_audit] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountId] [int] NOT NULL,
[Errors_ApiSqlCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Errors_BeforeUpdate] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_id] [int] NULL,
[cust_name_id] [int] NULL,
[acct_type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[company_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_first] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_mi] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_last] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[title] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[street_addr_1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[street_addr_2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[country] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_day] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_eve] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_fax] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_cell] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[points_YTD] [decimal] (18, 2) NULL,
[points_ITD] [decimal] (18, 2) NULL,
[email] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_date] [date] NULL,
[name_type] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[owner_name] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[birth_date] [date] NULL,
[gender] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_1] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_2] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_3] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_4] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_5] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_6] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_7] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_8] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_9] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_10] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_on_mobile_phone] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[total_donation_amount] [decimal] (18, 2) NULL,
[ITD_donations] [decimal] (18, 2) NULL,
[honorary_donor] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_access_level] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qualified_donation_amount] [decimal] (18, 2) NULL,
[phone_day_do_not_solicit] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_eve_do_not_solicit] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_cell_do_not_solicit] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phone_fax_do_not_solicit] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email_deliv_opt] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email_optout] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cmd] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedOn] [datetime] NOT NULL CONSTRAINT [DF__TM_Custom__ETL_C__33CC5840] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__TM_Custom__ETL_C__34C07C79] DEFAULT (suser_sname()),
[ETL_UpdatedOn] [datetime] NOT NULL CONSTRAINT [DF__TM_Custom__ETL_U__35B4A0B2] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__TM_Custom__ETL_U__36A8C4EB] DEFAULT (suser_sname())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----------- CREATE TRIGGER -----------
CREATE TRIGGER [ods].[Snapshot_TM_CustomerUpdate_PostObjectsUpdate] ON [ods].[TM_CustomerUpdate_PostObjects]
AFTER UPDATE, DELETE

AS
BEGIN

DECLARE @ETL_UpdatedOn DATETIME = (SELECT [etl].[ConvertToLocalTime](CAST(GETDATE() AS DATETIME2(0))))
DECLARE @ETL_UpdatedBy NVARCHAR(400) = (SELECT SYSTEM_USER)

UPDATE t SET
[ETL_UpdatedOn] = @ETL_UpdatedOn
,[ETL_UpdatedBy] = @ETL_UpdatedBy
FROM [ods].[TM_CustomerUpdate_PostObjects] t
	JOIN inserted i ON  t.[multi_query_value_for_audit] = i.[multi_query_value_for_audit] AND t.[AccountId] = i.[AccountId]

INSERT INTO [ods].[Snapshot_TM_CustomerUpdate_PostObjects] ([multi_query_value_for_audit],[AccountId],[Errors_ApiSqlCode],[Errors_BeforeUpdate],[acct_id],[cust_name_id],[acct_type],[company_name],[name_first],[name_mi],[name_last],[title],[street_addr_1],[street_addr_2],[city],[state],[zip],[country],[phone_day],[phone_eve],[phone_fax],[phone_cell],[points_YTD],[points_ITD],[email],[add_date],[name_type],[owner_name],[birth_date],[gender],[other_info_1],[other_info_2],[other_info_3],[other_info_4],[other_info_5],[other_info_6],[other_info_7],[other_info_8],[other_info_9],[other_info_10],[text_on_mobile_phone],[total_donation_amount],[ITD_donations],[honorary_donor],[acct_access_level],[qualified_donation_amount],[phone_day_do_not_solicit],[phone_eve_do_not_solicit],[phone_cell_do_not_solicit],[phone_fax_do_not_solicit],[email_deliv_opt],[email_optout],[cmd],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],[RecordEndDate])
SELECT a.*,dateadd(s,-1,@ETL_UpdatedOn)
FROM deleted a

END
GO
ALTER TABLE [ods].[TM_CustomerUpdate_PostObjects] ADD CONSTRAINT [PK__TM_Custo__0658F94929292AB0] PRIMARY KEY CLUSTERED  ([multi_query_value_for_audit], [AccountId])
GO
