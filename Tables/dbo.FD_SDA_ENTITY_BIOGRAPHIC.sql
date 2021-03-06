CREATE TABLE [dbo].[FD_SDA_ENTITY_BIOGRAPHIC]
(
[ID_NUMBER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_MAIL_NAME] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RECORD_STATUS_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PERSON_OR_ORG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_ADDR_LABEL] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SALUTATION] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_PREF_MAIL_NAME] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JNT_MAILINGS_IND] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_JNT_MAIL_NAME1] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_JNT_MAIL_NAME2] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JNT_SALUTATION] [varchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_PHONE] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_EMAIL] [varchar] (320) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FERPA_CODE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_NO_CONTACT_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_NO_SOLICIT_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_ADDR_NO_MAIL_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_PHONE_NO_CONTACT_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_PHONE_NO_SOLICIT_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_NO_CONTACT_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_NO_SOLICIT_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_EMAIL_NO_CONTACT_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_EMAIL_NO_SOLICIT_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AGE] [int] NULL,
[BIRTH_DATE] [date] NULL,
[BIRTH_DAY] [int] NULL,
[BIRTH_MONTH] [int] NULL,
[BIRTH_YEAR] [int] NULL,
[CITIZENSHIP_CODE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CITIZENSHIP_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETHNIC_CODE] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETHNIC_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETHNIC_SRC_CODE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETHNIC_SRC_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_ADDR_LABEL] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_CITY] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_COUNTRY_CODE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_COUNTRY_DESC] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_COUNTY_CODE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_COUNTY_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_FOREIGN_CITY_ZIP] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_LONG_ZIP] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_NAME] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_SHORT_ZIP] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_STATE_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_STREET1] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_STREET2] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_STREET3] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BUSINESS_XSEQUENCE] [int] NULL,
[CHILDREN_NBR] [int] NULL,
[EMPLOYER_ID_NUMBER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMPLOYER_MATCHING_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMPLOYER_NAME] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ENTITY_STAFF_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRST_NAME] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GENDER_CODE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JNT_ADDRESS_IND] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JNT_GIFTS_IND] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JOB_SPECIALTY] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JOB_TITLE] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_NAME] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MARITAL_STATUS_CODE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MIDDLE_NAME] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PHONE_UNLISTED_IND] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_ADDR_TYPE_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_ADDR_TYPE_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_CARE_OF] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_CITY] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_CLASS_YEAR] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_COUNTRY_CODE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_COUNTRY_DESC] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_COUNTY_CODE] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_COUNTY_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_FOREIGN_CITYZIP] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_LONG_ZIP] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_MAIL_RETURNED_NBR] [int] NULL,
[PREF_NAME_SORT] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_SCHOOL_CODE] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_SHORT_ZIP] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_STATE_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_STREET1] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_STREET2] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_STREET3] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_XSEQUENCE] [int] NULL,
[PREFIX] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PROF_SUFFIX] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RECORD_STATUS_CODE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RECORD_TYPE_CODE] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RECORD_TYPE_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_AGE] [int] NULL,
[SPOUSE_BIRTH_DATE] [date] NULL,
[SPOUSE_BIRTH_DAY] [int] NULL,
[SPOUSE_BIRTH_MONTH] [int] NULL,
[SPOUSE_BIRTH_YEAR] [int] NULL,
[SPOUSE_EMPLOYER_ID_NUMBER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_EMPLOYER_NAME] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_FIRST_NAME] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_JOB_TITLE] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_LAST_NAME] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_MIDDLE_NAME] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_PREFIX] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_PROF_SUFFIX] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_STAFF_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_STATUS] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPOUSE_SUFFIX] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUFFIX] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRIMARY_EMAIL] [varchar] (320) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRIMARY_EMAIL_NO_CONTACT_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRIMARY_EMAIL_NO_SOLICIT_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MEMBER_SUMMARY] [varchar] (119) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
