SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO












CREATE PROCEDURE [dbo].[rptCustSelloutStrategy_Football_2016]
    (
      @DataType VARCHAR(5) = 'Qty'
    )
AS
    BEGIN
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        IF ( @DataType = '' )
            BEGIN
                SET @DataType = 'Qty'
            END





IF OBJECT_ID('tempdb..#Results') IS NOT NULL
	DROP TABLE #Results

IF OBJECT_ID('tempdb..#Budget') IS NOT NULL
	DROP TABLE #Budget

IF OBJECT_ID('tempdb..#ReportBase') IS NOT NULL
	DROP TABLE #ReportBase

IF OBJECT_ID('tempdb..#Event') IS NOT NULL
	DROP TABLE #Event

IF OBJECT_ID('tempdb..#TK_SEAT_SEAT') IS NOT NULL
	DROP TABLE #TK_SEAT_SEAT              

IF OBJECT_ID('tempdb..#output') IS NOT NULL
	DROP TABLE #output  

DECLARE @curSeason VARCHAR (10) = 'F16'
--DECLARE @DataType VARCHAR(5) = 'Qty'

/* ************************************************** Report Base ************************************************************ */

CREATE TABLE #ReportBase
            (
              SEASON VARCHAR(15)
            , CUSTOMER VARCHAR(20)
            , ITEM VARCHAR(32)
            , EVENT VARCHAR(32)
            , E_PL VARCHAR(10)
            , E_PT VARCHAR(32)
			, PT_DESCRIPTION VARCHAR(100)
			, E_STAT VARCHAR(MAX)
			, ORDQTY NUMERIC(18,2)
			, ORDTOTAL NUMERIC(18,2)
            , HOLD_CODE VARCHAR(20)
			, ORDER_DATE DATETIME
            )

        INSERT  INTO #ReportBase
                ( SEASON
                , CUSTOMER
                , ITEM
                , EVENT
                , E_PL
                , E_PT
				, PT_Description
                , E_STAT
                , ORDQTY
				, ORDTOTAL
                , HOLD_CODE
				, ORDER_DATE
                )

		SELECT   tkodet.SEASON
			   , tkodet.CUSTOMER
			   , seat.ITEM
			   , tkodet.EVENT
			   , tkodet.E_PL
			   , seat.I_PT AS E_PT
			   , pt.NAME AS PT_Description
			   , tkodet.E_STAT
			   , COUNT(*) AS ORDQTY
			   , SUM(tkodet.E_PRICE) AS ORDTOTAL
			   , stat AS HOLD_CODE
			   , tkodet.E_ADATE

		FROM TK_SEAT_SEAT  seat 
			 LEFT JOIN dbo.TK_ODET_EVENT_ASSOC tkodet 
				  ON seat.SEASON = tkodet.SEASON
					 AND seat.DKEY = tkodet.ZID
					 AND seat.EVENT =  tkodet.EVENT
			 LEFT JOIN dbo.TK_PRTYPE pt
					   ON seat.season = pt.season 
						  AND seat.I_PT = pt.PRTYPE

						  

		WHERE tkodet.Season = @curSeason
		GROUP BY tkodet.SEASON
				 ,tkodet.CUSTOMER
				 ,seat.ITEM
				 ,tkodet.EVENT
				 ,tkodet.E_PL
				 ,seat.I_PT
				 ,PT.NAME
				 ,tkodet.E_STAT
				 ,seat.STAT	
				 ,tkodet.E_ADATE


/* ************************************************** Budget ************************************************************ */

		CREATE TABLE #budget 
(
event VARCHAR (10)
,qty INTEGER	 
,amount float
)

insert into #budget
(event , qty, amount)

Select 'F01',0,'827148' UNION all
Select 'F02',0,'827148' UNION all
Select 'F03',0,'2112016' UNION all
Select 'F04',0,'1245928' UNION all
Select 'F05',0,'2112013' UNION all
Select 'F06',0,'1245928' 

					

/* ************************************************** Create Results Table ************************************************************ */

        CREATE TABLE #Results
            (
              Section VARCHAR(50)
            , SubSection1 VARCHAR(50)
            , SubSection2 VARCHAR(75)
            , EventCode VARCHAR(20)
            , EventName VARCHAR(50)
            , EventDate DATE
            , Ticket_Type VARCHAR(50)
			, PriceType VARCHAR(20)
            , PriceType_Decription VARCHAR(100)
			, ORDER_DATE DATETIME
            , Qty DECIMAL(18, 2)	
            , Revenue DECIMAL(18, 2)
            , Section_Sort_Order VARCHAR(20)
            , Ticket_Type_Sort_Order VARCHAR(20)
            )

/* ************************************************** Event List ************************************************************ */

        SELECT  SEASON COLLATE SQL_Latin1_General_CP1_CS_AS Season
              , EVENT COLLATE SQL_Latin1_General_CP1_CS_AS EventCode
              , NAME COLLATE SQL_Latin1_General_CP1_CS_AS EventName
              , CAST(DATE AS DATE) EventDate
        INTO    #Event
        FROM    dbo.TK_EVENT
        WHERE   SEASON = 'F16'
                AND EVENT LIKE 'F0[1-6]'

/* ************************************************** Seat_Seat Temp ************************************************************ */

        SELECT  SEASON
              , EVENT
              , STAT
              , ISNULL(Hold_Code.sstat, 'Unclassified') Hold_Code
              , ISNULL(Hold_Code.name, 'Unclassified') Description
              , ISNULL(Hold_Code.Capacity, 'T') Capacity
              , ISNULL(Hold_Code.Remaining_Inventory, 'T') Remaining_Inventory
              , ISNULL(Hold_Code.Grouping, 'Unclassified') Grouping
        INTO    #TK_SEAT_SEAT
        FROM    dbo.TK_SEAT_SEAT tkSeatSeat
                LEFT JOIN dbo.TI_Hold_Code_Lookup_FB15 Hold_Code 
						  ON Hold_Code.sstat COLLATE SQL_Latin1_General_CP1_CS_AS = tkSeatSeat.STAT
        WHERE   SEASON = @curSeason
                AND EVENT LIKE 'F0[1-6]'
                AND tkSeatSeat.STAT IS NOT NULL
                AND tkSeatSeat.STAT <> 'N'


                                                
/* **************************************************  Full Season   ************************************************************ */

  INSERT  INTO #Results
                 (  Section 
                  , SubSection1 
                  , SubSection2 
                  , EventCode 
                  , EventName 
                  , EventDate 
                  , Ticket_Type 
				  , PriceType 
                  , PriceType_Decription
				  , ORDER_DATE 
                  , Qty 
                  , Revenue 
                  , Section_Sort_Order 
                  , Ticket_Type_Sort_Order
                )
                SELECT  'Total Distributed' AS Section 
                        , 'Sold Tickets' AS SubSection 
                        , 'Full Season Tickets' AS SubSection2 
                        , event.EventCode 
                        , event.EventName 
                        , event.EventDate
                        , rb.Ticket_Type 
                        , rb.E_PT
                        , rb.PT_Description
						, rb.ORDER_DATE
                        , SUM(rb.ORDQTY) Qty 
                        , SUM(rb.ORDTOTAL) Revenue 
                        , 1 AS Section_Sort_Order 
                        , rb.Ticket_type_Sort_Order

                        FROM  #Event Event
						LEFT JOIN ( SELECT  rb.SEASON 
											, rb.EVENT
											, rb.E_PT
											, rb.PT_Description
											, RB.ORDER_DATE
											, 'Full Season' AS Ticket_Type 
											, 101 AS Ticket_type_Sort_Order
											, rb.ORDQTY 
											, rb.ORDTOTAL 
									FROM    #ReportBase rb
									WHERE   ITEM = 'FS'
											AND rb.ORDTOTAL > 0
											AND E_PL NOT IN( '21','23')
									) rb ON rb.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = Event.Season
											AND rb.EVENT COLLATE SQL_Latin1_General_CP1_CS_AS = Event.EventCode
                WHERE  Ticket_Type IS NOT NULL
                GROUP BY EventCode 
                         , EventName 
                         , EventDate 
                         , Ticket_Type 
						 , rb.E_PT
						 , rb.PT_Description
						 , rb.ORDER_DATE
                         , Ticket_type_Sort_Order

/* **************************************************   Mini Plans   ************************************************************ */


INSERT  INTO #Results
                 (  Section 
                  , SubSection1 
                  , SubSection2 
                  , EventCode 
                  , EventName 
                  , EventDate 
                  , Ticket_Type 
				  , PriceType 
                  , PriceType_Decription 
				  , ORDER_DATE
                  , Qty 
                  , Revenue 
                  , Section_Sort_Order 
                  , Ticket_Type_Sort_Order
                )
                SELECT  'Total Distributed' AS Section 
                        , 'Sold Tickets' AS SubSection 
                        , 'Mini Plans' AS SubSection2 
                        , event.EventCode 
                        , event.EventName 
                        , event.EventDate
                        , rb.Ticket_Type 
                        , rb.E_PT
                        , rb.PT_Description
						, rb.ORDER_DATE
                        , SUM(rb.ORDQTY) Qty 
                        , SUM(rb.ORDTOTAL) Revenue 
                        , 2 AS Section_Sort_Order 
                        , rb.Ticket_type_Sort_Order
				FROM    #Event Event
						LEFT JOIN ( SELECT  rb.SEASON 
											, rb.EVENT
											, rb.ITEM
											, rb.E_PT
											, rb.PT_Description 
											, rb.ORDER_DATE
											, 'Mini Plans' AS Ticket_Type 
											, 1 AS Ticket_type_Sort_Order 
											, rb.ORDQTY 
											, rb.ORDTOTAL
									FROM    #ReportBase rb
									WHERE   ITEM LIKE '[2-5]%'
											AND rb.ORDTOTAL > 0
											AND E_PL NOT IN( '21','23')
									) rb ON rb.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = Event.Season
											AND rb.EVENT COLLATE SQL_Latin1_General_CP1_CS_AS = Event.EventCode
                WHERE  Ticket_Type IS NOT NULL
                GROUP BY EventCode 
                         , EventName 
                         , EventDate 
                         , Ticket_Type 
						 , rb.E_PT
						 , rb.PT_Description
						 , rb.ORDER_DATE
                         , Ticket_type_Sort_Order

/* ************************************************** GROUP Tickets  ************************************************************ */


INSERT  INTO #Results
                 (  Section 
                  , SubSection1 
                  , SubSection2 
                  , EventCode 
                  , EventName 
                  , EventDate 
                  , Ticket_Type 
				  , PriceType 
                  , PriceType_Decription 
				  , ORDER_DATE
                  , Qty 
                  , Revenue 
                  , Section_Sort_Order 
                  , Ticket_Type_Sort_Order
                )
                SELECT  'Total Distributed' AS Section 
                        , 'Sold Tickets' AS SubSection 
                        , 'Group Tickets' AS SubSection2 
                        , event.EventCode 
                        , event.EventName 
                        , event.EventDate
                        , rb.Ticket_Type 
                        , rb.E_PT
                        , rb.PT_Description
						, rb.ORDER_DATE
                        , SUM(rb.ORDQTY) Qty 
                        , SUM(rb.ORDTOTAL) Revenue 
                        , 3 AS Section_Sort_Order 
                        , rb.Ticket_type_Sort_Order

                        FROM  #Event Event
						LEFT JOIN ( SELECT  rb.SEASON 
											, rb.EVENT
											, rb.E_PT
											, rb.PT_Description 
											, rb.ORDER_DATE
											, 'Group Tickets' AS Ticket_Type 
											, 1 AS Ticket_type_Sort_Order
											, rb.ORDQTY 
											, rb.ORDTOTAL 
									FROM  #ReportBase rb
									WHERE ITEM LIKE 'F0[1-6]%'
										 
										  AND rb.E_PT LIKE 'G%'
										  AND rb.ORDTOTAL > 0
										  AND E_PL NOT IN( '21','23', '16', '20')
									) rb ON rb.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = Event.Season
											AND rb.EVENT COLLATE SQL_Latin1_General_CP1_CS_AS = Event.EventCode
                WHERE  Ticket_Type IS NOT NULL
                GROUP BY EventCode 
                         , EventName 
                         , EventDate 
                         , Ticket_Type 
						 , rb.E_PT
						 , rb.PT_Description
						 , rb.ORDER_DATE
                         , Ticket_type_Sort_Order


/* **************************************************   Single Game  ************************************************************ */


INSERT  INTO #Results
                 (  Section 
                  , SubSection1 
                  , SubSection2 
                  , EventCode 
                  , EventName 
                  , EventDate 
                  , Ticket_Type 
				  , PriceType 
                  , PriceType_Decription 
				  , ORDER_DATE
                  , Qty 
                  , Revenue 
                  , Section_Sort_Order 
                  , Ticket_Type_Sort_Order
                )
                SELECT  'Total Distributed' AS Section 
                        , 'Sold Tickets' AS SubSection 
                        , 'Single Game' AS SubSection2 
                        , event.EventCode 
                        , event.EventName 
                        , event.EventDate
                        , rb.Ticket_Type 
                        , rb.E_PT
                        , rb.PT_Description
						, RB.ORDER_DATE
                        , SUM(rb.ORDQTY) Qty 
                        , SUM(rb.ORDTOTAL) Revenue 
                        , 4 AS Section_Sort_Order 
                        , rb.Ticket_type_Sort_Order

                        FROM  #Event Event
						LEFT JOIN ( SELECT  rb.SEASON 
											, rb.EVENT
											, rb.E_PT
											, rb.PT_Description 
											, rb.ORDER_DATE
											, CASE WHEN E_PT = 'V' THEN 'Visiting'
												   ELSE 'Public'
											  END AS Ticket_Type 
											, CASE WHEN E_PT = 'V' THEN 402
												   ELSE 401
											  END AS Ticket_type_Sort_Order 
											  , rb.ORDQTY
											, CASE WHEN E_PT = 'V' THEN  CASE When ITEM = 'F01' THEN 50 
																			  WHEN ITEM = 'F02' THEN 50
																			  WHEN ITEM = 'F03' THEN 55
																			  WHEN ITEM = 'F04' THEN 50  
																			  WHEN ITEM = 'F05' THEN 55
																			  WHEN ITEM = 'F06' THEN 50 
																		 END
												   ELSE ORDTOTAL
											  END ORDTOTAL 
									FROM  #ReportBase rb
									WHERE ITEM LIKE 'F0[1-6]%'
										   
										  AND rb.E_PT NOT LIKE 'G%' 
										  AND ORDTOTAL > 0
										  AND E_PL NOT IN( '21','23')
									) rb ON rb.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = Event.Season
											AND rb.EVENT COLLATE SQL_Latin1_General_CP1_CS_AS = Event.EventCode
                WHERE  Ticket_Type IS NOT NULL
                GROUP BY EventCode 
                         , EventName 
                         , EventDate 
                         , Ticket_Type 
						 , rb.E_PT
						 , rb.PT_Description
						 , rb.ORDER_DATE
                         , Ticket_type_Sort_Order


/* **************************************************     Suites	 ************************************************************ */

INSERT  INTO #Results
                 (  Section 
                  , SubSection1 
                  , SubSection2 
                  , EventCode 
                  , EventName 
                  , EventDate 
                  , Ticket_Type 
				  , PriceType 
                  , PriceType_Decription 
				  , ORDER_DATE
                  , Qty 
                  , Revenue 
                  , Section_Sort_Order 
                  , Ticket_Type_Sort_Order
                )
                SELECT  'Total Distributed' AS Section 
                        , 'Sold Tickets' AS SubSection 
                        , 'Suites' AS SubSection2 
                        , event.EventCode 
                        , event.EventName 
                        , event.EventDate
                        , rb.Ticket_Type 
                        , rb.E_PT
                        , rb.PT_Description
						, rb.ORDER_DATE
                        , SUM(rb.ORDQTY) Qty
                        , SUM(rb.ORDTOTAL) Revenue 
                        , 5 AS Section_Sort_Order 
                        , rb.Ticket_type_Sort_Order

                        FROM  #Event Event
						LEFT JOIN ( SELECT  rb.SEASON 
											, rb.EVENT
											, rb.E_PT
											, rb.PT_Description 
											, rb.ORDER_DATE
											, CASE WHEN item IN ('FSS','FSSUITE') AND rb.ORDTOTAL > 0
												   THEN 'Season Suites' 
												   WHEN item LIKE 'F0[1-6]' AND rb.ORDTOTAL > 0
												   THEN 'Single Game Suites'
												   WHEN rb.ORDTOTAL = 0
												   THEN 'Suite Comps'
											  END AS Ticket_Type 
											, CASE WHEN item IN ('FSS','FSSUITE') AND rb.ORDTOTAL > 0
												   THEN 501 
												   WHEN item LIKE 'F0[1-6]' AND rb.ORDTOTAL > 0
												   THEN 502
												   WHEN rb.ORDTOTAL = 0
												   THEN 503
											  END AS Ticket_type_Sort_Order
											, rb.ORDQTY	 
											, rb.ORDTOTAL 
									FROM  #ReportBase rb
									WHERE (ITEM in ('FSS','FSSUITE')
										   OR (item LIKE 'F0[1-6]'
											   AND rb.E_PL = '16'))
										  AND rb.E_PL NOT IN( '21','23')
									) rb ON rb.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = Event.Season
											AND rb.EVENT COLLATE SQL_Latin1_General_CP1_CS_AS = Event.EventCode
                WHERE  Ticket_Type IS NOT NULL
                GROUP BY EventCode 
                         , EventName 
                         , EventDate 
                         , Ticket_Type 
						 , rb.E_PT
						 , rb.PT_Description
						 , rb.ORDER_DATE
                         , Ticket_type_Sort_Order



/* ********************************************  MidFirstBankStadium Club  ************************************************************ */

INSERT  INTO #Results
                 (  Section 
                  , SubSection1 
                  , SubSection2 
                  , EventCode 
                  , EventName 
                  , EventDate 
                  , Ticket_Type 
				  , PriceType 
                  , PriceType_Decription 
				  , ORDER_DATE
                  , Qty 
                  , Revenue 
                  , Section_Sort_Order 
                  , Ticket_Type_Sort_Order
                )
                SELECT  'Total Distributed' AS Section 
                        , 'Sold Tickets' AS SubSection 
                        , 'MSBC' AS SubSection2 
                        , event.EventCode 
                        , event.EventName 
                        , event.EventDate
                        , rb.Ticket_Type 
                        , rb.E_PT
                        , rb.PT_Description
						, rb.ORDER_DATE
                        , SUM(rb.ORDQTY) Qty
                        , SUM(rb.ORDTOTAL) Revenue 
                        , 6 AS Section_Sort_Order 
                        , rb.Ticket_type_Sort_Order

                        FROM  #Event Event
						LEFT JOIN ( SELECT  rb.SEASON 
											, rb.EVENT
											, rb.E_PT
											, rb.PT_Description 
											, rb.ORDER_DATE
											, CASE WHEN item IN ('FSC') AND rb.ORDTOTAL > 0
												   THEN 'MSBC Season Ticket' 
												   WHEN item LIKE 'F0[1-6]' AND rb.ORDTOTAL > 0
												   THEN 'MSBC Single Game'
												   WHEN rb.ORDTOTAL = 0
												   THEN 'MSBC Comps'
											  END AS Ticket_Type 
											, CASE WHEN item IN ('FSC') AND rb.ORDTOTAL > 0
												   THEN 601 
												   WHEN item LIKE 'F0[1-6]' AND rb.ORDTOTAL > 0
												   THEN 602
												   WHEN rb.ORDTOTAL = 0
												   THEN 603
											  END AS Ticket_type_Sort_Order 
											, rb.ORDQTY
											, rb.ORDTOTAL 
									FROM  #ReportBase rb
									WHERE  (ITEM in ('FSC')
										    OR (item LIKE 'F0[1-6]'
												AND rb.E_PL = '20'))
											AND E_PL NOT IN( '21','23')
									) rb ON rb.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = Event.Season
											AND rb.EVENT COLLATE SQL_Latin1_General_CP1_CS_AS = Event.EventCode
                WHERE  Ticket_Type IS NOT NULL
                GROUP BY EventCode 
                         , EventName 
                         , EventDate 
                         , Ticket_Type 
						 , rb.E_PT
						 , rb.PT_Description
						 , rb.ORDER_DATE
                         , Ticket_type_Sort_Order


/* **************************************************   STUDENTS    ************************************************************ */



INSERT  INTO #Results
                 (  Section 
                  , SubSection1 
                  , SubSection2 
                  , EventCode 
                  , EventName 
                  , EventDate 
                  , Ticket_Type 
				  , PriceType 
                  , PriceType_Decription 
				  , ORDER_DATE
                  , Qty 
                  , Revenue 
                  , Section_Sort_Order 
                  , Ticket_Type_Sort_Order
                )
                SELECT  'Total Distributed' AS Section 
                        , 'Student Tickets' AS SubSection 
                        , 'Student Tickets' AS SubSection2 
                        , event.EventCode 
                        , event.EventName 
                        , event.EventDate
                        , rb.Ticket_Type 
                        , rb.E_PT
                        , rb.PT_Description
						, rb.ORDER_DATE
                        , SUM(RB.ORDQTY) Qty
                        , SUM(rb.ORDTOTAL) Revenue 
                        , 7 AS Section_Sort_Order 
                        , rb.Ticket_type_Sort_Order

                        FROM  #Event Event
						LEFT JOIN ( SELECT  rb.SEASON 
											, rb.EVENT
											, rb.E_PT
											, rb.PT_Description
											, rb.ORDER_DATE 
											, CASE rb.HOLD_CODE
												   WHEN 'O' THEN 'Unscanned Student'
												   WHEN 'X' THEN 'Scanned Student'
											  END AS Ticket_Type 
											, CASE rb.HOLD_CODE
												   WHEN 'O' THEN 701
												   WHEN 'X' THEN 702
											  END AS Ticket_type_Sort_Order 
											, rb.ORDQTY
											, rb.ORDTOTAL 
									FROM  #ReportBase rb
									WHERE rb.E_PL IN( '21','23') 
										  AND (rb.ORDTOTAL > 0 OR rb.E_PT = 'AP')
									) rb ON rb.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = Event.Season
											AND rb.EVENT COLLATE SQL_Latin1_General_CP1_CS_AS = Event.EventCode
                WHERE  Ticket_Type IS NOT NULL
                GROUP BY EventCode 
                         , EventName 
                         , EventDate 
                         , Ticket_Type 
						 , rb.E_PT
						 , rb.PT_Description
						 , rb.ORDER_DATE
                         , Ticket_type_Sort_Order



/* **************************************************     Comps	     ************************************************************ */


INSERT  INTO #Results
                 (  Section 
                  , SubSection1 
                  , SubSection2 
                  , EventCode 
                  , EventName 
                  , EventDate 
                  , Ticket_Type 
				  , PriceType 
                  , PriceType_Decription 
				  , ORDER_DATE
                  , Qty 
                  , Revenue 
                  , Section_Sort_Order 
                  , Ticket_Type_Sort_Order
                )
                SELECT  'Total Distributed' AS Section 
                        , 'Comp Tickets' AS SubSection 
                        , 'Comp Tickets' AS SubSection2 
                        , event.EventCode 
                        , event.EventName 
                        , event.EventDate
                        , rb.Ticket_Type 
                        , rb.E_PT
                        , rb.PT_Description
						, rb.ORDER_DATE
                        , SUM(RB.ORDQTY) Qty
                        , SUM(rb.ORDTOTAL) Revenue 
                        , 8 AS Section_Sort_Order 
                        , rb.Ticket_type_Sort_Order

                        FROM  #Event Event
						LEFT JOIN ( SELECT  rb.SEASON 
											, rb.EVENT
											, rb.E_PT
											, rb.PT_Description 
											, rb.ORDER_DATE
											, 'Comps' AS Ticket_Type 
											, 800 AS Ticket_type_Sort_Order 
											, rb.ORDQTY
											, rb.ORDTOTAL 
									FROM  #ReportBase rb
									WHERE  ordtotal = 0 
										   AND rb.E_PT NOT IN ('AP','EXC')
										   AND E_PL NOT IN ('16','20')
									) rb ON rb.SEASON COLLATE SQL_Latin1_General_CP1_CS_AS = Event.Season
											AND rb.EVENT COLLATE SQL_Latin1_General_CP1_CS_AS = Event.EventCode
                WHERE  Ticket_Type IS NOT NULL
                GROUP BY EventCode 
                         , EventName 
                         , EventDate 
                         , Ticket_Type 
						 , rb.E_PT
						 , rb.PT_Description
						 , rb.ORDER_DATE
                         , Ticket_type_Sort_Order



/* ***************************************************   Capacity   ************************************************************* */

        INSERT  INTO #Results
                ( Section
                , SubSection1
                , SubSection2
                , EventCode
                , EventName
                , EventDate
                , Ticket_Type
                , PriceType
                , PriceType_Decription
				, ORDER_DATE
                , Qty
                , Revenue
                , Section_Sort_Order
                , Ticket_Type_Sort_Order
                )
                SELECT  'Capacity' AS Section
                      , 'Capacity' AS SubSection1
                      , 'Capacity' AS SubSection2
                      , Event.EventCode
                      , Event.EventName
                      , Event.EventDate
                      , 'Capacity' AS Ticket_Type
                      , NULL
                      , NULL
					  , NULL
                      , COUNT(*) AS Qty
                      , NULL 
                      , 9 AS Section_Sort_Order
                      , 901 AS Ticket_Type_Sort_Order
                FROM    #Event Event
                        LEFT JOIN #TK_SEAT_SEAT tkSeatSeat ON tkSeatSeat.SEASON = Event.Season
                                                              AND tkSeatSeat.EVENT = Event.EventCode
                WHERE   tkSeatSeat.SEASON = @curSeason
                        AND tkSeatSeat.Capacity = 'T'
                GROUP BY Event.EventCode
                      , Event.EventName
                      , Event.EventDate


/* **********************************************   Remaining Inventory	 ******************************************************** */



        INSERT  INTO #Results
                ( Section
                , SubSection1
                , SubSection2
                , EventCode
                , EventName
                , EventDate
                , Ticket_Type
                , PriceType
                , PriceType_Decription
				, ORDER_DATE
                , Qty
                , Revenue
                , Section_Sort_Order
                , Ticket_Type_Sort_Order
                )
                SELECT  'Remaining Inventory' AS Section
                      , 'Remaining Inventory' AS SubSection1
                      , 'Remaining Inventory' AS SubSection2
                      , Event.EventCode
                      , Event.EventName
                      , Event.EventDate
                      , tkseatseat.Grouping AS Ticket_Type
                      , tkSeatSeat.STAT AS Hold_Code
                      , tkSeatSeat.Description AS PriceType_Decription
					  , NULL AS ORDER_DATE
                      , COUNT(*) AS Qty
                      , NULL
                      , 10 AS Section_Sort_Order
                      , tkSeatSeat.Hold_Code AS Ticket_Type_Sort_Order
                FROM    #Event Event
                        LEFT JOIN #TK_SEAT_SEAT tkSeatSeat ON tkSeatSeat.SEASON = Event.Season
                                                              AND tkSeatSeat.EVENT = Event.EventCode
                WHERE   tkSeatSeat.SEASON = @curSeason
                        AND (tkSeatSeat.Remaining_Inventory = 'T' 
							--OR tkSeatSeat.STAT = 'k'
							)
						--AND tkSeatSeat.Grouping <> 'Do Not Show'
                GROUP BY Event.EventCode
                      , Event.EventName
                      , Event.EventDate
                      , tkSeatSeat.Grouping
                      , tkSeatSeat.STAT
                      , tkSeatSeat.Description
					  , tkSeatSeat.Hold_Code
				ORDER BY Hold_Code



/* **************************************************     Budget	 ************************************************************ */



        INSERT  INTO #Results
                ( Section
                , SubSection1
                , SubSection2
                , EventCode
                , EventName
                , EventDate
                , Ticket_Type
                , PriceType
                , PriceType_Decription
				, ORDER_DATE
                , Qty
                , Revenue
                , Section_Sort_Order
                , Ticket_Type_Sort_Order
                )
                SELECT  'Budget' AS Section
                      , 'Budget' AS SubSection1
                      , 'Budget' AS SubSection2
                      , Event.EventCode
                      , Event.EventName
                      , Event.EventDate
                      , 'Budget' AS Ticket_Type
                      , NULL
                      , NULL
					  , NULL
                      , budget.qty
                      , budget.amount
                      , 11 AS Section_Sort_Order
                      , 111 AS Ticket_Type_Sort_Order
                FROM    #Event Event JOIN #budget budget
						ON event.eventcode COLLATE SQL_Latin1_General_CP1_CS_AS = budget.event COLLATE SQL_Latin1_General_CP1_CS_AS


/* ************************************************** #Output ************************************************************ */

		   SELECT * INTO 
		   #output
		   FROM(SELECT * FROM #Results

				UNION ALL
                
				--% to Budget
				SELECT  'Budget' AS Section
                      , 'Budget' AS SubSection1
                      , 'Budget' AS SubSection2
                      , results.EventCode
                      , results.EventName
                      , results.EventDate
                      , '% to Budget' AS Ticket_Type
                      , NULL AS PriceType
                      , NULL AS PriceType_Description
					  , NULL AS Order_date
                      , CASE WHEN SUM(CASE WHEN subsection1 = 'Budget' THEN results.Qty END) = 0
							 THEN 0
							 ELSE SUM(CASE WHEN subsection1 = 'Sold Tickets' THEN results.Qty END)/
							 SUM(CASE WHEN subsection1 = 'Budget' THEN results.Qty END)
						END AS Qty
					  , CASE WHEN SUM(CASE WHEN subsection1 = 'Budget' THEN results.Revenue END) = 0
							 THEN 0
							 ELSE SUM(CASE WHEN subsection1 = 'Sold Tickets' THEN results.Revenue END)/
							 SUM(CASE WHEN subsection1 = 'Budget' THEN results.Revenue END)
						END AS Revenue
                      , 11 AS Section_Sort_Order
                      , '112' AS Ticket_Type_Sort_Order
				FROM #Results results
				GROUP BY results.EventCode
						 , results.EventName
						 , results.EventDate

								UNION ALL
                
				--Avg Price
				SELECT  'Budget' AS Section
                      , 'Budget' AS SubSection1
                      , 'Budget' AS SubSection2
                      , results.EventCode
                      , results.EventName
                      , results.EventDate
                      , 'Average Price' AS Ticket_Type
                      , NULL AS PriceType
                      , NULL AS PriceType_Description
					  , NULL AS Order_date
					  , CASE WHEN SUM(results.Qty) = 0 THEN 0
							 ELSE SUM(results.Revenue)/SUM(results.Qty)
						END AS qty
					  , CASE WHEN SUM(results.Qty) = 0 THEN 0
							 ELSE SUM(results.Revenue)/SUM(results.Qty)
						END AS revenue
                      , 11 AS Section_Sort_Order
                      , '113' AS Ticket_Type_Sort_Order
				FROM #Results results
				WHERE subsection1 = 'Sold Tickets'
					  AND NOT(results.Ticket_Type IN ('Season Suites','MSBC Comps')
							  OR (results.Ticket_Type = 'Student' 
								  AND results.PriceType = 'AP'))
				GROUP BY results.EventCode
						 , results.EventName
						 , results.EventDate

				UNION ALL

				--Avg Price to Budget
				SELECT  'Budget' AS Section
                      , 'Budget' AS SubSection1
                      , 'Budget' AS SubSection2
                      , results.EventCode
                      , results.EventName
                      , results.EventDate
                      , 'Average Price to Budget' AS Ticket_Type
                      , NULL AS PriceType
                      , NULL AS PriceType_Description
					  , NULL AS Order_date
					  , CASE WHEN SUM(CASE WHEN section = 'Remaining Inventory' 
										   THEN results.Qty
									  END) = 0 THEN 0
							 ELSE (SUM(CASE WHEN section = 'Budget' THEN results.Revenue END) -
								   SUM(CASE WHEN section = 'Total Distributed' THEN results.Revenue END))
								   /
								   SUM(CASE WHEN section = 'Remaining Inventory' THEN results.Qty END)
						END AS qty
					  , CASE WHEN SUM(CASE WHEN section = 'Remaining Inventory' 
										   THEN results.Qty
									  END) = 0 THEN 0
							 ELSE (SUM(CASE WHEN section = 'Budget' THEN results.Revenue END) -
								   SUM(CASE WHEN section = 'Total Distributed' THEN results.Revenue END))
								   /
								   SUM(CASE WHEN section = 'Remaining Inventory' THEN results.Qty END)
						END AS revenue
                      , 11 AS Section_Sort_Order
                      , '114' AS Ticket_Type_Sort_Order

				FROM #Results results
				GROUP BY results.EventCode
						 , results.EventName
						 , results.EventDate

				UNION ALL
                
								--Sales Velocity
				SELECT  'Recent Sales Velocity' AS Section
                      , 'Recent Sales Velocity' AS SubSection1
                      , 'Recent Sales Velocity' AS SubSection2
                      , results.EventCode
                      , results.EventName
                      , results.EventDate
                      , dateGroups.ticketType AS Ticket_Type
                      , NULL AS PriceType
                      , NULL AS PriceType_Description
					  , NULL AS Order_date
                      , SUM(results.Qty) AS Qty
                      , SUM(results.Revenue) AS Revenue
                      , 12 AS Section_Sort_Order
                      , dateGroups.Ticket_Type_Sort_Order AS Ticket_Type_Sort_Order
                FROM    #Results results
					JOIN (SELECT 'Last 7 days' AS ticketType,'121' AS Ticket_Type_Sort_Order, DATEADD(DAY,-7,GETDATE()) AS dateLimit
						  UNION ALL
						  SELECT 'Last 14 days','122', DATEADD(DAY,-14,GETDATE())
						  UNION ALL
						  SELECT 'Last 30 days','123', DATEADD(DAY,-30,GETDATE())
						  )dateGroups ON results.order_date <= dateGroups.dateLimit
				WHERE subsection1 = 'Sold Tickets'
				GROUP BY  results.EventCode
						 , results.EventName
						 , results.EventDate
						 , results.Ticket_Type
						 , results.ORDER_DATE 
						 , dateGroups.ticketType
						 , dateGroups.Ticket_Type_Sort_Order

				)x

/* ************************************************** Displayed Output ************************************************************ */


        SELECT  Section
              , SubSection1
              , SubSection2
              , EventCode
              , EventName
              , EventDate
              , Ticket_Type
              , PriceType
              , PriceType_Decription
              , Section_Sort_Order
              , Ticket_Type_Sort_Order
              , SUM(CASE WHEN @DataType = 'Qty' THEN Qty ELSE Revenue END) AS Qty
              , SUM(Revenue) Revenue
        FROM    #output
        GROUP BY  Section
                , SubSection1
                , SubSection2
                , EventCode
                , EventName
                , EventDate
                , Ticket_Type
                , PriceType
                , PriceType_Decription
                , Section_Sort_Order
                , Ticket_Type_Sort_Order
        ORDER BY PriceType_Decription
				,Ticket_Type 
              


END	










GO
