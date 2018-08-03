SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO












CREATE VIEW [segmentation].[vw__Primary_Ticketing]
AS ( 
				  SELECT    rb.SEASON
                          , Season.NAME AS SEASON_NAME
						  , SSBID.SSB_CRMSYSTEM_CONTACT_ID
                          , rb.CUSTOMER
                          , rb.CUSTOMER_TYPE
                          , CType.NAME CUSTOMER_TYPE_NAME
                          , rb.ITEM
                          , Item.NAME ITEM_NAME
                          , rb.I_PT
                          , PT.NAME I_PT_NAME
                          , rb.E_PL
                          , PRLev.PL_NAME
                          , rb.I_PRICE
                          , rb.I_DAMT
                          , rb.ORDQTY
                          , rb.ORDTOTAL
                          , rb.PAIDTOTAL
                          , rb.MINPAYMENTDATE
                  FROM      dbo.vwTIReportBase rb WITH (NOLOCK)
                            LEFT JOIN dbo.TK_ITEM Item WITH (NOLOCK) ON Item.ITEM COLLATE SQL_Latin1_General_CP1_CI_AS = rb.ITEM
                                                          AND Item.SEASON COLLATE SQL_Latin1_General_CP1_CI_AS = rb.SEASON
                            LEFT JOIN dbo.TK_PRTYPE PT WITH (NOLOCK) ON PT.SEASON COLLATE SQL_Latin1_General_CP1_CI_AS = Item.SEASON
                                                          AND PT.PRTYPE COLLATE SQL_Latin1_General_CP1_CI_AS = rb.I_PT
                            LEFT JOIN dbo.TK_SEASON Season WITH (NOLOCK) ON Season.SEASON COLLATE SQL_Latin1_General_CP1_CI_AS = rb.SEASON
                            LEFT JOIN dbo.TK_CTYPE CType WITH (NOLOCK) ON CType.TYPE COLLATE SQL_Latin1_General_CP1_CI_AS = rb.CUSTOMER_TYPE
                            LEFT JOIN dbo.TK_PTABLE_PRLEV PRLev WITH (NOLOCK) ON PRLev.SEASON COLLATE SQL_Latin1_General_CP1_CI_AS = rb.SEASON
                                                              AND PRLev.PTABLE COLLATE SQL_Latin1_General_CP1_CI_AS = rb.ITEM
                                                              AND PRLev.PL COLLATE SQL_Latin1_General_CP1_CI_AS = rb.E_PL
							INNER JOIN dbo.dimcustomerssbid SSBID WITH (NOLOCK) 
									  ON SSBID.SSID COLLATE SQL_Latin1_General_CP1_CS_AS 
											= rb.CUSTOMER COLLATE SQL_Latin1_General_CP1_CS_AS  
										 AND SSBID.SourceSystem = 'TI ASU'
                  WHERE     CAST(RIGHT(rb.SEASON,2) AS INT) >= RIGHT(DATEPART(YEAR,GETDATE()),2)-4
				  AND rb.SEASON NOT IN ('F17', 'BB17')

)            






GO
