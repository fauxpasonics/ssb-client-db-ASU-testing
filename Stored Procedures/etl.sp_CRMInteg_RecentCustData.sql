SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE PROCEDURE [etl].[sp_CRMInteg_RecentCustData]
AS

TRUNCATE TABLE etl.CRMProcess_RecentCustData

DECLARE @Client VARCHAR(50)
SET @Client = 'ASU'

SELECT x.dimcustomerid, MAX(x.maxtransdate) maxtransdate, x.team
INTO #tmpTicketSales
	FROM (
		--Ticketing - PAC
		SELECT dc.DimCustomerID, MAX(tk.I_Date) MaxTransDate , @Client Team
		--Select * 
		FROM dbo.TK_ODET tk (NOLOCK)	
		JOIN dbo.DimCustomer dc (NOLOCK) on tk.Customer = dc.SSID and Sourcesystem = 'TI ASU'	
		WHERE tk.I_Date >= DATEADD(YEAR, -5, GETDATE())
		GROUP BY dc.[DimCustomerId]

		UNION 

		--Ticketing - TM
		SELECT dc.dimcustomerid, MAX(t.add_datetime), @Client Team
		FROM ods.TM_Ticket t (NOLOCK)
		INNER JOIN dbo.DimCustomer dc (NOLOCK)
		ON t.acct_id = dc.AccountId AND dc.SourceSystem = 'tm' AND dc.CustomerType = 'Primary'
		WHERE t.add_datetime > '2017-07-01 00:00:00.000'
		GROUP BY dc.DimCustomerId

		UNION 

		--Data Uploader (added 7/28/2017 AMEITIN)
		SELECT dc.dimcustomerid, MAX(CreatedDate), @Client Team
		FROM dbo.DimCustomer dc (NOLOCK)
		WHERE SourceSystem like 'ASU_LoadCRM_%'
		GROUP BY dc.DimCustomerId

		UNION 

		--Advance (added 1/3/2018 AMEITIN)
		SELECT dc.dimcustomerid, MAX(CreatedDate), @Client Team
		FROM dbo.DimCustomer dc (NOLOCK)
		INNER JOIN [dbo].[FD_SDA_TRANSACTION_DETAIL] fd (NOLOCK) on dc.SourceSystem = 'Advance ASU' AND dc.SSID = fd.ID_NUMBER
		WHERE SourceSystem = 'Advance ASU'
		AND fd.DATE_OF_RECORD >= DATEADD(YEAR, -5, GETDATE())
		GROUP BY dc.DimCustomerId



		--AMEITN: I am thinking I will add Advance & Email after the initial go-live to keep the initial population in line with production

		--UNION ALL 

		----Adobe
		--SELECT dc.DimCustomerID, MAX(dl.EventDate) MaxTransDate , @Client Team
		----Select * 
		--FROM [ods].[Adobe_DeliveryLog] dl WITH(NOLOCK)	
		--JOIN  dbo.DimCustomer dc on dl.AccountFK = dc.SSID and Sourcesystem = 'Adobe'	
		--WHERE dl.EventDate >= DATEADD(Day, -90, GETDATE())
		--GROUP BY dc.[DimCustomerId]



		) x
		GROUP BY x.dimcustomerid, x.team


INSERT INTO etl.CRMProcess_RecentCustData (SSID, MaxTransDate, Team)
SELECT SSID, [MaxTransDate], Team FROM [#tmpTicketSales] a 
INNER JOIN dbo.[vwDimCustomer_ModAcctId] b ON [b].[DimCustomerId] = [a].[DimCustomerId]





GO
