use GD2015C1

CREATE TABLE SELECT_QUANTUM_LIBRARY.Tiempo (
	anio int,
	mes int
	)

CREATE TABLE SELECT_QUANTUM_LIBRARY.Clientes (
id_cliente INT IDENTITY (1,1),
DNI INT NOT NULL,
nombre NVARCHAR (255) NOT NULL,
apellido NVARCHAR (255) NOT NULL,
mail NVARCHAR (255) NOT NULL,
telefono INT NOT NULL,
fecha_de_nacimiento DATE NOT NULL
PRIMARY KEY (id_cliente)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimEmpresa (
id_empresa INT IDENTITY (1,1),
nombre NVARCHAR (255) NOT NULL,
PRIMARY KEY (id_empresa)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimCiudad (
id_ciudad INT IDENTITY (1,1),
nombre NVARCHAR (255) NOT NULL,
PRIMARY KEY (id_ciudad)
);


CREATE TABLE SELECT_QUANTUM_LIBRARY.DimTipo_Habitacion (
codigo INT NOT NULL,
descripcion NVARCHAR (255) NOT NULL,
PRIMARY KEY (codigo)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimHotel (
id_hotel INT IDENTITY (1,1),
PRIMARY KEY (id_hotel)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimHabitacion (
id_habitacion INT IDENTITY (1,1),
id_hotel INT NOT NULL,
tipo INT NOT NULL,
FOREIGN KEY (id_hotel) REFERENCES SELECT_QUANTUM_LIBRARY.Hotel (id_hotel),
FOREIGN KEY (tipo) REFERENCES SELECT_QUANTUM_LIBRARY.DimTipo_Habitacion (codigo),
PRIMARY KEY (id_habitacion)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimAvion (
id_avion NVARCHAR (255) NOT NULL,
PRIMARY KEY (id_avion)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimVuelo (
codigo_vuelo INT NOT NULL,
fecha_llegada DATE NOT NULL,
fecha_salida DATE NOT NULL,
id_avion NVARCHAR (255) NOT NULL,
FOREIGN KEY (id_avion) REFERENCES SELECT_QUANTUM_LIBRARY.DimAvion,
PRIMARY KEY (codigo_vuelo)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimRuta_Aerea (
id_ruta_aerea INT IDENTITY (1,1),
codigo_ruta_aerea INT NOT NULL,
ciudad_origen INT NOT NULL,
ciudad_destino INT NOT NULL,
id_vuelo INT NOT NULL,
FOREIGN KEY (id_vuelo) REFERENCES SELECT_QUANTUM_LIBRARY.DimVuelo (codigo_vuelo),
FOREIGN KEY (ciudad_origen) REFERENCES SELECT_QUANTUM_LIBRARY.DimCiudad (id_ciudad),
FOREIGN KEY (ciudad_destino) REFERENCES SELECT_QUANTUM_LIBRARY.DimCiudad (id_ciudad),
PRIMARY KEY (id_ruta_aerea)
);


-- tipo de pasaje ??