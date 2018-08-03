SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO














CREATE PROCEDURE [api].[CRM_GetTransByContactGUID]
    (
      @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50)
	, @SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50)
    , @RowsPerPage INT = 500
    , --APIification
      @PageNumber INT = 0 --APIification
    )
AS
    BEGIN

-- =========================================
-- Initial Variables for API
-- =========================================

        DECLARE @totalCount INT
          , @xmlDataNode XML
          , @recordsInResponse INT
          , @remainingCount INT
          , @rootNodeName NVARCHAR(100)
          , @responseInfoNode NVARCHAR(MAX)
          , @finalXml XML;

-- =========================================
-- GUID Table for GUIDS
-- =========================================
DECLARE @GUIDTable TABLE ( GUID VARCHAR(50) );

IF ( @SSB_CRMSYSTEM_ACCT_ID NOT IN ( 'None', 'Test' ) )
    BEGIN
        INSERT  INTO @GUIDTable
                ( GUID
                )
                SELECT DISTINCT
                        z.SSB_CRMSYSTEM_CONTACT_ID
                FROM    ASU.dbo.vwDimCustomer_ModAcctId z
                WHERE   z.SSB_CRMSYSTEM_ACCT_ID = @SSB_CRMSYSTEM_ACCT_ID;
    END;

IF ( @SSB_CRMSYSTEM_CONTACT_ID NOT IN ( 'None', 'Test' ) )
    BEGIN
        INSERT  INTO @GUIDTable
                ( GUID
                )
                SELECT  @SSB_CRMSYSTEM_CONTACT_ID;
    END;

-- =========================================
-- Base Table Set
-- =========================================


        DECLARE @baseData TABLE
            (
              Team NVARCHAR(255)
			, Account NVARCHAR(255)
            , SeasonName NVARCHAR(255)
            , OrderNumber NVARCHAR(255)
            , OrderLine NVARCHAR(255)
            , OrderDate DATE
            , Item NVARCHAR(255)
            , ItemName NVARCHAR(255)
			, EventDate NVARCHAR(255)
            , PriceCode NVARCHAR(255)
            , IsComp BIT
            , PromoCode NVARCHAR(255)
            , Qty INT
			, SectionName NVARCHAR(255)
            , RowName NVARCHAR(255)
			, Seat	 NVARCHAR(255)
			, SeatPrice DECIMAL(18, 6)
		    , Total DECIMAL(18, 6)
            , AmountOwed DECIMAL(18, 6)
            , AmountPaid DECIMAL(18, 6)
			, SalesRep NVARCHAR(255)
            );

-- =========================================
-- Procedure
-- =========================================


SELECT DISTINCT
        'ASU' AS Team
      , fts.TicketingAccountId
      , fts.SeasonName
      , fts.TM_Order_Num AS OrderNumber
      , fts.TM_Order_Line_Item AS OrderLine
      , fts.OrderDate
      , fts.ItemCode AS Item
      , fts.ItemName
	  , fts.EventDate
      , fts.PriceCode
      , fts.IsComp
      , fts.PromoCode
      , fts.QtySeat AS Qty
      , fts.SectionName
      , fts.RowName
      , fts.Seat
      , fts.TM_purchase_price AS SeatPrice
      , fts.RevenueTotal AS Total
      , fts.OwedAmount
      , fts.PaidAmount
	  , fts.SalesRep
INTO #Trans
FROM   [ro].[vw_FactTicketSalesBase] fts
INNER JOIN [dbo].[vwDimCustomer_ModAcctId] dc on dc.SourceSystem = 'TM' AND dc.AccountId = fts.TicketingAccountId AND dc.CustomerType = 'Primary'
WHERE   dc.SSB_CRMSYSTEM_CONTACT_ID IN (SELECT GUID FROM @GUIDTable);



-- =========================================
-- API Pagination
-- =========================================
-- Cap returned results at 1000

        IF @RowsPerPage > 1000
            BEGIN

                SET @RowsPerPage = 1000;

            END;

-- Pull total count

        SELECT  @totalCount = COUNT(*)
        FROM    #Trans AS c;

-- =========================================
-- API Loading
-- =========================================

-- Load base data

        INSERT  INTO @baseData
                SELECT  *
                FROM    #Trans AS c
                ORDER BY c.OrderDate DESC
                      --, c.OrderNumber
                      OFFSET ( @PageNumber ) * @RowsPerPage ROWS

FETCH NEXT @RowsPerPage ROWS ONLY;

-- Set records in response

        SELECT  @recordsInResponse = COUNT(*)
        FROM    @baseData;
-- Create XML response data node

        SET @xmlDataNode = (
                             SELECT ISNULL(Team, '') AS Team
                                 
                                  , ISNULL(SeasonName,'') AS SeasonName
                                  , ISNULL(OrderNumber,'') AS OrderNumber
                                  , ISNULL(OrderLine,'') AS OrderLine
                                  , ISNULL(Account,'') AS Account
                                  , ISNULL(OrderDate,'') AS OrderDate
                                  , ISNULL(Item,'') AS Item
                                  , ISNULL(ItemName,'') AS ItemName
								  , ISNULL(EventDate,'') AS EventDate                                 
                                  , ISNULL(IsComp,0) AS IsComp                                
                                  , ISNULL(PromoCode,'') AS PromoCode
                                  , ISNULL(Qty,0) AS Qty
                                  , ISNULL(SeatPrice,0) AS SeatPrice
                                  , ISNULL(Total,0) AS Total
								  , ISNULL(AmountOwed,0) AS AmountOwed
                                  , ISNULL(AmountPaid,0) AS AmountPaid
								  , ISNULL(SectionName,0) AS SectionName
								  , ISNULL(RowName,0) AS RowName
                                  , ISNULL(Seat,'') AS Seat
								  , ISNULL(SalesRep,'') AS SalesRep
                             FROM   @baseData
                           FOR
                             XML PATH('Parent')
                               , ROOT('Parents')
                           );

        SET @rootNodeName = 'Parents';

		-- Calculate remaining count

        SET @remainingCount = @totalCount - ( @RowsPerPage * ( @PageNumber + 1 ) );

        IF @remainingCount < 0
            BEGIN

                SET @remainingCount = 0;

            END;

			-- Create response info node

        SET @responseInfoNode = ( '<ResponseInfo>' + '<TotalCount>'
                                  + CAST(@totalCount AS NVARCHAR(20))
                                  + '</TotalCount>' + '<RemainingCount>'
                                  + CAST(@remainingCount AS NVARCHAR(20))
                                  + '</RemainingCount>'
                                  + '<RecordsInResponse>'
                                  + CAST(@recordsInResponse AS NVARCHAR(20))
                                  + '</RecordsInResponse>'
                                  + '<PagedResponse>true</PagedResponse>'
                                  + '<RowsPerPage>'
                                  + CAST(@RowsPerPage AS NVARCHAR(20))
                                  + '</RowsPerPage>' + '<PageNumber>'
                                  + CAST(@PageNumber AS NVARCHAR(20))
                                  + '</PageNumber>' + '<RootNodeName>'
                                  + @rootNodeName + '</RootNodeName>'
                                  + '</ResponseInfo>' );
    END;

-- Wrap response info and data, then return    

    IF @xmlDataNode IS NULL
        BEGIN

            SET @xmlDataNode = '<' + @rootNodeName + ' />';

        END;

    SET @finalXml = '<Root>' + @responseInfoNode
        + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>';

    SELECT  CAST(@finalXml AS XML);









GO
