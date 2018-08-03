SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [api].[cust_CustomerLookupSearch] (@SearchCriteria VARCHAR(200))
AS
BEGIN
	SET NOCOUNT ON;
    --DECLARE @SearchCriteria VARCHAR(200) = 'kilasmith86@yahoo.coM'
 
    -- Init for response
    DECLARE @totalCount    INT,
        @xmlDataNode       XML,
        @rootNodeName      NVARCHAR(100),
        @responseInfoNode  NVARCHAR(MAX),
        @finalXml          XML
 
    DECLARE @CustomerId TABLE (
        DimCustomerId       INT
    )
         
    -- Init for data
    DECLARE @returnData TABLE(
        SourceSystem           NVARCHAR(50),
        FirstName              NVARCHAR(100),
        MiddleName             NVARCHAR(100),
        LastName               NVARCHAR(100),
        AddressPrimaryStreet   NVARCHAR(500),
        AddressPrimaryCity     NVARCHAR(200),
        AddressPrimaryState    NVARCHAR(100),
        AddressPrimaryZip      NVARCHAR(25),
        [DimCustomerId]  varchar(50),
        SSID NVARCHAR(100)
    )
 
    --DECLARE @searchcriteria VARCHAR(100) = 'ro jo'
    --single name search
    --first and last name search
    --SSID search
    DECLARE @searchpart1 NVARCHAR(100)
    DECLARE @searchpart2 NVARCHAR(100)
    DECLARE @ResultsCount INT
    DECLARE @IsIdSearch BIT
    DECLARE @IsEmailSearch BIT
 
    SET @ResultsCount = 0
     
    SET @SearchCriteria = REPLACE(@SearchCriteria,'(p)','.')
     
    SELECT @IsIdSearch = CASE WHEN @SearchCriteria LIKE '%[0-9]%' AND @SearchCriteria NOT LIKE '%@%' THEN 1 ELSE 0 END
 
    SELECT @IsEmailSearch = CASE WHEN @SearchCriteria LIKE '%@%' THEN 1 ELSE 0 END
 
    SET @SearchCriteria = REPLACE(REPLACE(@SearchCriteria,',',''),'!','')
 
    IF (CHARINDEX(' ',@SearchCriteria,0) > 0)
    BEGIN
        SELECT @searchpart1 = SUBSTRING(@SearchCriteria,1,CHARINDEX(' ',@SearchCriteria,0)-1),@searchpart2 = SUBSTRING(@SearchCriteria,CHARINDEX(' ',@SearchCriteria,0)+1,1000) 
    END
 
    IF (LEN(@SearchCriteria) > 0 AND @searchpart2 IS NULL AND @IsIdSearch = 0 AND @IsEmailSearch = 0)
    BEGIN
         
        INSERT INTO @CustomerId
        SELECT TOP 100 dc.DimCustomerId
        FROM dbo.DimCustomer dc (NOLOCK)
        WHERE LastName LIKE @SearchCriteria + '%'
 
        SELECT @ResultsCount = COUNT(*)
        FROM @CustomerId
 
        IF (@ResultsCount < 100) 
        BEGIN
            INSERT INTO @CustomerId
            SELECT TOP 100 dc.DimCustomerId
            FROM dbo.DimCustomer dc (NOLOCK)
            LEFT OUTER JOIN @CustomerId s
                ON  dc.DimCustomerId = s.DimCustomerId
            WHERE FirstName LIKE @SearchCriteria + '%'
                AND s.DimCustomerId IS NULL
        END
 
        SELECT @ResultsCount = COUNT(*)
        FROM @CustomerId
    END
     
    IF (LEN(@SearchCriteria) > 0 AND @searchpart2 IS NULL AND @IsIdSearch = 0 AND @IsEmailSearch = 1)
    BEGIN
 
        IF (@ResultsCount < 100) 
        BEGIN
            INSERT INTO @CustomerId
            SELECT TOP 100 dc.DimCustomerId
            FROM dbo.DimCustomer dc (NOLOCK)
            LEFT OUTER JOIN @CustomerId s
                ON  dc.DimCustomerId = s.DimCustomerId
            WHERE EmailPrimary LIKE @SearchCriteria + '%'
                AND s.DimCustomerId IS NULL
        END
 
        SELECT @ResultsCount = COUNT(*)
        FROM @CustomerId
 
    END
 
    IF (LEN(@SearchCriteria) > 0 AND @searchpart2 IS NOT NULL AND @IsIdSearch = 0 AND @IsEmailSearch = 0 AND ISNULL(@ResultsCount, 0) < 100)
    BEGIN
 
        INSERT INTO @CustomerId
        SELECT TOP 100 dc.DimCustomerId
        FROM dbo.DimCustomer dc (NOLOCK)
        LEFT OUTER JOIN @CustomerId s
            ON  dc.DimCustomerId = s.DimCustomerId
        WHERE (FirstName LIKE @SearchPart1 + '%' AND LastName LIKE @searchpart2 + '%')
            AND s.DimCustomerId IS NULL
         
    END
 
    IF (@IsIdSearch = 1)
    BEGIN
         
        INSERT INTO @CustomerId
        SELECT TOP 100 dc.DimCustomerId
        FROM dbo.DimCustomer dc (NOLOCK)
        LEFT OUTER JOIN @CustomerId s
            ON  dc.DimCustomerId = s.DimCustomerId
        WHERE dc.SSID LIKE @SearchCriteria+'%'
            AND s.DimCustomerId IS NULL
         
        SELECT @ResultsCount = COUNT(*)
        FROM @CustomerId
 
        IF (@ResultsCount < 100) 
        BEGIN
 
            INSERT INTO @CustomerId
            SELECT TOP 100 dc.DimCustomerId
            FROM dbo.DimCustomer dc (NOLOCK)
            INNER JOIN dbo.DimCustomerSSBID ds (NOLOCK)
                ON  dc.DimCustomerId = ds.DimCustomerId
            LEFT OUTER JOIN @CustomerId s
                ON  dc.DimCustomerId = s.DimCustomerId
            WHERE ds.SSB_CRMSYSTEM_CONTACT_ID like @SearchCriteria+'%'
                AND s.DimCustomerId IS NULL
 
        END
 
        SELECT @ResultsCount = COUNT(*)
        FROM @CustomerId
 
        IF (@ResultsCount < 100) 
        BEGIN
            INSERT INTO @CustomerId
            SELECT TOP 100 dc.DimCustomerId
            FROM dbo.DimCustomer dc (NOLOCK)
            INNER JOIN dbo.DimCustomerSSBID ds (NOLOCK)
                ON  dc.DimCustomerId = ds.DimCustomerId
            LEFT OUTER JOIN @CustomerId s
                ON  dc.DimCustomerId = s.DimCustomerId
            WHERE ds.SSB_CRMSYSTEM_ACCT_ID LIKE @SearchCriteria+'%'
                AND s.DimCustomerId IS NULL
 
        END
 
    END
 
    INSERT INTO @returnData (
        SourceSystem, 
        FirstName, 
        MiddleName, 
        LastName, 
        AddressPrimaryStreet, 
        AddressPrimaryCity, 
        AddressPrimaryState, 
        AddressPrimaryZip, 
        DimCustomerId, 
        SSID)
    SELECT DISTINCT TOP 100 
        dc.SourceSystem, 
        dc.FirstName, 
        dc.MiddleName, 
        dc.LastName, 
        dc.AddressPrimaryStreet, 
        dc.AddressPrimaryCity, 
        dc.AddressPrimaryState, 
        dc.AddressPrimaryZip , 
        dc.DimCustomerId,
        CASE WHEN SourceSystem = 'TM' THEN SUBSTRING(dc.SSID,1,CHARINDEX(':',dc.SSID,1)-1) ELSE dc.SSID END
    FROM dbo.DimCustomer dc (NOLOCK)
    INNER JOIN @CustomerId s
        ON  dc.DimCustomerId = s.DimCustomerId
    ORDER BY FirstName, LastName
 
    -- Set total count
    SELECT @totalCount = COUNT(*) FROM @returnData
 
    -- Format data for output
    SET @xmlDataNode = (
        SELECT SourceSystem, FirstName, MiddleName, LastName, AddressPrimaryStreet, AddressPrimaryCity, AddressPrimaryState, AddressPrimaryZip,[DimCustomerId],SSID
        FROM @returnData
        --ORDER BY FirstName, LastName
        FOR XML PATH ('Customer'), ROOT ('Customers'))
     
    -- Track the root node name
    SET @rootNodeName = 'Customers'
     
    -- Create response info node
    SET @responseInfoNode = ('<ResponseInfo>'
        + '<TotalCount>' + CAST(@totalCount AS NVARCHAR(20)) + '</TotalCount>'
        + '<RemainingCount>0</RemainingCount>'  -- No paging = remaining count = 0
        + '<RecordsInResponse>' + CAST(@totalCount AS NVARCHAR(20)) + '</RecordsInResponse>'  -- No paging = remaining count = total count
        + '<PagedResponse>false</PagedResponse>'
        + '<RowsPerPage />'
        + '<PageNumber />'
        + '<RootNodeName>' + @rootNodeName + '</RootNodeName>'
        + '</ResponseInfo>')
 
         
    -- Wrap response info and data, then return 
    IF @xmlDataNode IS NULL
    BEGIN
        SET @xmlDataNode = '<' + @rootNodeName + ' />'  -- Handle if no data
    END    
    SET @finalXml = '<Root>' + @responseInfoNode + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>'
    SELECT CAST(@finalXml AS XML)
 
END
GO
