SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




--[dbo].[rptCustSeasonTicketMBBRenew1B3_2017] '3/21/2017', '4/21/2017', 'AllData'

CREATE PROCEDURE [dbo].[rptCustSeasonTicketMBBRenew1B3_2017] 


AS 


BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @curSeason VARCHAR(50)
DECLARE @prevSeason VARCHAR(50)
DECLARE @Sport VARCHAR(50)
declare @DonationYearCY varchar(50), @DonationYearPY varchar(50)
, @DonationCYFTBPAIDTOTAL DECIMAL(12,2)
, @DonationCYCLUBPAIDTOTAL DECIMAL(12,2)
, @DonationCYSUITEPAIDTOTAL DECIMAL(12,2)
, @DonationPYFTB DECIMAL(12,2)
, @DonationPYCLUB DECIMAL(12,2)
, @DonationCYPledge DECIMAL(12,2)

, @DonationCYRENEWALSEATQTY DECIMAL(12,2)
, @DonationCYRENEWALSEATBUDGET DECIMAL(12,2)
, @DonationCYNEWSEATQTY DECIMAL(12,2)
, @DonationCYNEWSEATBUDGET DECIMAL(12,2)
, @DonationCYSUITEBUDGET DECIMAL(12,2)
, @DonationCYCLUBBUDGET DECIMAL(12,2)
, @DonationCYLCLUBBUDGET decimal(12,2)
, @DonationCYNTBUDGET decimal(12,2)
, @DonationCYSCBudget DECIMAL(12,2)
, @DonationCYBudget DECIMAL(12,2)

DECLARE @SeasonTicketAcctsCY INT, @SeasonTicketAcctsPY INT

SET @prevSeason = '2016'
SET @curSeason = '2017'
SET @Sport = 'MBB'

SET @DonationYearCY = '2017'
SET @DonationYearPY = '2016'

--DECLARE	@dateRange VARCHAR(20)= 'AllData'
--DECLARE @startDate DATE = DATEADD(month,-1,GETDATE())
--DECLARE @endDate DATE = GETDATE()

--DROP TABLE #Reportbase


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
where rb.drive_year IN ( @curSeason) 
AND fund_name like '%BB%' --Men's Basketball funds




IF OBJECT_ID ('tempdb..#ReportBase') IS NOT NULL
	DROP TABLE #ReportBase

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


----------------------------------------------------------------------------------------------

--Donation Accts and Donations

SET @DonationCYFTBPAIDTOTAL = 
(

select SUM(donation_paid_amount)  from #DonationBase  
where drive_year IN (@curSeason)  AND fund_name = '17BBPS'
)
SET @DonationCYCLUBPAIDTOTAL = 0
/*(

select SUM(donation_paid_amount)  from #DonationBase  
where drive_year IN (@curSeason)  AND fund_name =  '17FBMFCL'

)*/

SET @DonationCYSUITEPAIDTOTAL = 0
/*(

SELECT SUM(PAIDTOTAL)  FROM #ReportBase 
WHERE SEASON IN (@curSeason) AND ITEM = 'DONSUITE'

)*/


--DONCLUB BUDGET  
SET @DonationCYCLUBBUDGET = 0
/*(
SELECT SUM(ORDTOTAL)  FROM #ReportBase 
WHERE SEASON IN (@curSeason) AND ITEM = 'DONCLUB'
AND PAIDTOTAL > 0 
) */

--DONSUITE BUDGET
SET @DonationCYSUITEBUDGET = 0
/*(
SELECT SUM(ORDTOTAL)  FROM #ReportBase 
WHERE SEASON IN (@curSeason) AND ITEM = 'DONSUITE'
AND PAIDTOTAL > 0 
) */

---------------------------------------------------------------------------------------------------

SET @DonationCYNEWSEATBUDGET  = 
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

SET @DonationCYRENEWALSEATBUDGET = 
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

SET @SeasonTicketAcctsCY = (
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
,'' AS CYRev
,@DonationCYRENEWALSEATBUDGET AS 'Budget'

UNION ALL 

SELECT
'1'
,'Donor Seats(New)'
,CONVERT(VARCHAR, @DonationCYNEWSEATQTY) 
,'Seat Related Contributions (New Season Tickets)'
,''
,@DonationCYNEWSEATBUDGET AS 'Budget'

UNION ALL

SELECT
'1'
,'Total'
,CONVERT(VARCHAR, @DonationCYNEWSEATQTY+@DonationCYRENEWALSEATQTY) 
,''
,CONVERT(VARCHAR, @DonationCYFTBPAIDTOTAL)
,@DonationCYNEWSEATBUDGET + @DonationCYRENEWALSEATBUDGET AS 'Budget'



UNION ALL 



SELECT
'2' AS RowGroup
,'Season Ticket Accounts' AS RowCat
,CONVERT(VARCHAR, @SeasonTicketAcctsCY) AS CYQty
,'' AS RowCat2 --bwh removed this label "Seat Related Contributions (MBSC)" per Abbey Meitin
,CONVERT(VARCHAR, @DonationCYCLUBPAIDTOTAL) AS CYRev
,@DonationCYCLUBBUDGET  AS Budget

/*
UNION ALL 

Select
'2'
,''
,'' as '2013'
,'Seat Related Contributions (Suite)'
,CONVERT(varchar, @DonationCYSUITEPAIDTOTAL) 
,@DonationCYSUITEBUDGET
*/




END 


GO
