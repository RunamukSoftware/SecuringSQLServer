--Cleanup Script.sql
--This drops any certificates, keys, or objects we created
--as part of the demo.
--It is safe to re-run.

USE [master]
GO
IF DB_ID('RLSTest') IS NOT NULL
BEGIN
	ALTER DATABASE RLSTest SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE RLSTest;
END
GO

IF DB_ID('DDMTest') IS NOT NULL
BEGIN
	ALTER DATABASE DDMTest SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DDMTest;
END
GO

IF DB_ID('TDETest') IS NOT NULL
BEGIN
	ALTER DATABASE TDETest SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE TDETest;
END
GO

IF EXISTS
(
	SELECT 1 
	FROM sys.certificates
	WHERE name = N'TransparentDatabaseEncryptionCertificate'
)
BEGIN
	DROP CERTIFICATE [TransparentDatabaseEncryptionCertificate];
END
GO

IF EXISTS
(
	SELECT 1 
	FROM sys.certificates
	WHERE name = N'BackupEncryptionCertificate'
)
BEGIN
	DROP CERTIFICATE [BackupEncryptionCertificate];
END

IF EXISTS
(
	SELECT 1
	FROM sys.symmetric_keys
	WHERE
		name = N'##MS_DatabaseMasterKey##'
)
BEGIN
	DROP MASTER KEY;
END
GO

--Restart the SQL Server service to set tempdb encryption back to 0.
SELECT
	d.name,
	d.is_encrypted
FROM sys.databases d;
GO
