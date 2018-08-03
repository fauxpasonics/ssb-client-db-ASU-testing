SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 
 
CREATE PROCEDURE [api].[UploadDimCustomerPrivacyStaging_Process] 
    @DataTable dbo.UploadDimCustomerPrivacyStaging_Type READONLY 
AS 
BEGIN 
 
	DECLARE @finalXml  XML 
 
	BEGIN TRY 
 
		DECLARE @recordCount INT 
		SELECT @recordCount = COUNT(*) 
			FROM @DataTable 
			 
		INSERT INTO [api].[UploadDimCustomerPrivacyStaging] 
		([SessionId], RecordCreatedDate, Processed, [DimCustomerId], [SourceSystem],  [SSID], Verified_Consent_TS, Verified_Consent_Source, 
	Data_Deletion_Request_TS , Data_Deletion_Request_Reason, Data_Deletion_Request_Source,  
	Subject_Access_Request_TS, Subject_Access_Request_Source, Direct_Marketing_OptOut_TS, Direct_Marketing_Optout_Reason, Direct_Marketing_OptOut_Source ) 
			 		SELECT [SessionId], GETDATE(), 0, [DimCustomerId],  [SourceSystem],  [SSID], Verified_Consent_TS, Verified_Consent_Source, 
	 Data_Deletion_Request_TS ,Data_Deletion_Request_Reason, Data_Deletion_Request_Source, 
	Subject_Access_Request_TS, Subject_Access_Request_Source, Direct_Marketing_OptOut_TS, Direct_Marketing_Optout_Reason, Direct_Marketing_OptOut_Source 
	 
		FROM @DataTable 
		 
		SET @finalXml = '<Root><ResponseInfo><Success>true</Success><RecordsInserted>' + CAST(@recordCount AS NVARCHAR(10)) + '</RecordsInserted></ResponseInfo></Root>' 
 
	END TRY 
 
 
	BEGIN CATCH 
	 
		-- TODO: Better error messaging here 
		SET @finalXml = '<Root><ResponseInfo><Success>false</Success><ErrorMessage>There was an error attempting to upload this data.</ErrorMessage></ResponseInfo></Root>' 
 
	END CATCH 
 
 
	-- Return response 
	SELECT CAST(@finalXml AS XML) 
 
END 
 
 
 
 
GO
