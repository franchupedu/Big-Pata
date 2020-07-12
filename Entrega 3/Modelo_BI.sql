
USE GD1C2020;
GO

-- Se crea una funcion para el calculo de la cantidad de camas vendidas
CREATE FUNCTION cant_camas_vendidas (@descripcion nvarchar(255)) RETURNS int AS
	BEGIN
		RETURN
	CASE @descripcion 
	WHEN  'Base Simple' THEN 1
	WHEN 'King' THEN 1
	WHEN 'Base Doble' THEN 2
	WHEN 'Base Triple' THEN 3
	WHEN 'Base Cuadruple' THEN 4
	ELSE 0
	END
END
GO

-- Se procede con la creacion de las tablas necesarias para la creacion del modelo BI
-- Se crea la tabla Dimension Tiempo
CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Tiempo (
  id_tiempo int IDENTITY (1,1),
  Año int NOT NULL,
  Mes int NOT NULL,
  PRIMARY KEY (id_tiempo)
);

-- Se crea la tabla Dimension Tipo Habitacion
CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion (
  codigo int NOT NULL,
  descripcion NVARCHAR (255),
  PRIMARY KEY (codigo)
);

-- Se crea la tabla Dimension Proveedor
CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Proveedor (
  id_empresa INT NOT NULL,
  nombre NVARCHAR (255) NOT NULL,
  PRIMARY KEY (id_empresa)
);

-- Se crea la tabla Dimension Avion
CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Avion (
  id_avion NVARCHAR (255) NOT NULL,
  modelo NVARCHAR (255),
  PRIMARY KEY (id_avion)
);

-- Se crea la tabla Dimension Cliente
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

-- Se crea la tabla Dimension Ciudad
CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Ciudad (
  id_ciudad INT NOT NULL,
  nombre NVARCHAR (255),
  PRIMARY KEY (id_ciudad)
);

-- Se crea la tabla Dimension Ruta Aerea
CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea (
  id_ruta_aerea INT NOT NULL,
  Codigo INT,
  PRIMARY KEY (id_ruta_aerea)
);

-- Se crea la dimension Tipo de Pasaje
CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje (
  Codigo INT NOT NULL,
  descripcion NVARCHAR (255),
  PRIMARY KEY (codigo)
);

-- Se crea la tabla de hechos Fac_Venta
CREATE TABLE SELECT_QUANTUM_LIBRARY.Fac_Venta (
  id_cliente INT NOT NULL,
  id_tipoDeHabitacion INT NOT NULL,
  id_tiempo INT NOT NULL,
  id_ciudad_origen INT NOT NULL,
  id_ciudad_destino INT NOT NULL,
  id_ruta_aerea INT NOT NULL,
  id_avion NVARCHAR (255) NOT NULL,
  id_tipo_de_pasaje INT NOT NULL,
  precio_promedio decimal(18,2),
  cantidad_camas INT,
  habitaciones_vendidas INT,
  pasajes_vendidos INT,
  ganancias decimal(18,2),
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



-- Se crea la tabla de Hechos Fac_Compra
CREATE TABLE SELECT_QUANTUM_LIBRARY.Fac_Compra (
  id_tiempo INT NOT NULL,
  id_tipoDeHabitacion INT NOT NULL,
  id_empresa INT NOT NULL,
  id_tipo_de_pasaje INT NOT NULL,
  id_avion NVARCHAR (255) NOT NULL,
  id_ruta_aerea INT NOT NULL,
  id_ciudad_origen INT NOT NULL,
  id_ciudad_destino INT NOT NULL,
  precio_promedio decimal(18,2),
  precio_total decimal(18,2),

  PRIMARY KEY(id_tiempo, id_tipoDeHabitacion, id_empresa, id_tipo_de_pasaje, id_avion, 
				 id_ruta_aerea, id_ciudad_origen, id_ciudad_destino),
  FOREIGN KEY (id_tiempo) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Tiempo (id_tiempo),
  FOREIGN KEY (id_tipoDeHabitacion) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion (codigo),
  FOREIGN KEY (id_tipo_de_pasaje) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje (Codigo),
  FOREIGN KEY (id_empresa) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Proveedor (id_empresa),
  FOREIGN KEY (id_avion) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Avion (id_avion),
  FOREIGN KEY (id_ruta_aerea) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea (id_ruta_aerea),
  FOREIGN KEY (id_ciudad_origen) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Ciudad (id_ciudad),
  FOREIGN KEY (id_ciudad_destino) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Ciudad (id_ciudad)  
  
);

-- A partir de aqui se finaliza con la creacion de las tablas necesarias para el modelo BI

-- Se procede con la Migracion de los datos de la tabla maestra al modelo BI

-- Se insertan todos los datos necesarios para la tabla  Dimension Tiempo, siendo los mismos el mes y año de las diferentes compras y ventas existentes
-- El union que se observa fue utilizado para diferenciar los datos de las fechas entre la compra y la venta, evitando asi que se dieran fechas repetidas
INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Tiempo
	SELECT YEAR(fecha), MONTH(fecha) FROM SELECT_QUANTUM_LIBRARY.Compra
	UNION 
	SELECT YEAR(fecha), MONTH(fecha) FROM SELECT_QUANTUM_LIBRARY.Nota_De_Venta

-- Se insertan todos los datos necesarios para la tabla Dimension Tipo Habitacion
INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion
	SELECT DISTINCT codigo, descripcion
	FROM SELECT_QUANTUM_LIBRARY.Tipo_Habitacion

-- Este insert fue realizado para insertar el tipo de habitacion 0 para todo registro que tuviese sus datos en NULL, para que asi el mismo pueda ser evaluado en la tabla de hecho y asi poder diferenciar la estadia del pasaje 
INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion VALUES(0, NULL)

-- Este insert inserta todos los datos necesarios en la tabla dimension proveedor
INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Proveedor
	SELECT DISTINCT id_empresa, nombre
	FROM SELECT_QUANTUM_LIBRARY.Empresa

-- Este insert inserta todos los datos necesarios en la tabla dimension avion
INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Avion
	SELECT DISTINCT id_avion, modelo
	FROM SELECT_QUANTUM_LIBRARY.Avion

-- Este insert cumple el mismo caso explicado previamente de Tipo Habitacion
INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Avion VALUES(0, NULL)

-- Este insert inserta todo dato relacionado con el Cliente dentro de la tabla Dimension Cliente
INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Cliente
	SELECT DISTINCT id_cliente, 
	DNI,
	nombre,
	apellido,
	mail,
	telefono,
	fecha_de_nacimiento
	FROM SELECT_QUANTUM_LIBRARY.Cliente

-- Este insert inserta todo dato relacionado con cada ciudad dentro de la tabla Dimension Ciudad
INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Ciudad
	SELECT DISTINCT id_ciudad, nombre
	FROM SELECT_QUANTUM_LIBRARY.Ciudad

-- En este insert se repite el mismo caso explicado previamente para Tipo Habitacion y Avion
INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Ciudad VALUES(0, NULL)

-- En este insert se procede a guardar todo dato relacionado con Ruta Aerea dentro de la tabla Dimension Ruta Aerea
INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea
	SELECT DISTINCT id_ruta_aerea, codigo_ruta_aerea
	FROM SELECT_QUANTUM_LIBRARY.Ruta_Aerea

-- En este insert se repite el mismo caso explicado previamente para Tipo Habitacion, Avion y Ciudad

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea VALUES(0, NULL)

-- En este insert se procede a guardar todo dato relacionado al Tipo de pasaje dentro de la tabla Dimension Tipo de Pasaje
INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje
	SELECT DISTINCT codigo, descripcion
	FROM SELECT_QUANTUM_LIBRARY.Tipo_Butaca

-- En este insert se repite el mismo caso explicado previamente para Tipo Habitacion, Avion, Ciudad y Ruta Aerea
INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje VALUES(0, NULL)

-- En este insert se procede a guardar todo dato relacionado a cada compra y se guarda en la tabla de Hechos de Fac_compra
-- Ademas en este caso es donde se utilizan los insert explicados previamente que ocurren en las tablas dimensionales Tipo Habitacion, Avion, Ciudad y Ruta Aerea
-- Fue necesario realizar un left join para traer toda venta existente, ya que la tabla venta comparte tanto los datos de los pasajes como la estadia entonces habían campos en null que al hacer join provocaban pérdida de filas
INSERT INTO SELECT_QUANTUM_LIBRARY.Fac_Compra
	SELECT (SELECT id_tiempo FROM SELECT_QUANTUM_LIBRARY.Dim_Tiempo WHERE Año = YEAR(c.fecha) AND Mes = MONTH(c.fecha)), 
					isnull((SELECT codigo FROM SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion WHERE descripcion = th.descripcion),0), 
					(SELECT id_empresa FROM SELECT_QUANTUM_LIBRARY.Dim_Proveedor WHERE id_empresa = em.id_empresa), 
					isnull((SELECT Codigo FROM SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje WHERE Codigo = tb.codigo),0), 
					isnull((SELECT id_avion FROM SELECT_QUANTUM_LIBRARY.Dim_Avion WHERE id_avion = av.id_avion),0), 
					isnull((SELECT id_ruta_aerea FROM SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea WHERE id_ruta_aerea = ra.id_ruta_aerea),0),
					isnull((SELECT id_ciudad FROM SELECT_QUANTUM_LIBRARY.Dim_Ciudad WHERE id_ciudad = ra.ciudad_origen),0), 
					isnull((SELECT id_ciudad FROM SELECT_QUANTUM_LIBRARY.Dim_Ciudad WHERE id_ciudad = ra.ciudad_destino),0),
					AVG(c.costo_total), 
					SUM(c.costo_total)
		
	FROM SELECT_QUANTUM_LIBRARY.Compra c LEFT JOIN SELECT_QUANTUM_LIBRARY.Estadia e ON c.id_compra = e.id_compra
	LEFT JOIN SELECT_QUANTUM_LIBRARY.Habitacion h ON h.id_habitacion = e.id_habitacion 
	LEFT JOIN SELECT_QUANTUM_LIBRARY.Tipo_Habitacion th ON h.tipo = th.codigo
	LEFT JOIN SELECT_QUANTUM_LIBRARY.Empresa em ON em.id_empresa = c.id_empresa
	LEFT JOIN SELECT_QUANTUM_LIBRARY.Pasaje p ON p.id_compra = c.id_compra
	LEFT JOIN SELECT_QUANTUM_LIBRARY.Butaca b ON b.id_butaca = p.id_butaca
	LEFT JOIN SELECT_QUANTUM_LIBRARY.Tipo_Butaca tb ON tb.codigo = b.tipo_de_butaca
	LEFT JOIN SELECT_QUANTUM_LIBRARY.Avion av ON av.id_avion = b.id_avion 
	LEFT JOIN SELECT_QUANTUM_LIBRARY.Vuelo v ON v.codigo_vuelo = p.codigo_vuelo
	LEFT JOIN SELECT_QUANTUM_LIBRARY.Ruta_Aerea ra ON ra.id_vuelo = v.codigo_vuelo
	GROUP BY MONTH(c.fecha), YEAR(c.fecha), th.codigo,th.descripcion,em.id_empresa,tb.codigo,
			av.id_avion,ra.id_ruta_aerea,ra.ciudad_destino,ra.ciudad_origen

-- En este insert se procede a guardar todo dato relacionado a cada venta y se guarda en la tabla de Hechos de Fac_Venta
-- Ademas en este caso es donde se utilizan los insert explicados previamente que ocurren en las tablas dimensionales Tipo Habitacion, Avion, Ciudad y Ruta Aerea
-- Fue necesario realizar un left join para traer toda venta existente, ya que la tabla venta comparte tanto los datos de los pasajes como la estadia y 
-- habían campos en null que al hacer join provocaba pérdida de filas.
INSERT INTO SELECT_QUANTUM_LIBRARY.Fac_Venta
  SELECT DISTINCT(SELECT id_cliente FROM SELECT_QUANTUM_LIBRARY.Dim_Cliente WHERE id_cliente = c.id_cliente),
			 	 ISNULL((SELECT codigo FROM SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion WHERE codigo = th.codigo), 0),
				 (SELECT id_tiempo FROM SELECT_QUANTUM_LIBRARY.Dim_Tiempo WHERE Año = YEAR(ndv.fecha) AND Mes = MONTH(ndv.fecha)),
                 ISNULL((SELECT id_ciudad FROM SELECT_QUANTUM_LIBRARY.Dim_Ciudad WHERE id_ciudad = ra.ciudad_origen), 0),
                 ISNULL((SELECT id_ciudad FROM SELECT_QUANTUM_LIBRARY.Dim_Ciudad WHERE id_ciudad = ra.ciudad_destino), 0),
                 ISNULL((SELECT id_ruta_aerea FROM SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea WHERE id_ruta_aerea = ra.id_ruta_aerea), 0),
                 ISNULL((SELECT id_avion FROM SELECT_QUANTUM_LIBRARY.Dim_Avion WHERE id_avion = av.id_avion), 0),
                 ISNULL((SELECT Codigo FROM SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje WHERE Codigo = tb.codigo), 0),
				 AVG(ndv.precio_total),
                 SUM(dbo.cant_camas_vendidas(th.descripcion)),
				 -- Esto es equivalente a COUNT, pero count provocaba un
				 -- "Warning: Null value is eliminated by an aggregate or other SET operation in Aqua Data Studio"
				 -- por eso lo cambiamos
                 SUM(CASE WHEN e.id_estadia IS NULL THEN 0 ELSE 1 END), 
                 SUM(CASE WHEN p.codigo_pasaje IS NULL THEN 0 ELSE 1 END), 
				 SUM(CASE WHEN e.id_estadia IS NULL THEN p.precio_venta - p.costo_compra ELSE e.precio_final - e.costo_compra_total END) 


  FROM SELECT_QUANTUM_LIBRARY.Nota_De_Venta ndv 
  LEFT JOIN SELECT_QUANTUM_LIBRARY.Cliente c ON c.id_cliente = ndv.id_cliente
  LEFT JOIN SELECT_QUANTUM_LIBRARY.Estadia e ON e.id_nota_de_venta = ndv.id_nota_de_venta
  LEFT JOIN SELECT_QUANTUM_LIBRARY.Habitacion h ON  e.id_habitacion = h.id_habitacion 
  LEFT JOIN SELECT_QUANTUM_LIBRARY.Tipo_Habitacion th ON h.tipo = th.codigo
  LEFT JOIN SELECT_QUANTUM_LIBRARY.Pasaje p ON p.id_nota_de_venta =ndv.id_nota_de_venta
  LEFT JOIN SELECT_QUANTUM_LIBRARY.Butaca b ON b.id_butaca = p.id_butaca
  LEFT JOIN SELECT_QUANTUM_LIBRARY.Tipo_Butaca tb ON tb.codigo = b.tipo_de_butaca
  LEFT JOIN SELECT_QUANTUM_LIBRARY.Avion av ON av.id_avion = b.id_avion 
  LEFT JOIN SELECT_QUANTUM_LIBRARY.Vuelo v ON v.codigo_vuelo = p.codigo_vuelo
  LEFT JOIN SELECT_QUANTUM_LIBRARY.Ruta_Aerea ra ON ra.id_vuelo = v.codigo_vuelo
  GROUP BY c.id_cliente,th.codigo,YEAR(ndv.fecha),MONTH(ndv.fecha),ra.id_ruta_aerea,av.id_avion,tb.codigo,ra.ciudad_destino,ra.ciudad_origen
  
