USE bd_supermercado;
GO
-- *************************************************************************************************************************
-- * CREANDO SCHEMAS DE BASE DE DATOS
-- *************************************************************************************************************************

CREATE SCHEMA sec;
GO

CREATE SCHEMA adm;
GO

CREATE SCHEMA ven;
GO

-- *************************************************************************************************************************
-- * CREANDO LOGINS PARA LOS USUARIOS
-- *************************************************************************************************************************
USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'LoginAdmin')
BEGIN
    CREATE LOGIN LoginAdmin WITH PASSWORD = 'admin$123456';
END;

-- Crear login para auditoria (Reemplaza 'ContraseñaAuditoria' con una contraseña segura)
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'LoginAuditor')
BEGIN
    CREATE LOGIN LoginAuditor WITH PASSWORD = 'auditor$123456';
END;

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'LoginSeguridad')
BEGIN
	CREATE LOGIN LoginSeguridad WITH PASSWORD = 'seguridad$123456'
END;

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'LoginSistema')
BEGIN
	CREATE LOGIN LoginSistema WITH PASSWORD = 'sistema$123456'
END;


USE bd_supermercado;

-- *************************************************************************************************************************
-- * CREANDO ROLES Y ASIGNANDO PRIVILEGIOS
-- *************************************************************************************************************************

CREATE ROLE administrador;
GRANT CONTROL ON DATABASE::bd_supermercado TO administrador;

CREATE ROLE auditor;
GRANT SELECT ON SCHEMA::dbo TO auditor;
GRANT SELECT ON SCHEMA::adm TO auditor;
GRANT SELECT ON SCHEMA::ven TO auditor;

CREATE ROLE seguridad;
GRANT CONTROL ON SCHEMA::sec TO seguridad;
GRANT SELECT ON SCHEMA::adm TO seguridad;

CREATE ROLE sistema;
GRANT CONTROL ON SCHEMA::sec TO sistema;
GRANT CONTROL ON SCHEMA::adm TO seguridad;

-- *************************************************************************************************************************
-- * CREANDO USUARIOS Y ASIGNANDO ROLES
-- *************************************************************************************************************************

CREATE USER User_Admin FOR LOGIN LoginAdmin;
ALTER ROLE administrador ADD MEMBER User_Admin;

CREATE USER User_Auditor FOR LOGIN LoginAuditor;
ALTER ROLE auditor ADD MEMBER User_Auditor;

CREATE USER User_Seguridad FOR LOGIN LoginSeguridad;
ALTER ROLE seguridad ADD MEMBER User_Seguridad;

CREATE USER User_Sistema FOR LOGIN LoginSistema;
ALTER ROLE sistema ADD MEMBER User_Sistema;
