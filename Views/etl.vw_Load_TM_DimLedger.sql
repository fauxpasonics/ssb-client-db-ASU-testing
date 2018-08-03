SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_TM_DimLedger] AS (

SELECT  
        l.ledger_id AS ETL__SSID 
      , l.ledger_id AS ETL__SSID_TM_ledger_id
      , l.ledger_code AS LedgerCode
      , l.ledger_name AS LedgerName
      , l.ledger_name AS LedgerDesc
      
	  , CAST(CASE WHEN ISNULL(l.active, '') = 'N' THEN 0 ELSE 1 END AS BIT) IsActive
	  , l.gl_code_payment [TM_gl_code_payment]
	  , l.gl_code_refund [TM_gl_code_refund]

FROM    ods.TM_Ledger l (NOLOCK)

)




GO
