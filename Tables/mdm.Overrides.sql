CREATE TABLE [mdm].[Overrides]
(
[OverrideID] [int] NOT NULL IDENTITY(1, 1),
[DimCustomerID] [int] NOT NULL,
[SSID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ElementID] [int] NULL,
[Field] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceValue] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatusID] [int] NULL CONSTRAINT [DF_Overrides_StatusID] DEFAULT ((1)),
[CreatedDate] [datetime] NULL CONSTRAINT [DF_Overrides_CreatedDate] DEFAULT (getdate()),
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Overrides_CreatedBy] DEFAULT (suser_sname()),
[UpdatedDate] [datetime] NULL CONSTRAINT [DF_Overrides_UpdatedDate] DEFAULT (getdate()),
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActivatedDate] [datetime] NULL CONSTRAINT [DF_Overrides_ActivatedDate] DEFAULT (getdate()),
[DeactivatedDate] [datetime] NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** Object:  Trigger [mdm].[trg_Overrides_Update_Insert]    Script Date: 4/2/2018 11:56:01 AM ******/

CREATE TRIGGER [mdm].[trg_Overrides_Update_Insert]   
ON [mdm].[Overrides]   
AFTER UPDATE, INSERT   
AS    
BEGIN   
	SET NOCOUNT ON    
   
	DECLARE 
		@sql NVARCHAR(MAX) = ''
		,@MDM_DB VARCHAR(50) = CASE WHEN @@VERSION LIKE '%Azure%' THEN '' ELSE 'MDM' END
		,@action CHAR(1)
		,@currentDatetime DATETIME = CURRENT_TIMESTAMP   
		,@tmpOverridesTblName NVARCHAR(250) = '##overrides_' + REPLACE(CAST(NEWID() AS VARCHAR(50)),'-','')

	/********** TESTING **********/
	----SET @MDM_DB = 'SSB_MDM'

	IF @@SERVERNAME = 'SSBDWDEV01'
		SET @MDM_DB = 'SSB_MDM_TEST'

	IF CONTEXT_INFO() = 0x55555 -- Prevents trigger from firing
		RETURN

	IF OBJECT_ID('tempdb..#overrides_source') IS NOT NULL
		DROP TABLE #overrides_source

	CREATE TABLE #overrides_source (OverrideID INT, DimCustomerID INT, SourceSystem NVARCHAR(50), SSID NVARCHAR(100), StatusID INT, ElementID INT, Field VARCHAR(50), dimcust_value NVARCHAR(500), composite_value NVARCHAR(500), source_value NVARCHAR(500))

    --   
    -- Check if this is an INSERT, UPDATE or DELETE Action.   
    --    
    SET @action = 'I'; -- Set Action to Insert by default.   
    IF EXISTS(SELECT * FROM Deleted)   
    BEGIN   
        SET @action =    
            CASE   
                WHEN EXISTS(SELECT * FROM Inserted) THEN 'U' -- Set Action to Updated.   
                ELSE 'D' -- Set Action to Deleted.          
            END   
    END   
    ELSE IF NOT EXISTS(SELECT * FROM Inserted)    
		RETURN; -- Nothing updated or inserted.   

	
	BEGIN TRAN
		IF OBJECT_ID('tempdb..#overrides') IS NOT NULL
			DROP TABLE #overrides

		SELECT *
		INTO #overrides
		FROM Inserted

		SET @sql = ''
			+ '	SELECT a.OverrideID, a.DimCustomerID, a.SourceSystem, a.SSID, a.StatusID, a.ElementID, a.Field' + CHAR(13)
			+ '	INTO ' + @tmpOverridesTblName + CHAR(13)
			+ '	FROM #overrides a' + CHAR(13) + CHAR(13)

			+ '	INSERT INTO #overrides_source' + CHAR(13)
			+ '	EXEC ' + @MDM_DB + '.mdm.GetOverrideSourceValues @ClientDB = ''' + DB_NAME() + ''',' + CHAR(13)
			+ '	                                         @tmpOverridesTblName = ''' + @tmpOverridesTblName + '''' + CHAR(13)
	
		EXEC sp_executesql @sql

		----SELECT * FROM #overrides_source

		IF OBJECT_ID('tempdb..#overrides') IS NOT NULL
			DROP TABLE #overrides

		IF (@action = 'I') OR (@action = 'U' AND (UPDATE(ElementID) OR UPDATE(Field) OR UPDATE(Value) OR UPDATE(StatusID)))  
		BEGIN 
			UPDATE b
			SET b.SourceValue = CASE WHEN a.StatusID = 1 THEN c.source_value ELSE b.SourceValue END
				,b.UpdatedDate = @currentDatetime
				,b.UpdatedBy = SYSTEM_USER
				,b.ActivatedDate = CASE WHEN a.StatusID = 1 AND ISNULL(d.StatusID,1) = 0 THEN @currentDatetime ELSE b.ActivatedDate END
			--SELECT *
			FROM Inserted a
			INNER JOIN mdm.Overrides b ON a.OverrideID = b.OverrideID
			INNER JOIN #overrides_source c ON b.OverrideID = c.OverrideID
			LEFT JOIN Deleted d ON a.OverrideID = d.OverrideID
		END
	COMMIT
END

ALTER TABLE [mdm].[Overrides] ENABLE TRIGGER [trg_Overrides_Update_Insert]
GO
ALTER TABLE [mdm].[Overrides] ADD CONSTRAINT [PK_Overrides_OverrideID] PRIMARY KEY CLUSTERED  ([OverrideID])
GO
ALTER TABLE [mdm].[Overrides] ADD CONSTRAINT [UC_Overrides] UNIQUE NONCLUSTERED  ([DimCustomerID], [ElementID], [Field])
GO
CREATE NONCLUSTERED INDEX [IX_Overrides_ElementID] ON [mdm].[Overrides] ([ElementID])
GO
ALTER TABLE [mdm].[Overrides] ADD CONSTRAINT [FK_Overrides_DimCustomerID] FOREIGN KEY ([DimCustomerID]) REFERENCES [dbo].[DimCustomer] ([DimCustomerId])
GO
GRANT DELETE ON  [mdm].[Overrides] TO [db_SSB_IE_Permitted]
GO
GRANT INSERT ON  [mdm].[Overrides] TO [db_SSB_IE_Permitted]
GO
GRANT UPDATE ON  [mdm].[Overrides] TO [db_SSB_IE_Permitted]
GO
