USE bd_supermercado
GO

-- Auditor�a de cambios en 'adm.persona'
CREATE TRIGGER trg_audit_persona
ON [adm].persona
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO [sec].log_procesos(motivo, descripcion, fecha, id_usuario)
        VALUES (
            'Cambio en persona',
            'Se ha insertado o actualizado un registro en persona',
            GETDATE(),
            1
        );
    END
    
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO [sec].log_procesos(motivo, descripcion, fecha, id_usuario)
        VALUES (
            'Eliminaci�n en persona',
            'Se ha eliminado un registro de persona',
            GETDATE(),
            1
        );
    END
END;
GO


-- Eliminaci�n l�gica en 'adm.empresa_asociada'
CREATE TRIGGER trg_delete_empresa_asociada
ON [adm].empresa_asociada
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [adm].empresa_asociada
    SET flag = 0
    WHERE id IN (SELECT id FROM deleted);
END;
GO

-- Eliminaci�n l�gica en 'ven.cliente'
CREATE TRIGGER trg_delete_cliente
ON [ven].cliente
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [ven].cliente
    SET flag = 0
    WHERE id IN (SELECT id FROM deleted);
END;
GO

CREATE TRIGGER trg_prevent_duplicate_inactive
ON [ven].producto
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Permitir actualizaciones solo si el nuevo estado no es redundante
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN [ven].producto p ON i.id = p.id
        WHERE p.flag = 0 AND i.flag = 0
    )
    BEGIN
        RAISERROR('El producto ya est� inactivo.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Ejecutar la actualizaci�n
    UPDATE [ven].producto
    SET flag = inserted.flag
    FROM inserted
    WHERE [ven].producto.id = inserted.id;
END;
GO

CREATE TRIGGER trg_audit_empleado
ON [adm].empleado
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [sec].log_procesos(motivo, descripcion, fecha, id_usuario)
    SELECT
        'Actualizaci�n en empleado',
        CONCAT(
            'ID Empleado: ', d.id, 
            '. C�digo (Antes): ', d.codigo, ', C�digo (Despu�s): ', i.codigo,
            '. Horas trabajo (Antes): ', d.horas_trabajo, ', Horas trabajo (Despu�s): ', i.horas_trabajo,
            '. Sector (Antes): ', d.id_sector, ', Sector (Despu�s): ', i.id_sector
        ),
        GETDATE(),
        1 -- Este ID de usuario deber�a reemplazarse con el contexto real del usuario.
    FROM deleted d
    INNER JOIN inserted i ON d.id = i.id
    WHERE d.codigo <> i.codigo
       OR d.horas_trabajo <> i.horas_trabajo
       OR d.id_sector <> i.id_sector;
END;
GO

