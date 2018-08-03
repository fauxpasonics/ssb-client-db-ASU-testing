SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO













CREATE PROCEDURE [api].[CRM_GetDonations]
(
    @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'Test',
	@SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'Test',
	@DisplayTable INT = 0,
	@RowsPerPage  INT = 500,
	@PageNumber   INT = 0,
	@ViewResultInTable INT = 0
)
WITH RECOMPILE
AS

BEGIN

-- EXEC [api].[CRM_GetAccountDonations] @SearchCriteria = '28391FEE-5C97-4AB7-9551-2E53E5F17759', @RowsPerPage = 500, @PageNumber = 0, @ViewResultInTable = 0


--DECLARE @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'None',
--	@SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = '3F2266EE-3DAF-4976-8C4C-1EA38E4E7811',
--	@RowsPerPage  INT = 500,
--	@PageNumber   INT = 0,
--	@ViewResultinTable int = 0


--DROP TABLE #CustomerIDs
--DROP TABLE #CustomerList
--DROP TABLE #tmpA
--DROP TABLE #ReturnSet
--DROP TABLE #TopGroup

DECLARE @GUIDTable TABLE (
GUID VARCHAR(50)
)

IF (@SSB_CRMSYSTEM_ACCT_ID NOT IN ('None','Test'))
BEGIN
	INSERT INTO @GUIDTable
	        ( GUID )
	SELECT DISTINCT z.SSB_CRMSYSTEM_CONTACT_ID
		FROM ASU.dbo.vwDimCustomer_ModAcctId z 
		WHERE z.SSB_CRMSYSTEM_ACCT_ID = @SSB_CRMSYSTEM_ACCT_ID
END

IF (@SSB_CRMSYSTEM_CONTACT_ID NOT IN ('None','Test'))
BEGIN
	INSERT INTO @GUIDTable
	        ( GUID )
	SELECT @SSB_CRMSYSTEM_CONTACT_ID
END


DECLARE @CustomerID VARCHAR(MAX)

-- Init vars needed for API
DECLARE @totalCount         INT,
	@xmlDataNode        XML,
	@recordsInResponse  INT,
	@remainingCount     INT,
	@rootNodeName       NVARCHAR(100),
	@responseInfoNode   NVARCHAR(MAX),
	@finalXml           XML

-- Cap returned results at 1000
IF @RowsPerPage > 1000
BEGIN
	SET @RowsPerPage = 1000;
END



SELECT DimCustomerId 
INTO #CustomerIDs 
FROM ASU.dbo.[vwDimCustomer_ModAcctId] dc WITH(NOLOCK) 
WHERE ISNULL(dc.SSB_CRMSYSTEM_ACCT_ID, dc.SSB_CRMSYSTEM_CONTACT_ID)  = @SSB_CRMSYSTEM_CONTACT_ID


IF @@ROWCOUNT = 0
BEGIN
	INSERT INTO #CustomerIDs
	SELECT dimcustomerid FROM [ASU].mdm.SSB_ID_History a   WITH (NOLOCK)
	INNER JOIN ASU.dbo.[vwDimCustomer_ModAcctId] b  WITH (NOLOCK)
	ON a.ssid = b.ssid AND a.sourcesystem = b.SourceSystem
	WHERE ISNULL(a.SSB_CRMSYSTEM_ACCT_ID, a.SSB_CRMSYSTEM_CONTACT_ID) = @SSB_CRMSYSTEM_CONTACT_ID;

END

--SELECT * FROM [#CustomerIDs]


SELECT a.[AccountId] 
INTO #CustomerList
FROM ASU.dbo.[vwDimCustomer_ModAcctId] (nolock) a
INNER JOIN #CustomerIDs b ON a.DimCustomerId = b.DimCustomerId
WHERE a.SourceSystem = 'TM'

--SELECT * FROM #CustomerList


SET @CustomerID = (SELECT SUBSTRING(
(SELECT 
--',' + s.AccountId
CAST(s.AccountId AS nvarchar(50))
FROM [#CustomerList] s
ORDER BY s.AccountId
FOR XML PATH('')),2,200000) AS CSV)

SELECT AccountId, TX_NUMBER, DonationDate, CAMPAIGN_CODE, AllocationDescription
,SUM(Total_Gift) Total_Gift
INTO #tmpA
FROM (
		SELECT 
		t.PACIOLAN_ID AS AccountId
		, t.TX_NUMBER 
		, t.DATE_OF_RECORD AS DonationDate
		, t.CAMPAIGN_CODE
		, t.ALLOC_DESC AllocationDescription
		, CASE WHEN t.GYPMD_DESC = 'Matching Gift' THEN SUM(t.CREDIT_AMOUNT)
				ELSE SUM(t.NET_LEGAL_AMOUNT) END AS  Total_Gift
		FROM [dbo].[FD_SDA_TRANSACTION_DETAIL] t (NOLOCK)
		WHERE 1=1
		AND CAST(t.PACIOLAN_ID AS nvarchar(50)) IN (SELECT CAST(AccountId AS nvarchar(50)) FROM [#CustomerList])
		AND t.GYPMD_DESC IN ('Gift', 'Pledge Payment', 'Matching Gift')
		AND CAMPAIGN_CODE LIKE 'SC%'
		AND CASE WHEN t.GYPMD_DESC = 'Matching Gift' THEN CREDIT_AMOUNT
			 ELSE NET_LEGAL_AMOUNT END > 0
		GROUP BY t.PACIOLAN_ID 
		, t.TX_NUMBER 
		, t.DATE_OF_RECORD 
		, t.CAMPAIGN_CODE
		, t.ALLOC_DESC 
		, t.GYPMD_DESC
	) a
GROUP BY AccountId, TX_NUMBER, DonationDate, CAMPAIGN_CODE, AllocationDescription

 SET @totalCount = @@ROWCOUNT
 
SELECT 'ASU' Team
, AccountId Account_Id
, TX_NUMBER Trans_No
, CONVERT(DATE, ISNULL(DonationDate,''), 102) Donation_Date
, CAMPAIGN_CODE Campaign_Code
, AllocationDescription Allocation_Description
, Total_Gift 
INTO #ReturnSet
FROM #tmpA a
ORDER BY Donation_Date DESC
OFFSET (@PageNumber) * @RowsPerPage ROWS
FETCH NEXT @RowsPerPage ROWS ONLY

--SELECT * FROM [#ReturnSet]

SET @recordsInResponse  = (SELECT COUNT(*) FROM #ReturnSet)

SELECT Account_Id
, Campaign_Code
, SUM(Total_Gift) as Total_Gift
INTO #TopGroup
FROM #ReturnSet
GROUP BY Account_Id, Campaign_Code




-- Create XML response data node
SET @xmlDataNode = (

SELECT Campaign_Code
, CASE WHEN SIGN(ISNULL(t.Total_Gift ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS(t.[Total_Gift])), '0.00') as Total_Gift
, (
	SELECT a.Account_Id
	, a.Campaign_Code
	, a.Trans_No
	, a.Donation_Date
	, a.Allocation_Description
	, CASE WHEN SIGN(ISNULL([a].Total_Gift ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS( [a].Total_Gift)), '0.00') Total_Gift
	
FROM [#ReturnSet] a 
WHERE a.Campaign_Code = t.Campaign_Code 
FOR XML PATH ('Child'), TYPE) AS 'Children'
FROM #topgroup AS t
FOR XML PATH ('Parent'), ROOT('Parents')
)


SET @rootNodeName = 'Parent'

-- Calculate remaining count
SET @remainingCount = @totalCount - (@RowsPerPage * (@PageNumber + 1))
IF @remainingCount < 0
BEGIN
	SET @remainingCount = 0
END

-- Wrap response info and data, then return	
IF @xmlDataNode IS NULL
BEGIN
	SET @xmlDataNode = '<' + @rootNodeName + ' />' 
END


-- Create response info node
SET @responseInfoNode = ('<ResponseInfo>'
	+ '<TotalCount>' + CAST(@totalCount AS NVARCHAR(20)) + '</TotalCount>'
	+ '<RemainingCount>' + CAST(@remainingCount AS NVARCHAR(20)) + '</RemainingCount>'
	+ '<RecordsInResponse>' + CAST(@recordsInResponse AS NVARCHAR(20)) + '</RecordsInResponse>'
	+ '<PagedResponse>true</PagedResponse>'
	+ '<RowsPerPage>' + CAST(@RowsPerPage AS NVARCHAR(20)) + '</RowsPerPage>'
	+ '<PageNumber>' + CAST(@PageNumber AS NVARCHAR(20)) + '</PageNumber>'
	+ '<RootNodeName>' + @rootNodeName + '</RootNodeName>'
	+ '</ResponseInfo>')

SET @finalXml = '<Root>' + @responseInfoNode + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>'

IF ISNULL(@ViewResultinTable,0) = 0
BEGIN
SELECT CAST(@finalXml AS XML)
END
ELSE 
BEGIN
SELECT * FROM [#ReturnSet]
END

DROP TABLE [#tmpA]
DROP TABLE [#ReturnSet]
DROP TABLE [#CustomerIDs]
DROP TABLE [#CustomerList]
DROP TABLE [#TopGroup]
--DROP TABLE [#SecGroup]

END









GO
