USE GD1C2020;

if object_id('SELECT_QUANTUM_LIBRARY.Dia_Reservado') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Dia_Reservado;
if object_id('SELECT_QUANTUM_LIBRARY.Estadia') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Estadia;
if object_id('SELECT_QUANTUM_LIBRARY.Pasaje') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Pasaje;
if object_id('SELECT_QUANTUM_LIBRARY.Nota_De_Venta') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Nota_De_Venta;
if object_id('SELECT_QUANTUM_LIBRARY.Compra') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Compra;
if object_id('SELECT_QUANTUM_LIBRARY.Empresa') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Empresa;
if object_id('SELECT_QUANTUM_LIBRARY.Ruta_Aerea') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Ruta_Aerea;
if object_id('SELECT_QUANTUM_LIBRARY.Ciudad') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Ciudad;
if object_id('SELECT_QUANTUM_LIBRARY.Vuelo') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Vuelo;
if object_id('SELECT_QUANTUM_LIBRARY.Habitacion') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Habitacion;
if object_id('SELECT_QUANTUM_LIBRARY.Hotel') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Hotel;
if object_id('SELECT_QUANTUM_LIBRARY.Cliente') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Cliente;
if object_id('SELECT_QUANTUM_LIBRARY.Sucursal') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Sucursal;
if object_id('SELECT_QUANTUM_LIBRARY.Butaca') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Butaca;
if object_id('SELECT_QUANTUM_LIBRARY.Avion') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Avion;
if object_id('SELECT_QUANTUM_LIBRARY.Tipo_Butaca') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Tipo_Butaca;
if object_id('SELECT_QUANTUM_LIBRARY.Tipo_Habitacion') is not null
	DROP TABLE SELECT_QUANTUM_LIBRARY.Tipo_Habitacion;


DROP SCHEMA SELECT_QUANTUM_LIBRARY;