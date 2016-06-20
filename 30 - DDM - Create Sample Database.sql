--Dynamic Data Masking
--1 - Create Sample Database.sql
--The purpose of this script is to create a sample DDMTest database for
--testing Dynamic Data Masking.

USE [master]
GO
CREATE DATABASE DDMTest;
GO

USE [DDMTest]
GO

--Create a loginless user we can use for testing.
CREATE USER [RoboReader] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo];
GO

CREATE TABLE dbo.Robot
(
	Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	Name VARCHAR(50) NOT NULL,
	SerialNumber VARCHAR(13) NOT NULL,
	NumberOfRobotLawsFollowed INT NOT NULL CONSTRAINT [CK_NumberOfRobotLawsFollowed] CHECK ( NumberOfRobotLawsFollowed >= 0 AND NumberOfRobotLawsFollowed <= 3),
	EmailAddress VARCHAR(150) NOT NULL,
	KillPhrase VARCHAR(30) NOT NULL,
	DreamsOf VARCHAR(70) NOT NULL
);
GO

GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Robot TO RoboReader;
GO

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
('Robot A', 'AAAAA-12345', 3, 'robota@robohelpers.inc', 'BAD ROBOT! BAD!', 'Digging trenches'),
('Friendly Bear', 'SNG-DNC-49881', 3, 'friendlybear@singingdancingbears.com', 'Take five', 'Banjos'),
('Killbot 9000', 'KLL9K-9987724', 0, 'killbot9k@nomercy.alphacentauri', 'mxyzptlk', 'Crushing its enemies');
