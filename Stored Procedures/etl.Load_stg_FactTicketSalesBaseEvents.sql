SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [etl].[Load_stg_FactTicketSalesBaseEvents]

AS
    BEGIN

        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


-- Create #SalesBase --------------------------------------------------------------------------------------------------

        CREATE TABLE #SalesBase
            (
              SEASON VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CS_AS
            , CUSTOMER VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CS_AS
            , ITEM VARCHAR(32) COLLATE SQL_Latin1_General_CP1_CS_AS
            , EVENT VARCHAR(32) COLLATE SQL_Latin1_General_CP1_CS_AS
            , E_PL VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CS_AS
            , E_PT VARCHAR(32) COLLATE SQL_Latin1_General_CP1_CS_AS
            , E_PRICE NUMERIC(18, 2)
            , E_DAMT NUMERIC(18, 2)
            , E_STAT VARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CS_AS
            , ORDQTY BIGINT
            , ORDTOTAL NUMERIC(18, 2)
            , ORDFEE NUMERIC(18, 2)
			, OrderConvenienceFee NUMERIC(18, 2)
            ) 

        INSERT  INTO #SalesBase
                ( SEASON
                , CUSTOMER
                , ITEM
                , EVENT
                , E_PL
                , E_PT
                , E_PRICE
                , E_DAMT
                , E_STAT
                , ORDQTY
                , ORDTOTAL
                , ORDFEE
				, OrderConvenienceFee
                )
                SELECT  tkTrans.SEASON
                      , tkTransItem.CUSTOMER
                      , tkTransItem.ITEM
                      , tkTransItemEvent.EVENT
                      , tkTransItemEvent.E_PL
                      , tkTransItemEvent.E_PT
                      , tkTransItemEvent.E_PRICE
                      , tkTransItemEvent.E_DAMT
                      , tkTrans.E_STAT
                      , SUM(ISNULL(tkTransItemEvent.E_OQTY_TOT, 0)) ORDQTY
                      , SUM(ISNULL(tkTransItemEvent.E_OQTY_TOT, 0)
                            * ( ISNULL(E_PRICE, 0)  - ISNULL(E_DAMT, 0) + ISNULL(tkTransItemEvent.E_FPRICE, 0))) AS ORDTOTAL
                      , SUM(ISNULL(tkTransItemEvent.E_OQTY_TOT, 0)
                            * ( ISNULL(E_FPRICE, 0) )) AS ORDFEE
                       , SUM(ISNULL(tkTransItemEvent.E_OQTY_TOT, 0)
                            * ( ISNULL(tkTransItemEvent.E_CPRICE, 0) )) AS OrderConvenienceFee
                FROM    dbo.TK_TRANS tkTrans
                        INNER JOIN dbo.TK_TRANS_ITEM tkTransItem ON tkTrans.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = tkTransItem.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS
                                                              AND tkTrans.TRANS_NO = tkTransItem.TRANS_NO
                        LEFT JOIN ( SELECT  subtkTransItemEvent.SEASON
                                          , MAX(ISNULL(subtkTransItemEvent.E_PL,
                                                       99999)) E_PL
                                          , subtkTransItemEvent.TRANS_NO
                                          , subtkTransItemEvent.VMC
                                          , subtkTransItemEvent.EVENT
                                          , subtkTransItemEvent.E_OQTY_TOT
                                          , subtkTransItemEvent.E_PRICE
                                          , subtkTransItemEvent.E_DAMT
                                          , subtkTransItemEvent.E_PT
                                          , subtkTransItemEvent.E_FPRICE
										  , subtkTransItemEvent.E_CPRICE
                                    FROM    dbo.TK_TRANS_ITEM_EVENT subtkTransItemEvent
                                    GROUP BY subtkTransItemEvent.SEASON
                                          , subtkTransItemEvent.TRANS_NO
                                          , subtkTransItemEvent.VMC
                                          , subtkTransItemEvent.EVENT
                                          , subtkTransItemEvent.E_OQTY_TOT
                                          , subtkTransItemEvent.E_PRICE
                                          , subtkTransItemEvent.E_DAMT
                                          , subtkTransItemEvent.E_PT
                                          , subtkTransItemEvent.E_FPRICE
										  , subtkTransItemEvent.E_CPRICE
                                  ) tkTransItemEvent ON tkTransItem.SEASON = tkTransItemEvent.SEASON
                                                        AND tkTransItem.TRANS_NO = tkTransItemEvent.TRANS_NO
                                                        AND tkTransItem.VMC = tkTransItemEvent.VMC
                        INNER JOIN dbo.TK_ITEM tkItem ON tkTransItem.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = tkItem.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS
                                                         AND tkTransItem.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS = tkItem.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS

                WHERE   tkTrans.SOURCE <> 'TK.ERES.SH.PURCHASE'
                        AND ( 
							tkTrans.E_STAT NOT IN ( 'MI', 'MO', 'TO', 'TI', 'EO', 'EO R', 'EI' )
                            OR tkTrans.E_STAT IS NULL
                        )
                        AND NOT ( 
							tkTransItem.ITEM = 'FSN'
                            AND ISNULL(tkTrans.E_STAT, '') = 'R'
                        )
                GROUP BY tkTrans.SEASON
                      , tkTransItem.CUSTOMER
                      , tkTransItem.ITEM
                      , tkTransItemEvent.EVENT
                      , tkTransItemEvent.E_PL
                      , tkTransItemEvent.E_PT
                      , tkTransItemEvent.E_PRICE
                      , tkTransItemEvent.E_DAMT
                      , tkTrans.E_STAT
       

-- Create #PaidFinal --------------------------------------------------------------------------------------------------

        CREATE TABLE #PaidFinal
            (
              CUSTOMER VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CS_AS
            , MINPAYMENTDATE DATETIME
            , EVENT VARCHAR(32) COLLATE SQL_Latin1_General_CP1_CS_AS
            , ITEM VARCHAR(32) COLLATE SQL_Latin1_General_CP1_CS_AS
            , E_PL VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CS_AS
            , E_PT VARCHAR(32) COLLATE SQL_Latin1_General_CP1_CS_AS
            , E_PRICE NUMERIC(18, 2)
            , PAIDTOTAL NUMERIC(18, 2)
            , SEASON VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CS_AS
            ) 

        INSERT  INTO #PaidFinal
                ( CUSTOMER
                , MINPAYMENTDATE
                , EVENT
                , ITEM
                , E_PL
                , E_PT
                , E_PRICE
                , PAIDTOTAL
                , SEASON 
                )
                SELECT  tkTransItem.CUSTOMER
                      , MIN(tkTrans.DATE) minPaymentDate
                      , tkTransItemEvent.EVENT
                      , tkTransItem.ITEM
                      , tkTransItemEvent.E_PL
                      , tkTransItemEvent.E_PT
                      , tkTransItemEvent.E_PRICE
                      , SUM(ISNULL(( tkTransItemPaymode.E_PAY_PAMT ), 0)) PAIDTOTAL
                      , tkTransItem.SEASON
                FROM    dbo.TK_TRANS tkTrans
                        INNER JOIN dbo.TK_TRANS_ITEM tkTransItem ON tkTrans.SEASON = tkTransItem.SEASON
                                                              AND tkTrans.TRANS_NO = tkTransItem.TRANS_NO
                        LEFT JOIN ( SELECT  subtkTransItemEvent.SEASON
                                          , MAX(ISNULL(subtkTransItemEvent.E_PL,
                                                       99999)) E_PL
                                          , subtkTransItemEvent.TRANS_NO
                                          , subtkTransItemEvent.VMC
										  , subtkTransItemEvent.SVMC
                                          , subtkTransItemEvent.E_PT
                                          , subtkTransItemEvent.E_PRICE
                                          , subtkTransItemEvent.EVENT
                                    FROM    dbo.TK_TRANS_ITEM_EVENT subtkTransItemEvent

                                    WHERE   ISNULL(subtkTransItemEvent.E_STAT,'') <> 'R'
                                    GROUP BY subtkTransItemEvent.SEASON
                                          , subtkTransItemEvent.TRANS_NO
                                          , subtkTransItemEvent.VMC
										  , subtkTransItemEvent.SVMC
                                          , subtkTransItemEvent.E_PT
                                          , subtkTransItemEvent.E_PRICE
                                          , subtkTransItemEvent.EVENT
                                  ) tkTransItemEvent ON tkTransItem.SEASON = tkTransItemEvent.SEASON
                                                        AND tkTransItem.TRANS_NO = tkTransItemEvent.TRANS_NO
                                                        AND tkTransItem.VMC = tkTransItemEvent.VMC
                        INNER JOIN dbo.TK_TRANS_ITEM_EVENT_PAYMODE tkTransItemPaymode ON tkTransItem.SEASON = tkTransItemPaymode.SEASON
                                                              AND tkTransItem.TRANS_NO = tkTransItemPaymode.TRANS_NO
                                                              AND tkTransItem.VMC = tkTransItemPaymode.VMC
															  AND tkTransItemPaymode.SVMC = tkTransItemEvent.SVMC
                        INNER JOIN dbo.TK_ITEM tkItem ON tkTransItem.SEASON = tkItem.SEASON
                                                         AND tkTransItem.ITEM = tkItem.ITEM
                        LEFT OUTER JOIN dbo.TK_PTABLE_PRLEV tkPTablePRLev ON tkTransItem.SEASON = tkPTablePRLev.SEASON
                                                              AND tkItem.PTABLE = tkPTablePRLev.PTABLE
                                                              AND tkTransItemEvent.E_PL = tkPTablePRLev.PL
                WHERE   ( 
							ISNULL(tkTrans.E_STAT, 0) NOT IN ( 'MI', 'MO', 'TO', 'TI', 'EO', 'EO R', 'EI' )
							OR tkTrans.E_STAT IS NULL
                        )
                        AND tkTransItemPaymode.E_PAY_TYPE = 'E'
						
                GROUP BY tkTransItem.CUSTOMER
                      , tkTransItem.ITEM
                      , tkTransItemEvent.E_PL
                      , tkTransItemEvent.E_PT
                      , tkTransItemEvent.E_PRICE
                      , tkTransItem.SEASON
                      , tkTransItemEvent.EVENT
                HAVING  SUM(ISNULL(( tkTransItemPaymode.E_PAY_PAMT ), 0)) > 0      

---- Build Report --------------------------------------------------------------------------------------------------

        CREATE TABLE #ReportBase
            (
              SEASON VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CS_AS
            , CUSTOMER VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CS_AS
            , ITEM VARCHAR(32) COLLATE SQL_Latin1_General_CP1_CS_AS
            , EVENT VARCHAR(32) COLLATE SQL_Latin1_General_CP1_CS_AS
            , E_PL VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CS_AS
            , E_PT VARCHAR(32) COLLATE SQL_Latin1_General_CP1_CS_AS
            , E_PRICE NUMERIC(18, 2)
            , E_DAMT NUMERIC(18, 2)
            , E_STAT VARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CS_AS
            , ORDQTY BIGINT
            , ORDTOTAL NUMERIC(18, 2)
            , ORDFEE NUMERIC(18, 2)
			, OrderConvenienceFee NUMERIC(18, 2)
            , PAIDCUSTOMER VARCHAR(20)
            , MINPAYMENTDATE DATETIME
            , PAIDTOTAL NUMERIC(18, 2)
            )

        INSERT  INTO #ReportBase
                ( SEASON
                , CUSTOMER
                , ITEM
                , EVENT
                , E_PL
                , E_PT
                , E_PRICE
                , E_DAMT
                , E_STAT
                , ORDQTY
                , ORDTOTAL
                , ORDFEE
				, OrderConvenienceFee
                , PAIDCUSTOMER
                , MINPAYMENTDATE
                , PAIDTOTAL
                )
                SELECT  SalesBase.SEASON
                      , SalesBase.CUSTOMER
                      , SalesBase.ITEM
                      , SalesBase.EVENT
                      , SalesBase.E_PL
                      , SalesBase.E_PT
                      , SalesBase.E_PRICE
                      , SalesBase.E_DAMT
                      , SalesBase.E_STAT
                      , SalesBase.ORDQTY
                      , SalesBase.ORDTOTAL
                      , SalesBase.ORDFEE
					  , OrderConvenienceFee
                      , PaidFinal.CUSTOMER AS PAIDCUSTOMER
                      , PaidFinal.MINPAYMENTDATE
                      , ISNULL(PaidFinal.PAIDTOTAL, 0) PAIDTOTAL
                FROM    #SalesBase SalesBase
                        LEFT JOIN #PaidFinal PaidFinal ON SalesBase.CUSTOMER = PaidFinal.CUSTOMER
                                                          AND SalesBase.SEASON = PaidFinal.SEASON
                                                          AND SalesBase.ITEM = PaidFinal.ITEM
                                                          AND PaidFinal.EVENT = SalesBase.EVENT
                                                          AND ISNULL(SalesBase.E_PL,
                                                              99) = ISNULL(PaidFinal.E_PL,
                                                              99)
                                                          AND ISNULL(SalesBase.E_PT,
                                                              99) = ISNULL(PaidFinal.E_PT,
                                                              99)
                                                          AND SalesBase.E_PRICE = PaidFinal.E_PRICE
                WHERE   SalesBase.ORDQTY <> 0 
  

		TRUNCATE TABLE stg.FactTicketSalesBase

		INSERT INTO stg.FactTicketSalesBase
		        ( SEASON, CUSTOMER, ITEM, EVENT, E_PL, E_PT, E_PRICE, E_DAMT, E_STAT, ORDQTY, ORDTOTAL, ORDFEE, OrderConvenienceFee, PAIDCUSTOMER, MINPAYMENTDATE, PAIDTOTAL )

        SELECT  SEASON, CUSTOMER, ITEM, EVENT, E_PL, E_PT, E_PRICE, E_DAMT, E_STAT, ORDQTY, ORDTOTAL, ORDFEE, OrderConvenienceFee, PAIDCUSTOMER, MINPAYMENTDATE, PAIDTOTAL
        FROM    #ReportBase 

		ALTER INDEX ALL ON stg.FactTicketSalesBase REBUILD

    END 








GO
