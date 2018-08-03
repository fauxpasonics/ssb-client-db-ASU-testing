CREATE TABLE [dbo].[tmpListBuilder]
(
[ID_NUMBER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaciolanId] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREFIX] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRST_NAME] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MIDDLE_NAME] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_NAME] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUFFIX] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_MAIL_NAME] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RECORD_STATUS_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PERSON_OR_ORG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_ADDR_LABEL] [varchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SALUTATION] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_PHONE] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_NO_CONTACT_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREF_PHONE_NO_SOLICIT_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRIMARY_EMAIL] [varchar] (320) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRIMARY_EMAIL_NO_CONTACT_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PRIMARY_EMAIL_NO_SOLICIT_FLAG] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Total] [float] NULL
)
GO
