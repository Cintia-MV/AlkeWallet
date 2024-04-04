/*Crear base de datos*/
CREATE DATABASE IF NOT EXISTS Alke_wallet DEFAULT CHARACTER SET utf8;

/*Seleccionar base de datos*/
USE Alke_wallet;

/*Crear tabla Usuario*/
CREATE TABLE IF NOT EXISTS usuario(
id_usuario INT PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
nombre_user VARCHAR(50) NOT NULL,
correo_electronico VARCHAR(50) NOT NULL,
contrasena VARCHAR(20) NOT NULL,
saldo INT NOT NULL
);

-- Crear tabla transaccion
CREATE TABLE IF NOT EXISTS transaccion(
id_transaccion INT PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
emisor_user_id INT NOT NULL,
receptor_user_id INT NOT NULL,
monto INT NOT NULL,
fecha_transaccion DATE NOT NULL,
FOREIGN KEY (emisor_user_id) REFERENCES usuario(id_usuario),
FOREIGN KEY (receptor_user_id) REFERENCES usuario(id_usuario)
);

-- Crear tabla moneda
CREATE TABLE IF NOT EXISTS moneda(
id_moneda INT PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
nombre_moneda VARCHAR(45) NOT NULL,
simbolo_moneda VARCHAR(10) NOT NULL
);

-- Crear tabla intermedia transaccion_moneda
CREATE TABLE IF NOT EXISTS transaccion_moneda (
    id_transaccion INT NOT NULL,
    id_moneda INT NOT NULL,
    FOREIGN KEY (id_transaccion) REFERENCES transaccion(id_transaccion),
    FOREIGN KEY (id_moneda) REFERENCES moneda(id_moneda)
);

-- Ingresar datos en tabla usuario
INSERT INTO usuario (nombre_user, correo_electronico, contrasena, saldo) VALUES
('Juan Pérez', 'juan.perez@example.com', '123456', 100000),
('María González', 'maria.gonzalez@example.com', 'password', 150000),
('Pedro Rodríguez', 'pedro.rodriguez@example.com', 'abc123', 200000),
('Catalina Silva', 'catalina.silva@example.com', 'qwerty', 80000),
('Diego Muñoz', 'diego.munoz@example.com', 'pass123', 30000);

-- Mostrar datos de tabla usuario
SELECT * FROM usuario;

-- Insertar datos en la tabla transaccion
INSERT INTO transaccion (emisor_user_id, receptor_user_id, monto, fecha_transaccion) VALUES
(1, 2, 5000, '2024-04-01'),
(3, 1, 3000, '2024-04-02'),
(2, 4, 7000, '2024-04-03'),
(5, 3, 2000, '2024-04-04'),
(4, 1, 4000, '2024-04-05'),
(2, 5, 1000, '2024-04-06');


-- Mostrar datos de la tabla transaccion
SELECT * FROM transaccion;

-- Insertar datos en la tabla moneda
INSERT INTO moneda (nombre_moneda, simbolo_moneda) VALUES
('Dolar', 'USD'),
('Peso chileno', 'CLP'),
('Euro', 'EUR');

-- Mostrar datos de la tabla moneda
SELECT * FROM moneda;

-- Insertar datos en la tabla intermedia
INSERT INTO transaccion_moneda (id_transaccion, id_moneda) VALUES
(1, 1),  -- La transacción 1 utiliza dólares
(2, 3),  -- La transacción 2 utiliza euros
(3, 2),  -- La transacción 3 utiliza pesos chilenos
(4, 1),  -- La transacción 4 utiliza dólares
(5, 2);  -- La transacción 5 utiliza pesos chilenos

-- Mostrar datos de la tabla moneda
SELECT * FROM transaccion_moneda;


						-- ----------- --
						-- CONSULTAS --
						-- ---------- --

/* 1.- Consulta para obtener el nombre de la moneda elegida por un
usuario específico */
SELECT usuario.nombre_user AS Usuario, 
moneda.nombre_moneda AS Divisa
FROM usuario
INNER JOIN transaccion ON usuario.id_usuario = transaccion.emisor_user_id  -- se une tabla transaccion con tabla usuario
INNER JOIN transaccion_moneda ON transaccion.id_transaccion = transaccion_moneda.id_transaccion -- se une tabla transaccion con tabla intermedia
INNER JOIN moneda ON transaccion_moneda.id_moneda = moneda.id_moneda -- se une tabla moneda con tabla intermedia
WHERE usuario.nombre_user = 'Pedro Rodríguez';

/* 2.- Consulta para obtener las transacciones realizadas por un usuario
específico */
SELECT usuario.nombre_user AS Emisor, 
emisor_user_id AS Id_emisor, 
usuario_receptor.nombre_user AS Receptor,
receptor_user_id AS id_receptor,
transaccion.id_transaccion AS numero_transaccion, 
monto, fecha_transaccion AS fecha
FROM usuario
INNER JOIN transaccion ON usuario.id_usuario = transaccion.emisor_user_id
INNER JOIN usuario AS usuario_receptor ON transaccion.receptor_user_id = usuario_receptor.id_usuario
WHERE usuario.nombre_user = "María González";

/*3.- Consulta para obtener todos los usuarios registrados*/
SELECT id_usuario AS id, nombre_user AS nombre,correo_electronico AS correo,saldo -- no muestro la contraseña
FROM usuario;

/*4.- Consulta para obtener todas las monedas registradas*/
SELECT * FROM moneda;

/*5.- Consulta para obtener todas las transacciones registradas*/
SELECT * FROM transaccion;

/*6.- Consulta para obtener todas las transacciones recibidas por un
usuario específico*/
SELECT usuario.nombre_user AS Nombre_receptor, 
	   receptor_user_id AS id_receptor,
       usuario_emisor.nombre_user AS Nombre_emisor,
       emisor_user_id AS id_emisor,
       transaccion.id_transaccion AS numero_transaccion, 
       transaccion.monto, 
       transaccion.fecha_transaccion AS fecha
FROM usuario
INNER JOIN transaccion ON usuario.id_usuario = transaccion.receptor_user_id
INNER JOIN usuario AS usuario_emisor ON transaccion.emisor_user_id = usuario_emisor.id_usuario
WHERE usuario.nombre_user = "Juan Pérez"; -- nombre de quién recibe la transacción

/*7.- Sentencia DML para modificar el campo correo electrónico de un
usuario específico*/
UPDATE usuario SET correo_electronico = 'juan.p@mail.com' WHERE id_usuario = 1;

/*8.- Sentencia para eliminar los datos de una transacción (eliminado de
la fila completa)*/
DELETE FROM transaccion_moneda WHERE id_transaccion = 5;
DELETE FROM transaccion WHERE id_transaccion = 5;

/*9.- Sentencia para DDL modificar el nombre de la columna correo_electronico por email*/
ALTER TABLE usuario RENAME COLUMN correo_electronico TO email;