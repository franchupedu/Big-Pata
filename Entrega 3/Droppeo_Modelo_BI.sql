USE GD1C2020;

if object_id('SELECT_QUANTUM_LIBRARY.Fac_Venta') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Fac_Venta;
if object_id('SELECT_QUANTUM_LIBRARY.Fac_Compra') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Fac_Compra;
if object_id('SELECT_QUANTUM_LIBRARY.Dim_Tiempo') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Dim_Tiempo;
if object_id('SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Dim_Tipo_Habitacion;
if object_id('SELECT_QUANTUM_LIBRARY.Dim_Avion') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Dim_Avion;
if object_id('SELECT_QUANTUM_LIBRARY.Dim_Cliente') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Dim_Cliente;
if object_id('SELECT_QUANTUM_LIBRARY.Dim_Ciudad') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Dim_Ciudad;
if object_id('SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Dim_Ruta_Aerea;
if object_id('SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Dim_Tipo_De_Pasaje;