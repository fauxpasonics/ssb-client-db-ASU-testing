SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[ods_Load_TI_PD_PATRON] 

AS
BEGIN 

	DECLARE @RunTime datetime = getdate()

	MERGE INTO ods.TI_PD_PATRON AS myTarget
	USING [etl].[vw_src_TI_PD_PATRON] AS mySource
	ON myTarget.PATRON = mySource.PATRON
	WHEN MATCHED 
	AND 
	(
		ISNULL(mySource.ETL_DeltaHashKey,-1) <> isnull(myTarget.ETL_DeltaHashKey, -1) )
	THEN 
	UPDATE SET
		myTarget.ETL_DeltaHashKey = mySource.ETL_DeltaHashKey
		, myTarget.ETL_UpdatedDate = @RunTime
		, myTarget.ETL_DeletedDate = null
		, myTarget.ETL_IsDeleted = 0

		, myTarget.EXPORT_DATETIME = mySource.EXPORT_DATETIME
		, myTarget.TAG = mySource.TAG
		, myTarget.LAST_USER = mySource.LAST_USER
		, myTarget.LAST_DATETIME = mySource.LAST_DATETIME
		, myTarget.ZID = mySource.ZID
		, myTarget.SOURCE_ID = mySource.SOURCE_ID
		, myTarget.PATRON = mySource.PATRON
		, myTarget.NAME = mySource.NAME
		, myTarget.SUFFIX = mySource.SUFFIX
		, myTarget.TITLE = mySource.TITLE
		, myTarget.NAME2 = mySource.NAME2
		, myTarget.SUFFIX2 = mySource.SUFFIX2
		, myTarget.TITLE2 = mySource.TITLE2
		, myTarget.STATUS = mySource.STATUS
		, myTarget.MAIL_NAME = mySource.MAIL_NAME
		, myTarget.VIP = mySource.VIP
		, myTarget.EXTERNAL_NUMBER = mySource.EXTERNAL_NUMBER
		, myTarget.COMMENTS = mySource.COMMENTS
		, myTarget.RELEASE = mySource.RELEASE
		, myTarget.SOURCE = mySource.SOURCE
		, myTarget.MARITAL_STATUS = mySource.MARITAL_STATUS
		, myTarget.INTERNET_PROFILE = mySource.INTERNET_PROFILE
		, myTarget.MAGSTRIPE_ID = mySource.MAGSTRIPE_ID
		, myTarget.ENTRY_USER = mySource.ENTRY_USER
		, myTarget.ENTRY_DATETIME = mySource.ENTRY_DATETIME
		, myTarget.HOUSEHOLD_INCOME = mySource.HOUSEHOLD_INCOME
		, myTarget.NICKNAME1 = mySource.NICKNAME1
		, myTarget.NICKNAME2 = mySource.NICKNAME2
		, myTarget.MAIDEN1 = mySource.MAIDEN1
		, myTarget.MAIDEN2 = mySource.MAIDEN2
		, myTarget.GENDER1 = mySource.GENDER1
		, myTarget.GENDER2 = mySource.GENDER2
		, myTarget.ETHNIC1 = mySource.ETHNIC1
		, myTarget.ETHNIC2 = mySource.ETHNIC2
		, myTarget.RELIGION1 = mySource.RELIGION1
		, myTarget.RELIGION2 = mySource.RELIGION2
		, myTarget.BIRTH_DATE1 = mySource.BIRTH_DATE1
		, myTarget.BIRTH_DATE2 = mySource.BIRTH_DATE2
		, myTarget.BIRTH_PLACE1 = mySource.BIRTH_PLACE1
		, myTarget.BIRTH_PLACE2 = mySource.BIRTH_PLACE2
		, myTarget.EV_EMAIL = mySource.EV_EMAIL
		, myTarget.LANGUAGE1 = mySource.LANGUAGE1
		, myTarget.LANGUAGE2 = mySource.LANGUAGE2
		, myTarget.KEYWORDS = mySource.KEYWORDS
		, myTarget.UD1 = mySource.UD1
		, myTarget.UD2 = mySource.UD2
		, myTarget.UD3 = mySource.UD3
		, myTarget.UD4 = mySource.UD4
		, myTarget.UD5 = mySource.UD5
		, myTarget.UD6 = mySource.UD6
		, myTarget.UD7 = mySource.UD7
		, myTarget.UD8 = mySource.UD8
		, myTarget.UD9 = mySource.UD9
		, myTarget.UD10 = mySource.UD10
		, myTarget.UD11 = mySource.UD11
		, myTarget.UD12 = mySource.UD12
		, myTarget.UD13 = mySource.UD13
		, myTarget.UD14 = mySource.UD14
		, myTarget.UD15 = mySource.UD15
		, myTarget.UD16 = mySource.UD16

	WHEN NOT MATCHED BY Target THEN
		INSERT 
		( 		
			ETL_CreatedDate
			, ETL_UpdatedDate
			, ETL_IsDeleted
			, ETL_DeletedDate
			, ETL_DeltaHashKey
		
			, EXPORT_DATETIME
			, TAG
			, LAST_USER
			, LAST_DATETIME
			, ZID
			, SOURCE_ID
			, PATRON
			, NAME
			, SUFFIX
			, TITLE
			, NAME2
			, SUFFIX2
			, TITLE2
			, STATUS
			, MAIL_NAME
			, VIP
			, EXTERNAL_NUMBER
			, COMMENTS
			, RELEASE
			, SOURCE
			, MARITAL_STATUS
			, INTERNET_PROFILE
			, MAGSTRIPE_ID
			, ENTRY_USER
			, ENTRY_DATETIME
			, HOUSEHOLD_INCOME
			, NICKNAME1
			, NICKNAME2
			, MAIDEN1
			, MAIDEN2
			, GENDER1
			, GENDER2
			, ETHNIC1
			, ETHNIC2
			, RELIGION1
			, RELIGION2
			, BIRTH_DATE1
			, BIRTH_DATE2
			, BIRTH_PLACE1
			, BIRTH_PLACE2
			, EV_EMAIL
			, LANGUAGE1
			, LANGUAGE2
			, KEYWORDS
			, UD1
			, UD2
			, UD3
			, UD4
			, UD5
			, UD6
			, UD7
			, UD8
			, UD9
			, UD10
			, UD11
			, UD12
			, UD13
			, UD14
			, UD15
			, UD16
		)
		VALUES
		(
			@RunTime --ETL_CreatedDate
			, @RunTime --ETL_UpdatedDate
			, 0 --ETL_IsDeleted
			, null --ETL_DeleteDate
			, mySource.ETL_DeltaHashKey	
			
			, mySource.EXPORT_DATETIME
			, mySource.TAG
			, mySource.LAST_USER
			, mySource.LAST_DATETIME
			, mySource.ZID
			, mySource.SOURCE_ID
			, mySource.PATRON
			, mySource.NAME
			, mySource.SUFFIX
			, mySource.TITLE
			, mySource.NAME2
			, mySource.SUFFIX2
			, mySource.TITLE2
			, mySource.STATUS
			, mySource.MAIL_NAME
			, mySource.VIP
			, mySource.EXTERNAL_NUMBER
			, mySource.COMMENTS
			, mySource.RELEASE
			, mySource.SOURCE
			, mySource.MARITAL_STATUS
			, mySource.INTERNET_PROFILE
			, mySource.MAGSTRIPE_ID
			, mySource.ENTRY_USER
			, mySource.ENTRY_DATETIME
			, mySource.HOUSEHOLD_INCOME
			, mySource.NICKNAME1
			, mySource.NICKNAME2
			, mySource.MAIDEN1
			, mySource.MAIDEN2
			, mySource.GENDER1
			, mySource.GENDER2
			, mySource.ETHNIC1
			, mySource.ETHNIC2
			, mySource.RELIGION1
			, mySource.RELIGION2
			, mySource.BIRTH_DATE1
			, mySource.BIRTH_DATE2
			, mySource.BIRTH_PLACE1
			, mySource.BIRTH_PLACE2
			, mySource.EV_EMAIL
			, mySource.LANGUAGE1
			, mySource.LANGUAGE2
			, mySource.KEYWORDS
			, mySource.UD1
			, mySource.UD2
			, mySource.UD3
			, mySource.UD4
			, mySource.UD5
			, mySource.UD6
			, mySource.UD7
			, mySource.UD8
			, mySource.UD9
			, mySource.UD10
			, mySource.UD11
			, mySource.UD12
			, mySource.UD13
			, mySource.UD14
			, mySource.UD15
			, mySource.UD16
		)
	;

END 
GO
