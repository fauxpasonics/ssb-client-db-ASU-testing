SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [rpt].[DOMO_Pac12_ASU_Football14_15]
AS
    BEGIN

        SELECT 
		  CAST(DOMO.SEASON AS NVARCHAR(255)) SEASON
		, CAST(DOMO.SEASON_NAME AS NVARCHAR(255)) SEASON_NAME
		, CAST(DOMO.CUSTOMER AS NVARCHAR(255)) CUSTOMER
		, CAST(DOMO.CUSTOMER_TYPE AS NVARCHAR(255)) CUSTOMER_TYPE
		, CAST(DOMO.CUSTOMER_TYPE_NAME AS NVARCHAR(255)) CUSTOMER_TYPE_NAME
		, CAST(DOMO.TICKET_TYPE AS NVARCHAR(255)) TICKET_TYPE
		, CAST(DOMO.ITEM AS NVARCHAR(255)) ITEM
		, CAST(DOMO.ITEM_NAME AS NVARCHAR(255)) ITEM_NAME
		, CAST(DOMO.I_PT AS NVARCHAR(255)) I_PT
		, CAST(DOMO.I_PT_NAME AS NVARCHAR(255)) I_PT_NAME
		, CAST(DOMO.E_PL AS NVARCHAR(255)) E_PL
		, CAST(DOMO.PL_NAME AS NVARCHAR(255)) PL_NAME
		, DOMO.I_PRICE
		, DOMO.I_DAMT
		, DOMO.ORDQTY
		, DOMO.ORDTOTAL
		, DOMO.PAIDTOTAL
		, CAST(DOMO.MINPAYMENTDATE AS NVARCHAR(255)) MINPAYMENTDATE
		, CAST(DOMO.calendarMonthName AS NVARCHAR(255)) calendarMonthName
		, CAST(DOMO.calendarDayOfWeekName AS NVARCHAR(255)) calendarDayOfWeekName
		, DOMO.calendarWeekOfYearNum
		, DOMO.calendarDayOfWeekNum
		, DOMO.calendarDayOfYearNum					
        , CAST(SSBID.SSB_CRMSYSTEM_CONTACT_ID AS NVARCHAR(255)) SSB_CRMSYSTEM_CONTACT_ID
        FROM    [172.31.17.15].ASU.dbo.DOMO_Pac12_ASU_Football14_15 DOMO WITH (NOLOCK)
                LEFT JOIN dbo.dimcustomerssbid SSBID WITH (NOLOCK) ON SSBID.SSID = DOMO.CUSTOMER AND SSBID.SourceSystem = 'TI ASU'


    END




GO
