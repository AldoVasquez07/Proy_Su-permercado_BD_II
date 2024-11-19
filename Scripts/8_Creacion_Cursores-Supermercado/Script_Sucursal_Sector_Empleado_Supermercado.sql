USE bd_supermercado
GO

DECLARE @sucursal_id INT
DECLARE @sector_id INT
DECLARE @empleado_id INT

-- Nivel 1: Cursor para las sucursales
DECLARE cursor_sucursal CURSOR FOR
SELECT id FROM [adm].sucursal;

OPEN cursor_sucursal;
FETCH NEXT FROM cursor_sucursal INTO @sucursal_id;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Sucursal ID: ' + CAST(@sucursal_id AS VARCHAR);

    -- Nivel 2: Cursor para los sectores de cada sucursal
    DECLARE cursor_sector CURSOR FOR
    SELECT id FROM [adm].sector WHERE id_sucursal = @sucursal_id;

    OPEN cursor_sector;
    FETCH NEXT FROM cursor_sector INTO @sector_id;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '  Sector ID: ' + CAST(@sector_id AS VARCHAR);

        -- Nivel 3: Cursor para los empleados en cada sector
        DECLARE cursor_empleado CURSOR FOR
        SELECT id FROM [adm].empleado WHERE id_sector = @sector_id;

        OPEN cursor_empleado;
        FETCH NEXT FROM cursor_empleado INTO @empleado_id;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            PRINT '    Empleado ID: ' + CAST(@empleado_id AS VARCHAR);

            -- Aquí puedes realizar operaciones con cada `empleado` específico en el sector.

            FETCH NEXT FROM cursor_empleado INTO @empleado_id;
        END

        CLOSE cursor_empleado;
        DEALLOCATE cursor_empleado;

        FETCH NEXT FROM cursor_sector INTO @sector_id;
    END

    CLOSE cursor_sector;
    DEALLOCATE cursor_sector;

    FETCH NEXT FROM cursor_sucursal INTO @sucursal_id;
END

CLOSE cursor_sucursal;
DEALLOCATE cursor_sucursal;
