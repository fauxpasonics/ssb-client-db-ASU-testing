CREATE TABLE [src].[FD_SDC_GIFT_CLUBS]
(
[GIFT_CLUB_ID_NUMBER] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QUALIFIED_AMOUNT] [float] NULL,
[GIFT_CLUB_FAMILY_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_FAMILY_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_YEAR] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_START_DATE] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_END_DATE] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_STATUS] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_AUTHORIZED_CODE] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_AUTHORIZED_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_REASON] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_COMMENT] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCHOOL_CODE] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SCHOOL_DESC] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_JOINT_IND] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_PARTNER_ID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIFT_CLUB_SEQUENCE] [int] NULL,
[GIFT_CLUB_GENERATED_ASGND] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DATE_ADDED] [date] NULL,
[DATE_MODIFIED] [date] NULL,
[OPERATOR_NAME] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[USER_GROUP] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[USER_GROUP_DESC] [varchar] (45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
