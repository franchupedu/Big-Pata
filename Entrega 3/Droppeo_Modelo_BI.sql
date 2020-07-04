USE GD1C2020;

IF OBJECT_ID (N'dbo.cant_camas_vendidas', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.cant_camas_vendidas;  
GO
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
if object_id('SELECT_QUANTUM_LIBRARY.Dim_Proveedor') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Dim_Proveedor;