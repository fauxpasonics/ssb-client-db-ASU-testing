SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_TM_CustRep_SCD] AS (
	SELECT CAST('etl.vw_TM_CustRep_SCD' AS NVARCHAR(255)) ETL__Source
		, acct_id, acct_rep_type, acct_rep_id
		--, UpdatedDate	
	FROM stg.TM_CustRep (NOLOCK)
	WHERE ISNULL(acct_rep_type,'') <> ''
)

GO
