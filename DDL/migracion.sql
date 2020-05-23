use GD1C2020

select count(*)
from gd_esquema.Maestra where HABITACION_PISO is not null
group by HOTEL_CALLE, HOTEL_NRO_CALLE, HABITACION_PISO, HABITACION_COSTO, HABITACION_FRENTE, HABITACION_NUMERO, 
HABITACION_PRECIO, TIPO_HABITACION_CODIGO, TIPO_HABITACION_DESC

select AVION_IDENTIFICADOR, AVION_MODELO from gd_esquema.Maestra


/* Tipo de Habitacion*/
insert into [SELECT_QUANTUM_LIBRARY].[Tipo_Habitacion] select 
														distinct(TIPO_HABITACION_CODIGO),
														TIPO_HABITACION_DESC 
														FROM gd_esquema.Maestra 
														WHERE TIPO_HABITACION_CODIGO is not null 


/*Habitacion*/	/*XXX: puse distinct aca*/
insert into [SELECT_QUANTUM_LIBRARY].[Habitacion] SELECT 
														HABITACION_PISO,
														HABITACION_NUMERO,
														(select codigo from[SELECT_QUANTUM_LIBRARY].[Tipo_Habitacion] 
															WHERE codigo = TIPO_HABITACION_CODIGO),
														HABITACION_FRENTE,
														HABITACION_COSTO,
														HABITACION_PRECIO 
														FROM gd_esquema.Maestra
														WHERE HABITACION_NUMERO IS NOT NULL
														group by HABITACION_PISO,
														HABITACION_NUMERO,													
														HABITACION_FRENTE, HOTEL_CALLE, HOTEL_NRO_CALLE, HOTEL_CANTIDAD_ESTRELLAS,
														HABITACION_COSTO, 
														HABITACION_PRECIO, TIPO_HABITACION_CODIGO
														order by HABITACION_PISO,
														HABITACION_NUMERO
/*Tipo de Butaca*/
insert into [SELECT_QUANTUM_LIBRARY].[Tipo_Butaca] select 
													distinct(BUTACA_TIPO) 
													FROM gd_esquema.Maestra
													WHERE BUTACA_TIPO is not null

/*Avion*/
insert into [SELECT_QUANTUM_LIBRARY].[Avion] SELECT 
													distinct(AVION_IDENTIFICADOR),
													AVION_MODELO
													FROM gd_esquema.Maestra
													WHERE AVION_IDENTIFICADOR IS NOT NULL
													
													
/*Vuelos*/
insert into [SELECT_QUANTUM_LIBRARY].[Vuelo]  SELECT 
													DISTINCT(VUELO_CODIGO),
													VUELO_FECHA_LLEGADA,
													VUELO_FECHA_SALUDA,		

													(SELECT distinct id_avion from [SELECT_QUANTUM_LIBRARY].[Avion] 
													WHERE id_avion = AVION_IDENTIFICADOR)

													FROM gd_esquema.Maestra
													WHERE VUELO_CODIGO IS NOT NULL	
													
/*Ruta aerea*/
insert into [SELECT_QUANTUM_LIBRARY].[Ruta_Aerea] select
														DISTINCT(RUTA_AEREA_CODIGO),
														RUTA_AEREA_CIU_ORIG,
														RUTA_AEREA_CIU_DEST,

														(SELECT distinct codigo_vuelo from [SELECT_QUANTUM_LIBRARY].[Vuelo] 
														WHERE codigo_vuelo = VUELO_CODIGO)

														FROM gd_esquema.Maestra
														WHERE RUTA_AEREA_CODIGO IS NOT NULL																				
													
/*Butaca*/	
/*XXX: aca tambien, el distinct es necesario xq x mas que dos vuelos referencien a la misma butaca, 
esta solo tiene el tipo_de_butaca y el numero. modifique el DER, una butaca esta en varios pasajes.*/

insert into [SELECT_QUANTUM_LIBRARY].[Butaca] select 
													distinct (SELECT distinct codigo 
													from [SELECT_QUANTUM_LIBRARY].[Tipo_Butaca] 
													WHERE descripcion = BUTACA_TIPO),
													BUTACA_NUMERO
													FROM gd_esquema.Maestra
													WHERE BUTACA_NUMERO is not null
													Order by 1, 2

INSERT INTO [SELECT_QUANTUM_LIBRARY].[Sucursal]	select 
													DISTINCT SUCURSAL_MAIL,
													SUCURSAL_DIR,
													SUCURSAL_TELEFONO
													FROM gd_esquema.Maestra
													WHERE SUCURSAL_MAIL is not null							


/*Pasaje*/ 
/*Compra*/

/*Estadia*/

/*Dia Reservado*/

															




