SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[TM_GetRealtimeAttendanceEvents]  
 
AS 
BEGIN 
 
 
	DECLARE @RunTime datetime = getdate() 
	DECLARE @UTCOffset int = ( select TOP 1 UTCOffset FROM dbo.DimDate where CalDate = cast(GETUTCDATE() as date) ) 
 
		SELECT  
			de.EventCode 
			, etl.fnGetClientSetting('TM API - DSN') TmApiDsn 
			, etl.fnGetClientSetting('TM API - Realtime Attendance Procedure') LoadProcedure 
			, @UTCOffset UTCOffset 
		FROM etl.vw_DimEvent de 
		WHERE de.Config_IsRealTimeAttendanceEnabled = 1 
		and dateadd(hour, @UTCOffset, @RunTime) between ISNULL(de.Config_EventOpenDateTime, de.EventOpenDateTime) AND ISNULL(de.Config_EventCloseDateTime, de.EventCloseDateTime)
 
 
 
END  
 

GO
