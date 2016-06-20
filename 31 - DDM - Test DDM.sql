--Dynamic Data Masking
--2 - Test DDM.sql
--The purpose of this script is to test dynamic data masking.

USE [DDMTest]
GO

--Without data masking, we can see all kinds of secrets:
SELECT
	r.*
FROM dbo.Robot r;

/* Let's turn on masking.  We'll mask each column separately:
SerialNumber - X's
NumberOfRobotLawsFollowed - Random number
EmailAddress - Email
KillPhrase - Random characters
DreamsOf - First & last characters with padding */

ALTER TABLE dbo.Robot ALTER COLUMN [SerialNumber] ADD MASKED WITH (FUNCTION = 'DEFAULT()');
ALTER TABLE dbo.Robot ALTER COLUMN [NumberOfRobotLawsFollowed] ADD MASKED WITH (FUNCTION = 'RANDOM(0, 3)');
ALTER TABLE dbo.Robot ALTER COLUMN [EmailAddress] ADD MASKED WITH (FUNCTION = 'EMAIL()');
ALTER TABLE dbo.Robot ALTER COLUMN [KillPhrase] ADD MASKED WITH (FUNCTION = 'PARTIAL(0, "DO NOT KILL", 0)');
ALTER TABLE dbo.Robot ALTER COLUMN [DreamsOf] ADD MASKED WITH (FUNCTION = 'PARTIAL(1, "XXXXXXXXXX", 1)');

--Notice that we, as sysadmins, can still see everything!
SELECT
	r.*
FROM dbo.Robot r;

--But as a non-privileged user...
EXECUTE AS USER = 'RoboReader'

--Our user sees masked data.
SELECT
	r.*
FROM dbo.Robot r;

--What happens on insertion?
INSERT INTO dbo.Robot
(
	Name,
	SerialNumber,
	NumberOfRobotLawsFollowed,
	EmailAddress,
	KillPhrase,
	DreamsOf
)
VALUES
('Bender', '2716057', 1, 'bender@ilovebender.com', 'Yeah, right', 'Killing humanity');

--Will Bender be obfuscated?
SELECT
	r.*
FROM dbo.Robot r;

--Can we do a search?
SELECT
	r.*
FROM dbo.Robot r
WHERE
	r.EmailAddress = 'bender@ilovebender.com';

REVERT

--But his data is here.
SELECT
	r.*
FROM dbo.Robot r;
GO
