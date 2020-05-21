use GD1C2020
select * from gd_esquema.Maestra
Select * from  [SELECT_QUANTUM_LIBRARY].[Ruta_Aerea]
SELECT * FROM  [SELECT_QUANTUM_LIBRARY].[Avion]
/* Tipo de Habitacion*/
insert into [SELECT_QUANTUM_LIBRARY].[Tipo_Habitacion] select 
														distinct(TIPO_HABITACION_CODIGO),
														TIPO_HABITACION_DESC 
														FROM gd_esquema.Maestra 
														WHERE TIPO_HABITACION_CODIGO is not null 


/*Habitacion*/
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
														ORDER BY RUTA_AEREA_CODIGO																					
													

/*Pasaje*/ 
/*Compra*/

/*Estadia*/

/*Dia Reservado*/

															




