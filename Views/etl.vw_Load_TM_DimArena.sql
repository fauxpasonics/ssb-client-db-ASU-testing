SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [etl].[vw_Load_TM_DimArena] AS (

SELECT  
      --'TM' ETL__SourceSystem
      a.arena_id AS ETL__SSID 
      , a.arena_id AS ETL__SSID_TM_arena_id
      , a.arena_abv AS ArenaCode
      , a.arena_name AS ArenaName
      , a.arena_name AS ArenaDesc
      , NULL ArenaClass

FROM    ods.TM_Arena a (NOLOCK)

)



GO
