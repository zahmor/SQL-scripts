
-- Tzach Mordechai 
-- Zah.mor@gmail.com
-- V1.1, 30/10/2023
-- Added example to create sql user using existing Azure active directory user


--Do you still create and give permissions to your database by user? If yes, then you might be missing out on a powerful and simple solution that can transform your data security and access management: RBAC. In this post, I will explain what RBAC is, why it is better than granting permissions individually, and how to implement it in SQL Server.

--RBAC stands for Role-Based Access Control, which is a method of managing access to resources based on the roles of individual users within an organization. RBAC has many advantages over granting permissions to each user individually, such as:

--Improved data security: RBAC minimizes the risk of unauthorized data access by ensuring that only those with the appropriate roles can access specific data.
--Streamlined operations: RBAC reduces administrative overhead and ensures consistency by assigning roles instead of individual permissions.
--Enhanced compliance and auditability: RBAC showcases adherence to data protection standards and makes audits a hassle-free process.
--Increased productivity and satisfaction: RBAC empowers users to perform their tasks efficiently and effectively without unnecessary restrictions or delays.


-- This script demonstrates how to create role-based access control (RBAC) in SQL Server 
-- It creates two roles: Developers and Support 
-- It grants different permissions to each role on the schema or table level 
-- It adds two users: David and Adam 
-- It assigns each user to one of the roles

-- Create a role named Developers 
CREATE ROLE Developers;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO Developers;
 
-- On master database
CREATE LOGIN David WITH PASSWORD = 'IsraelTogether!'; -- SQL Server authentication
-- Create user on master + dev database 
CREATE USER David FOR LOGIN David;

-- Add David to the Developers role
ALTER ROLE developers ADD MEMBER David;

CREATE ROLE Support;
GRANT SELECT, INSERT, UPDATE, DELETE ON ErrorLog TO Support;

-- On master database
CREATE LOGIN Adam WITH PASSWORD = 'IsraelTogether!'; -- SQL Server authentication
-- Create user on master + dev database 
CREATE USER Adam FOR LOGIN Adam;

ALTER ROLE Support ADD MEMBER Adam ;


-- To verify that the roles and their members have been created successfully, you can execute the following command:
SELECT r.name AS RoleName, m.name AS MemberName
FROM sys.database_role_members AS rm
JOIN sys.database_principals AS r ON rm.role_principal_id = r.principal_id
JOIN sys.database_principals AS m ON rm.member_principal_id = m.principal_id
WHERE r.name = 'Developers';



-- Using active directory users on the cloud is another option that can offer more benefits than using SQL Server users. Active directory users on the cloud use Azure Active Directory (AAD), which is a cloud-based identity and access management service that integrates with SQL Server. AAD users are safer because they use multi-factor authentication instead of passwords. They also simplify user management because you can use existing AAD groups as roles in SQL Server. In addition, AAD users enable you to access SQL Server from any device and location without VPN. In the next post, I will show you how to use AAD users and groups for RBAC in SQL Server. Stay tuned! 😊

-- A short example to add user that exist on Azure cloud Active directory

USE master: 

 
CREATE LOGIN  [David.BenYishai@tzach.com]  FROM EXTERNAL PROVIDER

CREATE USER [David.BenYishai@tzach.com] FOR LOGIN [yaron.brand@atriis.com]


-- Grant read and write access to a user in SQL Server
USE [dev]
GO

CREATE USER [David.BenYishai@tzach.com] FOR LOGIN [David.BenYishai@tzach.com]
GO

ALTER ROLE [db_datareader] ADD MEMBER [David.BenYishai@tzach.com]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [David.BenYishai@tzach.com]
GO
 
 
 

 