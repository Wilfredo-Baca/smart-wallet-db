INSERT INTO sw.Proveedores (Nombre, Descripcion) VALUES ('Google', 'Proveedor de inicio de sesión de Google');
INSERT INTO sw.Proveedores (Nombre, Descripcion) VALUES ('Microsoft', 'Proveedor de inicio de sesión de Microsoft');
INSERT INTO sw.Proveedores (Nombre, Descripcion) VALUES ('Local', 'Proveedor de inicio de sesión local');
SELECT * FROM sw.Proveedores;
EXEC sw.SignUpUsuarioLocal 'Carlos Ramirez', 'carlos.ramirez@example.com', '123456';
SELECT * FROM sw.Usuarios;
EXEC sw.UpdateUsuarioByBank '3142912e-5847-486a-9598-17854b8e0021', 'Carlos Ramírez', 'carlos.ramirez@example.com', '0801-1985-56789', '504-9966-7890', 'Col. Kennedy, Tegucigalpa, Honduras', '1985-03-08';

INSERT INTO sw.Niveles (Nombre, Precio, Descripcion) VALUES ('Free', 0.00, 'Nivel gratuito');
INSERT INTO sw.Niveles (Nombre, Precio, Descripcion) VALUES ('Básico', 49.66, 'Nivel básico sin anuncios');
INSERT INTO sw.Niveles (Nombre, Precio, Descripcion) VALUES ('Premium', 98.75, 'Nivel premium sin anuncios y más funcionalidades');
SELECT * FROM sw.Niveles;
EXEC sw.InsertarSuscripcion '8213F38F-1530-41A8-B3FC-64830F7CA199', '7457e5e4-10ea-4154-9e92-d75dcfca4cde';
SELECT * FROM sw.Suscripciones;
INSERT INTO sw.Bancos (Nombre, CodigoSwift, Direccion, Telefono) VALUES
('Banco de America Central, BAC Credomatic', 'BACCHNTE', 'Tegucigalpa, Honduras', '504-2234-5678'),
('Banco de Occidente', 'BOCHHNTE', 'Tegucigalpa, Honduras', '504-2234-5678'),
('Banco Atlantida', 'ATLHHNTE', 'Tegucigalpa, Honduras', '504-2234-5678'),
('Banco Ficohsa', 'FICHHNTE', 'Tegucigalpa, Honduras', '504-2234-5678'),
('Banco Cuscatlan', 'CUSCHNTE', 'Tegucigalpa, Honduras', '504-2234-5678'),
('Banco Davivienda', 'DAVHHNTE', 'Tegucigalpa, Honduras', '504-2234-5678'),
('Banco Lafise', 'LAFHHNTE', 'Tegucigalpa, Honduras', '504-2234-5678'),
('Banco Azteca', 'AZTHHNTE', 'Tegucigalpa, Honduras', '504-2234-5678'),
('Banpaís', 'BANPHNTE', 'Tegucigalpa, Honduras', '504-2234-5678'),
('Banco Popular', 'POPCHNTE', 'Tegucigalpa, Honduras', '504-2234-5678');
SELECT * FROM sw.Bancos;
INSERT INTO sw.TipoCuentas (Nombre, DescripcionTipoCuenta) VALUES
('Ahorro', 'Cuenta de ahorro'),
('Corriente', 'Cuenta corriente'),
('Inversion', 'Cuenta de inversion'),
('Nomina', 'Cuenta de nomina'),
('PlazoFijo', 'Cuenta de plazo fijo'),
('Credito', 'Cuenta de tarjeta de crédito');
SELECT * FROM sw.TipoCuentas;
INSERT INTO sw.Monedas (Nombre, Simbolo, Pais, DescripcionMoneda) VALUES
('Lempira', 'HNL', 'Honduras', 'Moneda de Honduras'),
('Dolar', 'USD', 'Estados Unidos', 'Moneda de Estados Unidos'),
('Euro', 'EUR', 'Europa', 'Moneda de Europa'),
('Peso', 'MXN', 'Mexico', 'Moneda de Mexico'),
('Quetzal', 'GTQ', 'Guatemala', 'Moneda de Guatemala'),
('Colon', 'CRC', 'Costa Rica', 'Moneda de Costa Rica'),
('Cordoba', 'NIO', 'Nicaragua', 'Moneda de Nicaragua'),
('Balboa', 'PAB', 'Panama', 'Moneda de Panama'),
('Peso', 'COP', 'Colombia', 'Moneda de Colombia'),
('Bolivar', 'VEF', 'Venezuela', 'Moneda de Venezuela');
SELECT * FROM sw.Monedas;
EXEC sw.InsertarCuentaBancaria '8213F38F-1530-41A8-B3FC-64830F7CA199', 'S56HsdfBhbv56454FLdfcFx5s', '9f39f637-5625-4d8e-8948-3260de9d775d', 2, 1, '768235489', 'WILFREDO BACA', 162325.54, 'Cuenta de ahorros en lempiras', NULL, NULL;
SELECT * FROM sw.CuentaBancaria;
EXEC sw.ObtenerCuentasBancarias '8213F38F-1530-41A8-B3FC-64830F7CA199';

INSERT INTO sw.Categorias (Nombre, DescripcionCategoria) VALUES ('Tecnología', 'Gasto, ingreso, meta de ahorro o presupuesto relacionado con tecnología');
INSERT INTO sw.Categorias (Nombre, DescripcionCategoria) VALUES ('Alimentación', 'Gasto, ingreso, meta de ahorro o presupuesto relacionado con alimentación');
INSERT INTO sw.Categorias (Nombre, DescripcionCategoria) VALUES ('Transporte', 'Gasto, ingreso, meta de ahorro o presupuesto relacionado con transporte');
INSERT INTO sw.Categorias (Nombre, DescripcionCategoria) VALUES ('Educación', 'Gasto, ingreso, meta de ahorro o presupuesto relacionado con educación');
INSERT INTO sw.Categorias (Nombre, DescripcionCategoria) VALUES ('Salud', 'Gasto, ingreso, meta de ahorro o presupuesto relacionado con salud');
INSERT INTO sw.Categorias (Nombre, DescripcionCategoria) VALUES ('Entretenimiento', 'Gasto, ingreso, meta de ahorro o presupuesto relacionado con entretenimiento');
INSERT INTO sw.Categorias (Nombre, DescripcionCategoria) VALUES ('Hogar', 'Gasto, ingreso, meta de ahorro o presupuesto relacionado con hogar');
INSERT INTO sw.Categorias (Nombre, DescripcionCategoria) VALUES ('Ropa', 'Gasto, ingreso, meta de ahorro o presupuesto relacionado con ropa');
INSERT INTO sw.Categorias (Nombre, DescripcionCategoria) VALUES ('Viajes', 'Gasto, ingreso, meta de ahorro o presupuesto relacionado con viajes');
INSERT INTO sw.Categorias (Nombre, DescripcionCategoria) VALUES ('Otros', 'Gasto, ingreso, meta de ahorro o presupuesto relacionado con otros');
SELECT * FROM sw.Categorias;
INSERT INTO sw.TipoTransacciones (Nombre, DescripcionTipoTransac) VALUES
('Deposito', 'Deposito de dinero en cuenta'),
('Retiro', 'Retiro de dinero de cuenta'),
('Transferencia', 'Transferencia de dinero entre cuentas'),
('Pago', 'Pago de servicios, Productos, Tarjetas, Prestamos, etc'),
('AHORRO PROTEGIDO', 'Transferencia de fondos a una meta de ahorro');
SELECT * FROM sw.TipoTransacciones;
INSERT INTO sw.Frecuencias (Nombre, Descripcion) VALUES ('Diario', 'Frecuencia diaria');
INSERT INTO sw.Frecuencias (Nombre, Descripcion) VALUES ('Semanal', 'Frecuencia semanal');
INSERT INTO sw.Frecuencias (Nombre, Descripcion) VALUES ('Mensual', 'Frecuencia mensual');
SELECT * FROM sw.Frecuencias;
INSERT INTO sw.Prioridades (Nombre, Descripcion) VALUES ('Muy baja', 'Prioridad muy baja');
INSERT INTO sw.Prioridades (Nombre, Descripcion) VALUES ('Baja', 'Prioridad baja');
INSERT INTO sw.Prioridades (Nombre, Descripcion) VALUES ('Media', 'Prioridad media');
INSERT INTO sw.Prioridades (Nombre, Descripcion) VALUES ('Alta', 'Prioridad alta');
INSERT INTO sw.Prioridades (Nombre, Descripcion) VALUES ('Muy alta', 'Prioridad muy alta');
SELECT * FROM sw.Prioridades;

EXEC sw.InsertarCategoria '8213F38F-1530-41A8-B3FC-64830F7CA199', 'Tecnología', 'Gasto, ingreso, meta de ahorro o presupuesto relacionado con tecnología';

EXEC sw.ObtenerCategorias '8213F38F-1530-41A8-B3FC-64830F7CA199';

EXEC sw.EliminarCategoria 'b8c338e9-0874-4a96-9f19-14cf7a71e2ff';

EXEC sw.CrearPresupuestoDesdeCuentas '8213F38F-1530-41A8-B3FC-64830F7CA199', 'Presupuesto de Julio 2021', 5000.00, 'Presupuesto de gastos para el mes de julio 2021', '2021-07-01', '2021-07-31'; -- DA ERROR POR SALDO INSUFICIENTE. HAY QUE ARREGLAR EL SP

SELECT * FROM sw.CuentaBancaria

EXEC sw.InsertarMetaAhorro '8213F38F-1530-41A8-B3FC-64830F7CA199', 'Viaje a Europa', 60000.00, 'cbadbae9-c53b-4781-907f-3b1ce12c9732', '2021-07-01', '2022-07-01', 'Meta de ahorro para viaje a Europa';
SELECT * FROM sw.Prioridades;
SELECT * FROM sw.MetasAhorro;


EXEC sw.ProgramarTransferenciaMetaAhorro '8213F38F-1530-41A8-B3FC-64830F7CA199', '10b56a9d-317d-41ef-a0f2-60ba8144c5d1', 'c8646836-aa85-4ff4-bec6-1514345d7457', 'd5e92106-ddab-45d8-b7c4-20a44be733fa', 1000.00, '2021-07-01';
SELECT * FROM sw.Frecuencias;
SELECT * FROM sw.MetasAhorro;
EXEC sw.EjecutarTransferenciasProgramadas;

EXEC sw.ObtenerEstadoMetasAhorro '8213F38F-1530-41A8-B3FC-64830F7CA199';

EXEC sw.ObtenerMetaAhorroPorID '9ad9752d-6e34-4fe3-a03d-171b6bc60c89';