SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
-- Get the status of your table 20 minutes ago...
DECLARE @AsOfDate DATETIME = (SELECT [etl].[ConvertToLocalTime](DATEADD(MINUTE,-20,GETDATE())))
SELECT * FROM [ods].[AsOf_TM_CustomerUpdate_AfterUpdate] (@AsOfDate)
*/

CREATE FUNCTION [ods].[AsOf_TM_CustomerUpdate_AfterUpdate] (@AsOfDate DATETIME)

RETURNS @Results TABLE
(
[multi_query_value_for_audit] [nvarchar](100) NULL,
[AccountId] [nvarchar](25) NULL,
[acct_id] [int] NULL,
[cust_name_id] [int] NULL,
[rec_status] [nvarchar](25) NULL,
[acct_type] [nvarchar](50) NULL,
[company_name] [nvarchar](255) NULL,
[name_first] [nvarchar](100) NULL,
[name_mi] [nvarchar](100) NULL,
[name_last] [nvarchar](50) NULL,
[title] [nvarchar](100) NULL,
[street_addr_1] [nvarchar](100) NULL,
[street_addr_2] [nvarchar](100) NULL,
[city] [nvarchar](25) NULL,
[state] [nvarchar](25) NULL,
[zip] [nvarchar](25) NULL,
[country] [nvarchar](25) NULL,
[phone_day] [nvarchar](25) NULL,
[phone_eve] [nvarchar](25) NULL,
[phone_fax] [nvarchar](100) NULL,
[phone_cell] [nvarchar](100) NULL,
[priority] [int] NULL,
[points_YTD] [decimal](18, 2) NULL,
[points_ITD] [decimal](18, 2) NULL,
[email] [nvarchar](100) NULL,
[add_date] [date] NULL,
[name_type] [nvarchar](25) NULL,
[owner_name] [nvarchar](250) NULL,
[birth_date] [date] NULL,
[gender] [nvarchar](10) NULL,
[other_info_1] [nvarchar](100) NULL,
[other_info_2] [nvarchar](100) NULL,
[other_info_3] [nvarchar](100) NULL,
[other_info_4] [nvarchar](100) NULL,
[other_info_5] [nvarchar](100) NULL,
[other_info_6] [nvarchar](100) NULL,
[other_info_7] [nvarchar](100) NULL,
[other_info_8] [nvarchar](100) NULL,
[other_info_9] [nvarchar](100) NULL,
[other_info_10] [nvarchar](100) NULL,
[rank] [int] NULL,
[text_on_mobile_phone] [nvarchar](25) NULL,
[total_donation_amount] [decimal](18, 2) NULL,
[ITD_donations] [decimal](18, 2) NULL,
[honorary_donor] [nvarchar](25) NULL,
[acct_access_level] [nvarchar](25) NULL,
[qualified_donation_amount] [decimal](18, 2) NULL,
[phone_day_do_not_solicit] [nvarchar](25) NULL,
[phone_eve_do_not_solicit] [nvarchar](25) NULL,
[phone_cell_do_not_solicit] [nvarchar](25) NULL,
[phone_fax_do_not_solicit] [nvarchar](10) NULL,
[email_deliv_opt] [nvarchar](25) NULL,
[email_optout] [nvarchar](25) NULL,
[logon_attempts] [int] NULL,
[result] [nvarchar](100) NULL,
[change_pin] [int] NULL,
[account_id_list] [int] NULL,
[sql_code] [nvarchar](25) NULL,
[cmd] [nvarchar](100) NULL,
[ETL_CreatedOn] [datetime] NOT NULL,
[ETL_CreatedBy] NVARCHAR(400) NOT NULL,
[ETL_UpdatedOn] [datetime] NOT NULL,
[ETL_UpdatedBy] NVARCHAR(400) NOT NULL
)

AS
BEGIN

DECLARE @EndDate DATETIME = (SELECT [etl].[ConvertToLocalTime](CAST(GETDATE() AS datetime2(0))))
SET @AsOfDate = (SELECT CAST(@AsOfDate AS datetime2(0)))

INSERT INTO @Results
SELECT [multi_query_value_for_audit],[AccountId],[acct_id],[cust_name_id],[rec_status],[acct_type],[company_name],[name_first],[name_mi],[name_last],[title],[street_addr_1],[street_addr_2],[city],[state],[zip],[country],[phone_day],[phone_eve],[phone_fax],[phone_cell],[priority],[points_YTD],[points_ITD],[email],[add_date],[name_type],[owner_name],[birth_date],[gender],[other_info_1],[other_info_2],[other_info_3],[other_info_4],[other_info_5],[other_info_6],[other_info_7],[other_info_8],[other_info_9],[other_info_10],[rank],[text_on_mobile_phone],[total_donation_amount],[ITD_donations],[honorary_donor],[acct_access_level],[qualified_donation_amount],[phone_day_do_not_solicit],[phone_eve_do_not_solicit],[phone_cell_do_not_solicit],[phone_fax_do_not_solicit],[email_deliv_opt],[email_optout],[logon_attempts],[result],[change_pin],[account_id_list],[sql_code],[cmd],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy]
FROM
	(
	SELECT [multi_query_value_for_audit],[AccountId],[acct_id],[cust_name_id],[rec_status],[acct_type],[company_name],[name_first],[name_mi],[name_last],[title],[street_addr_1],[street_addr_2],[city],[state],[zip],[country],[phone_day],[phone_eve],[phone_fax],[phone_cell],[priority],[points_YTD],[points_ITD],[email],[add_date],[name_type],[owner_name],[birth_date],[gender],[other_info_1],[other_info_2],[other_info_3],[other_info_4],[other_info_5],[other_info_6],[other_info_7],[other_info_8],[other_info_9],[other_info_10],[rank],[text_on_mobile_phone],[total_donation_amount],[ITD_donations],[honorary_donor],[acct_access_level],[qualified_donation_amount],[phone_day_do_not_solicit],[phone_eve_do_not_solicit],[phone_cell_do_not_solicit],[phone_fax_do_not_solicit],[email_deliv_opt],[email_optout],[logon_attempts],[result],[change_pin],[account_id_list],[sql_code],[cmd],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],@EndDate [RecordEndDate]
	FROM [ods].[TM_CustomerUpdate_AfterUpdate] t
	UNION ALL
	SELECT [multi_query_value_for_audit],[AccountId],[acct_id],[cust_name_id],[rec_status],[acct_type],[company_name],[name_first],[name_mi],[name_last],[title],[street_addr_1],[street_addr_2],[city],[state],[zip],[country],[phone_day],[phone_eve],[phone_fax],[phone_cell],[priority],[points_YTD],[points_ITD],[email],[add_date],[name_type],[owner_name],[birth_date],[gender],[other_info_1],[other_info_2],[other_info_3],[other_info_4],[other_info_5],[other_info_6],[other_info_7],[other_info_8],[other_info_9],[other_info_10],[rank],[text_on_mobile_phone],[total_donation_amount],[ITD_donations],[honorary_donor],[acct_access_level],[qualified_donation_amount],[phone_day_do_not_solicit],[phone_eve_do_not_solicit],[phone_cell_do_not_solicit],[phone_fax_do_not_solicit],[email_deliv_opt],[email_optout],[logon_attempts],[result],[change_pin],[account_id_list],[sql_code],[cmd],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],[RecordEndDate]
	FROM [ods].[Snapshot_TM_CustomerUpdate_AfterUpdate]
	) a
WHERE
	@AsOfDate BETWEEN [ETL_UpdatedOn] AND [RecordEndDate]
	AND [ETL_CreatedOn] <= @AsOfDate

RETURN

END
GO
