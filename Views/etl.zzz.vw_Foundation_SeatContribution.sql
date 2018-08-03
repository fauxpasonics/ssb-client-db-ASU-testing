SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[zzz.vw_Foundation_SeatContribution]
AS
(

	SELECT
		j.journal_Seq_id TransactionId
		, j.stamp [Date]
		, NULL Season --to do?
		, d.drive_year TicketYear
		, CASE WHEN d.fund_name like '%FB%' THEN 'Football'
			   WHEN d.fund_name like '%BB%' THEN 'Mens Basketball'
			   ELSE 'Unknown' END AS TicketSport
		, d.fund_name Item
		, payment_type_desc PayType
		, j.cc_type PayMode
		, NULL CheckNumber -- I don't see this
		, j.credit_applied PaymentAmount
		--, j.ledger_code
		--,j.*, d.*
		, j.acct_id TM_AccountId
		, dc.FirstName
		, dc.MiddleName
		, dc.LastName
		, dc.Suffix
		, dc.EmailPrimary
		, dc.PhonePrimary
		, dc.AddressPrimaryStreet
		, CAST(dc.AddressPrimarySuite AS NVARCHAR(25)) AddressPrimarySuite
		, dc.AddressPrimaryCity
		, dc.AddressPrimaryState
		, dc.AddressPrimaryZip
	FROM ods.TM_Journal j (NOLOCK)
	INNER JOIN ods.TM_Donation d (NOLOCK)
		ON d.acct_id = j.acct_id 
		AND d.order_num = j.order_num 
		AND d.order_line_item = j.order_line_item 
		AND d.order_line_item_seq = j.order_line_item_seq
	LEFT JOIN [dbo].[vwDimCustomer_ModAcctId] dc 
		ON CAST(j.acct_id AS NVARCHAR(25)) = dc.AccountId 
		AND dc.CustomerType = 'Primary'
	WHERE 1=1
	AND (j.credit <> 0 OR j.credit_applied <> 0)
	AND j.cc_type NOT LIKE 'Z%'
	AND j.cc_type NOT IN ('SD', 'PD')
	AND (d.fund_name LIKE '%FB%' OR d.fund_name LIKE '%BB%')
	AND d.active = 'Y'

)

GO
