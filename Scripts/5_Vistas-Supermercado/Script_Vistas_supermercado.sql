--************************************************************************************************
--* CONSULTAS ANIDADAS EN LA BASE DE DATOS
--************************************************************************************************
USE bd_supermercado;
GO
/*
**	Seleccionando todos los productos de una sucursal
**	cuyo precio supere la media.
*/
CREATE VIEW vw_productos_sucursal AS
SELECT
	SU.nombre AS 'Sucursal',
	P.nombre AS 'Producto',
	P.precio AS 'Precio'
FROM adm.sucursal AS SU
RIGHT JOIN adm.sector AS SE
ON SE.id_sucursal = SU.id
RIGHT JOIN ven.producto AS P
ON P.id_sector = SE.id
WHERE P.precio > (
	SELECT
		AVG(precio)
	FROM ven.producto
)
GO

/*
**	Consulta para seleccionar productos cuyo precio
**	es mayor al promedio de su categoría específica.
*/
CREATE VIEW vw_productos_precio_mayor AS
SELECT
    TP.tipo AS 'Tipo de Producto',
    P.nombre AS 'Producto',
    P.precio AS 'Precio',
    C.nombre + ' ' + C.apellido_paterno + ' ' + C.apellido_materno AS 'Cliente',
    VC.fecha AS 'Fecha de Venta'
FROM ven.producto AS P
JOIN ven.tipo_producto AS TP
ON P.id_tipo_producto = TP.id
JOIN ven.venta_detalle AS VD
ON VD.id_producto = P.id
JOIN ven.venta_cabecera AS VC
ON VD.id_venta_cabecera = VC.id
JOIN ven.cliente AS C
ON VC.id_cliente = C.id
WHERE P.precio > (
    SELECT AVG(precio)
    FROM ven.producto
    WHERE id_tipo_producto = TP.id
)
GO


--************************************************************************************************
--* CONSULTAS JOIN
--************************************************************************************************

/*	
**	Consulta para obtener los empleados activos de la empresa,
**	con información de contrato, método de pago, rol y sector correspondiente.
*/

CREATE VIEW vw_empleados_activos AS
SELECT
	emp.dni AS 'DNI',
	emp.codigo AS 'Codigo',
	t_emp.tipo AS 'Rol',
	emp.nombre + ' ' + emp.apellido_materno + ' ' + emp.apellido_paterno AS 'Empleado',
	emp.horas_trabajo AS 'Horas Trabajadas',
	con.descripcion AS 'Contrato',
	m_con.motivo AS 'Motivo Contrato',
	con.monto AS 'Sueldo',
	fg.forma AS 'Metodo Pago',
	sec.nombre AS 'Sector'
FROM adm.empleado AS emp
LEFT JOIN adm.tipo_empleado AS t_emp
ON emp.id_tipo_empleado = t_emp.id
LEFT JOIN adm.contrato AS con
ON emp.id_contrato = con.id
LEFT JOIN adm.motivo_contrato AS m_con
ON con.id_motivo_contrato = m_con.id
LEFT JOIN ven.forma_pago AS fg
ON con.id_forma_pago = fg.id
LEFT JOIN adm.sector AS sec
ON emp.id_sector = sec.id
WHERE emp.estado = 1 AND con.estado = 1;
GO

/*
**	Consulta para obtener todas las ventas y sus detalles, 
**	como cliente, producto vendido y método de pago.
*/
CREATE VIEW vw_ventas_generales AS
SELECT
V.fecha AS 'Fecha de Venta',
C.nombre + ' ' + C.apellido_materno + ' ' + C.apellido_paterno AS 'Cliente',
P.nombre AS 'Producto',
P.precio AS 'Precio',
FG.forma AS 'Metodo de Pago'
FROM ven.venta_cabecera AS V
RIGHT JOIN ven.venta_detalle AS VD
ON VD.id_venta_cabecera = V.id
LEFT JOIN ven.producto AS P
ON VD.id_producto = P.id
LEFT JOIN ven.cliente AS C
ON V.id_cliente = C.id
LEFT JOIN ven.forma_pago AS FG
ON V.id_forma_pago = FG.id;
GO

/*
**	Consulta para obtener todas las sucursales, la ciudad a la que pertenecen, 
**	y la cantidad de sectores que cada sucursal tiene.
*/
CREATE VIEW vw_sucursales_sectores AS
SELECT
	S.nombre AS 'Sucursal',
	C.nombre AS 'Ciudad',
	S.direccion AS 'Direccion',
	COUNT(SE.id) AS 'Cantidad Sectores'
FROM adm.sucursal AS S
LEFT JOIN adm.ciudad AS C
ON S.id_ciudad = C.id
RIGHT JOIN adm.sector AS SE
ON SE.id_sucursal = S.id
WHERE S.estado = 1
GROUP BY S.nombre, C.nombre, S.direccion;
GO


/*
**	Consulta para obtener los sectores existentes, su tipo, 
**	sucursal a la que pertenecen y productos disponibles en cada sector.
*/

CREATE VIEW vw_productos_sectores AS
SELECT
	S.nombre AS 'Sector',
	TS.tipo AS 'Tipo',
	SU.nombre AS 'Sucursal',
	P.nombre AS 'Producto',
	P.existencias AS 'Stock'
FROM adm.sector AS S
LEFT JOIN adm.tipo_sector AS TS
ON S.id_tipo_sector = TS.id
LEFT JOIN adm.sucursal AS SU
ON S.id_sucursal = SU.id
RIGHT JOIN ven.producto AS P
ON P.id_sector = S.id
GO

/*
**	Consulta para calcular la cantidad de ventas y las ganancias promedio por sucursal.
*/
CREATE VIEW vw_ventas_ganancias AS
SELECT
	SU.nombre AS 'Sucursal',
	COUNT(VC.id) AS 'Cantidad Ventas',
	AVG(VD.id_producto) AS 'Ganancias Promedio'
FROM adm.sucursal AS SU
RIGHT JOIN adm.sector AS SE
ON SU.id = SE.id_sucursal
RIGHT JOIN ven.producto AS P
ON SE.id = P.id_sector
RIGHT JOIN ven.venta_detalle AS VD
ON P.id = VD.id_producto
LEFT JOIN ven.venta_cabecera AS VC
ON VC.id = VD.id_venta_cabecera
GROUP BY SU.nombre;
GO

/*
**	Consulta para obtener todas las empresas asociadas a cada sucursal,
**	incluyendo sus contratos y el monto de cada contrato.
*/
CREATE VIEW vw_empresas_asociadas AS
SELECT
	SU.nombre AS 'Sucursal',
	EA.nombre AS 'Empresa Asociada',
	C.descripcion AS 'Contrato',
	C.monto AS 'Monto'
FROM adm.sucursal AS SU
RIGHT JOIN adm.empresa_sucursal AS ES
ON SU.id = ES.id_sucursal
LEFT JOIN adm.empresa_asociada AS EA
ON ES.id_empresa = EA.id
LEFT JOIN adm.contrato AS C
ON EA.id_contrato = C.id
GO
/*
**	Consulta para obtener los productos con descuento que se encuentran en cada sector,
**	incluyendo motivo y porcentaje de descuento.
*/
CREATE VIEW vw_productos_descuento AS
SELECT
    S.nombre AS 'Sector',
    P.nombre AS 'Producto',
    P.existencias AS 'Existencias',
    O.motivo AS 'Motivo Oferta',
    O.descuento AS 'Descuento (%)'
FROM ven.producto AS P
JOIN adm.sector AS S
ON P.id_sector = S.id
JOIN ven.oferta AS O
ON P.id_oferta = O.id
WHERE O.estado = 1
GO


/*
**	Consulta para obtener información de contratos de los empleados,
**	incluyendo el método de pago, motivo del contrato y fechas de vigencia.
*/
CREATE VIEW vw_empleados_contrato AS
SELECT
    E.nombre + ' ' + E.apellido_paterno + ' ' + E.apellido_materno AS nombre,
    C.descripcion AS contrato,
    C.fecha_inicio AS fecha_ini,
    C.fecha_finalizacion AS fecha_fin,
    F.forma AS metodo_pago,
    MC.motivo AS motivo_contrato
FROM adm.empresa_asociada AS EA
JOIN adm.empleado AS E
ON EA.id = E.id_contrato
JOIN adm.contrato AS C
ON E.id_contrato = C.id
JOIN ven.forma_pago AS F
ON C.id_forma_pago = F.id
JOIN adm.motivo_contrato AS MC
ON C.id_motivo_contrato = MC.id
GO

/*
**	Consulta para obtener la cantidad de ventas y el monto total generado por cliente,
**	agrupados por el método de pago.
*/
CREATE VIEW ganancia_cliente AS
SELECT
    C.nombre + ' ' + C.apellido_paterno + ' ' + C.apellido_materno AS Cliente,
    FP.forma AS Método_de_Pago,
    COUNT(VC.id) AS Total_de_Ventas,
    SUM(P.precio) AS Monto_Total
FROM ven.venta_cabecera AS VC
JOIN ven.venta_detalle AS VD ON VC.id = VD.id_venta_cabecera AND VC.fecha = VD.fecha_venta
JOIN ven.producto AS P ON VD.id_producto = P.id
JOIN ven.cliente AS C ON VC.id_cliente = C.id
JOIN ven.forma_pago AS FP ON VC.id_forma_pago = FP.id
GROUP BY C.nombre, C.apellido_paterno, C.apellido_materno, FP.forma
GO


--************************************************************************************************
--* VIEWS
--************************************************************************************************

/*
** Vista para mostrar todos los productos de una sucursal 
** cuyo precio supere el precio medio de todos los productos.
*/

CREATE VIEW vw_productos_precio_superior_media AS
SELECT
    SU.nombre AS 'Sucursal',
    P.nombre AS 'Producto',
    P.precio AS 'Precio'
FROM adm.sucursal AS SU
RIGHT JOIN adm.sector AS SE ON SE.id_sucursal = SU.id
RIGHT JOIN ven.producto AS P ON P.id_sector = SE.id
WHERE P.precio > (
    SELECT AVG(precio)
    FROM ven.producto
);
GO


/*
** Vista para obtener los productos de cada tipo que superan
** el precio promedio dentro de su tipo, junto con el cliente
** que realizó la compra y la fecha de la venta.
*/

CREATE VIEW vw_productos_precio_superior_tipo AS
SELECT
    TP.tipo AS 'Tipo de Producto',
    P.nombre AS 'Producto',
    P.precio AS 'Precio',
    C.nombre + ' ' + C.apellido_paterno + ' ' + C.apellido_materno AS 'Cliente',
    VC.fecha AS 'Fecha de Venta'
FROM ven.producto AS P
JOIN ven.tipo_producto AS TP ON P.id_tipo_producto = TP.id
JOIN ven.venta_detalle AS VD ON VD.id_producto = P.id
JOIN ven.venta_cabecera AS VC ON VD.id_venta_cabecera = VC.id
JOIN ven.cliente AS C ON VC.id_cliente = C.id
WHERE P.precio > (
    SELECT AVG(precio)
    FROM ven.producto
    WHERE id_tipo_producto = TP.id
);
GO


/*
** Vista para listar todos los empleados activos junto con su contrato,
** método de pago, rol, y sector correspondiente dentro de la empresa.
*/

CREATE VIEW vw_empleados_activos_contrato AS
SELECT
    emp.dni AS 'DNI',
    emp.codigo AS 'Codigo',
    t_emp.tipo AS 'Rol',
    emp.nombre + ' ' + emp.apellido_materno + ' ' + emp.apellido_paterno AS 'Empleado',
    emp.horas_trabajo AS 'Horas Trabajadas',
    con.descripcion AS 'Contrato',
    m_con.motivo AS 'Motivo Contrato',
    con.monto AS 'Sueldo',
    fg.forma AS 'Metodo Pago',
    sec.nombre AS 'Sector'
FROM adm.empleado AS emp
LEFT JOIN adm.tipo_empleado AS t_emp ON emp.id_tipo_empleado = t_emp.id
LEFT JOIN adm.contrato AS con ON emp.id_contrato = con.id
LEFT JOIN adm.motivo_contrato AS m_con ON con.id_motivo_contrato = m_con.id
LEFT JOIN ven.forma_pago AS fg ON con.id_forma_pago = fg.id
LEFT JOIN adm.sector AS sec ON emp.id_sector = sec.id
GO


/*
** Vista para listar todas las ventas realizadas, mostrando el cliente, 
** productos en la venta, precios y método de pago utilizado.
*/

CREATE VIEW vw_ventas_cliente_producto AS
SELECT
    V.fecha AS 'Fecha de Venta',
    C.nombre + ' ' + C.apellido_materno + ' ' + C.apellido_paterno AS 'Cliente',
    P.nombre AS 'Producto',
    P.precio AS 'Precio',
    FG.forma AS 'Metodo de Pago'
FROM ven.venta_cabecera AS V
RIGHT JOIN ven.venta_detalle AS VD ON VD.id_venta_cabecera = V.id
LEFT JOIN ven.producto AS P ON VD.id_producto = P.id
LEFT JOIN ven.cliente AS C ON V.id_cliente = C.id
LEFT JOIN ven.forma_pago AS FG ON V.id_forma_pago = FG.id;
GO


/*
** Vista para contar la cantidad de sectores en cada sucursal,
** mostrando el nombre de la sucursal, ciudad y dirección.
*/

CREATE VIEW vw_sucursal_sectores AS
SELECT
    S.nombre AS 'Sucursal',
    C.nombre AS 'Ciudad',
    S.direccion AS 'Direccion',
    COUNT(SE.id) AS 'Cantidad Sectores'
FROM adm.sucursal AS S
LEFT JOIN adm.ciudad AS C ON S.id_ciudad = C.id
RIGHT JOIN adm.sector AS SE ON SE.id_sucursal = S.id
WHERE S.estado = 1
GROUP BY S.nombre, C.nombre, S.direccion;
GO


/*
** Vista para mostrar todos los sectores junto con el tipo de sector,
** sucursal correspondiente y los productos con su stock en cada sector.
*/

CREATE VIEW vw_sector_producto_stock AS
SELECT
    S.nombre AS 'Sector',
    TS.tipo AS 'Tipo',
    SU.nombre AS 'Sucursal',
    P.nombre AS 'Producto',
    P.existencias AS 'Stock'
FROM adm.sector AS S
LEFT JOIN adm.tipo_sector AS TS ON S.id_tipo_sector = TS.id
LEFT JOIN adm.sucursal AS SU ON S.id_sucursal = SU.id
RIGHT JOIN ven.producto AS P ON P.id_sector = S.id;
GO


/*
** Vista para determinar la cantidad total de ventas y el promedio de ganancias 
** en cada sucursal.
*/

CREATE VIEW vw_ventas_ganancias_sucursal AS
SELECT
    SU.nombre AS 'Sucursal',
    COUNT(VC.id) AS 'Cantidad Ventas',
    AVG(VD.id_producto) AS 'Ganancias Promedio'
FROM adm.sucursal AS SU
RIGHT JOIN adm.sector AS SE ON SU.id = SE.id_sucursal
RIGHT JOIN ven.producto AS P ON SE.id = P.id_sector
RIGHT JOIN ven.venta_detalle AS VD ON P.id = VD.id_producto
LEFT JOIN ven.venta_cabecera AS VC ON VC.id = VD.id_venta_cabecera
GROUP BY SU.nombre;
GO

/*
** Vista para mostrar todas las empresas asociadas a las sucursales, 
** incluyendo los contratos y sus montos respectivos.
*/

CREATE VIEW vw_empresas_sucursales_contrato AS
SELECT
    SU.nombre AS 'Sucursal',
    EA.nombre AS 'Empresa Asociada',
    C.descripcion AS 'Contrato',
    C.monto AS 'Monto'
FROM adm.sucursal AS SU
RIGHT JOIN adm.empresa_sucursal AS ES ON SU.id = ES.id_sucursal
LEFT JOIN adm.empresa_asociada AS EA ON ES.id_empresa = EA.id
LEFT JOIN adm.contrato AS C ON EA.id_contrato = C.id;
GO

/*
** Vista para listar productos en oferta, junto con el sector, 
** motivo y descuento de cada oferta activa.
*/

CREATE VIEW vw_productos_oferta AS
SELECT
    S.nombre AS 'Sector',
    P.nombre AS 'Producto',
    P.existencias AS 'Existencias',
    O.motivo AS 'Motivo Oferta',
    O.descuento AS 'Descuento (%)'
FROM ven.producto AS P
JOIN adm.sector AS S ON P.id_sector = S.id
JOIN ven.oferta AS O ON P.id_oferta = O.id
GO

/*
** Vista para listar los empleados de una empresa específica, 
** junto con detalles de su contrato y método de pago.
*/

CREATE VIEW vw_empleados_empresa_contrato AS
SELECT
    E.nombre + ' ' + E.apellido_paterno + ' ' + E.apellido_materno AS 'Empleado',
    C.descripcion AS 'Contrato',
    C.fecha_inicio AS 'Fecha de Inicio',
    C.fecha_finalizacion AS 'Fecha de Finalización',
    F.forma AS 'Método de Pago',
    MC.motivo AS 'Motivo del Contrato'
FROM adm.empresa_asociada AS EA
JOIN adm.empleado AS E ON EA.id = E.id_contrato
JOIN adm.contrato AS C ON E.id_contrato = C.id
JOIN ven.forma_pago AS F ON C.id_forma_pago = F.id
JOIN adm.motivo_contrato AS MC ON C.id_motivo_contrato = MC.id
GO

/*
** Vista para listar el total de ventas y el monto total 
** gastado por cada cliente, junto con el método de pago preferido.
*/

CREATE VIEW vw_cliente_ventas_monto AS
SELECT
    C.nombre + ' ' + C.apellido_paterno + ' ' + C.apellido_materno AS Cliente,
    FP.forma AS Método_de_Pago,
    COUNT(VC.id) AS Total_de_Ventas,
    SUM(P.precio) AS Monto_Total
FROM ven.venta_cabecera AS VC
JOIN ven.venta_detalle AS VD ON VC.id = VD.id_venta_cabecera AND VC.fecha = VD.fecha_venta
JOIN ven.producto AS P ON VD.id_producto = P.id
JOIN ven.cliente AS C ON VC.id_cliente = C.id
JOIN ven.forma_pago AS FP ON VC.id_forma_pago = FP.id
GROUP BY C.nombre, C.apellido_paterno, C.apellido_materno, FP.forma;
GO


-- Creando Vista para la seleccion de Contratos

CREATE VIEW vw_contrato AS
select
	C.id, C.fecha_inicio, C.fecha_finalizacion,
	C.descripcion, C.monto, FP.forma, MC.motivo,
	C.estado
from adm.contrato AS C
LEFT JOIN ven.forma_pago AS FP
ON FP.id = C.id_forma_pago
LEFT JOIN adm.motivo_contrato AS MC
ON MC.id = C.id_motivo_contrato
GO

CREATE VIEW vw_ventas_cabecera AS
SELECT
	VC.id,
	VC.fecha,
	FP.forma,
	C.nombre + ' ' + C.apellido_paterno + ' ' + C.apellido_paterno AS cliente
FROM ven.venta_cabecera AS VC
LEFT JOIN ven.cliente AS C
ON C.id = VC.id_cliente
LEFT JOIN ven.forma_pago AS FP
ON FP.id = VC.id_forma_pago
GO

CREATE VIEW vw_venta_detalle AS
SELECT
	VD.id_venta_cabecera,
	P.nombre,
	P.descripcion,
	P.precio
FROM ven.venta_detalle AS VD
LEFT JOIN ven.producto AS P
ON P.id = VD.id_producto
GO