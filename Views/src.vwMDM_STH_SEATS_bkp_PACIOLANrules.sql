SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





-- =============================================
-- Author:		<Abbey Meitin>
-- Create date: <03/17/2017>
-- Description:	<Created view to use in MDM Primary record selection>
-- =============================================

-- =============================================
-- Author:		<Author>
-- Updated date: <Date>
-- Description:	<>
-- =============================================



CREATE VIEW [src].[vwMDM_STH_SEATS_bkp_PACIOLANrules] AS
(
SELECT  PATRON ,
        STH ,
        SEATS ,
		TRANS , 
		SDC_ID
FROM    dbo.PD_PATRON p WITH (NOLOCK)
        LEFT JOIN ( SELECT  CASE WHEN STH > 0 THEN STH
                                 ELSE 0
                            END AS STH ,
                            CUSTOMER
                    FROM    ( SELECT    SUM(ORDQTY) STH ,
                                        CUSTOMER
                              FROM      dbo.vwTIReportBase rb WITH (NOLOCK)
                              WHERE     rb.ITEM like 'FS%'
							  AND CAST(RIGHT(rb.season,2) AS INT)
							>= RIGHT(DATEPART(YEAR,GETDATE()),2)-3
								GROUP BY  CUSTOMER
                            ) x
                  ) sth ON p.PATRON = sth.CUSTOMER
        LEFT JOIN ( SELECT  CUSTOMER ,
                            COUNT(SEAT) SEATS
                    FROM    dbo.TK_SEAT_SEAT tkSeatSeat WITH (NOLOCK)
					WHERE CAST(RIGHT(tkSeatSeat.season,2) AS INT)
							>= RIGHT(DATEPART(YEAR,GETDATE()),2)-3
                    GROUP BY CUSTOMER
                  ) seats ON p.PATRON = seats.CUSTOMER
		LEFT JOIN (SELECT MAX(date) TRANS
					, customer 
					FROM dbo.tk_trans WITH (NOLOCK) GROUP BY customer 
					) trans ON p.patron = trans.customer

		LEFT JOIN (SELECT OTHER_ID SDC_ID
					FROM [dbo].[FD_SDA_ENTITY_OTHER_IDS] WITH (NOLOCK)
					WHERE TYPE_CODE = 'SDP'
					) Advance ON p.patron = Advance.SDC_ID

)


GO
