if object_id('SELECT_QUANTUM_LIBRARY.Tipo_Habitacion') is not null
	drop PROCEDURE SELECT_QUANTUM_LIBRARY.Tipo_Habitacion;
if object_id('SELECT_QUANTUM_LIBRARY.Tipo_Butaca') is not null
	drop PROCEDURE SELECT_QUANTUM_LIBRARY.Tipo_Butaca;
if object_id('SELECT_QUANTUM_LIBRARY.Ruta_Aerea') is not null
	drop PROCEDURE SELECT_QUANTUM_LIBRARY.Ruta_Aerea;
if object_id('SELECT_QUANTUM_LIBRARY.Avion') is not null
	drop PROCEDURE SELECT_QUANTUM_LIBRARY.Avion;
if object_id('SELECT_QUANTUM_LIBRARY.Butaca') is not null
	drop PROCEDURE SELECT_QUANTUM_LIBRARY.Butaca;
if object_id('SELECT_QUANTUM_LIBRARY.Sucursal') is not null
	drop PROCEDURE SELECT_QUANTUM_LIBRARY.Sucursal;
if object_id('SELECT_QUANTUM_LIBRARY.Cliente') is not null
	drop PROCEDURE SELECT_QUANTUM_LIBRARY.Cliente;
if object_id('SELECT_QUANTUM_LIBRARY.Hotel') is not null
	drop PROCEDURE SELECT_QUANTUM_LIBRARY.Hotel;
if object_id('SELECT_QUANTUM_LIBRARY.Habitacion') is not null
	drop PROCEDURE SELECT_QUANTUM_LIBRARY.Habitacion;
if object_id('SELECT_QUANTUM_LIBRARY.Vuelo') is not null
	drop PROCEDURE SELECT_QUANTUM_LIBRARY.Vuelo;
if object_id('SELECT_QUANTUM_LIBRARY.Compra') is not null
	drop PROCEDURE SELECT_QUANTUM_LIBRARY.Compra;
if object_id('SELECT_QUANTUM_LIBRARY.Nota_De_Venta') is not null
	drop PROCEDURE SELECT_QUANTUM_LIBRARY.Nota_De_Venta;
if object_id('SELECT_QUANTUM_LIBRARY.Pasaje') is not null
	drop PROCEDURE SELECT_QUANTUM_LIBRARY.Pasaje;
if object_id('SELECT_QUANTUM_LIBRARY.Estadia') is not null
	drop PROCEDURE SELECT_QUANTUM_LIBRARY.Estadia;


DROP SCHEMA SELECT_QUANTUM_LIBRARY;
GO
USE [GD1C2020]
GO
CREATE SCHEMA [SELECT_QUANTUM_LIBRARY]
GO

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Tipo_Habitacion](
[codigo] [int] IDENTITY(1,1),
[descripcion] [nvarchar] (255) NOT NULL,
PRIMARY KEY(codigo)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Tipo_Butaca](
[codigo] [int] IDENTITY(1,1),
[descripcion] [nvarchar] (255) NOT NULL,
PRIMARY KEY(codigo)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Ruta_Aerea](
[id_ruta_aerea] [int] IDENTITY(1,1),
[ciudad_origen] [nvarchar] (255) NOT NULL,
[ciudad_destino] [nvarchar] (255) NOT NULL,
PRIMARY KEY(id_ruta_aerea)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Avion](
[id_avion] [int] IDENTITY(1,1),
[modelo] [nvarchar] (255) NOT NULL,
PRIMARY KEY(id_avion)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Butaca](
[id_butaca] [int] IDENTITY(1,1),
[tipo_de_butaca] [nvarchar] (255) NOT NULL,
[numero] [int] NOT NULL,
FOREIGN KEY (id_butaca) REFERENCES [SELECT_QUANTUM_LIBRARY].[Tipo_Butaca](codigo),
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
[DNI] [int] IDENTITY(1,1),
[nombre] [nvarchar](255) NOT NULL,
[apellido] [nvarchar](255) NOT NULL,
[mail] [nvarchar](255),
[telefono] [int],
[fecha_de_nacimiento] [date] NOT NULL
PRIMARY KEY (DNI)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Hotel](
[id_hotel] [int] IDENTITY(1,1),
[calle] [nvarchar] (255) NOT NULL,
[nro_calle] [int] NOT NULL,
[cantidad_estrellas] [int] NOT NULL
PRIMARY KEY(id_hotel)
);


CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Habitacion](
[id_habitacion] [int] IDENTITY(1,1),
[piso] [int] NOT NULL,
[numero][int] NOT NULL,
[id_estadia] [int] NOT NULL, -- ES FK
[tipo] [int] NOT NULL, 
[frente] [nvarchar] (255) NOT NULL, 
[costo_compra] [int] NOT NULL,
[precio_venta] [int] NOT NULL
FOREIGN KEY(tipo) REFERENCES [SELECT_QUANTUM_LIBRARY].[Tipo_Habitacion](codigo) 
PRIMARY KEY(id_habitacion)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Vuelo](
[codigo_vuelo] [int] IDENTITY(1,1),
[fecha_llegada] [date] NOT NULL,
[fecha_salida] [date] NOT NULL,
[id_ruta_aerea] [int] NOT NULL,
[id_avion] [int] NOT NULL,
FOREIGN KEY(id_ruta_aerea) REFERENCES [SELECT_QUANTUM_LIBRARY].[Ruta_Aerea],
FOREIGN KEY(id_avion) REFERENCES [SELECT_QUANTUM_LIBRARY].[Avion],
PRIMARY KEY (codigo_vuelo)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Compra](
[numero] [int] IDENTITY(1,1),
[fecha] [date] NOT NULL,
[empresa] [nvarchar] (255),
[costo_total] [int] NOT NULL,
PRIMARY KEY (numero)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Nota_De_Venta](
[id_nota_de_venta][int]IDENTITY(1,1),
[id_cliente][int] NOT NULL,
[id_sucursal] [int] NOT NULL,
[fecha_de_salida] [date] NOT NULL,
[id_butaca] [int] NOT NULL,
[precio_total] [int] NOT NULL,
FOREIGN KEY (id_cliente) REFERENCES[SELECT_QUANTUM_LIBRARY].[Cliente](DNI),
FOREIGN KEY (id_sucursal) REFERENCES[SELECT_QUANTUM_LIBRARY].[Sucursal](id_sucursal),
PRIMARY KEY (id_nota_de_venta)
);

CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Pasaje](
[codigo_pasaje] [int] IDENTITY(1,1),
[codigo_vuelo] [int] NOT NULL,
[precio_venta] [int] NOT NULL,
[costo_compra] [int] NOT NULL,
[fecha_compra] [date] NOT NULL,
[id_butaca] [int] NOT NULL,
[id_compra] [int] NOT NULL,
FOREIGN KEY(codigo_vuelo) REFERENCES [SELECT_QUANTUM_LIBRARY].[Vuelo](codigo_vuelo),
FOREIGN KEY(costo_compra) REFERENCES [SELECT_QUANTUM_LIBRARY].[Compra](numero),
FOREIGN KEY(id_butaca) REFERENCES [SELECT_QUANTUM_LIBRARY].[Butaca](id_butaca),
FOREIGN KEY(id_compra) REFERENCES [SELECT_QUANTUM_LIBRARY].[Nota_De_Venta](id_nota_de_venta),
PRIMARY KEY(codigo_pasaje)
);


CREATE TABLE [SELECT_QUANTUM_LIBRARY].[Estadia](
[codigo] [int] IDENTITY(1,1),
[fecha_inicio] [date] NOT NULL,
[cantidad_noches] [int] NOT NULL,
[id_compra] [int] NOT NULL,
[id_hotel] [int] NOT NULL,
[id_nota_de_venta] [int] NOT NULL,
[precio_final] [int] NOT NULL,
FOREIGN KEY(id_compra) REFERENCES [SELECT_QUANTUM_LIBRARY].[Compra](numero),
FOREIGN KEY(id_hotel) REFERENCES [SELECT_QUANTUM_LIBRARY].[Hotel](id_hotel),
FOREIGN KEY(id_nota_de_venta) REFERENCES [SELECT_QUANTUM_LIBRARY].[Nota_De_Venta](id_nota_de_venta),
PRIMARY KEY (codigo) 
);



