SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--EXEC rptCustDonationTrans1_2014 '2013-10-02', '2013-11-03'

create     PROC [dbo].[rptCustSDC_SeatContributionTransactions_Paciolan] 

(
	@StartDate DATETIME,
	@EndDate DATETIME  
)
AS

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED




SELECT
	 tkTrans.DATE
	,tkTransItem.SEASON
	,tkTrans.CUSTOMER 
	,pdPatron.NAME CUSTOMER_NAME 
	,tkTransItem.ITEM
	,tkItem.NAME AS ITEM_NAME 
	,tkTransItemPaymode.I_PAY_PAYMODE
	,tkPaymode.NAME PAYMODE_NAME
	,tkPaymode.TYPE_NAME 
	,tkOdet.I_SPECIAL
	,ISNULL(tkTransItemPaymode.I_PAY_PAMT,0) PAYAMT 


FROM
	dbo.TK_TRANS tkTrans
	INNER JOIN dbo.TK_TRANS_ITEM tkTransItem
	ON tkTrans.Season = tkTransItem.Season
	 AND tkTrans.Trans_No = tkTransItem.Trans_No
		INNER JOIN dbo.TK_TRANS_ITEM_PAYMODE tkTransItemPaymode 
		ON tkTransItem.SEASON = tkTransItemPaymode.SEASON 
		AND tkTransItem.TRANS_NO = tkTransItemPaymode.TRANS_NO 
		AND tkTransItem.VMC = tkTransItemPaymode.VMC

   INNER JOIN PD_PATRON pdPatron ON tkTrans.CUSTOMER = pdPatron.PATRON 
	
	LEFT JOIN  dbo.TK_ITEM tkItem
		ON tkTransItem.SEASON = tkItem.SEASON AND tkTransItem.ITEM = tkItem.ITEM
	 
	  
	LEFT JOIN dbo.TK_PAYMODE tkPaymode 
		ON tkTransItemPaymode.I_PAY_PAYMODE = tkPaymode.PAYMODE
	
	LEFT JOIN 
	
	(SELECT tkOdet.SEASON, CUSTOMER, ITEM, MAX(I_SPECIAL) I_SPECIAL FROM dbo.TK_ODET tkOdet 
		WHERE tkOdet.ITEM LIKE 'DON%' AND (SEASON LIKE 'F%' OR SEASON LIKE 'BB%')
		AND SEASON NOT LIKE '%13%'
		AND SEASON NOT LIKE '%12%'
		AND SEASON NOT LIKE '%11%'
		AND SEASON NOT LIKE '%10%' 
		AND I_SPECIAL IS NOT NULL 
		GROUP BY tkOdet.SEASON, CUSTOMER, ITEM ) tkOdet 
	ON  tkTrans.SEASON = tkOdet.SEASON 
	AND tkTrans.CUSTOMER = tkOdet.CUSTOMER 
	AND tkTransItem.ITEM = tkOdet.ITEM 
	
WHERE

         tkTransItemPaymode.I_PAY_TYPE = 'I'
     AND (tkTrans.SEASON LIKE 'F%'  OR tkTrans.SEASON LIKE 'BB%') 
	 AND tkTrans.Season NOT LIKE '%13%'
	 AND tkTrans.Season NOT LIKE '%12%'
	 AND tkTrans.Season NOT LIKE '%11%'
     AND tkTransItem.ITEM LIKE 'DON%'
     AND ISNULL(tkTransItemPaymode.I_PAY_PAYMODE,9999999) IN ('A','C','CK','MC','V','CREDIT', 'TR')
     AND tkTrans.DATE >= @StartDate AND tkTrans.DATE <= @EndDate


ORDER BY tkTrans.DATE 

END 








GO
