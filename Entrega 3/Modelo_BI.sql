-- Hay que fijarse de cambiar INT por Decimal en algunos

USE GD1C2020;
GO

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


CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Tiempo (
  id_tiempo int IDENTITY (1,1),
  Año int NOT NULL,
  Mes int NOT NULL,
  PRIMARY KEY (id_tiempo)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion (
  codigo int NOT NULL,
  descripcion NVARCHAR (255),
  PRIMARY KEY (codigo)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Proveedor (
  id_empresa INT NOT NULL,
  nombre NVARCHAR (255) NOT NULL,
  PRIMARY KEY (id_empresa)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Avion (
  id_avion NVARCHAR (255) NOT NULL,
  modelo NVARCHAR (255),
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
  nombre NVARCHAR (255),
  PRIMARY KEY (id_ciudad)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea (
  id_ruta_aerea INT NOT NULL,
  Codigo INT,
  PRIMARY KEY (id_ruta_aerea)
);

CREATE TABLE SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje (
  Codigo INT NOT NULL,
  descripcion NVARCHAR (255),
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
  FOREIGN KEY (id_tipo_de_pasaje) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje (Codigo),
  FOREIGN KEY (id_empresa) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Proveedor (id_empresa),
  FOREIGN KEY (id_avion) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Avion (id_avion),
  FOREIGN KEY (id_ruta_aerea) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea (id_ruta_aerea),
  FOREIGN KEY (id_ciudad_origen) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Ciudad (id_ciudad),
  FOREIGN KEY (id_ciudad_destino) REFERENCES SELECT_QUANTUM_LIBRARY.Dim_Ciudad (id_ciudad)  
  
);

-- MIGRACION


INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Tiempo
	SELECT YEAR(fecha), MONTH(fecha) FROM SELECT_QUANTUM_LIBRARY.Compra
	UNION 
	SELECT YEAR(fecha), MONTH(fecha) FROM SELECT_QUANTUM_LIBRARY.Nota_De_Venta

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion
	SELECT DISTINCT codigo, descripcion
	FROM SELECT_QUANTUM_LIBRARY.Tipo_Habitacion

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion VALUES(0, NULL)

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Proveedor
	SELECT DISTINCT id_empresa, nombre
	FROM SELECT_QUANTUM_LIBRARY.Empresa

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Avion
	SELECT DISTINCT id_avion, modelo
	FROM SELECT_QUANTUM_LIBRARY.Avion

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Avion VALUES(0, NULL)

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

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Ciudad VALUES(0, NULL)

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea
	SELECT DISTINCT id_ruta_aerea, codigo_ruta_aerea
	FROM SELECT_QUANTUM_LIBRARY.Ruta_Aerea

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea VALUES(0, NULL)

INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje
	SELECT DISTINCT codigo, descripcion
	FROM SELECT_QUANTUM_LIBRARY.Tipo_Butaca

	
INSERT INTO SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje VALUES(0, NULL)


INSERT INTO SELECT_QUANTUM_LIBRARY.Fac_Compra
	SELECT (SELECT id_tiempo FROM SELECT_QUANTUM_LIBRARY.Dim_Tiempo WHERE Año = YEAR(c.fecha) AND Mes = MONTH(c.fecha)), 
					isnull((SELECT codigo FROM SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion WHERE descripcion = th.descripcion),0), 
					(SELECT id_empresa FROM SELECT_QUANTUM_LIBRARY.Dim_Proveedor WHERE id_empresa = em.id_empresa), 
					isnull((SELECT Codigo FROM SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje WHERE Codigo = tb.codigo),0), 
					isnull((SELECT id_avion FROM SELECT_QUANTUM_LIBRARY.Dim_Avion WHERE id_avion = av.id_avion),0), 
					isnull((SELECT id_ruta_aerea FROM SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea WHERE id_ruta_aerea = ra.codigo_ruta_aerea),0),
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
			av.id_avion,ra.codigo_ruta_aerea,ra.ciudad_destino,ra.ciudad_origen


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
				 -- ESTO ES LO MISMO QUE UN COUNT, PERO TIRA UN 
				 -- "Warning: Null value is eliminated by an aggregate or other SET operation in Aqua Data Studio"
				 -- POR ESO LO CAMBIAMOS PARA QUE NO APAREZCA EL MISMO
                 SUM(CASE WHEN e.id_estadia IS NULL THEN 0 ELSE 1 END), 
                 SUM(CASE WHEN p.codigo_pasaje IS NULL THEN 0 ELSE 1 END), 
                 SUM(ndv.precio_total) 
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
  
