SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROC [dbo].[Transaction_Detail__c]
AS 


BEGIN 


CREATE TABLE #SalesBase 
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

) 

INSERT #SalesBase
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

)

select
     tkTrans.SEASON
	,tkTransItem.CUSTOMER
	,tkTransItem.ITEM
	,tkTransItemEvent.E_PL
	,tkTransItem.I_PT
	,tkTransItem.I_PRICE
	,tkTransItem.I_DAMT 
	,sum(isnull(tkTransItem.I_OQTY_TOT,0)) ORDQTY
	,sum(isnull(tkTransItem.I_OQTY_TOT,0) * (isnull(I_Price,0) - isnull(I_Damt,0)))   as ORDTOTAL
	
FROM 
	dbo.TK_TRANS tkTrans
	INNER JOIN dbo.TK_TRANS_ITEM tkTransItem
	 on tkTrans.Season = tkTransItem.Season
	 and tkTrans.Trans_No = tkTransItem.Trans_No
	 	 
	 
	LEFT JOIN 
	 (select
	   subtkTransItemEvent.SEASON,
	   max(isnull(subtkTransItemEvent.E_PL,5)) E_PL,
	   subtkTransItemEvent.TRANS_NO,
	   subtkTransItemEvent.VMC
	  FROM
	   dbo.TK_TRANS_ITEM_EVENT subtkTransItemEvent
	  --INNER JOIN  #pSeasons subpSeasons
	  -- on subtkTransItemEvent.SEASON = subpSeasons.Season
	  group by
	   subtkTransItemEvent.SEASON,
	   subtkTransItemEvent.TRANS_NO,
	   subtkTransItemEvent.VMC) tkTransItemEvent
			on tkTransItem.SEASON = tkTransItemEvent.SEASON 
			and tkTransItem.TRANS_NO = tkTransItemEvent.TRANS_NO 
			and tkTransItem.VMC = tkTransItemEvent.VMC
	
	INNER JOIN  dbo.TK_ITEM tkItem
	 on tkTransItem.SEASON = tkItem.SEASON and tkTransItem.ITEM = tkItem.ITEM
	 
    -- INNER JOIN  #pSeasons Seasons
	   --on tkTrans.SEASON = Seasons.Season
	

where
     (isnull(tkTrans.E_STAT,'') not in ( 'MI','MO','TO','TI','EO','EI') OR tkTrans.E_STAT IS NULL )

     
group by
	 tkTrans.SEASON
	,tkTransItem.CUSTOMER
 	,tkTransItem.ITEM
	,tkTransItemEvent.E_PL
	,tkTransItem.I_PT 
	,tkTransItem.I_PRICE 
	,tkTransItem.I_DAMT 

-- Create #PaidFinal --------------------------------------------------------------------------------------------------

CREATE TABLE #PaidFinal
( 
  CUSTOMER varchar (20)
 ,MINPAYMENTDATE datetime 
 ,ITEM varchar (32) 
 ,E_PL varchar (10)
 ,I_PT  varchar (32)
 ,I_PRICE  numeric (18,2)  
 ,PAIDTOTAL numeric (18,2)
 ,SEASON varchar (15) 
) 

INSERT #PaidFinal
(
  CUSTOMER
 ,MINPAYMENTDATE 
 ,ITEM
 ,E_PL
 ,I_PT
 ,I_PRICE
 ,PAIDTOTAL
 ,SEASON 
)

select
	tkTransItem.CUSTOMER
	,min(tkTrans.DATE) minPaymentDate 
	,tkTransItem.ITEM
	,tkTransItemEvent.E_PL
	,tkTransItem.I_PT
	,tkTransItem.I_PRICE 
	,SUM(ISNULL((tkTransItemPaymode.I_PAY_PAMT ),0))  PAIDTOTAL
	,tkTransItem.SEASON 

FROM
	dbo.TK_TRANS tkTrans
	INNER JOIN dbo.TK_TRANS_ITEM tkTransItem
	on tkTrans.Season = tkTransItem.Season
	 and tkTrans.Trans_No = tkTransItem.Trans_No
	LEFT JOIN 
	 (select
	   subtkTransItemEvent.SEASON,
	   max(isnull(subtkTransItemEvent.E_PL,5)) E_PL,
	   subtkTransItemEvent.TRANS_NO,
	   subtkTransItemEvent.VMC
	  FROM
	   dbo.TK_TRANS_ITEM_EVENT subtkTransItemEvent
	  --INNER JOIN #pSeasons subpSeasons
	  -- on subtkTransItemEvent.SEASON = subpSeasons.Season
	  group by
	   subtkTransItemEvent.SEASON,
	   subtkTransItemEvent.TRANS_NO,
	   subtkTransItemEvent.VMC) tkTransItemEvent
	    on tkTransItem.SEASON = tkTransItemEvent.SEASON
	     and tkTransItem.TRANS_NO = tkTransItemEvent.TRANS_NO
	     and tkTransItem.VMC = tkTransItemEvent.VMC
	
		inner join dbo.TK_TRANS_ITEM_PAYMODE tkTransItemPaymode 
		ON tkTransItem.SEASON = tkTransItemPaymode.SEASON 
		and tkTransItem.TRANS_NO = tkTransItemPaymode.TRANS_NO 
		and tkTransItem.VMC = tkTransItemPaymode.VMC
	
	INNER JOIN  dbo.TK_ITEM tkItem
	 on tkTransItem.SEASON = tkItem.SEASON and tkTransItem.ITEM = tkItem.ITEM
	 
	--INNER JOIN  #pSeasons Seasons
	--   on tkTrans.SEASON = Seasons.Season 
	 
	LEFT OUTER JOIN dbo.TK_PTABLE_PRLEV tkPTablePRLev
	 on tkTransItem.SEASON = tkPTablePRLev.SEASON and tkItem.ptable = tkPTablePRLev.ptable
	  and tkTransItemEvent.E_PL  = tkPTablePRLev.PL
	  
where
     (isnull(tkTrans.E_STAT,'') not in ( 'MI','MO','TO','TI','EO','EI') OR tkTrans.E_STAT IS NULL )
     AND tkTransItemPaymode.I_PAY_TYPE = 'I'

group by
	 tkTransItem.CUSTOMER
	,tkTransItem.ITEM
	,tkTransItemEvent.E_PL
	,tkTransItem.I_PT
	,tkTransItem.I_PRICE
	,tkTransItem.Season
having SUM(ISNULL((tkTransItemPaymode.I_PAY_PAMT ),0)) > 0 	

---- Build Report --------------------------------------------------------------------------------------------------

TRUNCATE TABLE wrk.Transaction_Detail__c 
;


INSERT wrk.Transaction_Detail__c 
 (
  Season__c 
 ,Customer__c 
 ,Item__c  
 ,Price_Level__c 
 ,Price_Type__c  
 ,Item_Price__c 
 ,Item_Discount_Amount__c  
 ,Order_Quantity__c  
 ,Order_Total__c  
 ,Paid_Customer__c  
 ,Min_Pmt_Date__c 
 ,Paid_Total__c 
)  

select 
	 SalesBase.SEASON
	,SalesBase.CUSTOMER 
	,SalesBase.ITEM
	,SalesBase.E_PL
	,SalesBase.I_PT
	,SalesBase.I_PRICE  
    ,SalesBase.I_DAMT 
	,SalesBase.ORDQTY
	,SalesBase.ORDTOTAL
	,PaidFinal.CUSTOMER as PAIDCUSTOMER 
	,PaidFinal.MINPAYMENTDATE
	,isnull(PaidFinal.PAIDTOTAL,0) PAIDTOTAL 
 
	from #SalesBase  SalesBase 

	   LEFT JOIN  #PaidFinal PaidFinal
	  on    SalesBase.CUSTOMER = PaidFinal.CUSTOMER
	    and SalesBase.SEASON = PaidFinal.SEASON 
        and SalesBase.ITEM = PaidFinal.ITEM
        and isnull(SalesBase.E_PL,99)  = isnull(PaidFinal.E_PL,99) 
        and isnull(SalesBase.I_PT,99) = isnull(PaidFinal.I_PT,99) 
        and SalesBase.I_PRICE = PaidFinal.I_PRICE
  WHERE SalesBase.ORDQTY <> 0
;


END 




GO
