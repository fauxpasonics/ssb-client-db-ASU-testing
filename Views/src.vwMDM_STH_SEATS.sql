SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






-- =============================================
-- Author:		<Abbey Meitin>
-- Create date: <03/17/2017>
-- Description:	<Created view to use in MDM Primary record selection>
-- 7/5/2017 modified view for TM conversion
-- =============================================




CREATE VIEW [src].[vwMDM_STH_SEATS] AS
(
SELECT  p.acct_id ,
        sth.STH ,
        seats.SEATS ,
		TRANS , 
		SDC_ID
FROM    ods.TM_Cust p (NOLOCK)
        LEFT JOIN ( SELECT  CASE WHEN STH > 0 THEN STH
                                 ELSE 0
                            END AS STH ,
                            acct_id
                    FROM    ( SELECT    
								SUM(num_seats) STH ,
								acct_id
							FROM      [ods].[TM_Ticket] rb (NOLOCK)
							WHERE     rb.plan_event_name like '%FS'
								AND TRY_CAST(LEFT(rb.event_name,2) AS INT)
								>= RIGHT(DATEPART(YEAR,GETDATE()),2)-3
							GROUP BY  acct_id) x
                  ) sth ON p.acct_id = sth.acct_id
        LEFT JOIN ( SELECT    
						SUM(num_seats) SEATS ,
						acct_id
					FROM      [ods].[TM_Ticket] rb (NOLOCK)
					--WHERE    
					-- CAST(LEFT(rb.event_name,2) AS INT)
					--	>= RIGHT(DATEPART(YEAR,GETDATE()),2)-3
					GROUP BY  acct_id
                  ) seats ON p.acct_id = seats.acct_id
		LEFT JOIN (SELECT MAX(add_Datetime) TRANS
					, acct_id
					FROM [ods].[TM_Ticket] WITH (NOLOCK) GROUP BY acct_id 
					) trans ON p.acct_id = trans.acct_id

		LEFT JOIN (SELECT OTHER_ID SDC_ID
					FROM [dbo].[FD_SDA_ENTITY_OTHER_IDS] WITH (NOLOCK)
					WHERE TYPE_CODE = 'SDP'
					) Advance ON CAST(p.acct_id AS nvarchar(100)) = Advance.SDC_ID AND p.Primary_code = 'Primary'

)



GO
