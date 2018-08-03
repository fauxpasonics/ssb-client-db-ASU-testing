SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




 
-- =============================================
-- Created By: Abbey Meitin
-- Create Date: 2018-04-12
-- Reviewed By: 
-- Reviewed Date: 
-- Description: ASU Football HOB Donations
-- =============================================
 
/***** Revision History
 

*****/







CREATE  PROCEDURE [dbo].[rptCustSeasonTicketFootballRenew1B3_2018] 

AS 

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @curSeason varchar(50)
declare @prevSeason varchar(50)
declare @Sport varchar(50)

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

Set @prevSeason = '2017'
Set @curSeason = '2018'
Set @Sport = 'Football'

Set @DonationYearCY = '2018'
Set @DonationYearPY = '2017'






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
AND fund_name like '%FB%' --Football funds


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


set @DonationPYFTBPAIDTOTAL = 
(

select SUM(donation_paid_amount)  from #DonationBase  
where drive_year IN (@prevSeason)  AND fund_name = '18FBPS'
)
set @DonationPYCLUBPAIDTOTAL = 
(


select SUM(donation_paid_amount)  from #DonationBase  
where drive_year IN (@prevSeason)  AND fund_name = '18FBMFCL'

)

set @DonationPYSUITEPAIDTOTAL = 
(

select SUM(donation_paid_amount)  from #DonationBase  
where drive_year IN (@prevSeason)  AND fund_name = '18FBDSTE'

)

set @DonationPYLCLUBPAIDTOTAL = 
(

select SUM(donation_paid_amount)  from #DonationBase 
where drive_year IN (@prevSeason)  AND fund_name = '18FBLGCL'

)

set @DonationPYNTPAIDTOTAL = 
(

select SUM(donation_paid_amount)  from #DonationBase 
where drive_year IN (@prevSeason)  AND fund_name = '18FBNTCL'

)
----------------------------------------------------------------------------------------------

--Donation Accts and Donations Current Year



set @DonationCYFTBPAIDTOTAL = 
(

select SUM(donation_paid_amount)  from #DonationBase  
where drive_year IN (@curSeason)  AND fund_name = '18FBPS'

)

set @DonationCYCLUBPAIDTOTAL = 
(

select SUM(donation_paid_amount)  from #DonationBase  
where drive_year IN (@curSeason)  AND fund_name =  '18FBMFCL'

)

set @DonationCYSUITEPAIDTOTAL = 
(

select SUM(donation_paid_amount)  from #DonationBase 
where drive_year IN (@curSeason)  AND fund_name = '18FBDSTE'

)

set @DonationCYLCLUBPAIDTOTAL = 
(

select SUM(donation_paid_amount)  from #DonationBase  
where drive_year IN (@curSeason)  AND fund_name = '18FBLGCL'

)

set @DonationCYNTPAIDTOTAL = 
(

select SUM(donation_paid_amount)  from #DonationBase  
where drive_year IN (@curSeason)  AND fund_name = '18FBNTCL'

)


--DONCLUB BUDGET  

set @DonationCYCLUBEXPECTED = 
(
select SUM(pledge_amount)  from #DonationBase 
where drive_year IN (@curSeason)  AND fund_name =  '18FBMFCL'
AND donation_paid_amount  > 0 
) 

--DONSUITE BUDGET

set @DonationCYSUITEEXPECTED = 
(
select SUM(pledge_amount)  from #DonationBase  
where drive_year IN (@curSeason)  AND fund_name =  '18FBDSTE'
AND donation_paid_amount  > 0 
) 


--LEGENDS CLUB BUDGET

set @DonationCYLCLUBEXPECTED = 
(
select SUM(pledge_amount)  from #DonationBase  
where drive_year IN (@curSeason)  AND fund_name =  '18FBLGCL'
AND donation_paid_amount  > 0 
) 

--NORTH TERRACE BUDGET

set @DonationCYNTEXPECTED = 
(
select SUM(pledge_amount)  from #DonationBase  
where drive_year IN (@curSeason)  AND fund_name =  '18FBNTCL'
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


















GO
