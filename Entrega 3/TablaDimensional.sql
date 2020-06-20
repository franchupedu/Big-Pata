use GD2015C1

CREATE TABLE SELECT_QUANTUM_LIBRARY.Tiempo (
	anio int,
	mes int
	)

CREATE TABLE SELECT_QUANTUM_LIBRARY.Clientes (
id_cliente INT ,
DNI INT NOT NULL,
nombre NVARCHAR (255) NOT NULL,
apellido NVARCHAR (255) NOT NULL,
telefono INT NOT NULL,
fecha_de_nacimiento DATE NOT NULL
PRIMARY KEY (id_cliente)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimEmpresa (
id_empresa INT ,
nombre NVARCHAR (255) NOT NULL,
PRIMARY KEY (id_empresa)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimCiudad (
id_ciudad INT ,
nombre NVARCHAR (255) NOT NULL,
PRIMARY KEY (id_ciudad)
);


CREATE TABLE SELECT_QUANTUM_LIBRARY.DimTipo_Habitacion (
codigo INT NOT NULL,
descripcion NVARCHAR (255) NOT NULL,
PRIMARY KEY (codigo)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimHotel (
id_hotel INT ,
PRIMARY KEY (id_hotel)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimHabitacion (
id_habitacion INT ,
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
mes_llegada int NOT NULL,
anio_llegada int NOT NULL,
mes_salida int NOT NULL,
anio_salida int NOT NULL,
id_avion NVARCHAR (255) NOT NULL,
FOREIGN KEY (id_avion) REFERENCES SELECT_QUANTUM_LIBRARY.DimAvion,
PRIMARY KEY (codigo_vuelo)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimRuta_Aerea (
id_ruta_aerea INT ,
codigo_ruta_aerea INT NOT NULL,
ciudad_origen INT NOT NULL,
ciudad_destino INT NOT NULL,
id_vuelo INT NOT NULL,
FOREIGN KEY (id_vuelo) REFERENCES SELECT_QUANTUM_LIBRARY.DimVuelo (codigo_vuelo),
FOREIGN KEY (ciudad_origen) REFERENCES SELECT_QUANTUM_LIBRARY.DimCiudad (id_ciudad),
FOREIGN KEY (ciudad_destino) REFERENCES SELECT_QUANTUM_LIBRARY.DimCiudad (id_ciudad),
PRIMARY KEY (id_ruta_aerea)
);


CREATE TABLE SELECT_QUANTUM_LIBRARY.DimTipo_Butaca (
codigo INT ,
descripcion NVARCHAR (255) NOT NULL,
PRIMARY KEY (codigo)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimButaca (
id_butaca INT ,
tipo_de_butaca INT NOT NULL,
numero INT NOT NULL,
id_avion NVARCHAR (255) NOT NULL
FOREIGN KEY (tipo_de_butaca) REFERENCES SELECT_QUANTUM_LIBRARY.Tipo_Butaca (codigo),
FOREIGN KEY (id_avion) REFERENCES SELECT_QUANTUM_LIBRARY.Avion (id_avion),
PRIMARY KEY (id_butaca)
);


CREATE TABLE SELECT_QUANTUM_LIBRARY.DimCompra (
id_compra INT ,
numero_compra INT NOT NULL,
mes int NOT NULL,
anio int NOT NULL,
id_empresa INT NOT NULL,
costo_total INT NOT NULL,
FOREIGN KEY (id_empresa) REFERENCES SELECT_QUANTUM_LIBRARY.Empresa (id_empresa),
PRIMARY KEY (id_compra)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimSucursal (
id_sucursal INT 
PRIMARY KEY (id_sucursal)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimNota_De_Venta (
id_nota_de_venta INT ,
id_cliente INT NOT NULL,
id_sucursal INT NOT NULL,
mes int NOT NULL,
anio int NOT NULL,
precio_total INT NOT NULL,
FOREIGN KEY (id_cliente) REFERENCES SELECT_QUANTUM_LIBRARY.Cliente (id_cliente),
FOREIGN KEY (id_sucursal) REFERENCES SELECT_QUANTUM_LIBRARY.Sucursal (id_sucursal),
PRIMARY KEY (id_nota_de_venta)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.DimEstadia (
id_estadia INT,
mes_inicio int NOT NULL,
anio_inicio int NOT NULL,
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