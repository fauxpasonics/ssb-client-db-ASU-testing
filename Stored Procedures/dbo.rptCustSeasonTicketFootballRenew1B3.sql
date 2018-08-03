SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
 
-- =============================================
-- Created By: Kaitlyn Sniffin
-- Create Date: 2018-06-01
-- Reviewed By: Abbey Meitin
-- Reviewed Date: 2018-06-07
-- Description: Football - Paid Report Donation Section
-- =============================================
  
/***** Revision History
 Abbey Meitin - 2018-06-13: added FBECL & FBSLCL 6/13/18 to regular Football Seat Contributions
 
 
*****/
  
 
 
 
CREATE PROCEDURE [dbo].[rptCustSeasonTicketFootballRenew1B3](
     @startDate DATE
    , @endDate DATE
    , @dateRange VARCHAR(20)
    , @curSeason NVARCHAR(20)
    , @Sport varchar(50)
    )
AS
--The issue with this report is that the base table that this pulls from only has information for 2017 and 2018, it comes from more custom tables in prior years.
                                                             
                                                             
 
BEGIN
 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
 
 
--declare @curSeason INT = 2018
--declare @Sport varchar(50) = 'Football'
--DECLARE   @dateRange VARCHAR(20)= 'AllData'
--DECLARE @startDate DATE = DATEADD(month,-1,GETDATE())
--DECLARE @endDate DATE = GETDATE()
 
 
declare @prevSeason NVARCHAR(20) = @curSeason - 1
 
declare @DonationYearCY varchar(50), @DonationYearPY varchar(50)
, @DonationCYFTBPAIDTOTAL decimal(12,2)
, @DonationCYCLUBPAIDTOTAL decimal(12,2)
, @DonationCYSUITEPAIDTOTAL decimal(12,2)
, @DonationCYLCLUBPAIDTOTAL decimal(12,2)
, @DonationCYNTPAIDTOTAL decimal(12,2)
, @DonationPYFTB decimal(12,2)
, @DonationPYCLUB decimal(12,2)
, @DonationCYPledge decimal(12,2)
, @DonationPYFTBPAIDTOTAL decimal(12,2)
, @DonationCYRENEWALSEATQTY decimal(12,2)
, @DonationCYRENEWALSEATEXPECTED decimal(12,2)
, @DonationCYNEWSEATQTY decimal(12,2)
, @DonationCYNEWSEATEXPECTED decimal(12,2)
, @DonationCYSUITEEXPECTED decimal(12,2)
, @DonationCYCLUBEXPECTED decimal(12,2)
, @DonationCYLCLUBEXPECTED decimal(12,2)
, @DonationCYNTEXPECTED decimal(12,2)
, @DonationPYCLUBPAIDTOTAL decimal(12,2)
, @DonationPYSUITEPAIDTOTAL decimal(12,2)
, @DonationPYLCLUBPAIDTOTAL decimal(12,2)
, @DonationPYNTPAIDTOTAL decimal(12,2)
, @DonationCYSCBudget DECIMAL(12,2) --suite+club budget total
, @DonationCYSUITEBUDGET decimal(12,2)
, @DonationCYCLUBBUDGET decimal(12,2)
, @DonationCYLCLUBBUDGET decimal(12,2)
, @DonationCYNTBUDGET decimal(12,2)
, @DonationCYRENEWALSEATREV decimal(12,2)
, @DonationCYNEWSEATREV decimal(12,2)
, @DonationCYBudget DECIMAL(12,2)
 
 
declare @SeasonTicketAcctsCY int, @SeasonTicketAcctsPY int
Set @DonationYearCY = @curSeason
Set @DonationYearPY = @prevSeason
 
 
/*********************************************************************************************************************************
    FB17 or later - after TM conversion
*********************************************************************************************************************************/
 
IF @curSeason >= 2017
BEGIN
 
            ---- Build Report --------------------------------------------------------------------------------------------------
 
            --DROP TABLE #ReportBase
            --DROP TABLE #DonationBase
            Create table #DonationBase  
            (
              drive_year nvarchar (255)
             ,acct_id int
             ,fund_name nvarchar (255)
             ,pledge_amount  numeric (18,6)
             ,donation_paid_amount  numeric (18,6)
             ,owed_amount  numeric (18,6) 
             ,donation_paid_datetime datetime  
 
            )
 
            INSERT INTO #DonationBase 
            (
              drive_year 
             ,acct_id 
             ,fund_name 
             ,pledge_amount  
             ,donation_paid_amount  
             ,owed_amount  
             ,donation_paid_datetime 
            ) 
 
            SELECT
              drive_year 
             ,acct_id 
             ,fund_name 
             ,pledge_amount  
             ,donation_paid_amount  
             ,owed_amount  
             ,donation_paid_datetime 
            FROM [ods].[TM_Donation] rb (NOLOCK) 
            where rb.drive_year IN (@curSeason, @prevSeason) 
            AND fund_name like '%FB%' --Football funds
             
             
            /*
            Select distinct fund_name from ods.TM_donation
 
            */
            --declare @curSeason varchar(50)
            --declare @prevSeason varchar(50)
            --declare @Sport varchar(50)
            --Set @prevSeason = '2017'
            --Set @curSeason = '2018'
            --Set @Sport = 'Football'
            Create table #ReportBase  
            (
              SeasonYear int
             ,Sport nvarchar(255)
             ,TicketingAccountId int
             ,DimItemId int
             ,PriceCode nvarchar (25)
             ,DimPlanId int
             ,PlanTypeCode nvarchar(25)
             ,TicketTypeCode nvarchar(25)
             ,TicketTypeClass varchar(100)
             ,QtySeatRenewable numeric (18,6)
             ,RevenueTotal numeric (18,6) 
             ,TransDateTime datetime  
             ,PaidAmount numeric (18,6)
            )
 
            INSERT INTO #ReportBase 
            (
              SeasonYear 
             ,Sport 
             ,TicketingAccountId 
             ,DimItemId 
             ,PriceCode 
             ,DimPlanId
             ,PlanTypeCode
             ,TicketTypeCode
             ,TicketTypeClass
             ,QtySeatRenewable
             ,RevenueTotal  
             ,TransDateTime 
             ,PaidAmount 
            ) 
 
            SELECT
             SeasonYear 
             ,Sport 
             ,TicketingAccountId 
             ,DimItemId 
             ,PriceCode
             ,DimPlanId
             ,PlanTypeCode
             ,TicketTypeCode
             ,TicketTypeClass
             ,SUM(QtySeatRenewable)
             ,SUM(RevenueTotal) 
             ,TransDateTime 
             ,SUM(PaidAmount)
            FROM  [ro].[vw_FactTicketSalesBase] fts 
            WHERE   fts.Sport = @Sport
            AND (fts.SeasonYear = @prevSeason OR  fts.SeasonYear = @curSeason)
            GROUP BY  SeasonYear 
             ,Sport 
             ,TicketingAccountId 
             ,DimItemId 
             ,PriceCode
             ,DimPlanId
             ,PlanTypeCode
             ,TicketTypeCode
             ,TicketTypeClass
             ,TransDateTime 
 
 
            ----------------------------------------------------------------------------------------
            ----Budget Information
            SET @DonationCYBudget = '0'
            SET @DonationCYSUITEBUDGET = '0'
            SET @DonationCYCLUBBUDGET = '0'
            SET @DonationCYLCLUBBUDGET = '0'
            SET @DonationCYNTBUDGET = '0'
            SET @DonationCYSCBudget = @DonationCYSUITEBUDGET+@DonationCYCLUBBUDGET+@DonationCYLCLUBBUDGET+@DonationCYNTBUDGET  --sum of suite and club budget
 
 
            -----------------------------------------------------------------------------------------
            --Donation Accts and Donations Previous Year 
 
 
            set @DonationPYFTBPAIDTOTAL = ---Previous Year Football Seat Contributions 
            (
 
            select SUM(donation_paid_amount)  from #DonationBase  
            where drive_year IN (@prevSeason)  
            AND fund_name IN (CONCAT(RIGHT(@prevSeason,2),'FBPS'), CONCAT(RIGHT(@prevSeason,2),'FBECL'), CONCAT(RIGHT(@prevSeason,2),'FBSLCL') ) --AMeitin added FBECL & FBSLCL 6/13/18
            )
            set @DonationPYCLUBPAIDTOTAL = ---Previous Year MidFirst Bank Donations
            (
 
 
            select SUM(donation_paid_amount)  from #DonationBase  
            where drive_year IN (@prevSeason)  AND fund_name = CONCAT(RIGHT(@prevSeason,2),'FBMFCL')
 
            )
 
            set @DonationPYSUITEPAIDTOTAL = --- Previous Year Suite Donations
            (
 
            select SUM(donation_paid_amount)  from #DonationBase  
            where drive_year IN (@prevSeason)  AND fund_name = CONCAT(RIGHT(@prevSeason,2),'FBDSTE')
 
            )
 
            set @DonationPYLCLUBPAIDTOTAL = --- Previous Year Legends Club Donations
            (
 
            select SUM(donation_paid_amount)  from #DonationBase 
            where drive_year IN (@prevSeason)  AND fund_name = CONCAT(RIGHT(@prevSeason,2),'FBLGCL')
 
            )
 
            set @DonationPYNTPAIDTOTAL = --- Previous Year North Terrace Club Donations
            (
 
            select SUM(donation_paid_amount)  from #DonationBase 
            where drive_year IN (@prevSeason)  AND fund_name = CONCAT(RIGHT(@prevSeason,2),'FBNTCL')
 
            )
            ----------------------------------------------------------------------------------------------
 
            --Donation Accts and Donations Current Year
 
 
 
            set @DonationCYFTBPAIDTOTAL = ---Current Year Football Seat Contributions 
            (
 
 
            select SUM(donation_paid_amount)  from #DonationBase  
            where drive_year IN (@curSeason)  
            AND fund_name IN (CONCAT(RIGHT(@curSeason,2),'FBPS'), CONCAT(RIGHT(@curSeason,2),'FBECL'), CONCAT(RIGHT(@curSeason,2),'FBSLCL') ) --AMeitin added FBECL & FBSLCL 6/13/18
             
 
            )
 
            set @DonationCYCLUBPAIDTOTAL = ---Current Year MidFirst Bank Stadium Club
            (
 
            select SUM(donation_paid_amount)  from #DonationBase  
            where drive_year IN (@curSeason)  AND fund_name =  CONCAT(RIGHT(@curSeason,2),'FBMFCL')
 
            )
 
            set @DonationCYSUITEPAIDTOTAL = ---Current Year Suite Donations
            (
 
            select SUM(donation_paid_amount)  from #DonationBase 
            where drive_year IN (@curSeason)  AND fund_name = CONCAT(RIGHT(@curSeason,2),'FBDSTE')
 
            )
 
            set @DonationCYLCLUBPAIDTOTAL = ---Current Year Legends Club
            (
 
            select SUM(donation_paid_amount)  from #DonationBase  
            where drive_year IN (@curSeason)  AND fund_name = CONCAT(RIGHT(@curSeason,2),'FBLGCL')
 
            )
 
            set @DonationCYNTPAIDTOTAL = ---Current Year North Terrace
            (
 
            select SUM(donation_paid_amount)  from #DonationBase  
            where drive_year IN (@curSeason)  AND fund_name = CONCAT(RIGHT(@curSeason,2),'FBNTCL')
 
            )
 
 
            --DONCLUB BUDGET  
 
            set @DonationCYCLUBEXPECTED = 
            (
 
            select SUM(pledge_amount)  from #DonationBase 
            where drive_year IN (@curSeason)  AND fund_name =  CONCAT(RIGHT(@curSeason,2),'FBMFCL')
            AND donation_paid_amount  > 0 
            ) 
 
            --DONSUITE BUDGET
 
            set @DonationCYSUITEEXPECTED = 
            (
            select SUM(pledge_amount)  from #DonationBase  
            where drive_year IN (@curSeason)  AND fund_name =  CONCAT(RIGHT(@curSeason,2),'FBDSTE')
            AND donation_paid_amount  > 0 
            ) 
 
 
            --LEGENDS CLUB BUDGET
 
            set @DonationCYLCLUBEXPECTED = 
            (
            select SUM(pledge_amount)  from #DonationBase  
            where drive_year IN (@curSeason)  AND fund_name =  CONCAT(RIGHT(@curSeason,2),'FBLGCL')
            AND donation_paid_amount  > 0 
            ) 
 
            --NORTH TERRACE BUDGET
 
            set @DonationCYNTEXPECTED = 
            (
            select SUM(pledge_amount)  from #DonationBase  
            where drive_year IN (@curSeason)  AND fund_name =  CONCAT(RIGHT(@curSeason,2),'FBNTCL')
            AND donation_paid_amount  > 0 
            ) 
 
 
            ---------------------------------------------------------------------------------------------------
 
            SET @DonationCYNEWSEATEXPECTED =  --@DonationCYNEWSEATBUDGET 
            (
            --NEW RENEWAL BUDGET 
 
            SELECT SUM(REQCONTRIB * QtySeatRenewable) BUDGET    
            FROM
            #ReportBase rb
            LEFT JOIN [rpt].[TM_PriceCode_Mapping] tm  on rb.SeasonYear = tm.SeasonYear and rb.Sport = tm.Sport
                  AND rb.TicketTypeCode = tm.TicketTypeCode
                  AND rb.PriceCode  = tm.PriceCode 
             WHERE 1=1
                  AND tm.Sport = @Sport 
                  AND rb.SeasonYear  IN (@curSeason)
                  AND rb.TicketTypeCode = 'FS'
                  AND rb.PaidAmount > 0
                  AND rb.PlanTypeCode IN ('NEW', 'ADD')
                  AND tm.REQCONTRIB > 0  
            ) 
 
 
            --NEW RENEWAL SEATS
 
 
            SET @DonationCYNEWSEATQTY  = 
            ( 
            SELECT
            SUM(QtySeatRenewable) BUDGET   
             FROM
            #ReportBase rb
            LEFT JOIN [rpt].[TM_PriceCode_Mapping] tm  on rb.SeasonYear = tm.SeasonYear and rb.Sport = tm.Sport
                  AND rb.TicketTypeCode = tm.TicketTypeCode
                  AND rb.PriceCode  = tm.PriceCode 
             WHERE 1=1
                  AND tm.Sport = @Sport
                  AND rb.SeasonYear  IN (@curSeason)
                  AND rb.TicketTypeCode = 'FS'
                  AND rb.PaidAmount > 0
                  AND rb.PlanTypeCode IN ('NEW', 'ADD')
                  AND tm.REQCONTRIB > 1  
            ) 
 
            ----------------------------------------------------------------------------------------------
 
 
 
 
            --RENEWAL BUDGET 
 
 
            SET @DonationCYRENEWALSEATEXPECTED = --@DonationCYRENEWALSEATBUDGET
            (
            SELECT SUM(REQCONTRIB * QtySeatRenewable) BUDGET    FROM
            #ReportBase rb
            LEFT JOIN [rpt].[TM_PriceCode_Mapping] tm  on rb.SeasonYear = tm.SeasonYear and rb.Sport = tm.Sport
                  AND rb.TicketTypeCode = tm.TicketTypeCode
                  AND rb.PriceCode  = tm.PriceCode 
             WHERE 1=1
                  AND tm.Sport = @Sport 
                  AND rb.SeasonYear  IN (@curSeason)
                  AND rb.TicketTypeCode = 'FS'
                  AND rb.PaidAmount > 0
                  AND rb.PlanTypeCode = 'RENEW'
                  AND tm.REQCONTRIB > 0
            ) 
 
            --RENEWAL SEATS 
 
            SET @DonationCYRENEWALSEATQTY  = 
            (
            SELECT
                SUM(QtySeatRenewable) QTY   
            FROM #ReportBase rb
            LEFT JOIN [rpt].[TM_PriceCode_Mapping] tm  on rb.SeasonYear = tm.SeasonYear and rb.Sport = tm.Sport
                  AND rb.TicketTypeCode = tm.TicketTypeCode
                  AND rb.PriceCode  = tm.PriceCode 
             WHERE 1=1
                  AND tm.Sport = @Sport 
                  AND rb.SeasonYear  IN (@curSeason)
                  AND rb.TicketTypeCode = 'FS'
                  AND rb.PaidAmount > 0
                  AND rb.PlanTypeCode = 'RENEW'
                  AND tm.REQCONTRIB > 1  
 
            ) 
 
 
            -----------------------------------------------------------------------------------------------
 
            -- Season Ticket Accts 
 
 
            set @SeasonTicketAcctsCY = (
                select COUNT (distinct TicketingAccountId) Accts    
                from #ReportBase  
                where SeasonYear in (@curSeason)
                    AND TicketTypeCode = 'FS'
                group by SeasonYear
            )
 
 
 
 
            SELECT
            '1' AS RowGroup
            ,'Donor Seats(Renewed)' AS RowCat
            ,CONVERT(VARCHAR, @DonationCYRENEWALSEATQTY) AS CYQty
            ,'Seat Related Contributions (Renewed Season Tickets)' AS RowCat2
            ,CONVERT(VARCHAR, @DonationCYFTBPAIDTOTAL) AS CYRev
            ,@DonationCYRENEWALSEATEXPECTED AS 'Expected'
            ,@DonationCYBudget AS 'Budget'
            ,(@DonationCYFTBPAIDTOTAL-@DonationCYBudget) AS 'Variance'
            ,CASE WHEN @DonationCYBudget = 0 THEN 0 
                ELSE(@DonationCYFTBPAIDTOTAL/@DonationCYBudget) END AS 'PctBudget'
 
            UNION ALL
 
            SELECT
            '1' AS RowGroup
            ,'Donor Seats(New)' AS RowCat
            ,CONVERT(VARCHAR, @DonationCYNEWSEATQTY) AS CYQty
            ,'Seat Related Contributions (New Season Tickets)' AS RowCat2
            ,CONVERT(VARCHAR,0.0) AS CYRev
            ,@DonationCYNEWSEATEXPECTED AS 'Expected'
            ,0.0 AS 'Budget'
            ,0.0 AS 'Variance'
            ,0.0 AS 'PctBudget'
 
 
            UNION ALL
 
 
 
            SELECT
            '2' AS RowGroup
            ,'Season Ticket Accounts' AS RowCat
            ,CONVERT(VARCHAR, @SeasonTicketAcctsCY) AS CYQty
            ,'Seat Related Contributions (MBSC)' AS RowCat2
            ,CONVERT(VARCHAR, @DonationCYCLUBPAIDTOTAL) AS CYRev
            ,@DonationCYCLUBEXPECTED  AS 'Expected'
            ,@DonationCYCLUBBUDGET AS 'Budget'
            ,(@DonationCYCLUBPAIDTOTAL-@DonationCYCLUBBUDGET) AS 'Variance'
            ,CASE WHEN @DonationCYSCBudget = 0 THEN 0 
                ELSE(@DonationCYCLUBPAIDTOTAL/@DonationCYCLUBBUDGET) END AS 'PctBudget'
 
            UNION ALL
 
            SELECT
            '2'
            ,''
            ,'' AS '2013'
            ,'Seat Related Contributions (Suite)'
            ,CONVERT(VARCHAR, @DonationCYSUITEPAIDTOTAL) 
            ,@DonationCYSUITEEXPECTED AS 'Expected'
            ,@DonationCYSUITEBUDGET AS 'Budget'
            ,(@DonationCYSUITEPAIDTOTAL-@DonationCYSCBudget) AS 'Variance'
            ,CASE WHEN @DonationCYSUITEBUDGET = 0 THEN 0 
                ELSE(@DonationCYSUITEPAIDTOTAL/@DonationCYSUITEBUDGET) END AS 'PctBudget'
 
            UNION ALL
 
            SELECT
            '2'
            ,''
            ,'' AS '2013'
            ,'Seat Related Contributions (Legends Club)'
            ,CONVERT(VARCHAR, @DonationCYLCLUBPAIDTOTAL) 
            ,@DonationCYLCLUBEXPECTED AS 'Expected'
            ,@DonationCYLCLUBBUDGET AS 'Budget'
            ,(@DonationCYLCLUBPAIDTOTAL-@DonationCYLCLUBBudget) AS 'Variance'
            ,CASE WHEN @DonationCYLCLUBBUDGET = 0 THEN 0 
                ELSE(@DonationCYLCLUBPAIDTOTAL/@DonationCYLCLUBBUDGET) END AS 'PctBudget'
 
            UNION ALL
 
            SELECT
            '2'
            ,''
            ,'' AS '2013'
            ,'Seat Related Contributions (North Terrace Club)'
            ,CONVERT(VARCHAR, @DonationCYNTPAIDTOTAL) 
            ,@DonationCYNTEXPECTED AS 'Expected'
            ,@DonationCYNTBUDGET AS 'Budget'
            ,(@DonationCYNTPAIDTOTAL-@DonationCYLCLUBBudget) AS 'Variance'
            ,CASE WHEN @DonationCYNTBUDGET = 0 THEN 0 
                ELSE(@DonationCYNTPAIDTOTAL/@DonationCYNTBUDGET) END AS 'PctBudget'
     
END
 
 
 
/*********************************************************************************************************************************
    FB16 or earlier - before TM conversion
*********************************************************************************************************************************/
 
IF @curSeason < 2017
BEGIN
             
            SET @curSeason = CONCAT('F', RIGHT(@curSeason, 2))
            SET @prevSeason = CONCAT('F', RIGHT(@prevSeason, 2))
 
 
            ---- Build Report --------------------------------------------------------------------------------------------------
 
            --DROP TABLE #ReportBaseOld
            Create table #ReportBaseOld  
            (
                SEASON varchar (15)
                ,CUSTOMER varchar (20)
                ,ITEM varchar (32) 
                ,E_PL varchar (10)
                ,I_PT  varchar (32)
                ,I_PRICE  numeric (18,2)
                ,I_DAMT  numeric (18,2)
                ,ORDQTY bigint
                ,ORDTOTAL numeric (18,2) 
                ,PAIDCUSTOMER  varchar (20)
                ,MINPAYMENTDATE datetime  
                ,PAIDTOTAL numeric (18,2)
            )
 
            INSERT INTO #ReportBaseOld 
            (
                SEASON
                ,CUSTOMER 
                ,ITEM 
                ,E_PL 
                ,I_PT 
                ,I_PRICE  
                ,I_DAMT  
                ,ORDQTY
                ,ORDTOTAL
                ,PAIDCUSTOMER  
                ,MINPAYMENTDATE  
                ,PAIDTOTAL 
            ) 
 
            SELECT
                SEASON
                ,CUSTOMER 
                ,ITEM 
                ,E_PL 
                ,I_PT 
                ,I_PRICE  
                ,I_DAMT  
                ,ORDQTY
                ,ORDTOTAL
                ,PAIDCUSTOMER  
                ,MINPAYMENTDATE  
                ,PAIDTOTAL 
                FROM vwTIReportBase rb where rb.SEASON IN ( @curSeason) 
 
 
 
            ----------------------------------------------------------------------------------------
            ----Budget Information
            SET @DonationCYBudget = CASE WHEN @curSeason = 'F16' THEN '0'
                                        WHEN @curSeason = 'F15' THEN '8920000' END
            SET @DonationCYSUITEBUDGET = CASE WHEN @curSeason = 'F16' THEN '0'
                                        WHEN @curSeason = 'F15' THEN '414295' END
            SET @DonationCYCLUBBUDGET = CASE WHEN @curSeason = 'F16' THEN '0'
                                        WHEN @curSeason = 'F15' THEN '147325' END
            SET @DonationCYLCLUBBUDGET = '0'
            SET @DonationCYSCBudget = @DonationCYSUITEBUDGET+@DonationCYCLUBBUDGET+@DonationCYLCLUBBUDGET  --sum of suite and club budget
 
 
            -----------------------------------------------------------------------------------------
            --Donation Accts and Donations Previous Year 
 
 
            set @DonationPYFTBPAIDTOTAL = 
            (
 
            select SUM(PAIDTOTAL)  from #ReportBaseOld 
            where SEASON IN (@prevSeason)  AND ITEM LIKE 'DON%'
                AND ITEM NOT like 'DONSUITE%' AND ITEM NOT like 'DONCLUB%' AND ITEM <> 'DONC3125+'
            )
            set @DonationPYCLUBPAIDTOTAL = 
            (
 
            select SUM(PAIDTOTAL)  from #ReportBaseOld 
            WHERE SEASON IN (@prevSeason)  
                AND ITEM LIKE 'DONCLUB%'
 
            )
 
            set @DonationPYSUITEPAIDTOTAL = 
            (
 
            select SUM(PAIDTOTAL)  from #ReportBaseOld 
            where SEASON IN (@prevSeason)
                AND ITEM LIKE 'DONSUITE%'
 
            )
 
            set @DonationPYLCLUBPAIDTOTAL = 
            (
 
            select SUM(PAIDTOTAL)  from #ReportBaseOld 
            where SEASON IN (@prevSeason)
                AND ITEM = 'DONC3125'
 
            )
            ----------------------------------------------------------------------------------------------
 
            --Donation Accts and Donations Current Year
 
 
 
            set @DonationCYFTBPAIDTOTAL = 
            (
 
            select SUM(PAIDTOTAL)  from #ReportBaseOld 
            where SEASON IN (@curSeason)  
            AND ITEM LIKE 'DON%'
                AND ITEM NOT like 'DONSUITE%'
                AND ITEM NOT like 'DONCLUB%'
                AND ITEM <> 'DONC3125'
            )
            set @DonationCYCLUBPAIDTOTAL = 
            (
 
            select SUM(PAIDTOTAL)  from #ReportBaseOld 
            where SEASON IN (@curSeason) AND ITEM LIKE 'DONCLUB%'
 
            )
 
            set @DonationCYSUITEPAIDTOTAL = 
            (
 
            select SUM(PAIDTOTAL)  from #ReportBaseOld 
            where SEASON IN (@curSeason) AND ITEM LIKE 'DONSUITE%'
 
            )
 
            set @DonationCYLCLUBPAIDTOTAL = 
            (
 
            select SUM(PAIDTOTAL)  from #ReportBaseOld 
            where SEASON IN (@curSeason) AND ITEM = 'DONC3125'
 
            )
 
 
            --DONCLUB BUDGET  
 
            set @DonationCYCLUBEXPECTED = 
            (
            select SUM(ORDTOTAL)  from #ReportBaseOld 
            where SEASON IN (@curSeason) AND ITEM LIKE 'DONCLUB%'
            AND PAIDTOTAL > 0 
            ) 
 
            --DONSUITE BUDGET
 
            set @DonationCYSUITEEXPECTED = 
            (
            select SUM(ORDTOTAL)  from #ReportBaseOld 
            where SEASON IN (@curSeason) AND ITEM LIKE 'DONSUITE%'
            AND PAIDTOTAL > 0 
            ) 
 
 
            --LEGENDS CLUB BUDGET
 
            set @DonationCYLCLUBEXPECTED = 
            (
            select SUM(ORDTOTAL)  from #ReportBaseOld 
            where SEASON IN (@curSeason) AND ITEM LIKE 'DONC3125%'
            AND PAIDTOTAL > 0 
            ) 
 
            ---------------------------------------------------------------------------------------------------
 
 
            SET @DonationCYNEWSEATEXPECTED =  --@DonationCYNEWSEATBUDGET 
            (
            --NEW RENEWAL BUDGET 
 
            SELECT SUM(DON_AMT * ORDQTY) BUDGET    FROM
            #ReportBaseOld rb
            LEFT join TIPRICELEVELMAP2  on rb.SEASON = TIPRICELEVELMAP2.SEASON 
                    AND rb.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS 
                    = TIPRICELEVELMAP2.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS
                    AND rb.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
                    = TIPRICELEVELMAP2.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
                    AND rb.E_PL = TIPRICELEVELMAP2.I_PL 
                    WHERE
                    TIPRICELEVELMAP2.REPORTCODE =  'FT'
                    AND rb.SEASON  IN (@curSeason)
                    AND rb.ITEM = 'FS'
                    AND PAIDTOTAL > 0
                    AND (rb.I_PT like 'N%' OR rb.I_PT like 'BN%' OR rb.I_PT LIKE '%A')
                    AND REQCONTRIB = 1  
            ) 
 
 
 
            --NEW RENEWAL SEATS
 
 
            SET @DonationCYNEWSEATQTY  = 
            ( 
            SELECT SUM( ORDQTY) BUDGET    FROM
            #ReportBaseOld rb
            LEFT join TIPRICELEVELMAP2 map on rb.SEASON = map.SEASON 
                    AND rb.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS 
                    = map.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS
                    AND rb.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
                    = map.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
                    AND rb.E_PL = map.I_PL 
                    WHERE
                    map.REPORTCODE =  'FT'
                    AND rb.SEASON in (@curSeason)
                    AND rb.ITEM = 'FS'
                    AND PAIDTOTAL > 0
                    AND (rb.I_PT like 'N%' OR rb.I_PT like 'BN%' OR rb.I_PT LIKE '%A')  
                    --AND REQCONTRIB = 1
                    AND map.DON_ITEM NOT LIKE   'DONCLUB%'
                    AND map.DON_ITEM NOT LIKE   'DONSUITE%'
                    AND map.DON_ITEM <>   'DONC3125'
            ) 
            /*
            --NEW RENEWAL REV
 
 
            SET @DonationCYNEWSEATREV  = 
            ( 
            SELECT
            SUM(rb.PAIDTOTAL) REV    
            FROM #ReportBaseOld rb
            LEFT join TIPRICELEVELMAP2 map on rb.SEASON = map.SEASON 
                    AND rb.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS 
                    = map.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS
                    AND rb.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
                    = map.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
                    AND rb.E_PL = map.I_PL 
                    WHERE
                    --map.REPORTCODE =  'FT' 
                    rb.SEASON IN (@curSeason)
                    AND rb.ITEM = 'FS'
                    --AND PAIDTOTAL > 0
                    AND (rb.I_PT like 'N%' OR rb.I_PT like 'BN%' OR rb.I_PT LIKE '%A')  
                    --AND REQCONTRIB = 1
                    AND map.DON_ITEM NOT LIKE   'DONCLUB%'
                    AND map.DON_ITEM NOT LIKE   'DONSUITE%'
            )
            */
            ----------------------------------------------------------------------------------------------
 
 
 
 
            --RENEWAL BUDGET 
 
 
            SET @DonationCYRENEWALSEATEXPECTED = --@DonationCYRENEWALSEATBUDGET
            (
            SELECT SUM(DON_AMT * ORDQTY) BUDGET    FROM
            #ReportBaseOld rb
            LEFT join TIPRICELEVELMAP2  on rb.SEASON = TIPRICELEVELMAP2.SEASON 
                    AND rb.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS 
                    = TIPRICELEVELMAP2.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS
                    AND rb.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
                    = TIPRICELEVELMAP2.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
                    AND rb.E_PL = TIPRICELEVELMAP2.I_PL 
                    WHERE
                    TIPRICELEVELMAP2.REPORTCODE =  'FT'
                    AND rb.SEASON  IN (@curSeason)
                    AND rb.ITEM = 'FS'
                    AND PAIDTOTAL > 0
                    AND rb.I_PT not like 'N%'
                    AND rb.I_PT not like 'BN%'
                    AND rb.I_PT not LIKE '%A'
                    AND REQCONTRIB = 1 
            ) 
 
            --RENEWAL SEATS 
 
            SET @DonationCYRENEWALSEATQTY  = 
            (
            SELECT
                SUM( ORDQTY) QTY   
            FROM #ReportBaseOld rb
            LEFT join TIPRICELEVELMAP2 map on rb.SEASON = map.SEASON 
                    AND rb.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS 
                    = map.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS
                    AND rb.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
                    = map.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
                    AND rb.E_PL = map.I_PL 
                    WHERE
                    map.REPORTCODE =  'FT'
                    AND rb.SEASON  IN (@curSeason)
                    AND rb.ITEM = 'FS'
                    AND PAIDTOTAL > 0
                    AND rb.I_PT not like 'N%'
                    AND rb.I_PT not like 'BN%'
                    AND rb.I_PT not LIKE '%A'
                    --AND REQCONTRIB = 1 
                    AND map.DON_ITEM NOT LIKE    'DONCLUB%'
                    AND map.DON_ITEM NOT LIKE   'DONSUITE%'
 
            ) 
 
 
            -----------------------------------------------------------------------------------------------
 
            -- Season Ticket Accts 
 
 
            set @SeasonTicketAcctsCY = (
                select COUNT (distinct CUSTOMER) Accts    
                from #ReportBaseOld  
                where SEASON in (@curSeason)
                    AND ITEM = 'FS'
                    AND E_PL not in ('10') 
                    --AND ( PAIDTOTAL > 0 OR CUSTOMER in ('152760','164043','186078' ) )
                    --AND CUSTOMER <> '137398'
                group by SEASON
            )
 
 
 
 
            SELECT
            '1' AS RowGroup
            ,'Donor Seats(Renewed)' AS RowCat
            ,CONVERT(VARCHAR, @DonationCYRENEWALSEATQTY) AS CYQty
            ,'Seat Related Contributions (Renewed Season Tickets)' AS RowCat2
            ,CONVERT(VARCHAR, @DonationCYFTBPAIDTOTAL) AS CYRev
            ,@DonationCYRENEWALSEATEXPECTED AS 'Expected'
            ,@DonationCYBudget AS 'Budget'
            ,(@DonationCYFTBPAIDTOTAL-@DonationCYBudget) AS 'Variance'
            ,CASE WHEN @DonationCYBudget = 0 THEN 0 
                ELSE(@DonationCYFTBPAIDTOTAL/@DonationCYBudget) END AS 'PctBudget'
 
            UNION ALL
 
            SELECT
            '1' AS RowGroup
            ,'Donor Seats(New)' AS RowCat
            ,CONVERT(VARCHAR, @DonationCYNEWSEATQTY) AS CYQty
            ,'Seat Related Contributions (New Season Tickets)' AS RowCat2
            ,CONVERT(VARCHAR,0.0) AS CYRev
            ,@DonationCYNEWSEATEXPECTED AS 'Expected'
            ,0.0 AS 'Budget'
            ,0.0 AS 'Variance'
            ,0.0 AS 'PctBudget'
 
 
            UNION ALL
 
 
 
            SELECT
            '2' AS RowGroup
            ,'Season Ticket Accounts' AS RowCat
            ,CONVERT(VARCHAR, @SeasonTicketAcctsCY) AS CYQty
            ,'Seat Related Contributions (MBSC)' AS RowCat2
            ,CONVERT(VARCHAR, @DonationCYCLUBPAIDTOTAL) AS CYRev
            ,@DonationCYCLUBEXPECTED  AS 'Expected'
            ,@DonationCYCLUBBUDGET AS 'Budget'
            ,(@DonationCYCLUBPAIDTOTAL-@DonationCYCLUBBUDGET) AS 'Variance'
            ,CASE WHEN @DonationCYSCBudget = 0 THEN 0 
                ELSE(@DonationCYCLUBPAIDTOTAL/@DonationCYCLUBBUDGET) END AS 'PctBudget'
 
            UNION ALL
 
            SELECT
            '2'
            ,''
            ,'' AS '2013'
            ,'Seat Related Contributions (Suite)'
            ,CONVERT(VARCHAR, @DonationCYSUITEPAIDTOTAL) 
            ,@DonationCYSUITEEXPECTED AS 'Expected'
            ,@DonationCYSUITEBUDGET AS 'Budget'
            ,(@DonationCYSUITEPAIDTOTAL-@DonationCYSCBudget) AS 'Variance'
            ,CASE WHEN @DonationCYSUITEBUDGET = 0 THEN 0 
                ELSE(@DonationCYSUITEPAIDTOTAL/@DonationCYSUITEBUDGET) END AS 'PctBudget'
 
            UNION ALL
 
            SELECT
            '2'
            ,''
            ,'' AS '2013'
            ,'Seat Related Contributions (Legends Club)'
            ,CONVERT(VARCHAR, @DonationCYLCLUBPAIDTOTAL) 
            ,@DonationCYLCLUBEXPECTED AS 'Expected'
            ,@DonationCYLCLUBBUDGET AS 'Budget'
            ,(@DonationCYLCLUBPAIDTOTAL-@DonationCYLCLUBBudget) AS 'Variance'
            ,CASE WHEN @DonationCYLCLUBBUDGET = 0 THEN 0 
                ELSE(@DonationCYLCLUBPAIDTOTAL/@DonationCYLCLUBBUDGET) END AS 'PctBudget'
     
END
 
  
 
END
 
GO
