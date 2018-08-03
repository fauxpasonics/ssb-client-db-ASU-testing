SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Description of output

--On each file, please include one line per Event and/or Plan bought by each account with:
--·         PacID of buyer
--·         Contact info (split out by column -> First Name, Last Name, Address 1, Address 2, City, State, Postal Code, Email, Phone)
--·         ID of the Event or Plan
--·         Description of Event/Plan
--·         If a plan, # games on plan
--·         Total Amount Spent on that Event/Plan (accounting for returns, where applicable)
--·         Tenure as a Plan holder (how long has the account held season tickets?)
--·         Please exclude any non-game event such as concerts, parking, and deposits. 
--·         Please exclude any suite, broker, post-season, and group tickets.
--·         Please include any secondary ticketing information, if available.
 
--For a single game buyer, if they bought 5 different single game tickets to 5 different games, that would be 5 lines on the Excel file. A single full season ticket plan would be one line.


CREATE PROCEDURE  [dbo].[rpt_TurnKey_DataExtract_B16]
AS
    BEGIN

        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--DROP TABLE #Tenure
--DROP TABLE #SalesBase

--TRUNCATE TABLE  TI_TurnKey_DataExtract_B16


--Create #Tenure --------------------------------------------------------------------------------------------------

        SELECT  F1.CUSTOMER
              , O.Seasons_Split
        INTO    #Tenure
        FROM    ( SELECT    F.CUSTOMER
                          , CAST('<X>' + REPLACE(F.SEASONS, ' ', '</X><X>')
                            + '</X>' AS XML) AS xmlfilter
                  FROM      ( SELECT    *
                              FROM      dbo.TK_CUSTOMER WITH ( NOLOCK )
                            ) F
                ) F1
                CROSS APPLY ( SELECT    fdata.D.value('.', 'varchar(50)') AS Seasons_Split
                              FROM      f1.xmlfilter.nodes('X') AS fdata ( D )
                            ) O

-- Create #SalesBase --------------------------------------------------------------------------------------------------

        CREATE TABLE #SalesBase
            (
              SEASON VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CS_AS
            , CUSTOMER VARCHAR(20) COLLATE SQL_Latin1_General_CP1_CS_AS
            , ITEM VARCHAR(32) COLLATE SQL_Latin1_General_CP1_CS_AS
            , ItemName VARCHAR(256) COLLATE SQL_Latin1_General_CP1_CS_AS
            , EVENT VARCHAR(32) COLLATE SQL_Latin1_General_CP1_CS_AS
            , EventName VARCHAR(256) COLLATE SQL_Latin1_General_CP1_CS_AS
            , EventDate DATETIME
            , E_PL VARCHAR(10) COLLATE SQL_Latin1_General_CP1_CS_AS
            , I_PT VARCHAR(32) COLLATE SQL_Latin1_General_CP1_CS_AS
            , I_PTName VARCHAR(128) COLLATE SQL_Latin1_General_CP1_CS_AS
            , ORDQTY BIGINT
            , I_PRICE NUMERIC(18, 2)
            , I_CPRICE NUMERIC(18, 2)
            , I_FPRICE NUMERIC(18, 2)
            , ORDTOTAL NUMERIC(18, 2)
            ) 

        INSERT  INTO #SalesBase
                ( SEASON
                , CUSTOMER
                , ITEM
                , ItemName
                , EVENT
                , EventName
                , EventDate
                , E_PL
                , I_PT
                , I_PTName
                , ORDQTY
                , I_PRICE
                , I_CPRICE
                , I_FPRICE
                , ORDTOTAL
                )
                SELECT  tkTrans.SEASON
                      , tkTransItem.CUSTOMER
                      , tkTransItem.ITEM
                      , tkItem.NAME ItemName
                      , tkEvent.EVENT
                      , tkEvent.NAME EventName
                      , tkEvent.DATE EventDate
                      , tkTransItemEvent.E_PL
                      , tkTransItem.I_PT
                      , PrType.NAME I_PTName
                      , SUM(ISNULL(tkTransItem.I_OQTY_TOT, 0)) ORDQTY
                      , tkTransItem.I_PRICE
                      , tkTransItem.I_CPRICE
                      , tkTransItem.I_FPRICE
                      , SUM(ISNULL(tkTransItem.I_OQTY_TOT, 0)
                            * ( ISNULL(I_PRICE, 0) ) - ISNULL(I_DAMT, 0)) AS ORDTOTAL
                FROM    dbo.TK_TRANS tkTrans WITH ( NOLOCK )
                        INNER JOIN dbo.TK_TRANS_ITEM tkTransItem WITH ( NOLOCK ) ON tkTrans.SEASON = tkTransItem.SEASON
                                                              AND tkTrans.TRANS_NO = tkTransItem.TRANS_NO
                        LEFT JOIN ( SELECT  subtkTransItemEvent.SEASON
                                          , MAX(ISNULL(subtkTransItemEvent.E_PL,
                                                       99999)) E_PL
                                          , subtkTransItemEvent.TRANS_NO
                                          , subtkTransItemEvent.VMC
                                    FROM    dbo.TK_TRANS_ITEM_EVENT subtkTransItemEvent
                                            WITH ( NOLOCK )
                                            INNER JOIN dbo.TI_ReportBaseSeasons subpSeasons
                                            WITH ( NOLOCK ) ON subtkTransItemEvent.SEASON = subpSeasons.Season COLLATE SQL_Latin1_General_CP1_CS_AS
                                    GROUP BY subtkTransItemEvent.SEASON
                                          , subtkTransItemEvent.TRANS_NO
                                          , subtkTransItemEvent.VMC
                                  ) tkTransItemEvent ON tkTransItem.SEASON = tkTransItemEvent.SEASON
                                                        AND tkTransItem.TRANS_NO = tkTransItemEvent.TRANS_NO
                                                        AND tkTransItem.VMC = tkTransItemEvent.VMC
                        INNER JOIN dbo.TK_ITEM tkItem WITH ( NOLOCK ) ON tkTransItem.SEASON = tkItem.SEASON
                                                              AND tkTransItem.ITEM = tkItem.ITEM
                        INNER JOIN TI_ReportBaseSeasons Seasons WITH ( NOLOCK ) ON tkTrans.SEASON = Seasons.Season COLLATE SQL_Latin1_General_CP1_CS_AS
                        INNER JOIN dbo.TK_CUSTOMER Customer WITH ( NOLOCK ) ON Customer.CUSTOMER = tkTrans.CUSTOMER
                        INNER JOIN dbo.TK_PRTYPE PrType WITH ( NOLOCK ) ON PrType.SEASON = tkTransItem.SEASON
                                                              AND PrType.PRTYPE = tkTransItem.I_PT
                        LEFT JOIN TK_EVENT tkEvent WITH ( NOLOCK ) ON tkTransItem.ITEM COLLATE SQL_Latin1_General_CP1_CS_AS = tkEvent.EVENT COLLATE SQL_Latin1_General_CP1_CS_AS
                                                              AND tkTransItemEvent.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = tkEvent.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS
                WHERE   1 = 1
                        AND tkTransItemEvent.SEASON IN ( 'B16')
                        --AND tkTransItem.CUSTOMER = '10209'
                        AND tkTrans.SOURCE <> 'TK.ERES.SH.PURCHASE'
                        AND ( tkTrans.E_STAT NOT IN ( 'MI', 'MO', 'TO', 'TI',
                                                      'EO', 'EI' )
                              OR tkTrans.E_STAT IS NULL
                            )

                        AND tkTransItem.I_PRICE <> 0 --remove students, credentials, comps
						AND PrType.NAME NOT LIKE '%Faculty%' -- remove Faculty/Staff
						AND PrType.NAME NOT LIKE '%Staff%' -- remove Faculty/Staff
						AND PrType.NAME NOT LIKE '%Parking%' -- remove Parking
						AND PrType.NAME NOT LIKE '%Student%' -- remove Parking
						AND tkTransItem.I_PT NOT LIKE 'G%' --remove Groups
						AND tkTransItem.I_PT <> 'SSR' --remove Suite Rental
						--AND tkTransItem.I_PT <> 'ZR' --remove Suites


                GROUP BY tkTrans.SEASON
                      , tkTransItem.CUSTOMER
                      , tkTransItem.ITEM
                      , tkItem.NAME
                      , tkEvent.EVENT
                      , tkEvent.NAME
                      , tkEvent.DATE
                      , tkTransItemEvent.E_PL
                      , tkTransItem.I_PT
                      , PrType.NAME
                      , tkTransItem.I_PRICE
                      , tkTransItem.I_CPRICE
                      , tkTransItem.I_FPRICE


/******************************************* Output *********************************************************************************/

        SELECT  sb.SEASON
              , sb.CUSTOMER
              , Tenure.Tenure
			  , sb.ITEM EvtItem
              , sb.ItemName EvtItemName
              , sb.EVENT EvtEvent
              , sb.EventName EvtEventName
              , sb.EventDate EventDate
              , sb.E_PL EvtPL
              , sb.I_PT EvtPT
              , sb.I_PTName EvtPTName
              , sb.ORDQTY EvtQty
              , sb.I_PRICE EvtEPrice
              , sb.I_CPRICE EvtCPrice
              , sb.I_FPRICE EvtFPrice
              , sb.ORDTOTAL EvtEValue
              INTO dbo.TI_TurnKey_DataExtract_B16
        FROM    #SalesBase sb
                INNER JOIN PD_PATRON patron WITH ( NOLOCK ) ON sb.CUSTOMER COLLATE SQL_Latin1_General_CP1_CS_AS = patron.PATRON COLLATE SQL_Latin1_General_CP1_CS_AS
                LEFT JOIN ( SELECT  
									CUSTOMER
                                  , COUNT(*) Tenure

                            FROM    #Tenure
                            WHERE   Seasons_Split IN ('B00', 'B01','B02','B03','B04','B05','B06', 'B07','B08', 'B09', 'B10', 'B11', 'B12', 'B13', 'B14', 'B15', 'B16', 'B17', 'B99')
                                    --AND Seasons_Split NOT LIKE '%P'
                                    --AND Seasons_Split NOT LIKE '%C'
                                    --AND Seasons_Split NOT LIKE '%T'

                            GROUP BY CUSTOMER, Seasons_Split
                          ) Tenure ON sb.CUSTOMER COLLATE SQL_Latin1_General_CP1_CS_AS = Tenure.CUSTOMER COLLATE SQL_Latin1_General_CP1_CS_AS
        WHERE   sb.ORDQTY <> 0
    END 
GO
