use bd_supermercado
go

CREATE TRIGGER trg_usuario_update
ON [sec].usuario
AFTER UPDATE
AS
BEGIN
    DECLARE @id_usuario INT, @motivo NVARCHAR(100), @descripcion NVARCHAR(255), @fecha DATETIME;
    
    SET @fecha = GETDATE();
    SET @motivo = 'Actualización de Usuario';
    SET @descripcion = 'Se ha actualizado el registro del usuario';

    SELECT @id_usuario = inserted.id 
    FROM inserted;
    
    INSERT INTO [sec].log_procesos (motivo, descripcion, fecha, id_usuario)
    VALUES (@motivo, @descripcion, @fecha, @id_usuario);
END;
GO


CREATE TRIGGER trg_check_stock
ON [ven].venta_detalle
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @id_producto INT, @cantidad INT, @existencias INT;
    
    SELECT @id_producto = id_producto 
    FROM inserted;
    
    SELECT @existencias = existencias 
    FROM [ven].producto 
    WHERE id = @id_producto;

    IF (@existencias < 1)
    BEGIN
        RAISERROR ('No hay existencias suficientes para el producto', 16, 1);
        ROLLBACK;
    END
    ELSE
    BEGIN
        -- Insertar registro en venta_detalle si hay existencias suficientes
        INSERT INTO [ven].venta_detalle (id_venta_cabecera, fecha_venta, id_producto)
        SELECT id_venta_cabecera, fecha_venta, id_producto 
        FROM inserted;

        -- Actualizar existencias en producto
        UPDATE [ven].producto
        SET existencias = existencias - 1
        WHERE id = @id_producto;
    END
END;
GO



CREATE TRIGGER trg_contrato_update_status
ON [adm].contrato
AFTER UPDATE
AS
BEGIN
    UPDATE [adm].contrato
    SET estado = 0
    WHERE fecha_finalizacion < GETDATE() AND estado = 1;
END;
GO


CREATE TRIGGER trg_cliente_delete
ON [ven].cliente
AFTER DELETE
AS
BEGIN
    DECLARE @id_usuario INT = 1; -- Colocar aquí el ID de un usuario del sistema, si es necesario
    DECLARE @motivo NVARCHAR(100) = 'Eliminación de Cliente';
    DECLARE @descripcion NVARCHAR(255) = 'Se ha eliminado un cliente';
    DECLARE @fecha DATETIME = GETDATE();

    INSERT INTO [sec].log_procesos (motivo, descripcion, fecha, id_usuario)
    VALUES (@motivo, @descripcion, @fecha, @id_usuario);
END;
GO



CREATE TRIGGER trg_unique_telefono
ON [adm].telefono
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @telefono NVARCHAR(9);

    SELECT @telefono = telefono FROM inserted;

    IF EXISTS (SELECT 1 FROM [adm].telefono WHERE telefono = @telefono)
    BEGIN
        RAISERROR ('El número de teléfono ya existe.', 16, 1);
        ROLLBACK;
    END
    ELSE
    BEGIN
        INSERT INTO [adm].telefono (prefijo, telefono, id_empresa_asociada, estado)
        SELECT prefijo, telefono, id_empresa_asociada, estado FROM inserted;
    END
END;
GO

CREATE TRIGGER trg_rol_update
ON [sec].rol
AFTER UPDATE
AS
BEGIN
    DECLARE @id_usuario INT = 1; -- Colocar aquí el ID de un usuario del sistema
    DECLARE @motivo NVARCHAR(100) = 'Actualización de Rol';
    DECLARE @descripcion NVARCHAR(255) = 'Se ha actualizado un rol';
    DECLARE @fecha DATETIME = GETDATE();

    INSERT INTO [sec].log_procesos (motivo, descripcion, fecha, id_usuario)
    VALUES (@motivo, @descripcion, @fecha, @id_usuario);
END;
GO

CREATE TRIGGER trg_producto_delete_check
ON [ven].producto
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @id_producto INT;
    
    SELECT @id_producto = id FROM deleted;

    IF EXISTS (SELECT 1 FROM [ven].venta_detalle WHERE id_producto = @id_producto)
    BEGIN
        RAISERROR ('No se puede eliminar el producto porque tiene ventas asociadas', 16, 1);
        ROLLBACK;
    END
    ELSE
    BEGIN
        DELETE FROM [ven].producto WHERE id = @id_producto;
    END
END;
GO
