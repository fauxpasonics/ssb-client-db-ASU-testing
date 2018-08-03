SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [segmentation].[vw__SDC_Priority_Points]

AS
(
SELECT ssbid.SSB_CRMSYSTEM_CONTACT_ID
, b.ID_NUMBER
, pp.* 
FROM [dbo].[FD_SDA_PRIORITY_POINT_SUMMARY] pp WITH (NOLOCK)
JOIN [dbo].[FD_SDA_ENTITY_OTHER_IDS] b WITH (NOLOCK) ON pp.PACIOLAN_ID = b.OTHER_ID AND b.TYPE_CODE = 'SDP'
JOIN dbo.dimcustomerssbid ssbid WITH (NOLOCK) ON ssbid.SSID = b.ID_NUMBER WHERE ssbid.SourceSystem = 'Advance ASU'
)








GO