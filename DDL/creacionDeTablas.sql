USE GD1C2020;

if object_id('SELECT_QUANTUM_LIBRARY.Dia_Reservado') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Dia_Reservado;
if object_id('SELECT_QUANTUM_LIBRARY.Estadia') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Estadia;
if object_id('SELECT_QUANTUM_LIBRARY.Pasaje') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Pasaje;
if object_id('SELECT_QUANTUM_LIBRARY.Nota_De_Venta') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Nota_De_Venta;
if object_id('SELECT_QUANTUM_LIBRARY.Compra') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Compra;
if object_id('SELECT_QUANTUM_LIBRARY.Empresa') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Empresa;
if object_id('SELECT_QUANTUM_LIBRARY.Ruta_Aerea') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Ruta_Aerea;
if object_id('SELECT_QUANTUM_LIBRARY.Ciudad') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Ciudad;
if object_id('SELECT_QUANTUM_LIBRARY.Vuelo') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Vuelo;
if object_id('SELECT_QUANTUM_LIBRARY.Habitacion') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Habitacion;
if object_id('SELECT_QUANTUM_LIBRARY.Hotel') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Hotel;
if object_id('SELECT_QUANTUM_LIBRARY.Cliente') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Cliente;
if object_id('SELECT_QUANTUM_LIBRARY.Sucursal') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Sucursal;
if object_id('SELECT_QUANTUM_LIBRARY.Butaca') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Butaca;
if object_id('SELECT_QUANTUM_LIBRARY.Avion') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Avion;
if object_id('SELECT_QUANTUM_LIBRARY.Tipo_Butaca') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Tipo_Butaca;
if object_id('SELECT_QUANTUM_LIBRARY.Tipo_Habitacion') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Tipo_Habitacion;

DROP SCHEMA SELECT_QUANTUM_LIBRARY;
GO
USE [GD1C2020]
GO
CREATE SCHEMA [SELECT_QUANTUM_LIBRARY]
GO

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Tipo_Habitacion](
[codigo] [int],
[descripcion] [nvarchar] (255) NOT NULL,
PRIMARY KEY(codigo)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Tipo_Butaca](
[codigo] [int] IDENTITY(1,1) ,
[descripcion] [nvarchar] (255) NOT NULL,
PRIMARY KEY(codigo)
);


CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Avion](
[id_avion] [nvarchar] (255) NOT NULL,
[modelo] [nvarchar] (255) NOT NULL,
PRIMARY KEY(id_avion)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Butaca](
[id_butaca] [int] IDENTITY(1,1),
[tipo_de_butaca] [int] NOT NULL,
[numero] [int] NOT NULL,
[id_avion] [nvarchar] (255) NOT NULL
FOREIGN KEY (tipo_de_butaca) REFERENCES [SELECT_QUANTUM_LIBRARY].[Tipo_Butaca](codigo),
FOREIGN KEY (id_avion) REFERENCES [SELECT_QUANTUM_LIBRARY].[Avion](id_avion),
PRIMARY KEY(id_butaca)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Sucursal](
[id_sucursal] [int] IDENTITY(1,1),
[mail] [nvarchar] (255),
[direccion] [nvarchar] (255) NOT NULL,
[telefono] [int] ,
PRIMARY KEY (id_sucursal)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Cliente](
[id_cliente] [int] IDENTITY(1,1),
[DNI] [int] NOT NULL,
[nombre] [nvarchar](255) NOT NULL,
[apellido] [nvarchar](255) NOT NULL,
[mail] [nvarchar](255),
[telefono] [int],
[fecha_de_nacimiento] [date] NOT NULL
PRIMARY KEY (id_cliente)
);

CREATE INDEX IX_Cliente_DNI ON [SELECT_QUANTUM_LIBRARY].[Cliente] (DNI) WHERE DNI IS NOT NULL
CREATE INDEX IX_Cliente_Mail ON [SELECT_QUANTUM_LIBRARY].[Cliente] (mail) WHERE mail IS NOT NULL


CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Hotel](
[id_hotel] [int] IDENTITY(1,1),
[calle] [nvarchar] (255) NOT NULL,
[nro_calle] [int] NOT NULL,
[cantidad_estrellas] [int] NOT NULL
PRIMARY KEY(id_hotel)
);


CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Habitacion](
[id_habitacion] [int] IDENTITY(1,1),
[id_hotel] [int] not NULL,
[piso] [int] NOT NULL,
[numero][int] NOT NULL,
[tipo] [int] NOT NULL, 
[frente] [nvarchar] (255) NOT NULL, 
FOREIGN KEY(id_hotel) REFERENCES [SELECT_QUANTUM_LIBRARY].[Hotel](id_hotel),
FOREIGN KEY(tipo) REFERENCES [SELECT_QUANTUM_LIBRARY].[Tipo_Habitacion](codigo),
PRIMARY KEY(id_habitacion)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Vuelo](
[codigo_vuelo] [int],
[fecha_llegada] [date] NOT NULL,
[fecha_salida] [date] NOT NULL,
[id_avion] [nvarchar] (255) NOT NULL,
FOREIGN KEY(id_avion) REFERENCES [SELECT_QUANTUM_LIBRARY].[Avion],
PRIMARY KEY (codigo_vuelo)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Ciudad](
[id_ciudad] [int] IDENTITY(1,1),
[nombre] [nvarchar] (255) NOT NULL,
PRIMARY KEY(id_ciudad)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Ruta_Aerea](
[id_ruta_aerea] [int] IDENTITY(1,1),
[codigo_ruta_aerea] [int],
[ciudad_origen] [int] NOT NULL,
[ciudad_destino] [int] NOT NULL,
[id_vuelo] [int] NOT NULL,
FOREIGN KEY (id_vuelo) REFERENCES [SELECT_QUANTUM_LIBRARY].[Vuelo](codigo_vuelo),
FOREIGN KEY (ciudad_origen) REFERENCES [SELECT_QUANTUM_LIBRARY].[Ciudad](id_ciudad),
FOREIGN KEY (ciudad_destino) REFERENCES [SELECT_QUANTUM_LIBRARY].[Ciudad](id_ciudad),
PRIMARY KEY(id_ruta_aerea)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Empresa](
[id_empresa] [int] IDENTITY(1,1),
[nombre] [nvarchar] (255) NOT NULL,
PRIMARY KEY(id_empresa)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Compra](
[id_compra][int] IDENTITY(1,1),
[numero_compra][int] NOT NULL,
[fecha] [date] NOT NULL,
[id_empresa][int] NOT NULL,
[costo_total][int] NOT NULL,
FOREIGN KEY (id_empresa) REFERENCES[SELECT_QUANTUM_LIBRARY].[Empresa](id_empresa),
PRIMARY KEY (id_compra)
)



CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Nota_De_Venta](
[id_nota_de_venta][int]IDENTITY(1,1),
[numero_venta] [int] NOT NULL,
[id_cliente] [int] NOT NULL,
[id_sucursal] [int] NOT NULL,
[fecha] [date] NOT NULL,
[precio_total] [int] NOT NULL,
FOREIGN KEY (id_cliente) REFERENCES[SELECT_QUANTUM_LIBRARY].[Cliente](id_cliente),
FOREIGN KEY (id_sucursal) REFERENCES[SELECT_QUANTUM_LIBRARY].[Sucursal](id_sucursal),
PRIMARY KEY (id_nota_de_venta)
)

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Pasaje](
[codigo_pasaje] [int],
[codigo_vuelo] [int] NOT NULL,
[fecha_compra] [date] NOT NULL,
[id_butaca] [int] NOT NULL,
[id_compra] [int] NOT NULL,
[costo_compra] [int] NOT NULL,
[id_nota_de_venta] [int],
[precio_venta] [int] NOT NULL,
FOREIGN KEY(codigo_vuelo) REFERENCES [SELECT_QUANTUM_LIBRARY].[Vuelo](codigo_vuelo),
FOREIGN KEY(id_butaca) REFERENCES [SELECT_QUANTUM_LIBRARY].[Butaca](id_butaca),
FOREIGN KEY(id_compra) REFERENCES [SELECT_QUANTUM_LIBRARY].[Compra](id_compra),
FOREIGN KEY(id_nota_de_venta) REFERENCES [SELECT_QUANTUM_LIBRARY].[Nota_De_Venta](id_nota_de_venta),
PRIMARY KEY(codigo_pasaje)
);


CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Estadia](
[id_estadia] [int] IDENTITY(1,1),
[codigo] [int] NOT NULL,
[fecha_inicio] [date] NOT NULL,
[cantidad_noches] [int] NOT NULL,
[id_habitacion] [int] NOT NULL,
[precio_final] [int] NOT NULL,
[id_compra] [int] NOT NULL,
[costo_compra_total] [int] NOT NULL,
[id_nota_de_venta] [int],
FOREIGN KEY(id_habitacion) REFERENCES [SELECT_QUANTUM_LIBRARY].[Habitacion](id_habitacion),
FOREIGN KEY(id_compra) REFERENCES [SELECT_QUANTUM_LIBRARY].[Compra](id_compra),
FOREIGN KEY(id_nota_de_venta) REFERENCES [SELECT_QUANTUM_LIBRARY].[Nota_De_Venta](id_nota_de_venta),
PRIMARY KEY (id_estadia) 
);

