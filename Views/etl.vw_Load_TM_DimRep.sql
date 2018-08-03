SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_TM_DimRep] AS (

SELECT 

	cr.acct_rep_id ETL__SSID
	, acct_rep_id ETL__SSID_TM_acct_id
	, REPLACE(CONCAT(c.name_first, ' ', c.name_mi, ' ', c.name_last), '  ', ' ') FullName
	, CAST(ca.name_prefix AS NVARCHAR(100)) Prefix
	, c.name_first FirstName
	, c.name_mi MiddleName
	, c.name_last LastName
	, CAST(ca.name_suffix AS NVARCHAR(100)) Suffix


FROM (
	SELECT DISTINCT acct_rep_id
	FROM ods.TM_CustRep (NOLOCK)
) cr 
LEFT OUTER JOIN ods.TM_Cust (NOLOCK) c ON cr.acct_rep_id = c.acct_id AND c.Primary_code = 'Primary'
LEFT OUTER JOIN (

	SELECT ca.acct_id, ca.cust_name_id, ca.name_prefix, ca.name_suffix
	FROM (
		SELECT DISTINCT ca.acct_id, ca.cust_name_id, ca.name_prefix, ca.name_suffix
		, ROW_NUMBER() OVER(PARTITION BY ca.acct_id, ca.cust_name_id ORDER BY ca.primary_ind DESC, ca.UpdateDate DESC) RowRank
		FROM ods.TM_CustAddress (NOLOCK) ca
	) ca
	WHERE ca.RowRank = 1

) ca ON c.acct_id = ca.acct_id AND c.cust_name_id = ca.cust_name_id

)

GO
