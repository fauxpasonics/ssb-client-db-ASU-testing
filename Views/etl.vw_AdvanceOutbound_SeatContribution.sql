SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*****	Revision History

DCH on 2018-07-16	-	need to explicitly cast EmailPrimary as nvarchar(256) due to changes in dbo.vwDimCustomer_ModAcctID

*****/


CREATE VIEW [etl].[vw_AdvanceOutbound_SeatContribution]
AS
(

	SELECT
		j.journal_Seq_id TransactionId
		, j.stamp [Date]
		, 'SC' + LEFT(j.event_name,2) AS CampaignCode
		, CASE WHEN j.event_name like '%FB%' THEN 'Football'
			   WHEN j.event_name like '%BB%' THEN 'Mens Basketball'
			   WHEN j.event_name like '%HO%' THEN 'Mens Hockey'
			   ELSE 'Unknown' END AS TicketSport
		, j.event_name Item
		, [type_desc] AS TransactionType
		, payment_type_desc PayType
		, j.cc_type PayMode
		, NULL CheckNumber -- I don't see this
		, j.debit PledgeAmount
		, j.credit_applied PaymentAmount
		, j.acct_id TM_AccountId
		, order_num
		, order_line_item
		, order_line_item_seq
		, info
		, dc.CompanyName
		, dc.FirstName
		, dc.MiddleName
		, dc.LastName
		, dc.Suffix
		, CAST(dc.EmailPrimary as nvarchar(256)) as EmailPrimary
		, dc.PhonePrimary
		, dc.AddressPrimaryStreet
		, CAST(dc.AddressPrimarySuite AS NVARCHAR(25)) AddressPrimarySuite
		, dc.AddressPrimaryCity
		, dc.AddressPrimaryState
		, dc.AddressPrimaryZip
	FROM ods.TM_Journal j (NOLOCK)
	LEFT JOIN [dbo].[vwDimCustomer_ModAcctId] dc 
		ON CAST(j.acct_id AS NVARCHAR(25)) = dc.AccountId 
		AND dc.SourceSystem = 'TM'
		AND dc.CustomerType = 'Primary'
	WHERE 1=1
	AND event_name IN (select distinct fund_name --This subquery controls what funds we send gift data for. This should not be changed without authorization from ASU
					   from ods.TM_Donation d (NOLOCK) 
					   where (d.fund_name LIKE '%FB%' --football
							  OR d.fund_name LIKE '%BB%' --men's basketball
							  OR d.fund_name LIKE '%HO%' --Hockey added 1/1/2018 by AMEITIN
							  OR d.fund_name LIKE '%FSAF' --FSAF added 1/1/2018 by AMEITIN
							  /*OR d.fund_name LIKE '%FPMF' --FPMF added 4/10/2018 by KSNIFFIN*/
							  )
						) 
	


)





GO
