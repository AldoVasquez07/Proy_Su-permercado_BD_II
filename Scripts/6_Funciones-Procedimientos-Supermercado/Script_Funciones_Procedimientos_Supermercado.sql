--************************************************************************************************
--* GENERACION FUNCIONES Y PROCEDIMIENTOS EN LA BASE DE DATOS
--************************************************************************************************

USE bd_supermercado
GO

-- Procedimieto para insertar una nueva persona
CREATE PROCEDURE sp_InsertarPersona
    @dni VARCHAR(8),
    @nombre NVARCHAR(100),
    @apellido_paterno NVARCHAR(100),
    @apellido_materno NVARCHAR(100),
    @fecha_nacimiento DATE
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [adm].persona WHERE dni = @dni)
    BEGIN
        INSERT INTO [adm].persona (dni, nombre, apellido_paterno, apellido_materno, fecha_nacimiento)
        VALUES (@dni, @nombre, @apellido_paterno, @apellido_materno, @fecha_nacimiento);
    END
    ELSE
    BEGIN
        PRINT 'La persona con el DNI ingresado ya existe.';
    END
END;
GO

-- Procedimieto para Actualizar los datos de una persona
CREATE PROCEDURE sp_ActualizarPersona
    @id INT,
    @nombre NVARCHAR(100),
    @apellido_paterno NVARCHAR(100),
    @apellido_materno NVARCHAR(100),
    @fecha_nacimiento DATE
AS
BEGIN
    UPDATE [adm].persona
    SET nombre = @nombre,
        apellido_paterno = @apellido_paterno,
        apellido_materno = @apellido_materno,
        fecha_nacimiento = @fecha_nacimiento
    WHERE id = @id;
END;
GO

-- Procedimieto para Eliminar una persona (soft delete)
CREATE PROCEDURE sp_EliminarPersona
    @id INT
AS
BEGIN
    UPDATE [adm].persona
    SET flag = 0
    WHERE id = @id;
END;
GO

-- Procedimieto para Insertar un producto
CREATE PROCEDURE sp_InsertarProducto
    @nombre VARCHAR(100),
    @descripcion NVARCHAR(255),
    @precio DECIMAL(10, 2),
    @fecha_creacion DATE,
    @fecha_vencimiento DATE = NULL,
    @contenido_neto DECIMAL(10, 2) = NULL,
    @existencias INT,
    @id_tipo_producto INT,
    @id_marca INT,
    @id_unidad_medida INT = NULL,
    @id_oferta INT = NULL,
    @id_sector INT
AS
BEGIN
    INSERT INTO [ven].producto 
        (nombre, descripcion, precio, fecha_creacion, fecha_vencimiento, contenido_neto, existencias, 
        id_tipo_producto, id_marca, id_unidad_medida, id_oferta, id_sector)
    VALUES 
        (@nombre, @descripcion, @precio, @fecha_creacion, @fecha_vencimiento, @contenido_neto, 
        @existencias, @id_tipo_producto, @id_marca, @id_unidad_medida, @id_oferta, @id_sector);
END;
GO

-- Procedimieto para Registrar una nueva venta
CREATE PROCEDURE sp_RegistrarVenta
    @id_cliente INT,
    @id_forma_pago INT,
    @id_estado_venta INT,
    @fecha_cancelacion DATE,
    @id_transaccion INT = NULL
AS
BEGIN
    INSERT INTO [ven].venta_cabecera 
        (id_cliente, id_forma_pago, id_estado_venta, fecha_cancelacion, id_transaccion)
    VALUES 
        (@id_cliente, @id_forma_pago, @id_estado_venta, @fecha_cancelacion, @id_transaccion);
END;
GO

-- Procedimieto para Registrar detalles de una venta
CREATE PROCEDURE sp_RegistrarDetalleVenta
    @id_venta_cabecera INT,
    @fecha_venta DATE,
    @id_producto INT
AS
BEGIN
    INSERT INTO [ven].venta_detalle (id_venta_cabecera, fecha_venta, id_producto)
    VALUES (@id_venta_cabecera, @fecha_venta, @id_producto);

    -- Actualizar existencias del producto
    UPDATE [ven].producto
    SET existencias = existencias - 1
    WHERE id = @id_producto AND existencias > 0;
END;
GO

CREATE PROCEDURE sp_ProductosBajaExistencia
    @umbral INT
AS
BEGIN
    SELECT 
        id, 
        nombre, 
        existencias 
    FROM [ven].producto
    WHERE existencias < @umbral;
END;
GO

CREATE PROCEDURE sp_ActualizarPrecioProducto
    @id_producto INT,
    @nuevo_precio DECIMAL(10, 2)
AS
BEGIN
    UPDATE [ven].producto
    SET precio = @nuevo_precio
    WHERE id = @id_producto;
END;
GO

-- Funcion Calcular la edad de una persona
CREATE FUNCTION fn_CalcularEdad(@fecha_nacimiento DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @fecha_nacimiento, GETDATE()) -
           CASE WHEN MONTH(@fecha_nacimiento) > MONTH(GETDATE()) OR 
                     (MONTH(@fecha_nacimiento) = MONTH(GETDATE()) AND DAY(@fecha_nacimiento) > DAY(GETDATE()))
                THEN 1 ELSE 0 END;
END;
GO

-- Funcion Calcular el descuento aplicado en una venta
CREATE FUNCTION fn_CalcularDescuento(@precio DECIMAL(10, 2), @descuento DECIMAL(5, 2))
RETURNS DECIMAL(10, 2)
AS
BEGIN
    RETURN @precio * (1 - @descuento / 100);
END;
GO

CREATE FUNCTION fn_ExistenciasPorSector(@id_sector INT)
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT SUM(existencias)
        FROM [ven].producto
        WHERE id_sector = @id_sector
    );
END;
GO

CREATE PROCEDURE sp_ClientesFrecuentes
    @min_compras INT
AS
BEGIN
    SELECT 
        c.id,
        p.nombre,
        p.apellido_paterno,
        COUNT(vc.id) AS compras_realizadas
    FROM [ven].cliente c
    INNER JOIN [ven].venta_cabecera vc ON c.id = vc.id_cliente
	LEFT JOIN [adm].persona p ON p.id = c.id_persona
    GROUP BY c.id, p.nombre, p.apellido_paterno
    HAVING COUNT(vc.id) > 10;
END;
GO

CREATE FUNCTION fn_ValorInventarioTotal()
RETURNS DECIMAL(10, 2)
AS
BEGIN
    RETURN (
        SELECT SUM(precio * existencias)
        FROM [ven].producto
    );
END;
GO