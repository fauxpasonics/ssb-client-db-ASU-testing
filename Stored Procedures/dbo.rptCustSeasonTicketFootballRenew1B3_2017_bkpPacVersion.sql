SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







--exec [rptCustSeasonTicketFootballRenew1B3_2015ProdReportBaseTest]

CREATE  PROCEDURE [dbo].[rptCustSeasonTicketFootballRenew1B3_2017_bkpPacVersion] 

AS 

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @curSeason varchar(50)
declare @prevSeason varchar(50)
declare @studentprevSeason varchar(50)
declare @studentcurSeason varchar(50)
declare @DonationYearCY varchar(50), @DonationYearPY varchar(50)
, @DonationCYFTBPAIDTOTAL decimal(12,2)
, @DonationCYCLUBPAIDTOTAL decimal(12,2)
, @DonationCYSUITEPAIDTOTAL decimal(12,2)
, @DonationCYLCLUBPAIDTOTAL decimal(12,2)
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
, @DonationPYCLUBPAIDTOTAL decimal(12,2)
, @DonationPYSUITEPAIDTOTAL decimal(12,2)
, @DonationPYLCLUBPAIDTOTAL decimal(12,2)
, @DonationCYSCBudget DECIMAL(12,2) --suite+club budget total
, @DonationCYSUITEBUDGET decimal(12,2)
, @DonationCYCLUBBUDGET decimal(12,2)
, @DonationCYLCLUBBUDGET decimal(12,2)
, @DonationCYRENEWALSEATREV decimal(12,2)
, @DonationCYNEWSEATREV decimal(12,2)
, @DonationCYBudget DECIMAL(12,2)


declare @SeasonTicketAcctsCY int, @SeasonTicketAcctsPY int

Set @prevSeason = 'F16'
Set @curSeason = 'F17'
Set @DonationYearCY = '2017'
Set @DonationYearPY = '2016'






---- Build Report --------------------------------------------------------------------------------------------------

--DROP TABLE #ReportBase
Create table #ReportBase  
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

INSERT INTO #ReportBase 
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
SET @DonationCYBudget = '0'
SET @DonationCYSUITEBUDGET = '0'
SET @DonationCYCLUBBUDGET = '0'
SET @DonationCYLCLUBBUDGET = '0'
SET @DonationCYSCBudget = @DonationCYSUITEBUDGET+@DonationCYCLUBBUDGET+@DonationCYLCLUBBUDGET  --sum of suite and club budget


-----------------------------------------------------------------------------------------
--Donation Accts and Donations Previous Year 


set @DonationPYFTBPAIDTOTAL = 
(

select SUM(PAIDTOTAL)  from #ReportBase 
where SEASON IN (@prevSeason)  AND ITEM LIKE 'DON%' 
    AND ITEM NOT like 'DONSUITE%' AND ITEM NOT like 'DONCLUB%' AND ITEM <> 'DONC3125'
)
set @DonationPYCLUBPAIDTOTAL = 
(

select SUM(PAIDTOTAL)  from #ReportBase 
WHERE SEASON IN (@prevSeason)  
	AND ITEM LIKE 'DONCLUB%'

)

set @DonationPYSUITEPAIDTOTAL = 
(

select SUM(PAIDTOTAL)  from #ReportBase 
where SEASON IN (@prevSeason)
	AND ITEM LIKE 'DONSUITE%'

)

set @DonationPYLCLUBPAIDTOTAL = 
(

select SUM(PAIDTOTAL)  from #ReportBase 
where SEASON IN (@prevSeason)
	AND ITEM = 'DONC3125'

)
----------------------------------------------------------------------------------------------

--Donation Accts and Donations Current Year



set @DonationCYFTBPAIDTOTAL = 
(

select SUM(PAIDTOTAL)  from #ReportBase 
where SEASON IN (@curSeason)  
AND ITEM LIKE 'DON%' 
    AND ITEM NOT like 'DONSUITE%' 
	AND ITEM NOT like 'DONCLUB%'
	AND ITEM <> 'DONC3125'
)
set @DonationCYCLUBPAIDTOTAL = 
(

select SUM(PAIDTOTAL)  from #ReportBase 
where SEASON IN (@curSeason) AND ITEM LIKE 'DONCLUB%'

)

set @DonationCYSUITEPAIDTOTAL = 
(

select SUM(PAIDTOTAL)  from #ReportBase 
where SEASON IN (@curSeason) AND ITEM LIKE 'DONSUITE%'

)

set @DonationCYLCLUBPAIDTOTAL = 
(

select SUM(PAIDTOTAL)  from #ReportBase 
where SEASON IN (@curSeason) AND ITEM = 'DONC3125'

)


--DONCLUB BUDGET  

set @DonationCYCLUBEXPECTED = 
(
select SUM(ORDTOTAL)  from #ReportBase 
where SEASON IN (@curSeason) AND ITEM LIKE 'DONCLUB%'
AND PAIDTOTAL > 0 
) 

--DONSUITE BUDGET

set @DonationCYSUITEEXPECTED = 
(
select SUM(ORDTOTAL)  from #ReportBase 
where SEASON IN (@curSeason) AND ITEM LIKE 'DONSUITE%'
AND PAIDTOTAL > 0 
) 


--LEGENDS CLUB BUDGET

set @DonationCYLCLUBEXPECTED = 
(
select SUM(ORDTOTAL)  from #ReportBase 
where SEASON IN (@curSeason) AND ITEM LIKE 'DONC3125%'
AND PAIDTOTAL > 0 
) 

---------------------------------------------------------------------------------------------------


SET @DonationCYNEWSEATEXPECTED =  --@DonationCYNEWSEATBUDGET 
(
--NEW RENEWAL BUDGET 

SELECT SUM(DON_AMT * ORDQTY) BUDGET    FROM 
#ReportBase rb
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
#ReportBase rb
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
	  AND map.DON_ITEM NOT LIKE	'DONCLUB%'
	  AND map.DON_ITEM NOT LIKE	'DONSUITE%'
	  AND map.DON_ITEM <>	'DONC3125'
) 
/*
--NEW RENEWAL REV


SET @DonationCYNEWSEATREV  = 
( 
SELECT 
SUM(rb.PAIDTOTAL) REV    
FROM #ReportBase rb
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
	  AND map.DON_ITEM NOT LIKE	'DONCLUB%'
	  AND map.DON_ITEM NOT LIKE	'DONSUITE%'
)
*/
----------------------------------------------------------------------------------------------




--RENEWAL BUDGET 


SET @DonationCYRENEWALSEATEXPECTED = --@DonationCYRENEWALSEATBUDGET
(
SELECT SUM(DON_AMT * ORDQTY) BUDGET    FROM 
#ReportBase rb
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
FROM #ReportBase rb
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
	  AND map.DON_ITEM NOT LIKE	 'DONCLUB%'
	  AND map.DON_ITEM NOT LIKE	'DONSUITE%'

) 


-----------------------------------------------------------------------------------------------

-- Season Ticket Accts 


set @SeasonTicketAcctsCY = (
    select COUNT (distinct CUSTOMER) Accts    
    from #ReportBase  
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














GO
