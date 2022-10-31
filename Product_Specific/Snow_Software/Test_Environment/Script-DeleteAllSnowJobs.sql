-- 
-- Name        : Script-DeleteAllSnowJobs.sql
--
-- Description : Deletes all Snow Jobs from SQL Server, run exec [dbo].[JobAdd] to add them back
--
-- Author      : Laim McKenzie
--
-- Copyright   : (c) 2022, laim.scot
-- 
-- Version History
-- 1.0  20221031    LMc     Initial Release
--

DECLARE @JobCategory INT;
DECLARE @JobID BINARY(16);
DECLARE @TestEnabled INT;

SET @TestEnabled = 1; -- Set this to 0 to DELETE, !! ENSURE BACKUP IS AVAILABLE
SET @JobCategory = NULL; -- Set this to your job Category from SELECT * FROM msdb.dbo.syscategories


/* !! DO NOT CHANGE ANYTHING BELOW THIS LINE !! */
IF @TestEnabled = 1
	SELECT * FROM msdb.dbo.sysjobs WHERE category_id = @JobCategory
ELSE
	WHILE(1=1)
		BEGIN
			SET @JobID = NULL;
			SELECT TOP 1 @JobID = job_id FROM msdb.dbo.sysjobs WHERE category_id = @JobCategory;

			IF @@ROWCOUNT = 0
				BREAK;

			IF(@JobID IS NOT NULL)
				BEGIN
					-- First check if the job is running and stop if it is
					IF EXISTS (
						SELECT * FROM msdb.dbo.sysjobactivity
						WHERE 
							run_requested_date IS NOT NULL
						AND job_id = @JobID)
					EXEC msdb.dbo.sp_stop_job @job_id = @JobID;

					-- Then delete the job
					EXEC msdb.dbo.sp_delete_job @job_id = @JobID;
				END
		END