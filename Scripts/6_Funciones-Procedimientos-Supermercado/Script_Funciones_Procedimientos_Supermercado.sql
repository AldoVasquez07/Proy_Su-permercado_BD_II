--************************************************************************************************
--* GENERACION FUNCIONES Y PROCEDIMIENTOS EN LA BASE DE DATOS
--************************************************************************************************

USE bd_supermercado
GO
CREATE PROCEDURE sp_insertar_cliente
    @dni NVARCHAR(8),
    @nombre NVARCHAR(100),
    @apellido_paterno NVARCHAR(100),
    @apellido_materno NVARCHAR(100),
    @id_tipo_cliente INT,
    @fecha_nacimiento DATE
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Punto de restauración
        SAVE TRANSACTION InsertCliente_SavePoint;

        INSERT INTO [ven].cliente (dni, nombre, apellido_paterno, apellido_materno, id_tipo_cliente, fecha_nacimiento, estado)
        VALUES (@dni, @nombre, @apellido_paterno, @apellido_materno, @id_tipo_cliente, @fecha_nacimiento, 1);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION InsertCliente_SavePoint;
        THROW;
    END CATCH;
END;
GO


CREATE PROCEDURE sp_actualizar_estado_producto
    @id_producto INT,
    @nuevo_estado BIT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Punto de restauración
        SAVE TRANSACTION UpdateProduct_SavePoint;

        UPDATE [ven].producto
        SET estado = @nuevo_estado
        WHERE id = @id_producto;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION UpdateProduct_SavePoint;
        THROW;
    END CATCH;
END;
GO


CREATE PROCEDURE sp_eliminar_sucursal
    @id_sucursal INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Punto de restauración
        SAVE TRANSACTION DeleteSucursal_SavePoint;

        DELETE FROM [adm].empresa_sucursal
        WHERE id_sucursal = @id_sucursal;

        DELETE FROM [adm].sucursal
        WHERE id = @id_sucursal;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION DeleteSucursal_SavePoint;
        THROW;
    END CATCH;
END;
GO


CREATE FUNCTION fn_nombre_completo_cliente (@id_cliente INT)
RETURNS NVARCHAR(300)
AS
BEGIN
    DECLARE @nombre_completo NVARCHAR(300);

    SELECT @nombre_completo = nombre + ' ' + apellido_paterno + ' ' + apellido_materno
    FROM [ven].cliente
    WHERE id = @id_cliente;

    RETURN @nombre_completo;
END;
GO


CREATE PROCEDURE sp_insertar_forma_pago
    @forma NVARCHAR(50)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        SAVE TRANSACTION InsertFormaPago_SavePoint;

        INSERT INTO [ven].forma_pago (forma, estado)
        VALUES (@forma, 1);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION InsertFormaPago_SavePoint;
        THROW;
    END CATCH;
END;
GO


CREATE PROCEDURE sp_actualizar_estado_contrato
    @id_contrato INT,
    @nuevo_estado BIT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        SAVE TRANSACTION UpdateContrato_SavePoint;

        UPDATE [adm].contrato
        SET estado = @nuevo_estado
        WHERE id = @id_contrato;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION UpdateContrato_SavePoint;
        THROW;
    END CATCH;
END;
GO


CREATE PROCEDURE sp_eliminar_empleado
    @id_empleado INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        SAVE TRANSACTION DeleteEmpleado_SavePoint;

        DELETE FROM [adm].empleado
        WHERE id = @id_empleado;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION DeleteEmpleado_SavePoint;
        THROW;
    END CATCH;
END;
GO


CREATE FUNCTION fn_nombre_completo_empleado (@id_empleado INT)
RETURNS NVARCHAR(300)
AS
BEGIN
    DECLARE @nombre_completo NVARCHAR(300);

    SELECT @nombre_completo = nombre + ' ' + apellido_paterno + ' ' + apellido_materno
    FROM [adm].empleado
    WHERE id = @id_empleado;

    RETURN @nombre_completo;
END;
GO


CREATE PROCEDURE sp_insertar_contrato
    @fecha_inicio DATE,
    @fecha_finalizacion DATE,
    @descripcion NVARCHAR(255),
    @monto DECIMAL(10,2),
    @id_forma_pago INT,
    @id_motivo_contrato INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        SAVE TRANSACTION InsertContrato_SavePoint;

        INSERT INTO [adm].contrato (fecha_inicio, fecha_finalizacion, descripcion, monto, id_forma_pago, id_motivo_contrato, estado)
        VALUES (@fecha_inicio, @fecha_finalizacion, @descripcion, @monto, @id_forma_pago, @id_motivo_contrato, 1);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION InsertContrato_SavePoint;
        THROW;
    END CATCH;
END;
GO


CREATE PROCEDURE sp_actualizar_estado_sucursal
    @id_sucursal INT,
    @nuevo_estado BIT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        SAVE TRANSACTION UpdateSucursal_SavePoint;

        UPDATE [adm].sucursal
        SET estado = @nuevo_estado
        WHERE id = @id_sucursal;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION UpdateSucursal_SavePoint;
        THROW;
    END CATCH;
END;
GO


CREATE FUNCTION fn_nombre_ciudad_sucursal (@id_sucursal INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @nombre_ciudad NVARCHAR(100);

    SELECT @nombre_ciudad = c.nombre
    FROM [adm].sucursal s
    INNER JOIN [adm].ciudad c ON s.id_ciudad = c.id
    WHERE s.id = @id_sucursal;

    RETURN @nombre_ciudad;
END;
GO


CREATE PROCEDURE sp_insertar_telefono
    @prefijo NVARCHAR(3),
    @telefono NVARCHAR(9),
    @id_empresa_asociada INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        SAVE TRANSACTION InsertTelefono_SavePoint;

        INSERT INTO [adm].telefono (prefijo, telefono, id_empresa_asociada, estado)
        VALUES (@prefijo, @telefono, @id_empresa_asociada, 1);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION InsertTelefono_SavePoint;
        THROW;
    END CATCH;
END;
GO
