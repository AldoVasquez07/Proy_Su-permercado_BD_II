SELECT name AS NombreBaseDatos
FROM sys.databases
WHERE state_desc = 'ONLINE';

DECLARE @databaseName NVARCHAR(255);
DECLARE @sql NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE state_desc = 'ONLINE'
  AND name NOT IN ('master', 'tempdb', 'model', 'msdb');

OPEN db_cursor;

FETCH NEXT FROM db_cursor INTO @databaseName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = '
        USE ' + QUOTENAME(@databaseName) + ';

        -- Mostrar tablas
        SELECT
            ''' + @databaseName + ''' AS BaseDeDatos,
            t.name AS Tabla,
            s.name AS Esquema,
            c.name AS Columna,
            ty.name AS TipoDeDato
        FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        INNER JOIN sys.columns c ON t.object_id = c.object_id
        INNER JOIN sys.types ty ON c.user_type_id = ty.user_type_id
        ORDER BY t.name, c.column_id;

        -- Mostrar vistas
        SELECT
            ''' + @databaseName + ''' AS BaseDeDatos,
            v.name AS Vista,
            s.name AS Esquema
        FROM sys.views v
        INNER JOIN sys.schemas s ON v.schema_id = s.schema_id
        ORDER BY v.name;

        -- Mostrar restricciones
        SELECT
            ''' + @databaseName + ''' AS BaseDeDatos,
            t.name AS Tabla,
            i.name AS Restriccion,
            i.type_desc AS TipoRestriccion
        FROM sys.indexes i
        INNER JOIN sys.tables t ON i.object_id = t.object_id
        WHERE i.is_primary_key = 1 OR i.is_unique_constraint = 1
        ORDER BY t.name;

        -- Mostrar usuarios
        SELECT
            ''' + @databaseName + ''' AS BaseDeDatos,
            u.name AS Usuario
        FROM sys.database_principals u
        WHERE u.type IN (''S'', ''U'', ''G'') AND u.name NOT LIKE ''##%'' AND u.name NOT LIKE ''NT AUTHORITY%'' AND u.name NOT LIKE ''NT SERVICE%'';

        -- Mostrar roles de base de datos
        SELECT
            ''' + @databaseName + ''' AS BaseDeDatos,
            r.name AS Rol
        FROM sys.database_principals r
        WHERE r.type = ''R'' AND r.name NOT LIKE ''##%'' AND r.name NOT LIKE ''NT AUTHORITY%'' AND r.name NOT LIKE ''NT SERVICE%'';

        -- Mostrar procedimientos almacenados
        SELECT
            ''' + @databaseName + ''' AS BaseDeDatos,
            p.name AS Procedimiento,
            s.name AS Esquema
        FROM sys.procedures p
        INNER JOIN sys.schemas s ON p.schema_id = s.schema_id
        ORDER BY p.name;

        -- Mostrar detonantes (triggers)
        SELECT
            ''' + @databaseName + ''' AS BaseDeDatos,
            tr.name AS Detonante,
            t.name AS Tabla,
            CASE
                WHEN tr.is_instead_of_trigger = 1 THEN ''INSTEAD OF''
                ELSE ''AFTER''
            END AS TipoDetonante
        FROM sys.triggers tr
        INNER JOIN sys.tables t ON tr.parent_id = t.object_id
        ORDER BY t.name, tr.name;

        -- Mostrar índices
        SELECT
            ''' + @databaseName + ''' AS BaseDeDatos,
            t.name AS Tabla,
            i.name AS Indice,
            i.type_desc AS TipoIndice,
            i.is_unique AS EsUnico
        FROM sys.indexes i
        INNER JOIN sys.tables t ON i.object_id = t.object_id
        WHERE i.is_primary_key = 0 -- Excluir claves primarias
        ORDER BY t.name, i.name;
    ';

    EXEC sp_executesql @sql;

    FETCH NEXT FROM db_cursor INTO @databaseName;
END;

CLOSE db_cursor;
DEALLOCATE db_cursor;
