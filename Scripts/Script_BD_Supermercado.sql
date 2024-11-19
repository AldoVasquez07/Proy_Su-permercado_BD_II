USE master;
GO

-- *************************************************************************************************************************
-- * BORRANDO BASE DE DATOS SI EXISTE
-- *************************************************************************************************************************
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'bd_supermercado')
BEGIN
    ALTER DATABASE bd_supermercado SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE bd_supermercado;
END

-- *************************************************************************************************************************
-- * DECLARANDO VARIABLES PARA LAS RUTAS
-- *************************************************************************************************************************
DECLARE @ruta_base NVARCHAR(255);
DECLARE @ruta_mdf NVARCHAR(255);
DECLARE @ruta_ldf NVARCHAR(255);
DECLARE @sql NVARCHAR(MAX);

-- Nota: Cambiar RUTA BASE si se ve necesario
SET @ruta_base = 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\';

-- Rutas para la creación de la BASE DE DATOS
SET @ruta_mdf = @ruta_base + 'bd_supermercado.mdf';
SET @ruta_ldf = @ruta_base + 'bd_supermercado_log.ldf';

-- *************************************************************************************************************************
-- * CREANDO BASE DE DATOS DE MANERA DINÁMICA
-- *************************************************************************************************************************
SET @sql = N'CREATE DATABASE bd_supermercado
ON PRIMARY 
(
    NAME = ''bd_supermercado'',
    FILENAME = ''' + @ruta_mdf + ''',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 5MB
)
LOG ON 
(
    NAME = ''bd_supermercado_log'',
    FILENAME = ''' + @ruta_ldf + ''',
    SIZE = 5MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 5MB
);';

EXEC sp_executesql @sql;


-- *************************************************************************************************************************
-- * VERIFICAR SI LA BASE DE DATOS SE CREÓ Y USARLA
-- *************************************************************************************************************************

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'bd_supermercado')
BEGIN
    USE bd_supermercado;
END
ELSE
BEGIN
    PRINT 'Error: La base de datos bd_supermercado no se creó correctamente.';
    RETURN;
END

-- *************************************************************************************************************************
-- * CREANDO FILEGROUPS DE LA BASE DE DATOS
-- *************************************************************************************************************************
ALTER DATABASE bd_supermercado ADD FILEGROUP FG_2024;
ALTER DATABASE bd_supermercado ADD FILEGROUP FG_2025;
ALTER DATABASE bd_supermercado ADD FILEGROUP FG_2026;
ALTER DATABASE bd_supermercado ADD FILEGROUP FG_2027;

-- *************************************************************************************************************************
-- * AGREGANDO ARCHIVOS A LOS FILEGROUPS
-- *************************************************************************************************************************
SET @sql = N'
ALTER DATABASE bd_supermercado ADD FILE 
(
    NAME = ''bd_supermercado_FG_2024'',
    FILENAME = ''' + @ruta_base + 'bd_supermercado_FG_2024.ndf' + ''',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 5MB
) TO FILEGROUP FG_2024;
 
ALTER DATABASE bd_supermercado ADD FILE 
(
    NAME = ''bd_supermercado_FG_2025'',
    FILENAME = ''' + @ruta_base + 'bd_supermercado_FG_2025.ndf' + ''',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 5MB
) TO FILEGROUP FG_2025;

ALTER DATABASE bd_supermercado ADD FILE 
(
    NAME = ''bd_supermercado_FG_2026'',
    FILENAME = ''' + @ruta_base + 'bd_supermercado_FG_2026.ndf' + ''',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 5MB
) TO FILEGROUP FG_2026;

ALTER DATABASE bd_supermercado ADD FILE 
(
    NAME = ''bd_supermercado_FG_2027'',
    FILENAME = ''' + @ruta_base + 'bd_supermercado_FG_2027.ndf' + ''',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 5MB
) TO FILEGROUP FG_2027;
';

EXEC sp_executesql @sql;

-- *************************************************************************************************************************
-- * CREANDO FUNCIÓN DE PARTICIÓN Y ESQUEMA DE PARTICIÓN
-- *************************************************************************************************************************
CREATE PARTITION FUNCTION partir_por_anio (DATE)
AS RANGE RIGHT FOR VALUES ('2024-12-31', '2025-12-31', '2026-12-31', '2027-12-31');
GO

CREATE PARTITION SCHEME partir_por_anio
AS PARTITION partir_por_anio TO (FG_2024, FG_2025, FG_2026, FG_2027, [PRIMARY]);
GO
