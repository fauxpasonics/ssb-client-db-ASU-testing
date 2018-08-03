SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [preods].[TM_CustomerUpdate_PostObjects]
AS

SELECT DISTINCT
	CONVERT(NVARCHAR(100),[ETL__multi_query_value_for_audit]) [multi_query_value_for_audit_K]
	,CONVERT(INT,[AccountId]) [AccountId_K]
	,CONVERT(NVARCHAR(MAX),[Errors_ApiSqlCode]) [Errors_ApiSqlCode]
	,CONVERT(NVARCHAR(MAX),[Errors_BeforeUpdate]) [Errors_BeforeUpdate]
	,CONVERT(INT,[PostObject_acct_id]) [acct_id]
	,CONVERT(INT,[PostObject_cust_name_id]) [cust_name_id]
--rec_status
	,CONVERT(NVARCHAR(50),[PostObject_acct_type]) [acct_type]
	,CONVERT(NVARCHAR(255),[PostObject_company_name]) [company_name]
	,CONVERT(NVARCHAR(100),[PostObject_name_first]) [name_first]
	,CONVERT(NVARCHAR(100),[PostObject_name_mi]) [name_mi]
	,CONVERT(NVARCHAR(100),[PostObject_name_last]) [name_last]
	,CONVERT(NVARCHAR(100),[PostObject_title]) [title]
	,CONVERT(NVARCHAR(100),[PostObject_street_addr_1]) [street_addr_1]
	,CONVERT(NVARCHAR(100),[PostObject_street_addr_2]) [street_addr_2]
	,CONVERT(NVARCHAR(100),[PostObject_city]) [city]
	,CONVERT(NVARCHAR(25),[PostObject_state]) [state]
	,CONVERT(NVARCHAR(25),[PostObject_zip]) [zip]
	,CONVERT(NVARCHAR(25),[PostObject_country]) [country]
	,CONVERT(NVARCHAR(100),[PostObject_phone_day]) [phone_day]
	,CONVERT(NVARCHAR(100),[PostObject_phone_eve]) [phone_eve]
	,CONVERT(NVARCHAR(100),[PostObject_phone_fax]) [phone_fax]
	,CONVERT(NVARCHAR(100),[PostObject_phone_cell]) [phone_cell]
--priority
	,CONVERT(DECIMAL(18,2),[PostObject_points_YTD]) [points_YTD]
	,CONVERT(DECIMAL(18,2),[PostObject_points_ITD]) [points_ITD]
	,CONVERT(NVARCHAR(100),[PostObject_email]) [email]
	,CONVERT(DATE,[PostObject_add_date]) [add_date]
	,CONVERT(NVARCHAR(25),[PostObject_name_type]) [name_type]
	,CONVERT(NVARCHAR(250),[PostObject_owner_name]) [owner_name]
	,CONVERT(DATE,[PostObject_birth_date]) [birth_date]
	,CONVERT(NVARCHAR(10),[PostObject_gender]) [gender]
	,CONVERT(NVARCHAR(100),[PostObject_other_info_1]) [other_info_1]
	,CONVERT(NVARCHAR(100),[PostObject_other_info_2]) [other_info_2]
	,CONVERT(NVARCHAR(100),[PostObject_other_info_3]) [other_info_3]
	,CONVERT(NVARCHAR(100),[PostObject_other_info_4]) [other_info_4]
	,CONVERT(NVARCHAR(100),[PostObject_other_info_5]) [other_info_5]
	,CONVERT(NVARCHAR(100),[PostObject_other_info_6]) [other_info_6]
	,CONVERT(NVARCHAR(100),[PostObject_other_info_7]) [other_info_7]
	,CONVERT(NVARCHAR(100),[PostObject_other_info_8]) [other_info_8]
	,CONVERT(NVARCHAR(100),[PostObject_other_info_9]) [other_info_9]
	,CONVERT(NVARCHAR(100),[PostObject_other_info_10]) [other_info_10]
--rank
	,CONVERT(NVARCHAR(25),[PostObject_text_on_mobile_phone]) [text_on_mobile_phone]
	,CONVERT(DECIMAL(18,2),[PostObject_total_donation_amount]) [total_donation_amount]
	,CONVERT(DECIMAL(18,2),[PostObject_ITD_donations]) [ITD_donations]
	,CONVERT(NVARCHAR(25),[PostObject_honorary_donor]) [honorary_donor]
	,CONVERT(NVARCHAR(25),[PostObject_acct_access_level]) [acct_access_level]
	,CONVERT(DECIMAL(18,2),[PostObject_qualified_donation_amount]) [qualified_donation_amount]
	,CONVERT(NVARCHAR(25),[PostObject_phone_day_do_not_solicit]) [phone_day_do_not_solicit]	
	,CONVERT(NVARCHAR(25),[PostObject_phone_eve_do_not_solicit]) [phone_eve_do_not_solicit]
	,CONVERT(NVARCHAR(25),[PostObject_phone_cell_do_not_solicit]) [phone_cell_do_not_solicit]
	,CONVERT(NVARCHAR(10),[PostObject_phone_fax_do_not_solicit]) [phone_fax_do_not_solicit]
	,CONVERT(NVARCHAR(25),[PostObject_email_deliv_opt]) [email_deliv_opt]
	,CONVERT(NVARCHAR(25),[PostObject_email_optout]) [email_optout]
	,CONVERT(NVARCHAR(100),[PostObject_cmd]) [cmd]
FROM [src].[TM_CustomerUpdate_Before] WITH (NOLOCK)
WHERE  [PostObject_acct_id] IS NOT NULL
GO
