-- Hay que fijarse de cambiar INT por Decimal en algunos

USE GD1C2020;
GO

CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Tiempo (
  id_tiempo int IDENTITY (1,1),
  Año int NOT NULL,
  Mes int NOT NULL,
  PRIMARY KEY (id_tiempo)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion (
  codigo int NOT NULL,
  descripcion NVARCHAR (255) NOT NULL,
  PRIMARY KEY (codigo)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Proveedor (
  id_empresa INT NOT NULL,
  nombre NVARCHAR (255) NOT NULL,
  PRIMARY KEY (id_empresa)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Avion (
  id_avion NVARCHAR (255) NOT NULL,
  modelo NVARCHAR (255) NOT NULL,
  PRIMARY KEY (id_avion)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Cliente (
  id_cliente INT NOT NULL,
  DNI INT NOT NULL,
  nombre NVARCHAR (255) NOT NULL,
  apellido NVARCHAR (255) NOT NULL,
  mail NVARCHAR (255) NOT NULL,
  telefono INT NOT NULL,
  fecha_de_nacimiento DATE NOT NULL
  PRIMARY KEY (id_cliente)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Ciudad (
  id_ciudad INT NOT NULL,
  nombre NVARCHAR (255) NOT NULL,
  PRIMARY KEY (id_ciudad)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea (
  id_ruta_aerea INT NOT NULL,
  Codigo INT NOT NULL,
  PRIMARY KEY (id_ruta_aerea)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje (
  Codigo INT NOT NULL,
  descripcion NVARCHAR (255) NOT NULL,
  PRIMARY KEY (codigo)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.Fac_Venta (
  id_cliente INT NOT NULL,
  id_tipoDeHabitacion INT NOT NULL,
  id_tiempo INT NOT NULL,
  id_ciudad_origen INT NOT NULL,
  id_ciudad_destino INT NOT NULL,
  id_ruta_aerea INT NOT NULL,
  id_avion NVARCHAR (255) NOT NULL,
  id_tipo_de_pasaje INT NOT NULL,
  precio_promedio INT,
  cantidad_camas INT,
  habitaciones_vendidas INT,
  pasajes_vendidos INT,
  ganancias INT,
  PRIMARY KEY(id_cliente, id_tipoDeHabitacion, id_tiempo, id_ciudad_origen, id_ciudad_destino,
				id_ruta_aerea, id_avion, id_tipo_de_pasaje),
  FOREIGN KEY (id_cliente) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Cliente (id_cliente),
  FOREIGN KEY (id_tipoDeHabitacion) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion (codigo),
  FOREIGN KEY (id_tiempo) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Tiempo (id_tiempo),
  FOREIGN KEY (id_ciudad_origen) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Ciudad (id_ciudad),
  FOREIGN KEY (id_ciudad_destino) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Ciudad (id_ciudad),
  FOREIGN KEY (id_ruta_aerea) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea (id_ruta_aerea),
  FOREIGN KEY (id_avion) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Avion (id_avion),
  FOREIGN KEY (id_tipo_de_pasaje) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje (Codigo),
);




CREATE TABLE SELECT_QUANTUM_LIBRARY.Fac_Compra (
  id_tiempo INT NOT NULL,
  id_tipoDeHabitacion INT NOT NULL,
  id_empresa INT NOT NULL,
  id_tipo_de_pasaje INT NOT NULL,
  id_avion NVARCHAR (255) NOT NULL,
  id_ruta_aerea INT NOT NULL,
  id_ciudad_origen INT NOT NULL,
  id_ciudad_destino INT NOT NULL,
  precio_promedio INT,
  precio_total INT,

  PRIMARY KEY(id_tiempo, id_tipoDeHabitacion, id_empresa, id_tipo_de_pasaje, id_avion, 
				 id_ruta_aerea, id_ciudad_origen, id_ciudad_destino),
  FOREIGN KEY (id_tiempo) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Tiempo (id_tiempo),
  FOREIGN KEY (id_tipoDeHabitacion) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion (codigo),
  FOREIGN KEY (id_empresa) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Proveedor (id_empresa),
  FOREIGN KEY (id_tipo_de_pasaje) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje (Codigo),
  FOREIGN KEY (id_avion) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Avion (id_avion),
  FOREIGN KEY (id_ruta_aerea) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea (id_ruta_aerea),
  FOREIGN KEY (id_ciudad_origen) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Ciudad (id_ciudad),
  FOREIGN KEY (id_ciudad_destino) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Ciudad (id_ciudad)  
  
);

-- MIGRACION

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion
	SELECT DISTINCT codigo, descripcion
	FROM SELECT_QUANTUM_LIBRARY.Tipo_Habitacion

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Proveedor
	SELECT DISTINCT id_empresa, nombre
	FROM SELECT_QUANTUM_LIBRARY.Empresa

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Avion
	SELECT DISTINCT id_avion, modelo
	FROM SELECT_QUANTUM_LIBRARY.Avion

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Cliente
	SELECT DISTINCT id_cliente, 
	DNI,
	nombre,
	apellido,
	mail,
	telefono,
	fecha_de_nacimiento
	FROM SELECT_QUANTUM_LIBRARY.Cliente

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Ciudad
	SELECT DISTINCT id_ciudad, nombre
	FROM SELECT_QUANTUM_LIBRARY.Ciudad

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea
	SELECT DISTINCT id_ruta_aerea, codigo_ruta_aerea
	FROM SELECT_QUANTUM_LIBRARY.Ruta_Aerea

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje
	SELECT DISTINCT codigo, descripcion
	FROM SELECT_QUANTUM_LIBRARY.Tipo_Butaca

