USE bd_supermercado
GO

-- *************************************************************************************************************************
-- * CREANDO TABLAS DE LA BASE DE DATOS
-- *************************************************************************************************************************

CREATE TABLE [adm].persona(
	id INT IDENTITY(1,1) PRIMARY KEY,
	dni VARCHAR(8) UNIQUE NOT NULL,
	nombre NVARCHAR(100) NOT NULL,
	apellido_paterno NVARCHAR(100) NOT NULL,
	apellido_materno NVARCHAR(100) NOT NULL,
	fecha_nacimiento DATE NOT NULL
);

CREATE TABLE [ven].forma_pago(
	id INT IDENTITY(1,1) PRIMARY KEY,
	forma VARCHAR (50) NOT NULL,
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [adm].motivo_contrato(
	id INT IDENTITY(1,1) PRIMARY KEY,
	motivo VARCHAR (100) NOT NULL,
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [adm].contrato(
	id INT IDENTITY(1,1) PRIMARY KEY,
	fecha_inicio DATE NOT NULL,
	fecha_finalizacion DATE NOT NULL,
	descripcion VARCHAR(255) NOT NULL,
	monto DECIMAL(10,2) NOT NULL,
	id_forma_pago INT NOT NULL,
	FOREIGN KEY (id_forma_pago) REFERENCES [ven].forma_pago(id),
	id_motivo_contrato INT NOT NULL,
	FOREIGN KEY (id_motivo_contrato) REFERENCES [adm].motivo_contrato(id),
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [adm].empresa_asociada(
	id INT IDENTITY(1,1) PRIMARY KEY,
	ruc VARCHAR(11) UNIQUE NOT NULL,
	nombre NVARCHAR(100) NOT NULL,
	direccion NVARCHAR(255) UNIQUE NOT NULL,
	id_contrato INT UNIQUE NOT NULL,
	FOREIGN KEY (id_contrato) REFERENCES [adm].contrato(id),
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [adm].telefono(
	id INT IDENTITY(1,1) PRIMARY KEY,
	prefijo NVARCHAR(3) NOT NULL,
	telefono NVARCHAR(9) UNIQUE NOT NULL,
	id_empresa_asociada INT NOT NULL,
	FOREIGN KEY (id_empresa_asociada) REFERENCES [adm].empresa_asociada(id),
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [adm].ciudad(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(100) UNIQUE NOT NULL,
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [adm].sucursal (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    direccion NVARCHAR(255) UNIQUE NOT NULL,
    id_ciudad INT NOT NULL,
	FOREIGN KEY (id_ciudad) REFERENCES [adm].ciudad(id),
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [adm].empresa_sucursal(
	id_empresa INT,
   	id_sucursal INT,
   	PRIMARY KEY (id_empresa, id_sucursal),
   	FOREIGN KEY (id_empresa) REFERENCES [adm].empresa_asociada(id),
   	FOREIGN KEY (id_sucursal) REFERENCES [adm].sucursal(id)
);

CREATE TABLE [adm].tipo_sector(
	id INT IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100) UNIQUE NOT NULL,
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [adm].sector(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre NVARCHAR(100) NOT NULL,
	id_tipo_sector INT NOT NULL,
	FOREIGN KEY (id_tipo_sector) REFERENCES [adm].tipo_sector(id),
	id_sucursal INT NOT NULL,
	FOREIGN KEY (id_sucursal) REFERENCES [adm].sucursal(id),
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [adm].tipo_empleado(
	id INT IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(100) UNIQUE NOT NULL,
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [adm].empleado(
	id INT IDENTITY(1,1) PRIMARY KEY,
	codigo VARCHAR(50) UNIQUE NOT NULL,
	id_persona INT NOT NULL,
	FOREIGN KEY (id_persona) REFERENCES [adm].persona(id),
	horas_trabajo DECIMAL(10, 2) NOT NULL,
	id_tipo_empleado INT NOT NULL,
	FOREIGN KEY (id_tipo_empleado) REFERENCES [adm].tipo_empleado(id),
	id_supervisor INT,
	FOREIGN KEY (id_supervisor) REFERENCES [adm].empleado(id),
	id_contrato INT UNIQUE NOT NULL,
	FOREIGN KEY (id_contrato) REFERENCES [adm].contrato(id),
	id_sector INT NOT NULL,
	FOREIGN KEY (id_sector) REFERENCES [adm].sector(id),
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [ven].tipo_cliente(
	id INT IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(50) UNIQUE NOT NULL,
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [ven].cliente(
	id INT IDENTITY(1,1) PRIMARY KEY,
	id_persona INT UNIQUE NOT NULL,
	FOREIGN KEY (id_persona) REFERENCES [adm].persona(id),
	id_tipo_cliente INT NOT NULL,
	FOREIGN KEY (id_tipo_cliente) REFERENCES [ven].tipo_cliente(id),
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [ven].tipo_producto (
	id INT IDENTITY(1,1) PRIMARY KEY,
	tipo NVARCHAR(50),
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [ven].marca_producto (
	id INT IDENTITY(1,1) PRIMARY KEY,
	marca NVARCHAR(50) NOT NULL,
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [ven].unidad_medida(
	id INT IDENTITY(1,1) PRIMARY KEY,
	unidad VARCHAR(10) NOT NULL,
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [ven].oferta(
	id INT IDENTITY(1,1) PRIMARY KEY,
	motivo VARCHAR(100) UNIQUE NOT NULL,
	descuento DECIMAL(5,2) NOT NULL,
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [ven].producto (
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	descripcion NVARCHAR(255) NOT NULL,
   	precio DECIMAL(10, 2) NOT NULL,
	fecha_creacion DATE NOT NULL,
    fecha_vencimiento DATE,
	contenido_neto DECIMAL(10, 2),
	existencias INT NOT NULL,
	id_tipo_producto INT NOT NULL,
	FOREIGN KEY (id_tipo_producto) REFERENCES [ven].tipo_producto(id),
	id_marca INT NOT NULL,
	FOREIGN KEY (id_marca) REFERENCES [ven].marca_producto(id),
	id_unidad_medida INT,
	FOREIGN KEY (id_unidad_medida) REFERENCES [ven].unidad_medida(id),
	id_oferta INT,
	FOREIGN KEY (id_oferta) REFERENCES [ven].oferta(id),
	id_sector INT NOT NULL,
	FOREIGN KEY (id_sector) REFERENCES [adm].sector(id),
	flag BIT NOT NULL DEFAULT 1
);

CREATE TABLE [ven].estado_venta(
	id INT IDENTITY (1,1) PRIMARY KEY,
	estado NVARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE [ven].banco(
	id INT IDENTITY (1,1) PRIMARY KEY,
	nombre NVARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE [ven].transaccion(
	id INT IDENTITY (1,1) PRIMARY KEY,
	tarjeta NVARCHAR(16) NOT NULL,
	id_banco INT NOT NULL,
	FOREIGN KEY (id_banco) REFERENCES [ven].banco(id)
);

CREATE TABLE [ven].venta_cabecera(
	id INT IDENTITY (1,1),
	fecha DATE NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY (id, fecha),
	fecha_cancelacion DATE NOT NULL,
	flag BIT NOT NULL DEFAULT 1,
	id_transaccion INT,
	FOREIGN KEY(id_transaccion) REFERENCES [ven].transaccion(id),
	id_estado_venta INT NOT NULL,
	FOREIGN KEY (id_estado_venta) REFERENCES [ven].estado_venta(id),
	id_forma_pago INT NOT NULL,
	FOREIGN KEY (id_forma_pago) REFERENCES [ven].forma_pago(id),
	id_cliente INT NOT NULL,
	FOREIGN KEY (id_cliente) REFERENCES [ven].cliente(id)
) ON partir_por_anio(fecha);


CREATE TABLE [ven].venta_detalle(
	id_venta_cabecera INT NOT NULL,
	fecha_venta DATE NOT NULL DEFAULT GETDATE(),
	flag BIT NOT NULL DEFAULT 1,
	id_producto INT NOT NULL,
	FOREIGN KEY (id_venta_cabecera, fecha_venta) REFERENCES [ven].venta_cabecera(id, fecha),
	FOREIGN KEY (id_producto) REFERENCES [ven].producto(id),
	PRIMARY KEY (id_venta_cabecera, fecha_venta, id_producto)
)ON partir_por_anio(fecha_venta);


CREATE TABLE [sec].rol(
	id INT IDENTITY(1,1) PRIMARY KEY,
	rol NVARCHAR(100) NOT NULL,
	flag BIT NOT NULL DEFAULT 1
);


CREATE TABLE [sec].usuario(
	id INT IDENTITY(1,1) PRIMARY KEY,
	codigo NVARCHAR(50) UNIQUE NOT NULL,
	id_persona INT UNIQUE NOT NULL,
	FOREIGN KEY (id_persona) REFERENCES [adm].persona(id),
	correo NVARCHAR(200) NOT NULL,
	contrasena NVARCHAR(100) NOT NULL,
	flag BIT NOT NULL,
	id_rol INT NOT NULL,
	FOREIGN KEY (id_rol) REFERENCES [sec].rol(id)
);

CREATE TABLE [sec].log_procesos (
	id INT IDENTITY(1,1) PRIMARY KEY,
	motivo NVARCHAR(100) NOT NULL,
	descripcion NVARCHAR(255) NOT NULL,
	fecha DATETIME NOT NULL,
	id_usuario INT NOT NULL,
	FOREIGN KEY(id_usuario) REFERENCES [sec].usuario(id)
);

-- *************************************************************************************************************************
-- * CREANDO INDICES DE LAS TABLAS DE LA BASE DE DATOS
-- *************************************************************************************************************************

CREATE INDEX idx_cliente_tipo ON [ven].cliente(id_tipo_cliente);
GO

CREATE INDEX idx_contrato_forma_pago ON [adm].contrato(id_forma_pago);
GO

CREATE INDEX idx_contrato_motivo ON [adm].contrato(id_motivo_contrato);
GO

CREATE INDEX idx_empleado_sector ON [adm].empleado(id_sector);
GO

CREATE INDEX idx_cliente_id ON [ven].cliente(id);
GO

CREATE INDEX idx_producto_marca ON [ven].producto(id_marca);
GO

CREATE INDEX idx_producto_sector ON [ven].producto(id_sector);
GO

CREATE INDEX idx_usuario_codigo ON [sec].usuario(codigo);
GO

CREATE INDEX idx_venta_cabecera_id ON [ven].venta_cabecera(id);
GO

CREATE INDEX idx_contrato_fecha_inicio ON [adm].contrato(fecha_inicio);
GO

CREATE INDEX idx_producto_precio_sector ON [ven].producto(precio, id_sector);
GO

CREATE INDEX idx_venta_detalle_id_fecha ON [ven].venta_detalle(id_venta_cabecera, fecha_venta);
GO
