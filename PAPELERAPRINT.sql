USE MASTER 
GO
IF DB_ID('BD_PAPELERA') IS NOT NULL
BEGIN
   ALTER DATABASE BD_PAPELERA
   SET SINGLE_USER
   WITH ROLLBACK IMMEDIATE;
   DROP DATABASE BD_PAPELERA;
END
GO

CREATE DATABASE BD_PAPELERA
/*ON PRIMARY
(
	NAME=BD_PAPELERA_DATA,
	FILENAME='D:\BD_PAPELERA\DATA\BD_PAPELERA_DATA.mdf',
	SIZE=30 MB,
	MAXSIZE=50 MB,
	FILEGROWTH=10 MB
)
LOG ON
(
	NAME=PAPELERA_LOG,
	FILENAME='D:\BD_PAPELERA\LOG\BD_PAPELERA_LOG.ldf',
	SIZE=20 MB,
	MAXSIZE=40 MB,
	FILEGROWTH=10 MB
)
GO*/

USE BD_PAPELERA
GO

CREATE TABLE TIPOTAMANHO
(
		CODTAMANHO		CHAR(6) NOT NULL PRIMARY KEY,
		NOMBRE			VARCHAR(30) NOT NULL
)
GO
CREATE TABLE TIPOGRAMAJE
(
		CODGRAMAJE		CHAR(6) NOT NULL PRIMARY KEY,
		NOMBRE			VARCHAR(30) NOT NULL
)

GO
CREATE TABLE TIPOACABADO 
(

		CODACABADO		CHAR(6) NOT NULL PRIMARY KEY,
		NOMBRE			VARCHAR(30) NOT NULL
)
GO

CREATE TABLE TIPO_DOCUMENTO
(
		COD_TIPO_DOCUMENTO	CHAR(13) NOT NULL PRIMARY KEY,
		NOMBRE				VARCHAR(40) NOT NULL
)
GO


CREATE TABLE DISTRITO
(
		CODDISTRITO		CHAR(6) NOT NULL PRIMARY KEY,
		NOMBRE			VARCHAR(50) NOT NULL
)
GO

CREATE TABLE UNI_MEDIDA 
(
		COD_UNI_MEDIDA		CHAR(7) NOT NULL PRIMARY KEY,
		NOMBRE				VARCHAR(80) NOT NULL
)
GO

CREATE TABLE AREA 
(
		CODAREA			CHAR(5) NOT NULL PRIMARY KEY,
		NOMBRE			VARCHAR(40) NOT NULL
)
GO

CREATE TABLE CARGO
(
		CODCARGO		CHAR(6) NOT NULL PRIMARY KEY,
		NOMBRE			VARCHAR(40) NOT NULL	
)
GO


CREATE TABLE MOVI_INVENTARIO
(
		COD_MOVI_INVEN	CHAR(5) NOT NULL PRIMARY KEY,
		FECHAMOVIMIENTO	DATE NULL,
		STOCKFINAL INT NULL
)
GO

CREATE  TABLE CLIENTE
(
		IDCLIENTE		CHAR(6) NOT NULL PRIMARY KEY,
		NOMBRE			VARCHAR(20) NOT NULL,
		APELLIDO		VARCHAR(30) NOT NULL,
		DIRECCION		VARCHAR(80) NULL	DEFAULT 'SIN REGISTRAR',
		TELEFONO		VARCHAR(11) NULL	DEFAULT '000-000-000',
		EMAIL			VARCHAR(40) NULL	DEFAULT 'SIN EMAIL',
		CODDISTRITO		CHAR(6) NOT NULL	REFERENCES DISTRITO
)
GO

CREATE TABLE PROVEEDORES
(
		CODPROVEEDOR	CHAR(6) NOT NULL PRIMARY KEY,
		NOMBRE			VARCHAR(30) NOT NULL,
		DIRECCION		VARCHAR(70) NOT NULL DEFAULT 'SIN REGISTRAR',
		TELEFONO		VARCHAR(9) NOT NULL	DEFAULT '000-000-000',
		EMAIL			VARCHAR(80) NULL	DEFAULT 'SIN EMAIL',
		NOM_CONTAC		VARCHAR(50) NOT NULL
)
GO
CREATE TABLE MATERIA_PRIMA
(
		CODMATERIA		CHAR(5) NOT NULL PRIMARY KEY,
		NOMBRE			VARCHAR(50) NOT NULL,
		DESCRIPCION		VARCHAR(80) NOT NULL,
		TOTALMATERIA	INT NOT NULL,
		COD_UNI_MEDIDA	CHAR(7) NOT NULL REFERENCES UNI_MEDIDA,
		CODPROVEEDOR	CHAR(6) NOT NULL REFERENCES PROVEEDORES 
)
GO

CREATE TABLE PRODUCTO
(
		CODPRODUCTO		CHAR(6) NOT NULL PRIMARY KEY,
		NOMPRODUC		VARCHAR(50) NOT NULL,
		PRECIO_UNI		MONEY NULL,
		STOCK			INT  NOT NULL,
		CODGRAMAJE		CHAR(6) NOT NULL REFERENCES TIPOGRAMAJE,
		CODTAMANHO		CHAR(6) NOT NULL REFERENCES TIPOTAMANHO,
		CODACABADO		CHAR(6) NOT NULL REFERENCES TIPOACABADO
)
GO


CREATE TABLE EMPLEADO
(
		CODEMPLE			CHAR(5)		NOT NULL	PRIMARY KEY,
		NOMBRE				VARCHAR(30)	NOT NULL,
		APELLIDO			VARCHAR(40) NOT NULL,
		DIRECCION			VARCHAR(60) NOT NULL	DEFAULT 'SIN REGISTRAR',
		TELEFONO			VARCHAR(9)	NOT NULL	DEFAULT'000-000-000',
		EMAIL				VARCHAR(50) NOT NULL	DEFAULT 'SIN REGISTRAR',
		SALARIO				MONEY		NOT NULL	DEFAULT 0,
		DNI					VARCHAR(8) NOT NULL		UNIQUE,
		FECHA_INGRESO		DATE		NOT NULL,
		CODDISTRITO			CHAR(6)		NOT NULL	REFERENCES DISTRITO,
		CODCARGO			CHAR(6)		NOT NULL	REFERENCES CARGO,
		CODAREA				CHAR(5)		NOT NULL	REFERENCES AREA
)
GO

CREATE TABLE DOCUMENTOVENTA
(
		CODVENT				CHAR(6)	NOT NULL PRIMARY KEY,
		FECHA_EMI			DATE	NOT NULL,
		FECHA_ENTREGA		DATE	NOT NULL,
		IDCLIENTE			CHAR(6) NOT NULL REFERENCES CLIENTE,
		CODEMPLE			CHAR(5) NOT NULL REFERENCES EMPLEADO,
		COD_TIPO_DOCUMENTO	CHAR(13) NOT NULL REFERENCES TIPO_DOCUMENTO,
)
GO

CREATE TABLE DETALLEVENTA
(
		CODVENT				CHAR(6)	NOT NULL	REFERENCES DOCUMENTOVENTA,
		CODPRODUCTO			CHAR(6) NOT NULL	REFERENCES PRODUCTO,
		PRECIOVENTA			MONEY	NOT NULL,
		CANTIDAD			INT		NOT NULL	DEFAULT 0,
		IMPORTE				MONEY	NOT NULL	DEFAULT 0		
		PRIMARY KEY (CODVENT,CODPRODUCTO)
)
GO

CREATE TABLE DETALLEMOVIMIENTO
(
		COD_MOVI_INVEN		CHAR(5) NOT NULL REFERENCES MOVI_INVENTARIO, 
		CODPRODUCTO			CHAR(6) NOT NULL REFERENCES PRODUCTO,
		CANTIDAD			INT NOT NULL,
		TIPOMOVIMIENTO		CHAR(7) NOT NULL,
		COMENTARIO			VARCHAR(255) NOT NULL
		PRIMARY KEY (COD_MOVI_INVEN,CODPRODUCTO)
)

GO

CREATE TABLE DETALLEP_M_P
(
		CODPRODUCTO		CHAR(6) NOT NULL			REFERENCES PRODUCTO,
		CODMATERIA		CHAR(5) NOT NULL			REFERENCES MATERIA_PRIMA,
		CANTIDAD_MATERIA INT
		PRIMARY KEY (CODPRODUCTO,CODMATERIA)
)


	 --@@@@@@@@@@@@@@@@@@@@@IMPLEMENTACIÓN DE RESTRICCIONES@@@@@@@@@@@@@@@@@@@@



ALTER TABLE EMPLEADO 
	ADD CONSTRAINT CHK_SALARIO 
	CHECK(SALARIO>=1030 AND SALARIO<=5000)
GO

ALTER TABLE DETALLEMOVIMIENTO
	ADD CONSTRAINT CHK_TIPOMOVIMIENTO
	CHECK (TIPOMOVIMIENTO IN ('SALIDA','ENTRADA'))
GO

ALTER TABLE PRODUCTO
	ADD CONSTRAINT CHK_STOCK
	CHECK (STOCK > 100)
GO

--IMPLEMENTACION DE REGISTROS


INSERT INTO TIPOACABADO (CODACABADO, NOMBRE)
VALUES 
('ACA01', 'Mate'),
('ACA02', 'Brillante'),
('ACA03', 'Satinado'),
('ACA04', 'Texturizado'),
('ACA05', 'Gofrado'),
('ACA06', 'Laminado'),
('ACA07', 'Barnizado UV'),
('ACA08', 'Térmico'),
('ACA09', 'Estucado'),
('ACA10', 'Soft Touch');
GO

INSERT INTO TIPOTAMANHO (CODTAMANHO, NOMBRE)
VALUES 
('TAM001', 'A4'),
('TAM002', 'A3'),
('TAM003', 'A5'),
('TAM004', 'Oficio'),
('TAM005', 'Carta'),
('TAM006', 'Tabloide'),
('TAM007', 'Legal'),
('TAM008', 'B5'),
('TAM009', 'C5'),
('TAM010', 'DL');
GO

INSERT INTO TIPOGRAMAJE (CODGRAMAJE, NOMBRE)
VALUES 
('GRA001', '80 gsm'),
('GRA002', '90 gsm'),
('GRA003', '100 gsm'),
('GRA004', '120 gsm'),
('GRA005', '150 gsm'),
('GRA006', '170 gsm'),
('GRA007', '200 gsm'),
('GRA008', '250 gsm'),
('GRA009', '300 gsm'),
('GRA010', '350 gsm');
GO

INSERT INTO UNI_MEDIDA (COD_UNI_MEDIDA, NOMBRE) VALUES 
('MED001', 'Kilogramos'),
('MED002', 'Gramos'),
('MED003', 'Cajas'),
('MED004', 'Litros'),
('MED005', 'Mililitros'),
('MED006', 'Metros'),
('MED007', 'Centímetros'),
('MED008', 'Pulgadas'),
('MED009', 'Hojas'),
('MED010', 'Paquetes');
GO

INSERT INTO PROVEEDORES (CODPROVEEDOR, NOMBRE, DIRECCION, TELEFONO, EMAIL, NOM_CONTAC)
VALUES 
('PROV1', 'Papelera Lima', 'Av. Principal 123, Lima', '987654321', 'contacto@papelera-lima.com', 'Carlos Pérez'),
('PROV2', 'Resinas Andinas', 'Calle Secundaria 456, Cusco', '976543210', 'ventas@resinasandinas.com', 'Ana Martínez'),
('PROV3', 'Embalajes Norte', 'Jr. Comercio 789, Trujillo', '965432109', 'info@embalajesnorte.com', 'Jorge Ramírez'),
('PROV4', 'Papeles del Sur', 'Av. Industrial 321, Arequipa', '954321098', 'contacto@papelessur.com', 'Laura Fernández'),
('PROV5', 'Adhesivos Central', 'Calle Mayor 654, Huancayo', '943210987', 'soporte@adhesivoscentral.com', 'Mario Díaz'),
('PROV6', 'Impresos Modernos', 'Av. Imprenta 987, Lima', '932109876', 'contacto@impresosmodernos.com', 'Sofía López'),
('PROV7', 'Plásticos Universal', 'Jr. Progreso 111, Iquitos', '921098765', 'ventas@plasticosuniversal.com', 'Ricardo Torres'),
('PROV8', 'Suministros Grau', 'Calle Libertad 222, Piura', '910987654', 'soporte@suministrosgrau.com', 'Fernando Castillo'),
('PROV9', 'Envolturas Creativas', 'Av. Decoración 333, Chiclayo', '909876543', 'contacto@envolturascreativas.com', 'Valeria Gómez'),
('PROV10', 'Papelera Andina', 'Jr. Montaña 444, Huaraz', '898765432', 'ventas@papeleraandina.com', 'Héctor Villegas');
GO


INSERT INTO MATERIA_PRIMA (CODMATERIA, NOMBRE, DESCRIPCION,TOTALMATERIA,COD_UNI_MEDIDA, CODPROVEEDOR) VALUES 
('MAT1', 'Papel Bond', 'Papel blanco para impresión',500, 'MED009', 'PROV1'),
('MAT2', 'Tinta Negra', 'Tinta negra para impresión',100, 'MED004', 'PROV2'),
('MAT3', 'Cartón Corrugado', 'Cartón resistente para embalaje', 300,'MED003', 'PROV3'),
('MAT4', 'Papel Reciclado', 'Papel reciclado para impresiones',700, 'MED009', 'PROV4'),
('MAT5', 'Tinta Color', 'Tinta de varios colores para impresión', 400,'MED005', 'PROV2'),
('MAT6', 'Cinta Adhesiva', 'Cinta adhesiva para embalaje',200, 'MED010', 'PROV5'),
('MAT7', 'Papel Couché', 'Papel brillante para revistas',4800, 'MED009', 'PROV6'),
('MAT8', 'Plástico Transparente', 'Plástico para envolver productos', 600,'MED001', 'PROV7'),
('MAT9', 'Pegamento', 'Pegamento fuerte para encuadernación', 400,'MED002', 'PROV8'),
('MAT10', 'Envoltura de Regalo', 'Papel decorativo para regalos',300, 'MED003', 'PROV9');
GO
SELECT * FROM MATERIA_PRIMA
INSERT INTO PRODUCTO (CODPRODUCTO, NOMPRODUC, PRECIO_UNI, STOCK, CODGRAMAJE, CODTAMANHO, CODACABADO)
VALUES 
('PROD01', 'Millar de Papel Bond A4 Brillante', 200, 800, 'GRA001', 'TAM001', 'ACA01'),
('PROD02', 'Paquete de 1000 Cartones Corrugados A3 Mate', 500, 5000, 'GRA002', 'TAM002', 'ACA02'),
('PROD03', 'Millar de Papel Couché A4 Brillante', 300, 8000, 'GRA003', 'TAM001', 'ACA01'),
('PROD04', 'Paquete de 1000 Papeles Reciclados A4 Mate', 150, 6000, 'GRA004', 'TAM001', 'ACA02'),
('PROD05', 'Millar de Papel Couché A3 Brillante', 450, 7000, 'GRA003', 'TAM002', 'ACA01'),
('PROD06', 'Paquete de 1000 Cartones Corrugados A4 Mate', 350, 4000, 'GRA002', 'TAM001', 'ACA02'),
('PROD07', 'Millar de Papel Bond A3 Brillante', 200, 12000, 'GRA001', 'TAM002', 'ACA01'),
('PROD08', 'Paquete de 1000 Papeles Reciclados A3 Mate', 250, 5000, 'GRA004', 'TAM002', 'ACA02'),
('PROD09', 'Millar de Papel Couché A3 Mate', 400, 3000, 'GRA003', 'TAM002', 'ACA02'),
('PROD10', 'Paquete de 1000 Papeles Bond A4 Mate', 120, 2000, 'GRA001', 'TAM001', 'ACA02');
GO



INSERT INTO CARGO (CODCARGO, NOMBRE) VALUES ('C001', 'Gerente de Producción');
INSERT INTO CARGO (CODCARGO, NOMBRE) VALUES ('C002', 'Supervisor de Calidad');
INSERT INTO CARGO (CODCARGO, NOMBRE) VALUES ('C003', 'Limpieza');
INSERT INTO CARGO (CODCARGO, NOMBRE) VALUES ('C004', 'Técnico de Mantenimiento');
INSERT INTO CARGO (CODCARGO, NOMBRE) VALUES ('C005', 'Asistente Administrativo');
INSERT INTO CARGO (CODCARGO, NOMBRE) VALUES ('C006', 'Encargado de Logística');
INSERT INTO CARGO (CODCARGO, NOMBRE) VALUES ('C007', 'Jefe de Ventas');
INSERT INTO CARGO (CODCARGO, NOMBRE) VALUES ('C008', 'Diseñador Gráfico');
INSERT INTO CARGO (CODCARGO, NOMBRE) VALUES ('C009', 'Contador');
INSERT INTO CARGO (CODCARGO, NOMBRE) VALUES ('C010', 'Vendedor');


-- Insertar registros en la tabla AREA
INSERT INTO AREA (CODAREA, NOMBRE) VALUES ('A001', 'Producción');
INSERT INTO AREA (CODAREA, NOMBRE) VALUES ('A002', 'Calidad');
INSERT INTO AREA (CODAREA, NOMBRE) VALUES ('A003', 'Mantenimiento');
INSERT INTO AREA (CODAREA, NOMBRE) VALUES ('A004', 'Administración');
INSERT INTO AREA (CODAREA, NOMBRE) VALUES ('A006', 'Ventas');
INSERT INTO AREA (CODAREA, NOMBRE) VALUES ('A007', 'Diseño Gráfico');
INSERT INTO AREA (CODAREA, NOMBRE) VALUES ('A008', 'Contabilidad');


-- Insertar registros en la tabla DISTRITO con distritos de Lima, Perú
INSERT INTO DISTRITO (CODDISTRITO, NOMBRE) VALUES ('D001', 'Miraflores');
INSERT INTO DISTRITO (CODDISTRITO, NOMBRE) VALUES ('D002', 'San Isidro');
INSERT INTO DISTRITO (CODDISTRITO, NOMBRE) VALUES ('D003', 'Barranco');
INSERT INTO DISTRITO (CODDISTRITO, NOMBRE) VALUES ('D004', 'Lima Cercado');
INSERT INTO DISTRITO (CODDISTRITO, NOMBRE) VALUES ('D005', 'Surco');
INSERT INTO DISTRITO (CODDISTRITO, NOMBRE) VALUES ('D006', 'San Borja');
INSERT INTO DISTRITO (CODDISTRITO, NOMBRE) VALUES ('D007', 'San Luis');
INSERT INTO DISTRITO (CODDISTRITO, NOMBRE) VALUES ('D008', 'La Molina');
INSERT INTO DISTRITO (CODDISTRITO, NOMBRE) VALUES ('D009', 'Chorrillos');
INSERT INTO DISTRITO (CODDISTRITO, NOMBRE) VALUES ('D010', 'San Juan de Lurigancho');


INSERT INTO EMPLEADO (CODEMPLE, NOMBRE, APELLIDO, DIRECCION, TELEFONO, EMAIL, SALARIO, DNI, FECHA_INGRESO, CODDISTRITO, CODCARGO, CODAREA) 
VALUES 
('E001', 'Juan', 'Pérez', 'Av. Pardo 123, Miraflores', '987654321', 'juan.perez@gmail.com', 3500.00, '12345678', '2024-01-15', 'D001', 'C010', 'A006'),
('E002', 'María', 'García', 'Av. Javier Prado 456, San Isidro', '987654322', 'maria.garcia@hotmail.com', 1800.00, '23456789', '2024-02-20', 'D002', 'C010', 'A006'),
('E003', 'Luis', 'Martínez', 'Calle Colina 789, Barranco', '987654323', 'luis.martinez@gmail.com', 1100.00, '34567890', '2024-03-10', 'D003', 'C003', 'A006'),
('E004', 'Ana', 'Fernández', 'Jr. Castañeda 101, Lima Cercado', '987654324', 'ana.fernandez@hotmail.com', 2500.00, '45678901', '2024-04-05', 'D004', 'C010', 'A006'),
('E005', 'Pedro', 'Sánchez', 'Av. Higuereta 202, Surco', '987654325', 'pedro.sanchez@gmail.com', 2500.00, '56789012', '2024-05-12', 'D005', 'C005', 'A006'),
('E006', 'Laura', 'Gómez', 'Av. San Borja Norte 303, San Borja', '987654326', 'laura.gomez@hotmail.com', 1800.00, '67890123', '2024-06-15', 'D006', 'C010', 'A006'),
('E007', 'Carlos', 'Ramírez', 'Av. San Luis 404, San Luis', '987654327', 'carlos.ramirez@gmail.com', 2000.00, '78901234', '2024-07-20', 'D007', 'C010', 'A006'),
('E008', 'Isabel', 'Torres', 'Calle La Molina 505, La Molina', '987654328', 'isabel.torres@hotmail.com', 1800.00, '89012345', '2024-08-25', 'D008', 'C010', 'A008'),
('E009', 'Fernando', 'Reyes', 'Av. Grau 606, Chorrillos', '987654329', 'fernando.reyes@gmail.com', 3500.00, '90123456', '2024-09-10', 'D009', 'C009', 'A006'),
('E010', 'Susana', 'Cruz', 'Av. Próceres 707, San Juan de Lurigancho', '987654330', 'susana.cruz@hotmail.com', 1150.00, '01234567', '2024-10-15', 'D010', 'C010', 'A006');

SELECT * FROM EMPLEADO

-- Insertar registros en la tabla CLIENTE
INSERT INTO CLIENTE (IDCLIENTE, NOMBRE, APELLIDO, DIRECCION, TELEFONO, EMAIL, CODDISTRITO) 
VALUES 
('C001', 'Luis', 'Gómez', 'Av. Arequipa 500, Miraflores', '945678901', 'luis.gomez@gmail.com', 'D010'),
('C002', 'Ana', 'Mendoza', 'Jr. Zárate 200, San Isidro', '945678902', 'ana.mendoza@hotmail.com', 'D002'),
('C003', 'Carlos', 'Castro', 'Calle Las Flores 123, San Borja', '945678903', 'carlos.castro@gmail.com', 'D010'),
('C004', 'María', 'Paredes', 'Av. Villarán 456, La Victoria', '945678904', 'maria.paredes@hotmail.com', 'D010'),
('C005', 'Pedro', 'Soto', 'Av. Javier Prado 789, San Luis', '945678905', 'pedro.soto@gmail.com', 'D005'),
('C006', 'Laura', 'Ríos', 'Av. Pardo 101, Barranco', '945678906', 'laura.rios@hotmail.com', 'D006'),
('C007', 'Fernando', 'Vega', 'Av. Grau 202, Chorrillos', '945678907', 'fernando.vega@gmail.com', 'D007'),
('C008', 'Susana', 'Fernández', 'Calle Los Olivos 303, Surco', '945678908', 'susana.fernandez@hotmail.com', 'D008'),
('C009', 'Ricardo', 'Márquez', 'Av. San Juan 404, San Juan de Lurigancho', '945678909', 'ricardo.marquez@gmail.com', 'D009'),
('C010', 'Isabel', 'Martínez', 'Av. Nicolás Ayllón 505, La Molina', '945678910', 'isabel.martinez@hotmail.com', 'D010');
GO

--REGISTROS DE TIPO DE DOCUMENTO
INSERT INTO TIPO_DOCUMENTO(COD_TIPO_DOCUMENTO, NOMBRE) VALUES ('TD001', 'Factura');
INSERT INTO TIPO_DOCUMENTO(COD_TIPO_DOCUMENTO, NOMBRE) VALUES ('TD002', 'Boleta');


-- Insertar registros en la tabla DOCUMENTOVENTA
INSERT INTO DOCUMENTOVENTA (CODVENT, FECHA_EMI, FECHA_ENTREGA, IDCLIENTE, CODEMPLE, COD_TIPO_DOCUMENTO)
VALUES
('DV001', '2024-01-01', '2024-08-07', 'C001', 'E001', 'TD001'),
('DV002', '2024-05-02', '2024-08-08', 'C002', 'E002', 'TD002'),
('DV003', '2024-08-03', '2024-08-09', 'C003', 'E003', 'TD001'),
('DV004', '2024-04-14', '2024-08-10', 'C003', 'E004', 'TD001'),
('DV005', '2024-08-05', '2024-08-11', 'C005', 'E005', 'TD001'),
('DV006', '2024-08-06', '2024-08-12', 'C001', 'E001', 'TD002'),
('DV007', '2024-08-07', '2024-08-13', 'C007', 'E002', 'TD002'),
('DV008', '2024-08-28', '2024-08-14', 'C002', 'E008', 'TD002'),
('DV009', '2024-08-09', '2024-08-15', 'C009', 'E002', 'TD001'),
('DV010', '2024-08-10', '2024-08-16', 'C001', 'E001', 'TD002');
GO




-- Insertar registros en la tabla DETALLEVENTA
INSERT INTO DETALLEVENTA (CODVENT, CODPRODUCTO, PRECIOVENTA, CANTIDAD, IMPORTE)
VALUES
('DV001', 'PROD01', 220, 10, 2200.00),  
('DV001', 'PROD03', 310, 5, 1550.00),    
('DV002', 'PROD02', 530, 1, 530.00),     
('DV002', 'PROD04', 160, 1, 160.00),    
('DV003', 'PROD05', 450, 1, 450.00),      
('DV003', 'PROD01', 220, 1, 220.00),    
('DV004', 'PROD07', 220, 6, 1320.00),     
('DV004', 'PROD08', 250, 2, 500.00),    
('DV005', 'PROD02', 530, 1, 530.00),    
('DV005', 'PROD01', 200, 1, 200.00);    
GO


INSERT INTO MOVI_INVENTARIO (COD_MOVI_INVEN, FECHAMOVIMIENTO, STOCKFINAL)
VALUES
('MOV01', '2024-08-27', 790),  -- Se vendió 1 unidad de millar de Papel Bond A4 Brillante
('MOV02', '2024-08-27', 5005), -- Se recibieron 5 unidades de paquetes de Cartón Corrugado A3 Mate
('MOV03', '2024-08-27', 7995), -- Se vendieron 8 unidades de millares de Papel Couché A4 Brillante
('MOV04', '2024-08-27', 5999), -- Se vendieron 6 unidades de paquetes de Papel Reciclado A4 Mate
('MOV05', '2024-08-27', 7007), -- Se produjeron 7 unidades de millares de Papel Couché A3 Brillante
('MOV06', '2024-08-27', 4004), -- Se recibieron 4 unidades de paquetes de Cartón Corrugado A4 Mate
('MOV07', '2024-08-27', 789),-- Se vendieron 12 unidades de millares de Papel Bond A3 Brillante
('MOV08', '2024-08-27', 5005), -- Se produjeron 5 unidades de paquetes de Papel Reciclado A3 Mate
('MOV09', '2024-08-27', 788), -- Se vendieron 3 unidades de millares de Papel Couché A3 Mate
('MOV10', '2024-08-27', 2002); -- Se recibieron 2 unidades de paquetes de Papel Bond A4 Mate
GO

INSERT INTO DETALLEMOVIMIENTO (COD_MOVI_INVEN, CODPRODUCTO, CANTIDAD, TIPOMOVIMIENTO, COMENTARIO)
VALUES
('MOV01', 'PROD01', 10, 'SALIDA', 'Venta de 10 millares de Papel Bond A4 Brillante'),
('MOV02', 'PROD02', 5, 'ENTRADA', 'Recepción de 5 paquetes de Cartón Corrugado A3 Mate'),
('MOV03', 'PROD03', 5, 'SALIDA', 'Venta de 5 millares de Papel Couché A4 Brillante'),
('MOV04', 'PROD04', 1, 'SALIDA', 'Venta de 1 paquete de Papel Reciclado A4 Mate'),
('MOV05', 'PROD05', 7, 'ENTRADA', 'Producción de 7 millares de Papel Couché A3 Brillante'),
('MOV06', 'PROD06', 4, 'ENTRADA', 'Recepción de 4 paquetes de Cartón Corrugado A4 Mate'),
('MOV07', 'PROD01', 1, 'SALIDA', 'Venta de 1 millar de Papel Bond A4 Brillante'),
('MOV08', 'PROD08', 5, 'ENTRADA', 'Producción de 5 paquetes de Papel Reciclado A3 Mate'),
('MOV09', 'PROD01', 1, 'SALIDA', 'Venta de 1 millar de Papel Bond A4 Brillante'),
('MOV10', 'PROD10', 2, 'ENTRADA', 'Recepción de 2 paquetes de Papel Bond A4 Mate');
GO

INSERT INTO DETALLEP_M_P (CODPRODUCTO, CODMATERIA, CANTIDAD_MATERIA)
VALUES
('PROD01', 'MAT1', 5),		-- Papel Bond
('PROD01', 'MAT2', 3),		-- Tinta Negra
('PROD02', 'MAT3', 6),		-- Cartón Corrugado
('PROD02', 'MAT6', 4),		-- Cinta Adhesiva
('PROD03', 'MAT7', 7),		-- Papel Couché
('PROD03', 'MAT5', 4),		--Tinta Color
('PROD04', 'MAT4', 6),		-- Papel Reciclado
('PROD04', 'MAT2', 5),		 --  Tinta Negra
('PROD05', 'MAT7', 3),		-- Papel Couché
('PROD05', 'MAT5', 5),		 -- Tinta Color
('PROD06', 'MAT3', 5),		-- MCartón Corrugado
('PROD06', 'MAT6', 5),		 --  Cinta Adhesiva
('PROD07', 'MAT1', 3),		-- Papel Bond
('PROD07', 'MAT2', 2),		-- Tinta Negra
('PROD08', 'MAT4', 70),		-- Papel Reciclado
('PROD08', 'MAT2', 7),		 -- Tinta Negra
('PROD09', 'MAT7', 5),		-- Papel Couché
('PROD09', 'MAT5', 6),		-- Tinta Color
('PROD10', 'MAT1', 5),		-- Papel Bond
('PROD10', 'MAT2', 4);		-- Tinta Negra
GO



