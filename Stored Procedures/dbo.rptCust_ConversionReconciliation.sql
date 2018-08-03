SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROC [dbo].[rptCust_ConversionReconciliation] 

(
	@Customer  varchar(20)
)
AS

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


SELECT 
tkTrans.SEASON + ':' + convert(varchar(25), tkTrans.TRANS_NO) + ':' + convert(varchar(25), tkTransItem.VMC) + ':' 
+ convert(varchar(25), tkTransItemPaymode.SVMC) ZID
, tkTrans.DATE Date
, tkTrans.SEASON Season
, '20' + RIGHT(tkTrans.SEASON,2) TicketYear
, CASE 
       WHEN tkTrans.SEASON LIKE 'F%' THEN 'FB' 
       WHEN tkTrans.SEASON LIKE 'BB%' THEN 'MBB' 
       WHEN tkTrans.SEASON LIKE 'AP%' THEN 'ST'
       WHEN tkTrans.SEASON LIKE 'B[0-9]%' THEN 'B'
       WHEN tkTrans.SEASON LIKE 'WB%' THEN 'WBB'
       WHEN tkTrans.SEASON LIKE 'SB%' THEN 'SB'
       WHEN tkTrans.SEASON LIKE 'V%' THEN 'V'
END TicketSport
, tkTransItem.ITEM Item
, tkTransItemPaymode.I_PAY_TYPE PayType
, tkTransItemPaymode.I_PAY_PAYMODE Paymode
, cast(null as varchar(100)) CheckNumber
, tkTransItemPaymode.I_PAY_PAMT PaymentAmount

, tkTrans.SALECODE
, tkTrans.LAST_USER 
, tkTrans.CUSTOMER Patron



--SELECT COUNT(*)       
FROM dbo.TK_TRANS (NOLOCK) tkTrans

INNER JOIN   dbo.TK_TRANS_ITEM (NOLOCK) tkTransItem
       on tkTrans.Season = tkTransItem.Season
       and tkTrans.Trans_No = tkTransItem.Trans_No
              
INNER JOIN  dbo.TK_TRANS_ITEM_PAYMODE (NOLOCK) tkTransItemPaymode 
       ON tkTransItem.SEASON = tkTransItemPaymode.SEASON 
              and tkTransItem.TRANS_NO = tkTransItemPaymode.TRANS_NO 
              and tkTransItem.VMC = tkTransItemPaymode.VMC




WHERE  tkTrans.Customer = @Customer

END




GO
