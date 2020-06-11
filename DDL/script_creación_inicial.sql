USE GD1C2020;
GO

-- Se crea el Schema 
CREATE SCHEMA SELECT_QUANTUM_LIBRARY;
GO

-- Se realiza la creacion de las tablas necesarias para la migracion
-- Se crea la tabla tipo_habitacion
CREATE TABLE SELECT_QUANTUM_LIBRARY.Tipo_Habitacion (
codigo INT NOT NULL,
descripcion NVARCHAR (255) NOT NULL,
PRIMARY KEY (codigo)
);
--Se crea la tabla Tipo_Butaca
CREATE TABLE SELECT_QUANTUM_LIBRARY.Tipo_Butaca (
codigo INT IDENTITY (1,1),
descripcion NVARCHAR (255) NOT NULL,
PRIMARY KEY (codigo)
);
--Se crea la tabla Avion
CREATE TABLE SELECT_QUANTUM_LIBRARY.Avion (
id_avion NVARCHAR (255) NOT NULL,
modelo NVARCHAR (255) NOT NULL,
PRIMARY KEY (id_avion)
);

--Se crea la tabla Butaca
CREATE TABLE SELECT_QUANTUM_LIBRARY.Butaca (
id_butaca INT IDENTITY(1,1),
tipo_de_butaca INT NOT NULL,
numero INT NOT NULL,
id_avion NVARCHAR (255) NOT NULL
FOREIGN KEY (tipo_de_butaca) REFERENCES SELECT_QUANTUM_LIBRARY.Tipo_Butaca (codigo),
FOREIGN KEY (id_avion) REFERENCES SELECT_QUANTUM_LIBRARY.Avion (id_avion),
PRIMARY KEY (id_butaca)
);

--Se crea la tabla Sucursal
CREATE TABLE SELECT_QUANTUM_LIBRARY.Sucursal (
id_sucursal INT IDENTITY (1,1),
mail NVARCHAR (255) NOT NULL,
direccion NVARCHAR (255) NOT NULL,
telefono INT NOT NULL,
PRIMARY KEY (id_sucursal)
);

--Se crea la tabla Cliente
CREATE TABLE SELECT_QUANTUM_LIBRARY.Cliente (
id_cliente INT IDENTITY (1,1),
DNI INT NOT NULL,
nombre NVARCHAR (255) NOT NULL,
apellido NVARCHAR (255) NOT NULL,
mail NVARCHAR (255) NOT NULL,
telefono INT NOT NULL,
fecha_de_nacimiento DATE NOT NULL
PRIMARY KEY (id_cliente)
);

--Se crea la tabla Hotel
CREATE TABLE SELECT_QUANTUM_LIBRARY.Hotel (
id_hotel INT IDENTITY (1,1),
calle NVARCHAR (255) NOT NULL,
nro_calle INT NOT NULL,
cantidad_estrellas INT NOT NULL
PRIMARY KEY (id_hotel)
);

--Se crea la tabla Habitacion
CREATE TABLE SELECT_QUANTUM_LIBRARY.Habitacion (
id_habitacion INT IDENTITY (1,1),
id_hotel INT NOT NULL,
piso INT NOT NULL,
numero INT NOT NULL,
tipo INT NOT NULL,
frente NVARCHAR (255) NOT NULL, 
FOREIGN KEY (id_hotel) REFERENCES SELECT_QUANTUM_LIBRARY.Hotel (id_hotel),
FOREIGN KEY (tipo) REFERENCES SELECT_QUANTUM_LIBRARY.Tipo_Habitacion (codigo),
PRIMARY KEY (id_habitacion)
);

--Se crea la tabla Vuelo
CREATE TABLE SELECT_QUANTUM_LIBRARY.Vuelo (
codigo_vuelo INT NOT NULL,
fecha_llegada DATE NOT NULL,
fecha_salida DATE NOT NULL,
id_avion NVARCHAR (255) NOT NULL,
FOREIGN KEY (id_avion) REFERENCES SELECT_QUANTUM_LIBRARY.Avion,
PRIMARY KEY (codigo_vuelo)
);

--Se crea la tabla Ciudad
CREATE TABLE SELECT_QUANTUM_LIBRARY.Ciudad (
id_ciudad INT IDENTITY (1,1),
nombre NVARCHAR (255) NOT NULL,
PRIMARY KEY (id_ciudad)
);

--Se crea la tabla Ruta_Aerea
CREATE TABLE SELECT_QUANTUM_LIBRARY.Ruta_Aerea (
id_ruta_aerea INT IDENTITY (1,1),
codigo_ruta_aerea INT NOT NULL,
ciudad_origen INT NOT NULL,
ciudad_destino INT NOT NULL,
id_vuelo INT NOT NULL,
FOREIGN KEY (id_vuelo) REFERENCES SELECT_QUANTUM_LIBRARY.Vuelo (codigo_vuelo),
FOREIGN KEY (ciudad_origen) REFERENCES SELECT_QUANTUM_LIBRARY.Ciudad (id_ciudad),
FOREIGN KEY (ciudad_destino) REFERENCES SELECT_QUANTUM_LIBRARY.Ciudad (id_ciudad),
PRIMARY KEY (id_ruta_aerea)
);

--Se crea la tabla Empresa
CREATE TABLE SELECT_QUANTUM_LIBRARY.Empresa (
id_empresa INT IDENTITY (1,1),
nombre NVARCHAR (255) NOT NULL,
PRIMARY KEY (id_empresa)
);

--Se crea la tabla Compra
CREATE TABLE SELECT_QUANTUM_LIBRARY.Compra (
id_compra INT IDENTITY (1,1),
numero_compra INT NOT NULL,
fecha DATE NOT NULL,
id_empresa INT NOT NULL,
costo_total INT NOT NULL,
FOREIGN KEY (id_empresa) REFERENCES SELECT_QUANTUM_LIBRARY.Empresa (id_empresa),
PRIMARY KEY (id_compra)
);

--Se crea la tabla Nota_De_Venta
CREATE TABLE SELECT_QUANTUM_LIBRARY.Nota_De_Venta (
id_nota_de_venta INT IDENTITY (1,1),
numero_venta INT NOT NULL,
id_cliente INT NOT NULL,
id_sucursal INT NOT NULL,
fecha DATE NOT NULL,
precio_total INT NOT NULL,
FOREIGN KEY (id_cliente) REFERENCES SELECT_QUANTUM_LIBRARY.Cliente (id_cliente),
FOREIGN KEY (id_sucursal) REFERENCES SELECT_QUANTUM_LIBRARY.Sucursal (id_sucursal),
PRIMARY KEY (id_nota_de_venta)
);

--Se crea la tabla Pasaje
CREATE TABLE SELECT_QUANTUM_LIBRARY.Pasaje (
codigo_pasaje INT NOT NULL,
codigo_vuelo INT NOT NULL,
fecha_compra DATE NOT NULL,
id_butaca INT NOT NULL,
id_compra INT NOT NULL,
costo_compra INT NOT NULL,
id_nota_de_venta INT,
precio_venta INT NOT NULL,
FOREIGN KEY (codigo_vuelo) REFERENCES SELECT_QUANTUM_LIBRARY.Vuelo (codigo_vuelo),
FOREIGN KEY (id_butaca) REFERENCES SELECT_QUANTUM_LIBRARY.Butaca (id_butaca),
FOREIGN KEY (id_compra) REFERENCES SELECT_QUANTUM_LIBRARY.Compra (id_compra),
FOREIGN KEY (id_nota_de_venta) REFERENCES SELECT_QUANTUM_LIBRARY.Nota_De_Venta (id_nota_de_venta),
PRIMARY KEY (codigo_pasaje)
);

--Se crea la tabla Estadia
CREATE TABLE SELECT_QUANTUM_LIBRARY.Estadia (
id_estadia INT IDENTITY (1,1),
codigo INT NOT NULL,
fecha_inicio DATE NOT NULL,
cantidad_noches INT NOT NULL,
id_habitacion INT NOT NULL,
precio_final INT NOT NULL,
id_compra INT NOT NULL,
costo_compra_total INT NOT NULL,
id_nota_de_venta INT,
FOREIGN KEY (id_habitacion) REFERENCES SELECT_QUANTUM_LIBRARY.Habitacion (id_habitacion),
FOREIGN KEY (id_compra) REFERENCES SELECT_QUANTUM_LIBRARY.Compra (id_compra),
FOREIGN KEY (id_nota_de_venta) REFERENCES SELECT_QUANTUM_LIBRARY.Nota_De_Venta (id_nota_de_venta),
PRIMARY KEY (id_estadia)
);

-- Se crean los indices necesarios para reducir significativamente el tiempo de insersion de datos
CREATE INDEX IX_Cliente_DNI ON SELECT_QUANTUM_LIBRARY.Cliente (DNI) WHERE DNI IS NOT NULL

CREATE INDEX IX_Cliente_Mail ON SELECT_QUANTUM_LIBRARY.Cliente (mail) WHERE mail IS NOT NULL

GO

-- Se crea el procedure que Migrara todos los datos a las tablas creadas anteriormente, tomando los datos de la tabla maestra e insertandolos en las tablas especificas
CREATE PROCEDURE SELECT_QUANTUM_LIBRARY.Migracion AS
BEGIN
	-- Se insertan todos los datos referentes a Ciudad
	INSERT INTO SELECT_QUANTUM_LIBRARY.Ciudad SELECT DISTINCT
	RUTA_AEREA_CIU_ORIG
	FROM gd_esquema.Maestra
	WHERE RUTA_AEREA_CIU_ORIG IS NOT NULL

	-- Se insertan todos los datos referentes a Tipo_Butaca
	INSERT INTO SELECT_QUANTUM_LIBRARY.Tipo_Butaca SELECT DISTINCT
	BUTACA_TIPO
	FROM gd_esquema.Maestra
	WHERE BUTACA_TIPO IS NOT NULL

	-- Se insertan todos los datos referentes a Tipo_Habitacion
	INSERT INTO SELECT_QUANTUM_LIBRARY.Tipo_Habitacion SELECT DISTINCT
	TIPO_HABITACION_CODIGO,
	TIPO_HABITACION_DESC 
	FROM gd_esquema.Maestra 
	WHERE TIPO_HABITACION_CODIGO IS NOT NULL

	-- Se insertan todos los datos referentes a Avion
	INSERT INTO SELECT_QUANTUM_LIBRARY.Avion SELECT DISTINCT
	AVION_IDENTIFICADOR,
	AVION_MODELO
	FROM gd_esquema.Maestra
	WHERE AVION_IDENTIFICADOR IS NOT NULL

	-- Se insertan todos los datos referentes a Vuelo
	INSERT INTO SELECT_QUANTUM_LIBRARY.Vuelo SELECT
	VUELO_CODIGO,
	VUELO_FECHA_SALUDA,
	VUELO_FECHA_LLEGADA,
	AVION_IDENTIFICADOR 
	FROM gd_esquema.Maestra 
	WHERE VUELO_FECHA_SALUDA IS NOT NULL
	GROUP BY VUELO_CODIGO, VUELO_FECHA_SALUDA, VUELO_FECHA_LLEGADA, AVION_IDENTIFICADOR 	

	-- Se insertan todos los datos referentes a Hotel
	INSERT INTO SELECT_QUANTUM_LIBRARY.Hotel SELECT DISTINCT
	HOTEL_CALLE,
	HOTEL_NRO_CALLE,
	HOTEL_CANTIDAD_ESTRELLAS
	FROM gd_esquema.Maestra
	WHERE HOTEL_CALLE IS NOT NULL

	-- Se insertan todos los datos referentes a Habitacion
	INSERT INTO SELECT_QUANTUM_LIBRARY.Habitacion SELECT DISTINCT
	(SELECT id_hotel FROM SELECT_QUANTUM_LIBRARY.Hotel WHERE calle = HOTEL_CALLE AND nro_calle = HOTEL_NRO_CALLE),
	HABITACION_PISO,
	HABITACION_NUMERO,
	(SELECT codigo FROM SELECT_QUANTUM_LIBRARY.Tipo_Habitacion WHERE codigo = TIPO_HABITACION_CODIGO),
	HABITACION_FRENTE
	FROM gd_esquema.Maestra
	WHERE HABITACION_NUMERO IS NOT NULL

	-- Se insertan todos los datos referentes a Ruta_Aerea
	INSERT INTO SELECT_QUANTUM_LIBRARY.Ruta_Aerea SELECT DISTINCT
	RUTA_AEREA_CODIGO,
	(SELECT id_ciudad FROM SELECT_QUANTUM_LIBRARY.Ciudad WHERE nombre = RUTA_AEREA_CIU_ORIG),
	(SELECT id_ciudad FROM SELECT_QUANTUM_LIBRARY.Ciudad WHERE nombre = RUTA_AEREA_CIU_DEST),
	VUELO_CODIGO
	FROM gd_esquema.Maestra
	WHERE RUTA_AEREA_CODIGO IS NOT NULL

	-- Se insertan todos los datos referentes a Butaca
	INSERT INTO SELECT_QUANTUM_LIBRARY.Butaca SELECT DISTINCT
	(SELECT DISTINCT codigo FROM SELECT_QUANTUM_LIBRARY.Tipo_Butaca WHERE descripcion = BUTACA_TIPO),
	BUTACA_NUMERO,
	AVION_IDENTIFICADOR
	FROM gd_esquema.Maestra
	WHERE BUTACA_NUMERO IS NOT NULL

	-- Se insertan todos los datos referentes a Sucursal
	INSERT INTO SELECT_QUANTUM_LIBRARY.Sucursal SELECT DISTINCT
	SUCURSAL_MAIL,
	SUCURSAL_DIR,
	SUCURSAL_TELEFONO
	FROM gd_esquema.Maestra
	WHERE SUCURSAL_MAIL IS NOT NULL

	-- Se insertan todos los datos referentes a Cliente
	INSERT INTO SELECT_QUANTUM_LIBRARY.Cliente SELECT DISTINCT
	CLIENTE_DNI,
	CLIENTE_NOMBRE,
	CLIENTE_APELLIDO,
	CLIENTE_MAIL,
	CLIENTE_TELEFONO,
	CLIENTE_FECHA_NAC
	FROM gd_esquema.Maestra
	WHERE CLIENTE_DNI IS NOT NULL

	-- Se insertan todos los datos referentes a Empresa
	INSERT INTO SELECT_QUANTUM_LIBRARY.Empresa SELECT DISTINCT
	EMPRESA_RAZON_SOCIAL
	FROM gd_esquema.Maestra
	WHERE EMPRESA_RAZON_SOCIAL IS NOT NULL

	-- Se insertan todos los datos referentes a Compra
	INSERT INTO SELECT_QUANTUM_LIBRARY.Compra SELECT DISTINCT
	COMPRA_NUMERO,
	COMPRA_FECHA,
	(SELECT id_empresa FROM SELECT_QUANTUM_LIBRARY.Empresa WHERE EMPRESA_RAZON_SOCIAL = nombre),
	(SELECT SUM (ISNULL (PASAJE_COSTO, 0)) + SUM (ISNULL (HABITACION_COSTO, 0) * ISNULL (ESTADIA_CANTIDAD_NOCHES, 0)) 
	FROM gd_esquema.Maestra M1 WHERE M1.COMPRA_NUMERO = M2.COMPRA_NUMERO)
	FROM gd_esquema.Maestra M2
	WHERE COMPRA_NUMERO IS NOT NULL

	-- Se insertan todos los datos referentes a Nota_De_Venta
	INSERT INTO SELECT_QUANTUM_LIBRARY.Nota_De_Venta SELECT DISTINCT
	FACTURA_NRO,
	(SELECT id_cliente FROM SELECT_QUANTUM_LIBRARY.Cliente WHERE CLIENTE_DNI = DNI AND mail = CLIENTE_MAIL),
	(SELECT id_sucursal FROM SELECT_QUANTUM_LIBRARY.Sucursal WHERE direccion = SUCURSAL_DIR),
	FACTURA_FECHA,
	ISNULL (PASAJE_PRECIO, 0) + ISNULL (HABITACION_PRECIO * ESTADIA_CANTIDAD_NOCHES, 0)
	FROM gd_esquema.Maestra
	WHERE FACTURA_NRO IS NOT NULL

	-- Se insertan todos los datos referentes a Pasaje
	INSERT INTO SELECT_QUANTUM_LIBRARY.Pasaje SELECT DISTINCT
	PASAJE_CODIGO,
	VUELO_CODIGO,
	COMPRA_FECHA,
	(SELECT id_butaca FROM SELECT_QUANTUM_LIBRARY.Butaca B JOIN SELECT_QUANTUM_LIBRARY.Tipo_Butaca TB ON TB.codigo = B.tipo_de_butaca 
	WHERE B.numero = BUTACA_NUMERO AND TB.descripcion = BUTACA_TIPO AND B.id_avion = AVION_IDENTIFICADOR),
	(SELECT id_compra FROM SELECT_QUANTUM_LIBRARY.Compra WHERE COMPRA_NUMERO = numero_compra),
	PASAJE_COSTO,
	NULL,
	PASAJE_PRECIO
	FROM gd_esquema.Maestra
	WHERE PASAJE_CODIGO IS NOT NULL

	-- Se actualizan los datos referentes a Pasaje para asi obtener todos los pasajes que fueron vendidos
	UPDATE SELECT_QUANTUM_LIBRARY.Pasaje SET id_nota_de_venta =
	(SELECT id_nota_de_venta FROM SELECT_QUANTUM_LIBRARY.Nota_De_Venta WHERE numero_venta = M.FACTURA_NRO)
	FROM SELECT_QUANTUM_LIBRARY.Pasaje P JOIN gd_esquema.Maestra M ON M.PASAJE_CODIGO = P.codigo_pasaje
	WHERE (SELECT id_nota_de_venta FROM SELECT_QUANTUM_LIBRARY.Nota_De_Venta WHERE numero_venta = M.FACTURA_NRO) IS NOT NULL

	-- Se insertan todos los datos referentes a Estadia
	INSERT INTO SELECT_QUANTUM_LIBRARY.Estadia SELECT DISTINCT
	ESTADIA_CODIGO,
	ESTADIA_FECHA_INI,
	ESTADIA_CANTIDAD_NOCHES,
	(SELECT id_habitacion FROM SELECT_QUANTUM_LIBRARY.Habitacion Ha JOIN SELECT_QUANTUM_LIBRARY.Hotel Ho ON Ho.id_hotel = Ha.id_hotel 
	WHERE Ho.calle = HOTEL_CALLE AND Ho.nro_calle = HOTEL_NRO_CALLE AND Ha.numero = HABITACION_NUMERO),
	ESTADIA_CANTIDAD_NOCHES * HABITACION_PRECIO,
	(SELECT id_compra FROM SELECT_QUANTUM_LIBRARY.Compra WHERE COMPRA_NUMERO = numero_compra),
	ESTADIA_CANTIDAD_NOCHES * HABITACION_COSTO,
	NULL
	FROM gd_esquema.Maestra
	WHERE ESTADIA_CODIGO IS NOT NULL

	-- Se actualizan los datos referentes a Estadia para asi obtener todos las estadias que fueron vendidas
	UPDATE SELECT_QUANTUM_LIBRARY.Estadia SET id_nota_de_venta =
	(SELECT id_nota_de_venta FROM SELECT_QUANTUM_LIBRARY.Nota_De_Venta WHERE numero_venta = M.FACTURA_NRO)
	FROM SELECT_QUANTUM_LIBRARY.Estadia E JOIN gd_esquema.Maestra M ON M.ESTADIA_CODIGO = E.codigo
	WHERE (SELECT id_nota_de_venta FROM SELECT_QUANTUM_LIBRARY.Nota_De_Venta WHERE numero_venta = M.FACTURA_NRO) IS NOT NULL
END
GO
-- Se procede a ejecutar el Store Procedure para realizar la insercion normalizada de los datos
EXECUTE SELECT_QUANTUM_LIBRARY.Migracion;