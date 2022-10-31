-- 
-- Name        : Procedure-JobKiller.sql
--
-- Description : SLM DUJ Job Killer for Development Environments
--
-- Author      : Laim McKenzie
--
-- Copyright   : (c) 2022, laim.scot
-- 
-- Version History
-- 1.0  20191203    LMc     Initial Release
-- 1.1	20221031	LMc		Public Release
--

GO
USE [SnowLicenseManager]
DROP PROCEDURE IF EXISTS [dbo].[_TEST_JobKiller]; 

GO

CREATE PROCEDURE [dbo].[_TEST_JobKiller]
(
	@Dank BIT = 0 -- not used anymore
)
WITH ENCRYPTION 
AS
BEGIN

DECLARE @q NVARCHAR(MAX);

SET @q = N'

EXEC msdb.[dbo].[sp_stop_job]
N''License Manager Data Update''

UPDATE [SnowLicenseManager].[dbo].[tblJobStatus]
SET [LastJobStatus] = ''Job finished successfully''
 
UPDATE [SnowLicenseManager].[dbo].[tblJobLog]
SET Message = ''Job finished successfully''
WHERE [JobType] = ''JOB_RUN''

UPDATE [SnowLicenseManager].[inv].[tblJobParallelStep] SET [Status] = 0 WHERE [Status] = -1

UPDATE [SnowLicenseManager].[dbo].[tblSystemInfo]
SET [LastJobStatus] = ''Job finished successfully''

UPDATE [SnowLicenseManager].[inv].[tblJobParallelStep] SET [Status] = 0 WHERE [Status] = -1
UPDATE [SnowLicenseManager].[dbo].[tblSystemInfo]
SET [LastJobStatus] = ''Job finished successfully''
'

EXECUTE sp_executesql @q

END
GO

exec [[dbo]].[_TEST_JobKiller]