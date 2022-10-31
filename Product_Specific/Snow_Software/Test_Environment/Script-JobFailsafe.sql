-- 
-- Name        : Script-JobFailsafe.sql
--
-- Description : Fail safe for stopping a Data Update Job automatically.  Should only be used in development environments.  Wrap the script into a custom SQL Agent Job.
--
-- Author      : Laim McKenzie
--
-- Copyright   : (c) 2022, laim.scot
-- 
-- Version History
-- 1.0	20221031	LMc		Initial Release
--


/* Name of the SQL Job that you want to stop */
DECLARE @SLM_JOB SYSNAME = N'License Manager Data Update';
DECLARE @JOB_MSG VARCHAR(130) = 'Job finished successfully';
DECLARE @TABLES VARCHAR(100) = 'tblJobLog, tblSystemInfo, tblJobStatus';

/* Check if the job is running */
IF EXISTS (
	SELECT 
		sysj.Name AS JobName--,
		--RP.program_name
	FROM msdb..sysjobs sysj WITH (NOLOCK)
	INNER JOIN master..sysprocesses RP WITH (NOLOCK) ON RP.program_name LIKE
		'SQLAgent - TSQL JobStep (Job ' + master.dbo.fn_varbintohexstr(convert(binary(16),sysj.job_id )) + '%'
	WHERE sysj.Name = @SLM_JOB
	)

    BEGIN
        PRINT @SLM_JOB + ' is running.';
        PRINT 'Stopping ' + @SLM_JOB + '.';
        EXEC msdb.dbo.sp_stop_job @SLM_JOB;
        PRINT 'Running update scripts for ' + @TABLES + '.';
        SET NOCOUNT ON
        UPDATE SnowLicenseManager.dbo.tblJobLog SET Message = @JOB_MSG WHERE JobType ='JOB_RUN'
            IF EXISTS ( SELECT Message FROM SnowLicenseManager.dbo.tblJobLog WHERE JobType = 'JOB_RUN' and Message = @JOB_MSG )
            BEGIN PRINT 'tblJobLog is updated' END ELSE	BEGIN RAISERROR('tblJobLog is not updated!',16,1); END

        UPDATE SnowLicenseManager.dbo.tblSystemInfo SET LastJobStatus = @JOB_MSG
            IF EXISTS ( SELECT LastJobStatus FROM SnowLicenseManager.dbo.tblSystemInfo WHERE LastJobStatus = @JOB_MSG )
            BEGIN PRINT 'tblSystemInfo is updated' END ELSE	BEGIN RAISERROR('tblSystemInfo is not updated!',16,1); END

        UPDATE SnowLicenseManager.dbo.tblJobStatus SET LastJobStatus = @JOB_MSG
            IF EXISTS ( SELECT LastJobStatus FROM SnowLicenseManager.dbo.tblJobStatus WHERE LastJobStatus = @JOB_MSG )
            BEGIN PRINT 'tblJobStatus is updated' END ELSE	BEGIN RAISERROR('tblJobStatus is not updated!',16,1); END

        SET NOCOUNT OFF
    END
ELSE
    BEGIN
        PRINT @SLM_JOB + ' is not running.';
    END