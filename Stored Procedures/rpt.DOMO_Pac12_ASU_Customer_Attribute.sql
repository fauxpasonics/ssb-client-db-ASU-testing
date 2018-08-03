SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [rpt].[DOMO_Pac12_ASU_Customer_Attribute]
AS
    BEGIN

        TRUNCATE TABLE [etl].[DOMO_Pac12_ExportFile_ASU_Customer_Attribute]

	
        IF OBJECT_ID('tempdb..#Membership') IS NOT NULL
            DROP TABLE #Membership

	    IF OBJECT_ID('tempdb..#PriorityPoints') IS NOT NULL
            DROP TABLE #PriorityPoints

		 IF OBJECT_ID('tempdb..#Model') IS NOT NULL
            DROP TABLE #Model

			IF OBJECT_ID('tempdb..#Axiom') IS NOT NULL
            DROP TABLE #Axiom

        IF OBJECT_ID('tempdb..#ID') IS NOT NULL
            DROP TABLE #ID

        DECLARE @CY_YEAR INT
        SET @CY_YEAR = ( SELECT 
                          MIN(GIFT_CLUB_YEAR) GIFT_CLUB_YEAR
                         FROM   dbo.FD_SDC_GIFT_CLUBS (NOLOCK)
                         WHERE  GIFT_CLUB_STATUS = 'A'
                       )

       SELECT  Priority_Points.PACIOLAN_ID
			   , dc.SSB_CRMSYSTEM_CONTACT_ID
               , Priority_Points.TOTAL_POINTS AS PriorityPoints
               , Priority_Points.RANKING AS PriorityPointsRank
	   INTO #PriorityPoints
       FROM    dbo.FD_SDA_PRIORITY_POINT_SUMMARY Priority_Points (NOLOCK)
	   INNER JOIN [dbo].[vwDimCustomer_ModAcctId] dc on dc.SourceSystem = 'TM' AND dc.AccountId = Priority_Points.PACIOLAN_ID AND dc.CustomerType = 'Primary' AND dc.SSB_CRMSYSTEM_PRIMARY_FLAG = '1'

	   
	   
	    SELECT DISTINCT
                GIFT_CLUB_ID_NUMBER
        INTO    #ID
        FROM    dbo.FD_SDC_GIFT_CLUBS (NOLOCK)
        WHERE   GIFT_CLUB_YEAR = @CY_YEAR
                OR GIFT_CLUB_YEAR = @CY_YEAR - 1
                OR GIFT_CLUB_YEAR = @CY_YEAR + 1


        SELECT  ID.GIFT_CLUB_ID_NUMBER
			  , ssbid.SSB_CRMSYSTEM_CONTACT_ID
              , PY.GIFT_CLUB_DESC GIFT_CLUB_DESC_PY
              , PY.QUALIFIED_AMOUNT QUALIFIED_AMOUNT_PY
              , CY.GIFT_CLUB_DESC GIFT_CLUB_DESC_CY
              , CY.QUALIFIED_AMOUNT QUALIFIED_AMOUNT_CY
              , FutureYear.GIFT_CLUB_DESC GIFT_CLUB_DESC_FutureYears
              , FutureYear.QUALIFIED_AMOUNT QUALIFIED_AMOUNT_FutureYears
        INTO    #Membership
        FROM    #ID ID
                JOIN dbo.dimcustomerssbid ssbid (NOLOCK) ON ID.GIFT_CLUB_ID_NUMBER = ssbid.SSID
                                                   AND ssbid.SourceSystem = 'Advance ASU'
                LEFT JOIN ( SELECT DISTINCT
                                    Clubs.GIFT_CLUB_ID_NUMBER
                                  , GIFT_CLUB_DESC
                                  , QUALIFIED_AMOUNT
                            FROM    dbo.FD_SDC_GIFT_CLUBS Clubs (NOLOCK)
                                    JOIN ( SELECT   GIFT_CLUB_ID_NUMBER
                                                  , MAX(GIFT_CLUB_SEQUENCE) GIFT_CLUB_SEQUENCE
                                           FROM     dbo.FD_SDC_GIFT_CLUBS (NOLOCK)
                                           WHERE    GIFT_CLUB_YEAR = @CY_YEAR
                                                    - 1
                                           GROUP BY GIFT_CLUB_ID_NUMBER
                                         ) MaxSequence ON MaxSequence.GIFT_CLUB_ID_NUMBER = Clubs.GIFT_CLUB_ID_NUMBER
                                                          AND MaxSequence.GIFT_CLUB_SEQUENCE = Clubs.GIFT_CLUB_SEQUENCE
                            WHERE   GIFT_CLUB_YEAR = @CY_YEAR - 1
                          ) PY ON PY.GIFT_CLUB_ID_NUMBER = ID.GIFT_CLUB_ID_NUMBER
                LEFT JOIN ( SELECT DISTINCT
                                    Clubs.GIFT_CLUB_ID_NUMBER
                                  , GIFT_CLUB_DESC
                                  , QUALIFIED_AMOUNT
                            FROM    dbo.FD_SDC_GIFT_CLUBS Clubs (NOLOCK)
                                    JOIN ( SELECT   GIFT_CLUB_ID_NUMBER
                                                  , MAX(GIFT_CLUB_SEQUENCE) GIFT_CLUB_SEQUENCE
                                           FROM     dbo.FD_SDC_GIFT_CLUBS
                                           WHERE    GIFT_CLUB_YEAR = @CY_YEAR
                                           GROUP BY GIFT_CLUB_ID_NUMBER
                                         ) MaxSequence ON MaxSequence.GIFT_CLUB_ID_NUMBER = Clubs.GIFT_CLUB_ID_NUMBER
                                                          AND MaxSequence.GIFT_CLUB_SEQUENCE = Clubs.GIFT_CLUB_SEQUENCE
                            WHERE   GIFT_CLUB_YEAR = @CY_YEAR
                          ) CY ON CY.GIFT_CLUB_ID_NUMBER = ID.GIFT_CLUB_ID_NUMBER
                LEFT JOIN ( SELECT DISTINCT
                                    Clubs.GIFT_CLUB_ID_NUMBER
                                  , GIFT_CLUB_DESC
                                  , QUALIFIED_AMOUNT
                            FROM    dbo.FD_SDC_GIFT_CLUBS Clubs (NOLOCK)
                                    JOIN ( SELECT   GIFT_CLUB_ID_NUMBER
                                                  , MAX(GIFT_CLUB_SEQUENCE) GIFT_CLUB_SEQUENCE
                                           FROM     dbo.FD_SDC_GIFT_CLUBS (NOLOCK)
                                           WHERE    GIFT_CLUB_YEAR = @CY_YEAR
                                                    + 1
                                           GROUP BY GIFT_CLUB_ID_NUMBER
                                         ) MaxSequence ON MaxSequence.GIFT_CLUB_ID_NUMBER = Clubs.GIFT_CLUB_ID_NUMBER
                                                          AND MaxSequence.GIFT_CLUB_SEQUENCE = Clubs.GIFT_CLUB_SEQUENCE
                            WHERE   GIFT_CLUB_YEAR = @CY_YEAR + 1
                          ) FutureYear ON FutureYear.GIFT_CLUB_ID_NUMBER = ID.GIFT_CLUB_ID_NUMBER  

        SELECT  *
        INTO    #Model
        FROM    dbo.ASU_Turnkey_2015Models_20150828

        SELECT  *
        INTO    #Axiom
        FROM    [dbo].[ASU_Turnkey_Acxiom_20151208]


        INSERT  INTO [etl].[DOMO_Pac12_ExportFile_ASU_Customer_Attribute]
                SELECT  COALESCE(ssbid.SSB_CRMSYSTEM_CONTACT_ID, Membership.SSB_CRMSYSTEM_CONTACT_ID, Priority_Points.SSB_CRMSYSTEM_CONTACT_ID) SSB_CRMSYSTEM_CONTACT_ID
                      , COALESCE(Axiom.[Ticketing System Account ID],
                                 Model.[Ticketing System Account ID],
								 Priority_Points.PACIOLAN_ID) [Ticketing System Account ID]
                      , [Abilitec ID]
                      , [Age 00 - 02 Female]
                      , [Age 00 - 02 Male]
                      , [Age 00 - 02 Unknown Gender]
                      , [Age 03 - 05 Female]
                      , [Age 03 - 05 Male]
                      , [Age 03 - 05 Unknown Gender]
                      , [Age 06 - 10 Female]
                      , [Age 06 - 10 Male]
                      , [Age 06 - 10 Unknown Gender]
                      , [Age 11 - 15 Female]
                      , [Age 11 - 15 Male]
                      , [Age 11 - 15 Unknown Gender]
                      , [Age 16 - 17 Female]
                      , [Age 16 - 17 Male]
                      , [Age 16 - 17 Unknown Gender]
                      , [Age in Two-Year Increments - 1st Individual]
                      , [Age in Two-Year Increments - 2nd Individual]
                      , [Age in Two-Year Increments - Input Individual]
                      , [Apartment Number]
                      , [Apparel - Female Apparel MOB's]
                      , [Apparel - Jewelry MOB's]
                      , [Apparel - Male Apparel MOB's]
                      , [Apparel - Plus Size Women's Clothing MOB's]
                      , [Apparel - Teen Fashion MOB's]
                      , [Apparel - Unknown Type]
                      , [Art & Antique MOB's]
                      , [Arts and Crafts MOB's]
                      , [Auto Supplies MOB's]
                      , [Bank Card Holder]
                      , [Bank, Financial Services - Banking]
                      , [Base Record Verification Date]
                      , [Beauty MOB's]
                      , [Book MOB's]
                      , [Business Owner]
                      , [Children's Merchandise MOB's]
                      , [Collectible MOB's]
                      , [Collectibles - Sports Memorabilia]
                      , [Computer Software MOB's]
                      , [Credit Card Holder - Unknown Type]
                      , [Discretionary Income Index]
                      , [Dwelling Type]
                      , [Education - 1st Individual]
                      , [Education - 2nd Individual]
                      , [Education - Input Individual]
                      , [Electronic MOB's]
                      , [Equestrian MOB's]
                      , [Females 18-24]
                      , [Females 25-34]
                      , [Females 35-44]
                      , [Females 45-54]
                      , [Females 55-64]
                      , [Females 65-74]
                      , [Females 75+]
                      , [Finance Company, Financial Services - Install Credit]
                      , [First Name - 1st Individual]
                      , [First Name - 2nd Individual]
                      , [Food MOB's]
                      , [Gas Department Retail Card Holder]
                      , [Gender - 1st Individual]
                      , [Gender - 2nd Individual]
                      , [Gender - Input Individual]
                      , [General Gifts and Merchandise MOB's]
                      , [Gift MOB's]
                      , [Health MOB's]
                      , [Home Assessed Value - Ranges]
                      , [Home Furnishing and Decorating MOB's]
                      , [Home Market Value]
                      , [Home Owner   Renter]
                      , [Home Phone]
                      , [Home Property Type Detail]
                      , [Home Square Footage - Actual]
                      , [Home Year Built - Actual]
                      , [Income - Estimated Household]
                      , [InfoBase Positive Match Indicator]
                      , [Investing - Active]
                      , [Length of Residence]
                      , [Mail Order Buyer]
                      , [Mail Order Donor]
                      , [Mail Order Responder]
                      , [Males 18-24]
                      , [Males 25-34]
                      , [Males 35-44]
                      , [Males 45-54]
                      , [Males 55-64]
                      , [Males 65-74]
                      , [Males 75+]
                      , [Marital Status in the Household]
                      , [Merchandise - High Ticket Merchandise MOB's]
                      , [Merchandise - Low Ticket Merchandise MOB's]
                      , [Middle Initial - 1st Individual]
                      , [Middle Initial - 2nd Individual]
                      , [Miscellaneous, Financial Services - Insurance]
                      , [Miscellaneous, Grocery]
                      , [Miscellaneous, Miscellaneous]
                      , [Miscellaneous, TV   Mail Order Purchases]
                      , [Motorcycle Owner]
                      , [Music MOB's]
                      , [Net Worth Gold]
                      , [Number of Adults]
                      , [Number of Sources]
                      , [Occupation - 1st Individual]
                      , [Occupation - 2nd Individual]
                      , [Occupation - Detail - Input Individual]
                      , [Occupation - Input Individual]
                      , [Oil Company, Oil Company]
                      , [Online Purchasing Indicator]
                      , [Outdoor Gardening MOB's]
                      , [Outdoor Hunting & Fishing MOB's]
                      , [Overall Match Indicator]
                      , [Personicx Cluster Code]
                      , [PersonicX Cluster]
                      , [Personicx Digital Cluster Code]
                      , [PersonicX Digital Cluster]
                      , [Pet Supplies MOB's]
                      , [Precision Level]
                      , [Premium Card Holder]
                      , [Presence of Children]
                      , [Purchase 0 - 3 Months]
                      , [Purchase 10 - 12 Months]
                      , [Purchase 13 - 18 Months]
                      , [Purchase 19 - 24 Months]
                      , [Purchase 24+ Months]
                      , [Purchase 4 - 6 Months]
                      , [Purchase 7 - 9 Months]
                      , [Race Code]
                      , [Retail Activity Date of Last]
                      , [Retail Purchases - Most Frequent Category]
                      , [RV Owner]
                      , [Spectator Sports - Auto   Motorcycle Racing]
                      , [Spectator Sports - Baseball]
                      , [Spectator Sports - Basketball]
                      , [Spectator Sports - Football]
                      , [Spectator Sports - Hockey]
                      , [Spectator Sports - Soccer]
                      , [Spectator Sports - Tennis]
                      , [Sports - Golf MOB's]
                      , [Sports and Leisure - SC]
                      , [Sports MOB's]
                      , [Standard Retail, Catalog Showroom   Retail Buyers]
                      , [Standard Retail, High Volume Low End Department Store Buyers]
                      , [Standard Retail, Main Street Retail]
                      , [Standard Retail, Membership Warehouse]
                      , [Standard Retail, Standard Retail]
                      , [Standard Specialty, Computer   Electronics Buyers]
                      , [Standard Specialty, Furniture Buyers]
                      , [Standard Specialty, Home Improvement]
                      , [Standard Specialty, Home Office Supply Purchases]
                      , [Standard Specialty, Specialty]
                      , [Standard Specialty, Specialty Apparel]
                      , [Standard Specialty, Sporting Goods]
                      , [Suppression - Mail - DMA]
                      , [Travel and Entertainment Card Holder]
                      , [Travel MOB's]
                      , [Truck Owner]
                      , [Unknown Gender 18-24]
                      , [Unknown Gender 25-34]
                      , [Unknown Gender 35-44]
                      , [Unknown Gender 45-54]
                      , [Unknown Gender 55-64]
                      , [Unknown Gender 65-74]
                      , [Unknown Gender 75+]
                      , [Upscale Card Holder]
                      , [Upscale Retail - High End Retail Buyers, Upscale Retail]
                      , [Upscale Specialty, Travel   Personal Services]
                      , [Vehicle - Dominant Lifestyle Indicator]
                      , [Vehicle - Known Owned Number]
                      , [Vehicle - New Car Buyer]
                      , [Vehicle - New Used Indicator - 1st Vehicle]
                      , [Vehicle - New Used Indicator - 2nd Vehicle]
                      , [Video DVD MOB's]
                      , [Working Woman]
                      , FootballCapacity
                      , FootballCapacityDate
                      , FootballPriority
                      , FootballPriorityDate
                      , BasketballCapacity
                      , BasketballCapacityDate
                      , BasketballPriority
                      , BasketballPriorityDate
                      , BaseballCapacity
                      , BaseballCapacityDate
                      , BaseballPriority
                      , BaseballPriorityDate
                      , [Abilitec ID Append Date]
                      , [Turnkey Standard Bundle Date]
                      , Priority_Points.PriorityPoints
                      , Priority_Points.PriorityPointsRank
					  , Membership.GIFT_CLUB_DESC_PY
					  , Membership.QUALIFIED_AMOUNT_PY
					  , Membership.GIFT_CLUB_DESC_CY
					  , Membership.QUALIFIED_AMOUNT_CY
					  , Membership.GIFT_CLUB_DESC_FutureYears
					  , Membership.QUALIFIED_AMOUNT_FutureYears
                FROM    #Axiom Axiom
                        FULL OUTER JOIN #Model Model ON Model.[Ticketing System Account ID] = Axiom.[Ticketing System Account ID]
                        JOIN [dbo].[vwDimCustomer_ModAcctId] ssbid (NOLOCK) ON ( ssbid.AccountId = Axiom.[Ticketing System Account ID]
                                                             OR ssbid.AccountId = Model.[Ticketing System Account ID]
                                                           )
                                                           AND ssbid.SourceSystem = 'TM' AND ssbid.CustomerType = 'Primary'
						FULL OUTER JOIN #Membership Membership ON Membership.SSB_CRMSYSTEM_CONTACT_ID = ssbid.SSB_CRMSYSTEM_CONTACT_ID

						FULL OUTER JOIN #PriorityPoints Priority_Points ON Priority_Points.SSB_CRMSYSTEM_CONTACT_ID = ssbid.SSB_CRMSYSTEM_CONTACT_ID
    END





GO
