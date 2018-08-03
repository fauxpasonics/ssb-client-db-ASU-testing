SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





--exec rptCustSeasonTicketWBRenew2_2014Prod


CREATE    PROCEDURE [dbo].[rptCustSeasonTicketBaseballRenew2_2015Prod] 

as
BEGIN

set transaction isolation level read uncommitted
      
declare @curSeason varchar(50)
declare @prevSeason varchar(50)


Set @prevSeason = 'B14'
Set @curSeason = 'B15'

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
 FROM vwTIReportBase rb where rb.SEASON IN ( @curSeason, @prevSeason) 

----------------------------------------------------------------------------------------------


create table #SeasonSummary
(
	season varchar(100)
	,saleTypeName  varchar(50)
	,pl_class varchar(50)
	,renewal int
	,qty  int
	,amt money
)



insert into #SeasonSummary
(
 season
,saleTypeName
,pl_class
,renewal
,qty
,amt
)


--Regular Season Ticket Current Season
select 
      rb.SEASON
      ,'Season' SALETYPENAME
      ,case when TIPRICELEVELMAP2.PL_CLASS IS Null then 'NOT CLASSIFIED'
		else TIPRICELEVELMAP2.PL_CLASS
      end as PL_CLASS 
      
      , CASE WHEN rb.I_PT like 'N%' THEN 0   
      WHEN rb.I_PT LIKE '%A' THEN 0 
      ELSE 1 END as  RENEWAL
      ,SUM(ORDQTY) QTY 
      ,SUM(ORDTOTAL) AMT
from #ReportBase rb
LEFT join TIPRICELEVELMAP2  on rb.SEASON = TIPRICELEVELMAP2.SEASON 
      AND rb.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS 
      = TIPRICELEVELMAP2.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS
      AND rb.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
      = TIPRICELEVELMAP2.I_PT COLLATE SQL_Latin1_General_CP1_CS_AS 
      AND rb.E_PL = TIPRICELEVELMAP2.I_PL 
      AND TIPRICELEVELMAP2.REPORTCODE =  'BT'
where rb.ITEM = 'BBS'  AND rb.SEASON in (@curSeason, @prevSeason)
	AND ( PAIDTOTAL > 0 )
GROUP BY	rb.SEASON, rb.I_PT , rb.E_PL,  PL_CLASS 


select 
	 isnull(PL.PL_CLASS,'') as QtyCat
	,isnull(case when PL.PL_CLASS = 'NOT CLASSIFIED' then 0 else bbPrev.bbPrevQty end,0) AS PYQty
	,isnull(bbPrev.bbPrevQty,0) AS PYQtyUnfiltered
	,isnull(bbPrev.bbPrevAmt,0) AS PYAmt
	,isnull(bbCurRenew.bbCurRenewQty,0) AS CYRenewQty
	,isnull(bbCurRenew.bbCurRenewAmt,0) AS CYRenewAmt
	,isnull(bbCurNew.bbCurNewQty,0) AS CYNewQty
	,isnull(bbCurNew.bbCurNewAmt,0) AS CYNewAmt
	,RenewPct = case when PL.PL_CLASS = 'NOT CLASSIFIED' then null when cast(isnull(bbPrev.bbPrevQty,0) as float) = 0 then 0 
	  else cast(isnull(bbCurRenew.bbCurRenewQty,0) as float) / cast(bbPrev.bbPrevQty as float) end
	,TotalQty = isnull(bbCurRenew.bbCurRenewQty,0)  + isnull(bbCurNew.bbCurNewQty,0)
	,TotalAmt = isnull(bbCurRenew.bbCurRenewAmt,0) + isnull(bbCurNew.bbCurNewAmt,0)
	,isnull(CAPACITY.CAPACITY,0) Capacity
	,isnull(CAPACITY.SORT_ORDER,998) sortOrder --998 to be last in sort order, but before 999 NOT CLASSIFIED
	,case when isnull(PL.PL_CLASS,'') in ('General Admission','Field Level','Reserved') then 1 else 0 end as HideRow
From (select distinct PL_CLASS from #seasonsummary) PL   
left outer join (select PL_CLASS, sum(QTY) as bbPrevQty, sum(AMT) as bbPrevAmt 
					from #seasonsummary 
					where season in (@prevSeason)				
					 group by PL_CLASS)  bbPrev
		on PL.PL_CLASS = bbPrev.PL_CLASS  

left outer join (select PL_CLASS
	, sum(QTY) as bbCurRenewQty, sum(AMT) as bbCurRenewAmt 
					from #seasonsummary 
					where SEASON in (@curSeason)	  
					and renewal = '1' 
					group by PL_CLASS) bbCurRenew
		on PL.PL_CLASS =  bbCurRenew.PL_CLASS 

left outer join (select PL_CLASS, sum(QTY) as bbCurNewQty, sum(AMT) as bbCurNewAmt 
					from #seasonsummary 
					where season in (@curSeason)	 
					 and renewal = '0' 
					group by PL_CLASS ) bbCurNew
		on PL.PL_CLASS =  bbCurNew.PL_CLASS 
left outer join dbo.TIPRICELEVELCAPACITY Capacity 
	on PL.PL_CLASS=CAPACITY.PL_CLASS And CAPACITY.SEASON = @curSeason		
order by sortOrder

	




END 





GO
