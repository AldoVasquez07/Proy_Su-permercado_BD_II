--************************************************************************************************
--* CONSULTAS ANIDADAS EN LA BASE DE DATOS
--************************************************************************************************
USE bd_supermercado
GO

CREATE VIEW [adm].vw_empleados AS
SELECT 
    e.id AS id_empleado,
    p.nombre + ' ' + p.apellido_paterno + ' ' + p.apellido_materno AS nombre_completo,
    p.dni,
    e.codigo,
    t.tipo AS tipo_empleado,
    s.nombre AS sector,
    c.monto AS sueldo,
    c.fecha_inicio,
    c.fecha_finalizacion
FROM [adm].empleado e
JOIN [adm].persona p ON e.id_persona = p.id
JOIN [adm].tipo_empleado t ON e.id_tipo_empleado = t.id
JOIN [adm].sector s ON e.id_sector = s.id
JOIN [adm].contrato c ON e.id_contrato = c.id
WHERE e.flag = 1;
GO

CREATE VIEW [adm].vw_sucursales AS
SELECT 
    s.id AS id_sucursal,
    s.nombre AS sucursal,
    s.direccion,
    c.nombre AS ciudad,
    ts.tipo AS tipo_sector,
    sec.nombre AS sector
FROM [adm].sucursal s
JOIN [adm].ciudad c ON s.id_ciudad = c.id
LEFT JOIN [adm].sector sec ON sec.id_sucursal = s.id
LEFT JOIN [adm].tipo_sector ts ON sec.id_tipo_sector = ts.id
WHERE s.flag = 1;
GO

CREATE VIEW [ven].vw_productos AS
SELECT 
    p.id AS id_producto,
    p.nombre AS producto,
    p.descripcion,
    p.precio,
    p.existencias,
    p.fecha_vencimiento,
    tp.tipo AS tipo_producto,
    m.marca AS marca,
    o.motivo AS oferta,
    o.descuento,
    sec.nombre AS sector
FROM [ven].producto p
JOIN [ven].tipo_producto tp ON p.id_tipo_producto = tp.id
JOIN [ven].marca_producto m ON p.id_marca = m.id
LEFT JOIN [ven].oferta o ON p.id_oferta = o.id
JOIN [adm].sector sec ON p.id_sector = sec.id
WHERE p.flag = 1;
GO

CREATE VIEW [ven].vw_ventas AS
SELECT 
    vc.id AS id_venta,
    vc.fecha,
    vc.fecha_cancelacion,
    cl.id AS id_cliente,
    cl.flag AS cliente_activo,
    t.tarjeta,
    b.nombre AS banco,
    e.estado AS estado_venta,
    p.nombre AS producto,
    vd.flag AS detalle_activo
FROM [ven].venta_cabecera vc
JOIN [ven].venta_detalle vd ON vc.id = vd.id_venta_cabecera
JOIN [ven].cliente cl ON vc.id_cliente = cl.id
LEFT JOIN [ven].transaccion t ON vc.id_transaccion = t.id
LEFT JOIN [ven].banco b ON t.id_banco = b.id
JOIN [ven].estado_venta e ON vc.id_estado_venta = e.id
JOIN [ven].producto p ON vd.id_producto = p.id
WHERE vc.flag = 1 AND vd.flag = 1;
GO

CREATE VIEW [sec].vw_usuarios AS
SELECT 
    u.id AS id_usuario,
    u.codigo AS usuario_codigo,
    p.nombre + ' ' + p.apellido_paterno + ' ' + p.apellido_materno AS nombre_completo,
    p.dni,
    u.correo,
    r.rol AS rol,
    u.flag AS activo
FROM [sec].usuario u
JOIN [adm].persona p ON u.id_persona = p.id
JOIN [sec].rol r ON u.id_rol = r.id
WHERE u.flag = 1;
GO

USE bd_supermercado;
GO

-- vw para obtener la información de cada empleado junto con el nombre del sector y el tipo de empleado
CREATE VIEW [adm].[vw_empleados_sector] AS
SELECT 
    e.id AS empleado_id,
    e.codigo AS codigo_empleado,
    p.nombre + ' ' + p.apellido_paterno + ' ' + p.apellido_materno AS nombre_completo,
    (SELECT nombre FROM [adm].sector WHERE id = e.id_sector) AS sector,
    (SELECT tipo FROM [adm].tipo_empleado WHERE id = e.id_tipo_empleado) AS tipo_empleado,
    e.horas_trabajo,
    e.flag
FROM 
    [adm].empleado e
JOIN 
    [adm].persona p ON e.id_persona = p.id;
GO

-- vw para obtener los productos con información detallada incluyendo oferta activa (si existe)
CREATE VIEW [ven].[vw_productos_detalle] AS
SELECT 
    p.id AS producto_id,
    p.nombre AS nombre_producto,
    p.descripcion,
    p.precio,
    (SELECT descuento FROM [ven].oferta WHERE id = p.id_oferta) AS descuento,
    (SELECT tipo FROM [ven].tipo_producto WHERE id = p.id_tipo_producto) AS tipo_producto,
    (SELECT marca FROM [ven].marca_producto WHERE id = p.id_marca) AS marca,
    (SELECT nombre FROM [adm].sector WHERE id = p.id_sector) AS sector,
    p.existencias,
    p.flag
FROM 
    [ven].producto p;
GO

-- vw para obtener los Contratos con detalle de la forma de pago y motivo
CREATE VIEW [adm].[vw_contratos_detalle] AS
SELECT 
    c.id AS contrato_id,
    c.fecha_inicio,
    c.fecha_finalizacion,
    c.descripcion,
    c.monto,
    (SELECT forma FROM [ven].forma_pago WHERE id = c.id_forma_pago) AS forma_pago,
    (SELECT motivo FROM [adm].motivo_contrato WHERE id = c.id_motivo_contrato) AS motivo_contrato,
    c.flag
FROM 
    [adm].contrato c;
GO

-- vw para obtener las ventas con detalle de cliente y forma de pago
CREATE VIEW [ven].[vw_ventas_detalle] AS
SELECT 
    vc.id AS venta_id,
    vc.fecha,
    vc.fecha_cancelacion,
    (SELECT CONCAT(p.nombre, ' ', p.apellido_paterno, ' ', p.apellido_materno)
     FROM [adm].persona p
     JOIN [ven].cliente c ON c.id_persona = p.id
     WHERE c.id = vc.id_cliente) AS cliente,
    (SELECT forma FROM [ven].forma_pago WHERE id = vc.id_forma_pago) AS forma_pago,
    (SELECT estado FROM [ven].estado_venta WHERE id = vc.id_estado_venta) AS estado_venta,
    vc.flag
FROM 
    [ven].venta_cabecera vc;
GO

-- vw para obtener el Detalle de cada venta con información del producto y su precio
CREATE VIEW [ven].[vw_venta_productos] AS
SELECT 
    vd.id_venta_cabecera,
    vd.fecha_venta,
    (SELECT nombre FROM [ven].producto WHERE id = vd.id_producto) AS producto,
    (SELECT precio FROM [ven].producto WHERE id = vd.id_producto) AS precio_unitario,
    (SELECT descuento FROM [ven].oferta WHERE id = 
        (SELECT id_oferta FROM [ven].producto WHERE id = vd.id_producto)) AS descuento_producto,
    vd.flag
FROM 
    [ven].venta_detalle vd;
GO

-- vw para obtener las sucursales con información de la ciudad y sectores asociados
CREATE VIEW [adm].[vw_sucursales_detalle] AS
SELECT 
    s.id AS sucursal_id,
    s.nombre AS sucursal_nombre,
    s.direccion AS direccion,
    (SELECT nombre FROM [adm].ciudad WHERE id = s.id_ciudad) AS ciudad,
    (SELECT COUNT(*) 
     FROM [adm].sector 
     WHERE id_sucursal = s.id) AS total_sectores,
    s.flag
FROM 
    [adm].sucursal s;
GO

-- vw para obtener la información de empresas asociadas y sus contratos
CREATE VIEW [adm].[vw_empresas_contrato] AS
SELECT 
    ea.id AS empresa_id,
    ea.nombre AS empresa_nombre,
    ea.ruc,
    ea.direccion,
    (SELECT descripcion FROM [adm].contrato WHERE id = ea.id_contrato) AS contrato_descripcion,
    (SELECT monto FROM [adm].contrato WHERE id = ea.id_contrato) AS monto_contrato,
    (SELECT forma FROM [ven].forma_pago 
     WHERE id = (SELECT id_forma_pago FROM [adm].contrato WHERE id = ea.id_contrato)) AS forma_pago,
    ea.flag
FROM 
    [adm].empresa_asociada ea;
GO