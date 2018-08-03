SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO













CREATE VIEW [etl].[vw_AdvanceOutbound_TM_UserDefinedFields] AS 

select DISTINCT
a.acct_id
, a.other_info_1
, a.other_info_2
, a.other_info_3
, a.other_info_4
, a.other_info_5
, a.other_info_6
, a.other_info_7
, a.other_info_8
FROM ods.AdvanceOutbound_TM_UserDefinedFields a 
INNER JOIN ods.TM_CUST c (NOLOCK) on a.acct_id = c.acct_id AND c.Primary_code = 'Primary'
WHERE c.acct_id = '4264598'
OR (a.other_info_1 <> c.other_info_1
OR a.other_info_2 <> c.other_info_2
OR a.other_info_3 <> c.other_info_3
OR a.other_info_4 <> c.other_info_4
OR a.other_info_5 <> c.other_info_5
OR a.other_info_6 <> c.other_info_6
OR a.other_info_7 <> c.other_info_7
OR a.other_info_8 <> c.other_info_8)




GO
