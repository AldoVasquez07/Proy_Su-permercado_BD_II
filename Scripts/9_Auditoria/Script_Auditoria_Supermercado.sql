USE [master]
GO

CREATE SERVER AUDIT [Auditoria_Ventas]
TO FILE 
(	FILEPATH = N'C:\BD_AUDIT\'
	,MAXSIZE = 0 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
) WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE, AUDIT_GUID = '4c185ba4-baf5-4ce8-9d8b-6252e407f925')
ALTER SERVER AUDIT [Auditoria_Ventas] WITH (STATE = ON)
GO

CREATE SERVER AUDIT [Auditoria_Personal]
TO FILE 
(	FILEPATH = N'C:\BD_AUDIT\'
	,MAXSIZE = 0 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
) WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE, AUDIT_GUID = '3741d81b-8d12-48f5-b8ea-e40e8e182996')
ALTER SERVER AUDIT [Auditoria_Personal] WITH (STATE = ON)
GO

CREATE SERVER AUDIT [Auditoria_Productos]
TO FILE 
(	FILEPATH = N'C:\BD_AUDIT\'
	,MAXSIZE = 0 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
) WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE, AUDIT_GUID = 'd96c279c-3ff7-41f1-bb1e-83d600bfa852')
ALTER SERVER AUDIT [Auditoria_Productos] WITH (STATE = ON)
GO

USE bd_supermercado
GO

CREATE DATABASE AUDIT SPECIFICATION [VentasAuditoria]
FOR SERVER AUDIT [Auditoria_Ventas]
ADD (DELETE ON OBJECT::[ven].[venta_cabecera] BY [dbo]),
ADD (INSERT ON OBJECT::[ven].[venta_cabecera] BY [dbo]),
ADD (SELECT ON OBJECT::[ven].[venta_cabecera] BY [dbo]),
ADD (UPDATE ON OBJECT::[ven].[venta_cabecera] BY [dbo]),
ADD (DELETE ON OBJECT::[ven].[venta_detalle] BY [dbo]),
ADD (INSERT ON OBJECT::[ven].[venta_detalle] BY [dbo]),
ADD (SELECT ON OBJECT::[ven].[venta_detalle] BY [dbo]),
ADD (UPDATE ON OBJECT::[ven].[venta_detalle] BY [dbo]),
ADD (DELETE ON OBJECT::[ven].[transaccion] BY [dbo]),
ADD (INSERT ON OBJECT::[ven].[transaccion] BY [dbo]),
ADD (SELECT ON OBJECT::[ven].[transaccion] BY [dbo]),
ADD (UPDATE ON OBJECT::[ven].[transaccion] BY [dbo]),
ADD (DELETE ON OBJECT::[ven].[banco] BY [dbo]),
ADD (INSERT ON OBJECT::[ven].[banco] BY [dbo]),
ADD (SELECT ON OBJECT::[ven].[banco] BY [dbo]),
ADD (UPDATE ON OBJECT::[ven].[banco] BY [dbo]),
ADD (DELETE ON OBJECT::[ven].[cliente] BY [dbo]),
ADD (INSERT ON OBJECT::[ven].[cliente] BY [dbo]),
ADD (SELECT ON OBJECT::[ven].[cliente] BY [dbo]),
ADD (UPDATE ON OBJECT::[ven].[cliente] BY [dbo]),
ADD (DELETE ON OBJECT::[ven].[estado_venta] BY [dbo]),
ADD (INSERT ON OBJECT::[ven].[estado_venta] BY [dbo]),
ADD (SELECT ON OBJECT::[ven].[estado_venta] BY [dbo]),
ADD (UPDATE ON OBJECT::[ven].[estado_venta] BY [dbo])
WITH (STATE = ON)
GO

CREATE DATABASE AUDIT SPECIFICATION [EmpleadosAuditoria]
FOR SERVER AUDIT [Auditoria_Personal]
ADD (DELETE ON OBJECT::[adm].[motivo_contrato] BY [dbo]),
ADD (INSERT ON OBJECT::[adm].[motivo_contrato] BY [dbo]),
ADD (SELECT ON OBJECT::[adm].[motivo_contrato] BY [dbo]),
ADD (UPDATE ON OBJECT::[adm].[motivo_contrato] BY [dbo]),
ADD (DELETE ON OBJECT::[adm].[contrato] BY [dbo]),
ADD (INSERT ON OBJECT::[adm].[contrato] BY [dbo]),
ADD (SELECT ON OBJECT::[adm].[contrato] BY [dbo]),
ADD (UPDATE ON OBJECT::[adm].[contrato] BY [dbo]),
ADD (DELETE ON OBJECT::[adm].[tipo_empleado] BY [dbo]),
ADD (INSERT ON OBJECT::[adm].[tipo_empleado] BY [dbo]),
ADD (SELECT ON OBJECT::[adm].[tipo_empleado] BY [dbo]),
ADD (UPDATE ON OBJECT::[adm].[tipo_empleado] BY [dbo]),
ADD (DELETE ON OBJECT::[adm].[empleado] BY [dbo]),
ADD (INSERT ON OBJECT::[adm].[empleado] BY [dbo]),
ADD (SELECT ON OBJECT::[adm].[empleado] BY [dbo]),
ADD (UPDATE ON OBJECT::[adm].[empleado] BY [dbo])
WITH (STATE = ON)
GO


CREATE DATABASE AUDIT SPECIFICATION [ProductosAuditoria]
FOR SERVER AUDIT [Auditoria_Productos]
ADD (DELETE ON OBJECT::[ven].[oferta] BY [dbo]),
ADD (INSERT ON OBJECT::[ven].[oferta] BY [dbo]),
ADD (SELECT ON OBJECT::[ven].[oferta] BY [dbo]),
ADD (UPDATE ON OBJECT::[ven].[oferta] BY [dbo]),
ADD (DELETE ON OBJECT::[ven].[unidad_medida] BY [dbo]),
ADD (INSERT ON OBJECT::[ven].[unidad_medida] BY [dbo]),
ADD (SELECT ON OBJECT::[ven].[unidad_medida] BY [dbo]),
ADD (UPDATE ON OBJECT::[ven].[unidad_medida] BY [dbo]),
ADD (DELETE ON OBJECT::[ven].[tipo_producto] BY [dbo]),
ADD (INSERT ON OBJECT::[ven].[tipo_producto] BY [dbo]),
ADD (SELECT ON OBJECT::[ven].[tipo_producto] BY [dbo]),
ADD (UPDATE ON OBJECT::[ven].[tipo_producto] BY [dbo]),
ADD (DELETE ON OBJECT::[ven].[marca_producto] BY [dbo]),
ADD (INSERT ON OBJECT::[ven].[marca_producto] BY [dbo]),
ADD (SELECT ON OBJECT::[ven].[marca_producto] BY [dbo]),
ADD (UPDATE ON OBJECT::[ven].[marca_producto] BY [dbo]),
ADD (DELETE ON OBJECT::[ven].[producto] BY [dbo]),
ADD (INSERT ON OBJECT::[ven].[producto] BY [dbo]),
ADD (SELECT ON OBJECT::[ven].[producto] BY [dbo]),
ADD (UPDATE ON OBJECT::[ven].[producto] BY [dbo])
WITH (STATE = ON)
GO