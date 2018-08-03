SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE PROC [dbo].[rptCustSDC_SeatContributionTransactions_Ticketmaster_bk] 

(
	@StartDate DATETIME,
	@EndDate DATETIME  
)
AS

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT
	 j.stamp [Date]
	,'SC' + LEFT(j.event_name,2) TicketYear
	, CASE WHEN j.event_name LIKE '%FB%' THEN 'Football'
			   WHEN j.event_name LIKE '%BB%' THEN 'Mens Basketball'
			   ELSE 'Unknown' END AS TicketSport
	,j.acct_id TM_AccountId 
	,NULL AS FullName
	,j.event_name FundName
	,NULL FundDesc
	,j.cc_type PayMode
	,j.payment_type_desc PayType
	,NULL AS Notes
	,j.credit_applied PaymentAmount 


FROM ods.TM_Journal j (NOLOCK)
	LEFT JOIN [dbo].[vwDimCustomer_ModAcctId] dc 
		ON CAST(j.acct_id AS NVARCHAR(25)) = dc.AccountId 
		AND dc.CustomerType = 'Primary'
	WHERE 1=1
	AND event_name IN (SELECT DISTINCT fund_name FROM ods.TM_Donation d (NOLOCK) WHERE (d.fund_name LIKE '%FB%' OR d.fund_name LIKE '%BB%'))
	--AND j.stamp >= @StartDate AND j.stamp <= @EndDate
	AND j.cc_type NOT LIKE 'Z%'
	AND j.cc_type NOT IN ('PD', 'SD', 'UF', 'JE')

ORDER BY j.stamp 

END 












GO
