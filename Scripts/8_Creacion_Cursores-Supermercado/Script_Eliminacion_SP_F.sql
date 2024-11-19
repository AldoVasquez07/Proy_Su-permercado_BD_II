USE bd_supermercado;
GO

-- Deshabilitar comprobaciones de dependencias
SET NOCOUNT ON;

-- VARIABLES
DECLARE @sql NVARCHAR(MAX);

-- ELIMINAR PROCEDIMIENTOS ALMACENADOS
PRINT 'Eliminando procedimientos almacenados...';
DECLARE cursor_sp CURSOR FOR
SELECT 'DROP PROCEDURE [' + SCHEMA_NAME(schema_id) + '].[' + name + '];'
FROM sys.objects
WHERE type = 'P' -- Procedimientos almacenados
  AND is_ms_shipped = 0; -- Excluir procedimientos del sistema

OPEN cursor_sp;
FETCH NEXT FROM cursor_sp INTO @sql;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @sql;
    EXEC sp_executesql @sql;
    FETCH NEXT FROM cursor_sp INTO @sql;
END;
CLOSE cursor_sp;
DEALLOCATE cursor_sp;

-- ELIMINAR FUNCIONES ESCALARES
PRINT 'Eliminando funciones escalares...';
DECLARE cursor_fn_scalar CURSOR FOR
SELECT 'DROP FUNCTION [' + SCHEMA_NAME(schema_id) + '].[' + name + '];'
FROM sys.objects
WHERE type = 'FN' -- Funciones escalares
  AND is_ms_shipped = 0;

OPEN cursor_fn_scalar;
FETCH NEXT FROM cursor_fn_scalar INTO @sql;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @sql;
    EXEC sp_executesql @sql;
    FETCH NEXT FROM cursor_fn_scalar INTO @sql;
END;
CLOSE cursor_fn_scalar;
DEALLOCATE cursor_fn_scalar;

-- ELIMINAR FUNCIONES TABULARES
PRINT 'Eliminando funciones tabulares...';
DECLARE cursor_fn_table CURSOR FOR
SELECT 'DROP FUNCTION [' + SCHEMA_NAME(schema_id) + '].[' + name + '];'
FROM sys.objects
WHERE type IN ('TF', 'IF') -- Funciones tabulares e in-line
  AND is_ms_shipped = 0;

OPEN cursor_fn_table;
FETCH NEXT FROM cursor_fn_table INTO @sql;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @sql;
    EXEC sp_executesql @sql;
    FETCH NEXT FROM cursor_fn_table INTO @sql;
END;
CLOSE cursor_fn_table;
DEALLOCATE cursor_fn_table;

PRINT 'Todos los procedimientos y funciones han sido eliminados.';
GO
