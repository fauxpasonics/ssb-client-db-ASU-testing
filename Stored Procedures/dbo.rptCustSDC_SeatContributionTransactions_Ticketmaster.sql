SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO













CREATE PROC [dbo].[rptCustSDC_SeatContributionTransactions_Ticketmaster] 

(
	@StartDate DATETIME,
	@EndDate DATETIME  
)
AS

BEGIN

--DECLARE @StartDate DATETIME
--DECLARE @EndDate DATETIME  
--SET @StartDate = '09/01/2017'
--SET @EndDate = '09/30/2017'

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT
		j.TransactionId
		, CAST(j.[Date] AS DATE) [Date]
		, j.CampaignCode
		, j.TicketSport
		, j.Item
		, j.TransactionType
		, j.PayType
		, j.PayMode
		, j.CheckNumber -- I don't see this
		, j.PledgeAmount
		, j.PaymentAmount
		, j.TM_AccountId
		, order_num
		, order_line_item
		, order_line_item_seq
		, info
		, oid.ID_NUMBER AS SDP_AdvanceId
		, j.CompanyName
		, j.FirstName
		, j.MiddleName
		, j.LastName
		, j.Suffix
		, j.EmailPrimary
		, j.PhonePrimary
		, j.AddressPrimaryStreet
		, j.AddressPrimarySuite
		, j.AddressPrimaryCity
		, j.AddressPrimaryState
		, j.AddressPrimaryZip
	FROM [etl].[vw_AdvanceOutbound_SeatContribution] j
	LEFT JOIN [dbo].[FD_SDA_ENTITY_OTHER_IDS] oid (NOLOCK)
		ON oid.OTHER_ID = CAST(j.TM_AccountId AS NVARCHAR) AND oid.TYPE_CODE = 'SDP'
	WHERE 1=1
	AND (j.PayMode NOT LIKE 'Z%' --excludes Paciolan paymodes 
	AND j.PayMode NOT IN ('PD', 'SD', 'UF', 'JE') --excludes paymodes where money is deposited by ASUF 
    OR (j.PayMode LIKE 'Z%' AND j.[Date] > '8/31/2017')) --brings in Paciolan paymodes after defined date. 9/1/2017 was chosen as safest date when majority of conversion changes were completed.
	AND j.[Date] >= @StartDate AND j.[Date] <= @EndDate


ORDER BY j.[Date]

END 














GO
