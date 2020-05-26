use GD1C2020

/*Estan faltando las siguientes tablas (por favor actualizar a medida que se avanza

	Falta sacar repetidos en estadia y pasaje
*/

/*para probar*/

/*SELECT COUNT(*) FROM gd_esquema.Maestra WHERE COMPRA_NUMERO IS NOT NULL GROUP BY COMPRA_NUMERO HAVING COUNT(*)>1 ORDER BY COMPRA_NUMERO 

SELECT COUNT(*) FROM gd_esquema.Maestra WHERE FACTURA_NRO IS NOT NULL GROUP BY FACTURA_NRO HAVING COUNT(*)>1 ORDER BY FACTURA_NRO 

SELECT count(*) FROM gd_esquema.Maestra WHERE (FACTURA_NRO IS NOT NULL OR COMPRA_NUMERO IS NOT NULL) AND ESTADIA_CODIGO IS NOT NULL ORDER BY COMPRA_NUMERO, FACTURA_NRO

SELECT * FROM gd_esquema.Maestra
SELECT * from [SELECT_QUANTUM_LIBRARY].[Cliente] order by mail


SELECT COUNT(*) FROM [SELECT_QUANTUM_LIBRARY].Habitacion HAB 
GROUP BY HAB.id_habitacion, HAB.id_hotel
HAVING COUNT(*)>1
*/
/*
SELECT numero_venta FROM [SELECT_QUANTUM_LIBRARY].Nota_De_Venta GROUP BY numero_venta HAVING COUNT (*) >1

SELECT PASAJE_CODIGO, FACTURA_NRO FROM gd_esquema.Maestra
WHERE PASAJE_CODIGO IS NOT NULL ORDER BY PASAJE_CODIGO
*/
/*inicio de la migracion*/

/* Ciudad */
/* En origen estan las mismas ciudades que en destino por eso agarro cualquiera*/
insert into [SELECT_QUANTUM_LIBRARY].[Ciudad] select distinct
												RUTA_AEREA_CIU_ORIG
												from gd_esquema.Maestra
												where RUTA_AEREA_CIU_ORIG is not null

/*Tipo de Butaca*/
insert into [SELECT_QUANTUM_LIBRARY].[Tipo_Butaca] select 
													distinct(BUTACA_TIPO) 
													FROM gd_esquema.Maestra
													WHERE BUTACA_TIPO is not null

/* Tipo de Habitacion*/
insert into [SELECT_QUANTUM_LIBRARY].[Tipo_Habitacion] select 
														distinct(TIPO_HABITACION_CODIGO),
														TIPO_HABITACION_DESC 
														FROM gd_esquema.Maestra 
														WHERE TIPO_HABITACION_CODIGO is not null

/*Avion*/
insert into [SELECT_QUANTUM_LIBRARY].[Avion] SELECT 
													distinct(AVION_IDENTIFICADOR),
													AVION_MODELO
													FROM gd_esquema.Maestra
													WHERE AVION_IDENTIFICADOR IS NOT NULL

/*Vuelos*/
insert into [SELECT_QUANTUM_LIBRARY].[Vuelo]  select VUELO_CODIGO, VUELO_FECHA_SALUDA, VUELO_FECHA_LLEGADA, AVION_IDENTIFICADOR 
												from gd_esquema.Maestra 
												where VUELO_FECHA_SALUDA is not null
												group by VUELO_CODIGO, VUELO_FECHA_SALUDA, VUELO_FECHA_LLEGADA, AVION_IDENTIFICADOR 	

/*Hotel*/
insert into [SELECT_QUANTUM_LIBRARY].[Hotel] SELECT 
													DISTINCT HOTEL_CALLE,
													HOTEL_NRO_CALLE,
													HOTEL_CANTIDAD_ESTRELLAS
													FROM gd_esquema.Maestra
													WHERE HOTEL_CALLE IS NOT NULL
													
													

/*Habitacion*/
insert into [SELECT_QUANTUM_LIBRARY].[Habitacion] SELECT 
														distinct(SELECT id_hotel FROM [SELECT_QUANTUM_LIBRARY].[Hotel] 
																WHERE HOTEL_CALLE = calle AND HOTEL_NRO_CALLE = nro_calle),
														HABITACION_PISO,
														HABITACION_NUMERO,
														(select codigo from[SELECT_QUANTUM_LIBRARY].[Tipo_Habitacion] 
															WHERE codigo = TIPO_HABITACION_CODIGO),
														HABITACION_FRENTE														
														FROM gd_esquema.Maestra
														WHERE HABITACION_NUMERO IS NOT NULL
													
										
/*Ruta aerea*/
insert into [SELECT_QUANTUM_LIBRARY].[Ruta_Aerea] select
														DISTINCT(RUTA_AEREA_CODIGO),
														(SELECT id_ciudad FROM [SELECT_QUANTUM_LIBRARY].Ciudad
														WHERE nombre = RUTA_AEREA_CIU_ORIG),

														(SELECT id_ciudad FROM [SELECT_QUANTUM_LIBRARY].Ciudad
														WHERE nombre = RUTA_AEREA_CIU_DEST),
														
														VUELO_CODIGO

														FROM gd_esquema.Maestra
														WHERE RUTA_AEREA_CODIGO IS NOT NULL																
													
/*Butaca*/	
/*XXX: aca tambien, el distinct es necesario xq x mas que dos vuelos referencien a la misma butaca, 
esta solo tiene el tipo_de_butaca y el numero. modifique el DER, una butaca esta en varios pasajes.*/

insert into [SELECT_QUANTUM_LIBRARY].[Butaca] select 
													distinct (SELECT distinct codigo 
													from [SELECT_QUANTUM_LIBRARY].[Tipo_Butaca] 
													WHERE descripcion = BUTACA_TIPO),

													BUTACA_NUMERO,

													AVION_IDENTIFICADOR
														
													FROM gd_esquema.Maestra
													WHERE BUTACA_NUMERO is not null

/*Sucursal*/
INSERT INTO [SELECT_QUANTUM_LIBRARY].[Sucursal]	select 
													DISTINCT SUCURSAL_MAIL,
													SUCURSAL_DIR,
													SUCURSAL_TELEFONO
													FROM gd_esquema.Maestra
													WHERE SUCURSAL_MAIL is not null							


/*Cliente*/
INSERT INTO [SELECT_QUANTUM_LIBRARY].[Cliente] SELECT
													distinct CLIENTE_DNI,
													CLIENTE_NOMBRE,
													CLIENTE_APELLIDO,
													CLIENTE_MAIL,
													CLIENTE_TELEFONO,
													CLIENTE_FECHA_NAC
													FROM gd_esquema.Maestra
													WHERE CLIENTE_DNI IS NOT NULL

/* Empresa */
INSERT INTO [SELECT_QUANTUM_LIBRARY].[Empresa] SELECT
												DISTINCT EMPRESA_RAZON_SOCIAL
												FROM gd_esquema.Maestra
												WHERE EMPRESA_RAZON_SOCIAL IS NOT NULL

/* Compra */
INSERT INTO [SELECT_QUANTUM_LIBRARY].Compra SELECT
											DISTINCT COMPRA_NUMERO,
											COMPRA_FECHA,
											(SELECT id_empresa FROM [SELECT_QUANTUM_LIBRARY].Empresa
											WHERE EMPRESA_RAZON_SOCIAL = nombre),
											(SELECT SUM(ISNULL(PASAJE_COSTO, 0)) + 
													SUM(ISNULL(HABITACION_COSTO, 0)*ISNULL(ESTADIA_CANTIDAD_NOCHES, 0))
											 FROM gd_esquema.Maestra g
											 WHERE g.COMPRA_NUMERO = g2.COMPRA_NUMERO
											)
											FROM gd_esquema.Maestra g2
											WHERE COMPRA_NUMERO IS NOT NULL

/* Nota de Venta */
/* Sumamos el pasaje y las habitaciones xq la factura es o solo pasaje o solo habitacion*/
INSERT INTO [SELECT_QUANTUM_LIBRARY].[Nota_De_Venta] SELECT
													DISTINCT FACTURA_NRO,
													(SELECT id_cliente FROM [SELECT_QUANTUM_LIBRARY].Cliente
													WHERE CLIENTE_DNI = DNI AND mail = CLIENTE_MAIL),

													(SELECT id_sucursal FROM [SELECT_QUANTUM_LIBRARY].Sucursal
													WHERE direccion = SUCURSAL_DIR),

													FACTURA_FECHA,

													 ISNULL(PASAJE_PRECIO, 0) + ISNULL(
															HABITACION_PRECIO*ESTADIA_CANTIDAD_NOCHES, 0)

													FROM gd_esquema.Maestra
													WHERE FACTURA_NRO IS NOT NULL



/* Pasaje */
INSERT INTO [SELECT_QUANTUM_LIBRARY].[Pasaje] SELECT
												DISTINCT PASAJE_CODIGO,
												VUELO_CODIGO,
												COMPRA_FECHA,
												(SELECT id_butaca FROM [SELECT_QUANTUM_LIBRARY].Butaca B
												JOIN [SELECT_QUANTUM_LIBRARY].Tipo_Butaca TB ON TB.codigo = B.tipo_de_butaca
												WHERE B.numero = BUTACA_NUMERO AND TB.descripcion = BUTACA_TIPO 
												AND B.id_avion = AVION_IDENTIFICADOR),

												(SELECT id_compra FROM [SELECT_QUANTUM_LIBRARY].Compra
												WHERE COMPRA_NUMERO = numero_compra),
												PASAJE_COSTO,

												NULL,
												PASAJE_PRECIO

												FROM gd_esquema.Maestra
												WHERE PASAJE_CODIGO IS NOT NULL												

UPDATE [SELECT_QUANTUM_LIBRARY].[Pasaje] 
SET id_nota_de_venta = (SELECT id_nota_de_venta FROM [SELECT_QUANTUM_LIBRARY].Nota_De_Venta WHERE numero_venta = mas.FACTURA_NRO)
FROM [SELECT_QUANTUM_LIBRARY].[Pasaje] pas
JOIN gd_esquema.Maestra mas ON mas.PASAJE_CODIGO = pas.codigo_pasaje


/* Estadia */
INSERT INTO [SELECT_QUANTUM_LIBRARY].Estadia SELECT
												DISTINCT ESTADIA_CODIGO,
												ESTADIA_FECHA_INI,
												ESTADIA_CANTIDAD_NOCHES,

												(SELECT id_habitacion FROM [SELECT_QUANTUM_LIBRARY].Habitacion hab
												JOIN [SELECT_QUANTUM_LIBRARY].Hotel hot ON hot.id_hotel = hab.id_hotel
												WHERE hot.calle = HOTEL_CALLE AND HOT.nro_calle = HOTEL_NRO_CALLE
												AND hab.numero = HABITACION_NUMERO),

												ESTADIA_CANTIDAD_NOCHES*HABITACION_PRECIO,

												(SELECT id_compra FROM [SELECT_QUANTUM_LIBRARY].Compra
												WHERE COMPRA_NUMERO = numero_compra),
												ESTADIA_CANTIDAD_NOCHES*HABITACION_COSTO,

												NULL

												FROM gd_esquema.Maestra
												WHERE ESTADIA_CODIGO IS NOT NULL


UPDATE [SELECT_QUANTUM_LIBRARY].[Estadia] 
SET id_nota_de_venta = (SELECT id_nota_de_venta FROM [SELECT_QUANTUM_LIBRARY].Nota_De_Venta WHERE numero_venta = mas.FACTURA_NRO)
FROM [SELECT_QUANTUM_LIBRARY].[Estadia] est
JOIN gd_esquema.Maestra mas ON mas.ESTADIA_CODIGO = est.codigo