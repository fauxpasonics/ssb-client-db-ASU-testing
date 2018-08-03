SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO















CREATE PROC [dbo].[rptCustSDC_AdvanceIDReview_20180222] 

AS

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DISTINCT 
x.TM_AccountId
		, x.SDP_AdvanceId
		, x.CompanyName
		, x.FirstName
		, x.MiddleName
		, x.LastName
		, x.Suffix
		, x.EmailPrimary
		, x.PhonePrimary
		, x.AddressPrimaryStreet
		, x.AddressPrimarySuite
		, x.AddressPrimaryCity
		, x.AddressPrimaryState
		, x.AddressPrimaryZip
		, MAX(x.[Date]) AS MostRecentTransactionDate
		, SUM(x.PaymentAmount) AS TotalPaid
FROM (
	SELECT 
		 j.TM_AccountId
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
		, j.Date
		, j.PaymentAmount
	FROM [etl].[vw_AdvanceOutbound_SeatContribution] j
	LEFT JOIN [dbo].[FD_SDA_ENTITY_OTHER_IDS] oid (NOLOCK)
		ON oid.OTHER_ID = CAST(j.TM_AccountId AS NVARCHAR) AND oid.TYPE_CODE = 'SDP'
	WHERE 1=1
	AND oid.OTHER_ID IS NULL
	AND PaymentAmount > '0'
	) x


	GROUP BY x.TM_AccountId
		, x.SDP_AdvanceId
		, x.CompanyName
		, x.FirstName
		, x.MiddleName
		, x.LastName
		, x.Suffix
		, x.EmailPrimary
		, x.PhonePrimary
		, x.AddressPrimaryStreet
		, x.AddressPrimarySuite
		, x.AddressPrimaryCity
		, x.AddressPrimaryState
		, x.AddressPrimaryZip

END 















GO
