SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[Load_stg_FactTicketSalesBaseItems]
 
AS 
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


-- Create #SalesBase --------------------------------------------------------------------------------------------------

Create table #SalesBase 
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
,ORDFEE NUMERIC (18,2)
,OrderConvenienceFee NUMERIC (18,2)

) 

Insert Into #SalesBase
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
 ,ORDFEE
 ,OrderConvenienceFee
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
      ,sum(isnull(tkTransItem.I_OQTY_TOT,0) * (isnull(I_Price,0)) - isnull(I_Damt,0))   as ORDTOTAL 
	  , SUM((ISNULL(tkTransItem.I_OQTY_TOT,0) * ISNULL(tkTransItem.I_FPRICE,0))) ORDFEE
	  , SUM((ISNULL(tkTransItem.I_OQTY_TOT,0) * ISNULL(tkTransItem.I_CPRICE,0))) OrderConvenienceFee
							      
	FROM 
      dbo.TK_TRANS tkTrans
      INNER JOIN dbo.TK_TRANS_ITEM tkTransItem
      on tkTrans.Season = tkTransItem.Season
      and tkTrans.Trans_No = tkTransItem.Trans_No
            
       
      LEFT JOIN 
       (select
         subtkTransItemEvent.SEASON,
         max(isnull(subtkTransItemEvent.E_PL,99999)) E_PL,
         subtkTransItemEvent.TRANS_NO,
         subtkTransItemEvent.VMC
        FROM
         dbo.TK_TRANS_ITEM_EVENT subtkTransItemEvent
        INNER JOIN  TI_ReportBaseSeasons subpSeasons
         on subtkTransItemEvent.SEASON  COLLATE Latin1_General_CS_AS = subpSeasons.Season COLLATE Latin1_General_CS_AS
        group by
         subtkTransItemEvent.SEASON,
         subtkTransItemEvent.TRANS_NO,
         subtkTransItemEvent.VMC) tkTransItemEvent
                 on tkTransItem.SEASON = tkTransItemEvent.SEASON 
                 and tkTransItem.TRANS_NO = tkTransItemEvent.TRANS_NO 
                 and tkTransItem.VMC = tkTransItemEvent.VMC
      
      INNER JOIN  dbo.TK_ITEM tkItem
      on tkTransItem.SEASON = tkItem.SEASON and tkTransItem.ITEM = tkItem.ITEM
      
      
	  ----- does the where clause apply to texas? 
	  
where
	tkTrans.SOURCE <> 'TK.ERES.SH.PURCHASE'
    and   (tkTrans.E_STAT not in ( 'MI','MO','TO','TI','EO', 'EO R','EI') or tkTrans.E_STAT IS NULL)

    
group by
      tkTrans.SEASON
      ,tkTransItem.CUSTOMER
     ,tkTransItem.ITEM
      ,tkTransItemEvent.E_PL
      ,tkTransItem.I_PT 
      ,tkTransItem.I_PRICE 
     ,tkTransItem.I_DAMT 


-- Create #PaidFinal --------------------------------------------------------------------------------------------------

Create table #PaidFinal
( 
  CUSTOMER varchar (20)
 ,MINPAYMENTDATE datetime 
 ,ITEM varchar (32) 
 ,E_PL varchar (10)
 ,I_PT  varchar (32)
 ,I_PRICE  numeric (18,2)
 ,I_DAMT   numeric (18,2)
 ,PAIDTOTAL numeric (18,2)
 ,SEASON varchar (15) 
) 

Insert Into #PaidFinal
(
	CUSTOMER
 ,MINPAYMENTDATE 
 ,ITEM
 ,E_PL
 ,I_PT
 ,I_PRICE
 ,I_DAMT
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
	  ,tkTransItem.I_DAMT 
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
         max(isnull(subtkTransItemEvent.E_PL,99999)) E_PL,
         subtkTransItemEvent.TRANS_NO,
         subtkTransItemEvent.VMC
        FROM
         dbo.TK_TRANS_ITEM_EVENT subtkTransItemEvent
        INNER JOIN  TI_ReportBaseSeasons subpSeasons
         on subtkTransItemEvent.SEASON COLLATE Latin1_General_CS_AS = subpSeasons.Season COLLATE Latin1_General_CS_AS
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

       
      --LEFT OUTER JOIN dbo.TK_PTABLE_PRLEV tkPTablePRLev
      --on tkTransItem.SEASON = tkPTablePRLev.SEASON and tkItem.ptable = tkPTablePRLev.ptable
      --  and tkTransItemEvent.E_PL  = tkPTablePRLev.PL
        
      ----- does the where clause apply to texas?
	  
where
	tkTrans.SOURCE <> 'TK.ERES.SH.PURCHASE'
    and   (tkTrans.E_STAT not in ( 'MI','MO','TO','TI','EO', 'EO R','EI') or tkTrans.E_STAT IS NULL)

    and    tkTransItemPaymode.I_PAY_TYPE = 'I' 

group by
      tkTransItem.CUSTOMER
      ,tkTransItem.ITEM
      ,tkTransItemEvent.E_PL
      ,tkTransItem.I_PT
      ,tkTransItem.I_PRICE
	  ,tkTransItem.I_DAMT
      ,tkTransItem.Season
having SUM(ISNULL((tkTransItemPaymode.I_PAY_PAMT ),0)) > 0      

---- Build Report --------------------------------------------------------------------------------------------------

Create table #ReportBase 
(
  SEASON varchar (15)
 ,CUSTOMER varchar (20)
 ,CUSTOMER_TYPE varchar (20) 
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
 ,INSERTDATE datetime 
 ,ORDFEE numeric (18,2) 
 ,OrderConvenienceFee NUMERIC (18,2)
)

INSERT INTO #ReportBase 
 (
  SEASON 
 ,CUSTOMER 
 ,CUSTOMER_TYPE  
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
 ,INSERTDATE
 ,ORDFEE
 ,OrderConvenienceFee
)  

SELECT 
       SalesBase.SEASON
      ,SalesBase.CUSTOMER
      ,tkCustomer.[TYPE] CUSTOMER_TYPE 
      ,SalesBase.ITEM
      ,SalesBase.E_PL
      ,SalesBase.I_PT
      ,SalesBase.I_PRICE  
      ,SalesBase.I_DAMT 
      ,SalesBase.ORDQTY
      ,SalesBase.ORDTOTAL
      ,PaidFinal.CUSTOMER AS PAIDCUSTOMER 
      ,PaidFinal.MINPAYMENTDATE
      ,ISNULL(PaidFinal.PAIDTOTAL,0) PAIDTOTAL 
	  ,GETDATE () INSERTDATE
	  ,SalesBase.ORDFEE
	  ,SalesBase.OrderConvenienceFee
 
      FROM #SalesBase  SalesBase 

         LEFT JOIN  #PaidFinal PaidFinal
        ON    SalesBase.CUSTOMER = PaidFinal.CUSTOMER
          AND SalesBase.SEASON = PaidFinal.SEASON 
        AND SalesBase.ITEM = PaidFinal.ITEM
        AND ISNULL(SalesBase.E_PL,99999)  = ISNULL(PaidFinal.E_PL,99999) 
        AND ISNULL(SalesBase.I_PT,99999) = ISNULL(PaidFinal.I_PT,99999) 
        AND SalesBase.I_PRICE = PaidFinal.I_PRICE
	    AND SalesBase.I_DAMT = PaidFinal.I_DAMT
        
        LEFT JOIN TK_CUSTOMER tkCustomer ON SalesBase.CUSTOMER = tkCustomer.CUSTOMER 
  
  WHERE SalesBase.ORDQTY <> 0 
  

TRUNCATE TABLE stg.FactTicketSalesBaseItems

INSERT INTO stg.FactTicketSalesBaseItems
        ( SEASON, CUSTOMER, CUSTOMER_TYPE, ITEM, E_PL, I_PT, I_PRICE, I_DAMT, ORDQTY, ORDTOTAL, ORDFEE, OrderConvenienceFee, PAIDCUSTOMER, MINPAYMENTDATE, PAIDTOTAL, INSERTDATE )

SELECT SEASON, CUSTOMER, CUSTOMER_TYPE, ITEM, E_PL, I_PT, I_PRICE, I_DAMT, ORDQTY, ORDTOTAL, ORDFEE, OrderConvenienceFee, PAIDCUSTOMER, MINPAYMENTDATE, PAIDTOTAL, INSERTDATE
FROM #ReportBase 

ALTER INDEX ALL ON stg.FactTicketSalesBaseItems REBUILD


END 











GO
