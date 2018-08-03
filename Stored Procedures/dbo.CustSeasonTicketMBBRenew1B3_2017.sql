SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [dbo].[CustSeasonTicketMBBRenew1B3_2017] 
    (
      @startDate DATE
    , @endDate DATE
    , @dateRange VARCHAR(20)
    )
AS 


BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @curSeason varchar(50)
declare @prevSeason varchar(50)
--declare @DonationYearCY varchar(50), @DonationYearPY varchar(50)
, @DonationCYFTBPAIDTOTAL decimal(12,2)
, @DonationCYCLUBPAIDTOTAL decimal(12,2)
, @DonationCYSUITEPAIDTOTAL decimal(12,2)
, @DonationPYFTB decimal(12,2)
, @DonationPYCLUB decimal(12,2)
, @DonationCYPledge decimal(12,2)

, @DonationCYRENEWALSEATQTY decimal(12,2)
, @DonationCYRENEWALSEATBUDGET decimal(12,2)
, @DonationCYNEWSEATQTY decimal(12,2)
, @DonationCYNEWSEATBUDGET decimal(12,2)
, @DonationCYSUITEBUDGET decimal(12,2)
, @DonationCYCLUBBUDGET decimal(12,2)

declare @SeasonTicketAcctsCY int, @SeasonTicketAcctsPY int

Set @prevSeason = 'BB16'
Set @curSeason = 'BB17'

--DECLARE	@dateRange VARCHAR(20)= 'AllData'
--DECLARE @startDate DATE = DATEADD(month,-1,GETDATE())
--DECLARE @endDate DATE = GETDATE()


--DROP TABLE #Reportbase
----------------------------------------------------------------------------------------

--Donation Accts and Donations Previous Year 
--set @DonationPYFTB = (
--	select sum(l.transAmount) amount
--	from dbo.ADVContactTransHeader (nolock) h
--	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
--	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
--	where p.ProgramCode in ('FTB') 
--	and h.transType = 'Cash Receipt'
--	and h.transYear = @DonationYearPY
--)

--set @DonationPYCLUB = (
--	select sum(l.transAmount) amount
--	from dbo.ADVContactTransHeader (nolock) h
--	inner join dbo.ADVContactTransLineItems (nolock) l on h.TransID = l.TransID
--	inner join dbo.ADVProgram (nolock) p on l.ProgramID = p.programID
--	where p.ProgramCode in ('SCLUB') 
--	and h.transType = 'Cash Receipt'
--	and h.transYear = @DonationYearPY
--)




---- Build Report --------------------------------------------------------------------------------------------------

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
 FROM vwTIReportBase rb 
WHERE   (@dateRange = 'AllData' 
		 AND rb.season = @curseason)
		OR (@dateRange <> 'AllData' 
			AND rb.season = @curSeason 
			AND rb.MINPAYMENTDATE 
				BETWEEN @startDate AND @endDate)


----------------------------------------------------------------------------------------------
--Donation Accts and Donations



set @DonationCYFTBPAIDTOTAL = 
(

select SUM(PAIDTOTAL)  from #ReportBase 
where SEASON IN (@curSeason)  AND ITEM LIKE 'DON%' 
	AND ITEM <> 'DONSUITE' AND ITEM <> 'DONCLUB'
)
set @DonationCYCLUBPAIDTOTAL = 
(

select SUM(PAIDTOTAL)  from #ReportBase 
where SEASON IN (@curSeason) AND ITEM = 'DONCLUB'

)

set @DonationCYSUITEPAIDTOTAL = 
(

select SUM(PAIDTOTAL)  from #ReportBase 
where SEASON IN (@curSeason) AND ITEM = 'DONSUITE'

)


--DONCLUB BUDGET  
set @DonationCYCLUBBUDGET = 
(
select SUM(ORDTOTAL)  from #ReportBase 
where SEASON IN (@curSeason) AND ITEM = 'DONCLUB'
AND PAIDTOTAL > 0 
) 

--DONSUITE BUDGET
set @DonationCYSUITEBUDGET = 
(
select SUM(ORDTOTAL)  from #ReportBase 
where SEASON IN (@curSeason) AND ITEM = 'DONSUITE'
AND PAIDTOTAL > 0 
) 

---------------------------------------------------------------------------------------------------

SET @DonationCYNEWSEATBUDGET  = 
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
       TIPRICELEVELMAP2.REPORTCODE =  'BBT' 
      AND rb.SEASON  IN (@curSeason)
      AND rb.ITEM = 'FS'
      AND (PAIDTOTAL > 0  OR rb.I_PT = 'BNYALC') 
	  AND CUSTOMER <> '137398'
      AND (rb.I_PT like 'N%' OR rb.I_PT like 'BN%' OR rb.I_PT LIKE '%A')
      AND REQCONTRIB = 1  
) 



--NEW RENEWAL SEATS

SET @DonationCYNEWSEATQTY  = 
( 
SELECT SUM( ORDQTY) BUDGET    FROM 
#ReportBase rb
LEFT join TIPRICELEVELMAP2  on rb.SEASON = TIPRICELEVELMAP2.SEASON 
      AND rb.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS 
      = TIPRICELEVELMAP2.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS
      AND rb.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
      = TIPRICELEVELMAP2.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
      AND rb.E_PL = TIPRICELEVELMAP2.I_PL 
      WHERE
       TIPRICELEVELMAP2.REPORTCODE =  'BBT' 
      AND rb.SEASON IN (@curSeason)
      AND rb.ITEM = 'FS'
      AND (PAIDTOTAL > 0  OR rb.I_PT = 'BNYALC') 
	  AND CUSTOMER <> '137398'
      AND (rb.I_PT like 'N%' OR rb.I_PT like 'BN%' OR rb.I_PT LIKE '%A')  
      AND REQCONTRIB = 1 
) 

----------------------------------------------------------------------------------------------



--RENEWAL BUDGET 

SET @DonationCYRENEWALSEATBUDGET = 
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
       TIPRICELEVELMAP2.REPORTCODE =  'BBT' 
      AND rb.SEASON  IN (@curSeason)
      AND rb.ITEM = 'FS'
      AND (PAIDTOTAL > 0  OR rb.I_PT = 'BNYALC') 
	  AND CUSTOMER <> '137398'
      AND rb.I_PT not like 'N%' 
      AND rb.I_PT not like 'BN%' 
      AND rb.I_PT not LIKE '%A'
      AND REQCONTRIB = 1 
) 

--RENEWAL SEATS 
SET @DonationCYRENEWALSEATQTY  = 
(
SELECT SUM( ORDQTY) BUDGET    FROM 
#ReportBase rb
LEFT join TIPRICELEVELMAP2  on rb.SEASON = TIPRICELEVELMAP2.SEASON 
      AND rb.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS 
      = TIPRICELEVELMAP2.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS
      AND rb.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
      = TIPRICELEVELMAP2.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
      AND rb.E_PL = TIPRICELEVELMAP2.I_PL 
      WHERE
       TIPRICELEVELMAP2.REPORTCODE =  'BBT' 
      AND rb.SEASON  IN (@curSeason)
      AND rb.ITEM = 'FS'
      AND (PAIDTOTAL > 0  OR rb.I_PT = 'BNYALC') 
	  AND CUSTOMER <> '137398'
      AND rb.I_PT not like 'N%' 
      AND rb.I_PT not like 'BN%' 
      AND rb.I_PT not LIKE '%A'
      AND REQCONTRIB = 1 

) 

-----------------------------------------------------------------------------------------------
-- Season Ticket Accts 

set @SeasonTicketAcctsCY = (
	select COUNT (distinct CUSTOMER) Accts	
	from #ReportBase  
	where SEASON in (@curSeason)
		AND ITEM = 'FS'
	    AND (PAIDTOTAL > 0  OR I_PT = 'BNYALC') 
	    AND CUSTOMER <> '137398'
	group by SEASON
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
,'' AS RowCat2 --bwh removed this label "Seat Related Contributions (MBSC)" per Abbey Carter
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
