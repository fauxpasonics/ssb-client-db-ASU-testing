SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[vw_Turnkey_Acxiom] with schemabinding

 
-- =============================================
-- Created By: Abbey Meitin
-- Create Date: 2018-07-06
-- Reviewed By: 
-- Reviewed Date: 
-- Description: Turnkey Nightly Automation Process
-- =============================================
 
/***** Revision History
 

*****/

AS

select ETL_ID, ETL_CreatedDate, ETL_UpdatedDate, ETL_IsDeleted, ETL_DeletedDate, ETL_DeltaHashKey, ETL_FileName, AbilitecID, ProspectID, FirstName, TicketingSystemAccountID, LastName, Email, OverallMatchIndicator, PersonicxClusterCode, PersonicxCluster, PrecisionLevel, AgeInTwoYearIncrements_InputIndividual, AgeInTwoYearIncrements_1stIndividual, AgeInTwoYearIncrements_2ndIndividual, Gender_InputIndividual, Gender_1stIndividual, Gender_2ndIndividual, FirstName_1stIndividual, MiddleInitial_1stIndividual, FirstName_2ndIndividual, MiddleInitial_2ndIndividual, OccupationDetail_InputIndividual, Occupation_InputIndividual, Occupation_1stIndividual, Occupation_2ndIndividual, Education_InputIndividual, Education_1stIndividual, Education_2ndIndividual, Males_18to24, Females_18to24, UnknownGender_18to24, Males_25to34, Females_25to34, UnknownGender_25to34, Males_35to44, Females_35to44, UnknownGender_35to44, Males_45to54, Females_45to54, UnknownGender_45to54, Males_55to64, Females_55to64, UnknownGender_55to64, Males_65to74, Females_65to74, UnknownGender_65to74, Males_75plus, Females_75plus, UnknownGender_75plus, MaritalStatusinHousehold, WorkingWoman, PresenceofChildren, NumberofAdults, BankCardHolder, GasDepartmentRetailCardHolder, TravelandEntertainmentCardHolder, CreditCardHolder_UnknownType, PremiumCardHolder, UpscaleCardHolder, Income_EstimatedHousehold, InfoBasePositiveMatchIndicator, NumberofSources, SuppressionMailDMA, BusinessOwner, BaseRecordVerificationDate, HomeOwnerorRenter, LengthofResidence, HomePropertyType_Detail, HomeYearBuilt_Actual, DwellingType, HomeMarketValue, ApartmentNumber, MailOrder_Buyer, MailOrder_Responder, MailOrder_Donor, Apparel_FemaleApparel_MOBs, Apparel_Jewelry_MOBs, Apparel_MaleApparel_MOBs, Apparel_PlusSizeWomensClothing_MOBs, Apparel_TeenFashion_MOBs, Apparel_UnknownType, ArtandAntique_MOBs, ArtsandCrafts_MOBs, AutoSupplies_MOBs, Beauty_MOBs, Book_MOBs, ChildrensMerchandise_MOBs, Collectible_MOBs, ComputerSoftware_MOBs, Electronic_MOBs, Equestrian_MOBs, Food_MOBs, GeneralGiftsandMerchandise_MOBs, Gift_MOBs, Health_MOBs, HomeFurnishingandDecorating_MOBs, Merchandise_HighTicketMerchandise_MOBs, Merchandise_LowTicketMerchandise_MOBs, Music_MOBs, OutdoorGardening_MOBs, OutdoorHuntingandFishing_MOBs, PetSupplies_MOBs, Sports_GolfMOBs, Sports_MOBs, Travel_MOBs, VideoDVD_MOBs, StandardRetail_MembershipWarehouse, StandardRetail_CatalogShowroomRetailBuyers, StandardRetail_MainStreetRetail, StandardRetail_HighVolumeLowEndDepartmentStoreBuyers, StandardRetail_StandardRetail, StandardSpecialty_SportingGoods, StandardSpecialty_SpecialtyApparel, StandardSpecialty_Specialty, StandardSpecialty_ComputerElectronicsBuyers, StandardSpecialty_FurnitureBuyers, StandardSpecialty_HomeOfficeSupplyPurchases, StandardSpecialty_HomeImprovement, UpscaleRetail_HighEndRetailBuyersUpscaleRetail, UpscaleSpecialty_TravelPersonalServices, Bank_FinancialServicesBanking, FinanceCompany_FinancialServicesInstallCredit, OilCompany_OilCompany, Miscellaneous_FinancialServicesInsurance, Miscellaneous_TVMailOrderPurchases, Miscellaneous_Grocery, Miscellaneous_Miscellaneous, RetailActivity_DateofLast, OnlinePurchasingIndicator, Purchase_0to3Months, Purchase_4to6Months, Purchase_7to9Months, Purchase_10to12Months, Purchase_13to18Months, Purchase_19to24Months, Purchase_24PlusMonths, RetailPurchases_MostFrequentCategory, Vehicle_NewUsedIndicator_1stVehicle, Vehicle_NewUsedIndicator_2ndVehicle, Vehicle_DominantLifestyleIndicator, TruckOwner, MotorcycleOwner, RVOwner, Vehicle_KnownOwnedNumber, Vehicle_NewCarBuyer, Age00to02_Male, Age00to02_Female, Age00to02_UnknownGender, Age03to05_Male, Age03to05_Female, Age03to05_UnknownGender, Age06to10_Male, Age06to10_Female, Age06to10_UnknownGender, Age11to15_Male, Age11to15_Female, Age11to15_UnknownGender, Age16to17_Male, Age16to17_Female, Age16to17_UnknownGender, DiscretionaryIncomeIndex, Investing_Active, SpectatorSports_AutoMotorcycleRacing, SpectatorSports_Football, SpectatorSports_Baseball, SpectatorSports_Basketball, SpectatorSports_Hockey, SpectatorSports_Soccer, SpectatorSports_Tennis, Collectibles_SportsMemorabilia, NASCAR, SportsAndLeisure_SC, NetWorth, HomeAssessedValue_Ranges, HomeSquareFootage_Actual, HouseholdAbilitecID, PersonicxDigitalCluster, PersonicxDigitalClusterCode, NetWorthGold, RaceCode, PersonID, Address1, Address2, City, State, PostalCode, Country, HomePhone, MobilePhone, AbilitecIDAppendDate, TurnkeyStandardBundleDate
from ods.Turnkey_Acxiom (nolock)
;
GO
