USE bd_supermercado
GO

-- Declaración del cursor principal
DECLARE @id_cliente INT, @nombre_cliente NVARCHAR(100);

DECLARE cursor_clientes CURSOR FOR
SELECT c.id, CONCAT(p.nombre, ' ', p.apellido_paterno, ' ', p.apellido_materno) AS nombre_completo
FROM [ven].cliente c
INNER JOIN [adm].persona p ON c.id_persona = p.id
WHERE c.flag = 1;

OPEN cursor_clientes;

FETCH NEXT FROM cursor_clientes INTO @id_cliente, @nombre_cliente;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Procesando cliente: ' + @nombre_cliente;

    -- Cursor anidado para obtener ventas del cliente actual
    DECLARE @id_venta INT, @fecha_venta DATE;

    DECLARE cursor_ventas CURSOR FOR
    SELECT vc.id, vc.fecha
    FROM [ven].venta_cabecera vc
    WHERE vc.id_cliente = @id_cliente AND vc.flag = 1;

    OPEN cursor_ventas;

    FETCH NEXT FROM cursor_ventas INTO @id_venta, @fecha_venta;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   Venta ID: ' + CAST(@id_venta AS NVARCHAR) + ', Fecha: ' + CAST(@fecha_venta AS NVARCHAR);

        -- Aquí se puede incluir lógica adicional para cada venta

        FETCH NEXT FROM cursor_ventas INTO @id_venta, @fecha_venta;
    END

    CLOSE cursor_ventas;
    DEALLOCATE cursor_ventas;

    -- Siguiente cliente
    FETCH NEXT FROM cursor_clientes INTO @id_cliente, @nombre_cliente;
END

CLOSE cursor_clientes;
DEALLOCATE cursor_clientes;
