-- =====================================================================
-- INSTITUTO UNIVERSITARIO DE TECNOLOGIA "ANTONIO JOSE DE SUCRE"
-- DESAFIO PRACTICO 2 - Prof.: Julio Castillo
-- Practica Avanzada de SQL: SELECT, UPDATE, DELETE, WHERE y VISTAS (MySQL)
-- Escenario: tienda de ropa en linea
-- Participante: [TU NOMBRE Y APELLIDO]   C.I.: [TU CEDULA]
-- =====================================================================


-- =====================================================================
-- 1. CREACION DE LA BASE DE DATOS
-- =====================================================================
DROP DATABASE IF EXISTS tienda_ropa;
CREATE DATABASE tienda_ropa CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tienda_ropa;


-- =====================================================================
-- 2. CREACION DE TABLAS (con claves primarias y foraneas)
-- =====================================================================

-- Tabla clientes
CREATE TABLE clientes (
    id_cliente  INT AUTO_INCREMENT,
    nombre      VARCHAR(50)  NOT NULL,
    apellido    VARCHAR(50)  NOT NULL,
    direccion   VARCHAR(150) NOT NULL,
    correo      VARCHAR(100) NOT NULL UNIQUE,
    telefono    VARCHAR(20),
    PRIMARY KEY (id_cliente)
);

-- Tabla productos
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT,
    nombre      VARCHAR(80)   NOT NULL,
    descripcion VARCHAR(200),
    precio      DECIMAL(10,2) NOT NULL,
    categoria   VARCHAR(40)   NOT NULL,
    stock       INT           NOT NULL DEFAULT 0,
    PRIMARY KEY (id_producto)
);

-- Tabla pedidos (clave foranea hacia clientes)
CREATE TABLE pedidos (
    id_pedido   INT AUTO_INCREMENT,
    id_cliente  INT           NOT NULL,
    fecha       DATE          NOT NULL,
    estado      VARCHAR(20)   NOT NULL,
    total       DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido),
    CONSTRAINT fk_pedidos_clientes
        FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente)
);

-- Tabla ventas (claves foraneas hacia pedidos y productos)
CREATE TABLE ventas (
    id_venta      INT AUTO_INCREMENT,
    id_pedido     INT           NOT NULL,
    id_producto   INT           NOT NULL,
    cantidad      INT           NOT NULL,
    precio_venta  DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_venta),
    CONSTRAINT fk_ventas_pedidos
        FOREIGN KEY (id_pedido)   REFERENCES pedidos (id_pedido),
    CONSTRAINT fk_ventas_productos
        FOREIGN KEY (id_producto) REFERENCES productos (id_producto)
);


-- =====================================================================
-- 3. INSERCION DE REGISTROS
--    Las fechas son relativas a CURDATE() para que las consultas
--    de "ultimos 30 dias / ultimo mes / ultimo anio" siempre den datos.
-- =====================================================================

INSERT INTO clientes (id_cliente, nombre, apellido, direccion, correo, telefono) VALUES
(1, 'Maria',   'Gonzalez', 'Av. Bolivar, Edif. Sol, Apto 3B, Caracas',   'maria.gonzalez@correo.com', '0412-1112233'),
(2, 'Carlos',  'Perez',    'Calle 5 con Carrera 8, Barquisimeto',        'carlos.perez@correo.com',   '0414-2223344'),
(3, 'Ana',     'Rodriguez','Urb. Las Mercedes, Casa 12, Valencia',       'ana.rodriguez@correo.com',  '0424-3334455'),
(4, 'Luis',    'Martinez', 'Av. Libertador, Torre Norte, Maracaibo',     'luis.martinez@correo.com',  '0416-4445566'),
(5, 'Sofia',   'Ramirez',  'Calle Sucre, Casa 45, Cumana',               'sofia.ramirez@correo.com',  '0412-5556677'),
(6, 'Jose',    'Hernandez','Av. Intercomunal, Qta. Rosa, Puerto La Cruz','jose.hernandez@correo.com', '0414-6667788'),
(7, 'Laura',   'Diaz',     'Sector Centro, Calle 3, Merida',             'laura.diaz@correo.com',     '0424-7778899'),
(8, 'Pedro',   'Torres',   'Urb. El Paraiso, Apto 7, Caracas',           'pedro.torres@correo.com',   '0416-8889900');

INSERT INTO productos (id_producto, nombre, descripcion, precio, categoria, stock) VALUES
(1,  'Camiseta Basica Blanca',  'Camiseta de algodon cuello redondo', 15.00, 'Camisetas',  100),
(2,  'Camiseta Estampada Negra','Camiseta con estampado grafico',     20.00, 'Camisetas',   80),
(3,  'Camiseta Polo Azul',      'Polo de piqué manga corta',          25.00, 'Camisetas',   60),
(4,  'Jean Slim Fit',           'Pantalon de mezclilla ajustado',     45.00, 'Pantalones',  50),
(5,  'Pantalon Cargo',          'Pantalon con bolsillos laterales',   40.00, 'Pantalones',  40),
(6,  'Chaqueta Denim',          'Chaqueta de mezclilla clasica',      70.00, 'Chaquetas',   30),
(7,  'Sudadera con Capucha',    'Sudadera de felpa con capucha',      50.00, 'Sudaderas',   45),
(8,  'Zapatillas Urbanas',      'Calzado casual para uso diario',     65.00, 'Calzado',     35),
(9,  'Gorra Deportiva',         'Gorra ajustable de poliester',       12.00, 'Accesorios', 120),
(10, 'Cinturon de Cuero',       'Cinturon de cuero genuino',          18.00, 'Accesorios',  70);

INSERT INTO pedidos (id_pedido, id_cliente, fecha, estado, total) VALUES
(1,  1, DATE_SUB(CURDATE(), INTERVAL 5   DAY), 'Entregado', 75.00),
(2,  1, DATE_SUB(CURDATE(), INTERVAL 12  DAY), 'Entregado', 57.00),
(3,  2, DATE_SUB(CURDATE(), INTERVAL 20  DAY), 'Enviado',   90.00),
(4,  3, DATE_SUB(CURDATE(), INTERVAL 40  DAY), 'Entregado', 70.00),
(5,  4, DATE_SUB(CURDATE(), INTERVAL 3   DAY), 'Pendiente', 85.00),
(6,  2, DATE_SUB(CURDATE(), INTERVAL 100 DAY), 'Entregado', 65.00),
(7,  5, DATE_SUB(CURDATE(), INTERVAL 200 DAY), 'Entregado', 80.00),
(8,  1, DATE_SUB(CURDATE(), INTERVAL 300 DAY), 'Entregado', 42.00),
(9,  3, DATE_SUB(CURDATE(), INTERVAL 15  DAY), 'Enviado',   35.00),
(10, 6, DATE_SUB(CURDATE(), INTERVAL 500 DAY), 'Entregado', 45.00),
(11, 7, DATE_SUB(CURDATE(), INTERVAL 8   DAY), 'Cancelado', 30.00),  -- sin ventas
(12, 8, DATE_SUB(CURDATE(), INTERVAL 60  DAY), 'Cancelado', 55.00);  -- sin ventas

INSERT INTO ventas (id_venta, id_pedido, id_producto, cantidad, precio_venta) VALUES
(1,  1, 1,  2, 15.00),
(2,  1, 4,  1, 45.00),
(3,  2, 1,  3, 15.00),
(4,  2, 9,  1, 12.00),
(5,  3, 2,  2, 20.00),
(6,  3, 7,  1, 50.00),
(7,  4, 6,  1, 70.00),
(8,  5, 1,  4, 15.00),
(9,  5, 3,  1, 25.00),
(10, 6, 8,  1, 65.00),
(11, 7, 5,  2, 40.00),
(12, 8, 10, 1, 18.00),
(13, 8, 9,  2, 12.00),
(14, 9, 2,  1, 20.00),
(15, 9, 1,  1, 15.00),
(16, 10, 4, 1, 45.00);

-- Verificacion de los datos cargados
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM pedidos;
SELECT * FROM ventas;


-- =====================================================================
-- 4. a) CONSULTAS AVANZADAS CON SELECT (y WHERE)
-- =====================================================================

-- Consulta 1: nombre completo, direccion y correo de los clientes
--             que realizaron pedidos en los ultimos 30 dias.
SELECT DISTINCT
       CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
       c.direccion,
       c.correo
FROM clientes c
INNER JOIN pedidos p ON p.id_cliente = c.id_cliente
WHERE p.fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Consulta 2: productos con mayor cantidad de ventas en el ultimo mes,
--             junto con el total vendido de cada uno.
SELECT pr.id_producto,
       pr.nombre                       AS producto,
       SUM(v.cantidad)                 AS unidades_vendidas,
       SUM(v.cantidad * v.precio_venta) AS total_vendido
FROM ventas v
INNER JOIN pedidos   p  ON p.id_pedido   = v.id_pedido
INNER JOIN productos pr ON pr.id_producto = v.id_producto
WHERE p.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY pr.id_producto, pr.nombre
ORDER BY unidades_vendidas DESC, total_vendido DESC;

-- Consulta 3: clientes con mas pedidos en el ultimo anio,
--             ordenados de mayor a menor cantidad de pedidos.
SELECT c.id_cliente,
       CONCAT(c.nombre, ' ', c.apellido) AS cliente,
       COUNT(p.id_pedido)                AS cantidad_pedidos
FROM clientes c
INNER JOIN pedidos p ON p.id_cliente = c.id_cliente
WHERE p.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY c.id_cliente, c.nombre, c.apellido
ORDER BY cantidad_pedidos DESC, cliente ASC;


-- =====================================================================
-- 4. b) ACTUALIZACIONES CON UPDATE
-- =====================================================================
-- (Se desactiva temporalmente el modo seguro de MySQL Workbench)
SET SQL_SAFE_UPDATES = 0;

-- Actualizacion 1: aumentar 10% el precio de los productos de "Camisetas".
-- Precios ANTES:
SELECT id_producto, nombre, categoria, precio
FROM productos WHERE categoria = 'Camisetas';

UPDATE productos
SET precio = ROUND(precio * 1.10, 2)
WHERE categoria = 'Camisetas';

-- Precios DESPUES:
SELECT id_producto, nombre, categoria, precio
FROM productos WHERE categoria = 'Camisetas';


-- =====================================================================
-- 4. c) ELIMINACIONES CON DELETE
-- =====================================================================

-- Eliminacion 2: eliminar los pedidos que no tengan ventas asociadas.
-- Pedidos candidatos ANTES de borrar:
SELECT p.*
FROM pedidos p
WHERE NOT EXISTS (SELECT 1 FROM ventas v WHERE v.id_pedido = p.id_pedido);

DELETE FROM pedidos
WHERE NOT EXISTS (SELECT 1 FROM ventas v WHERE v.id_pedido = pedidos.id_pedido);

-- Verificacion DESPUES (deben quedar 10 pedidos):
SELECT * FROM pedidos;

SET SQL_SAFE_UPDATES = 1;


-- =====================================================================
-- 4. d) CREACION DE VISTAS
-- =====================================================================

-- Vista 1: nombre completo del cliente, fecha y total del pedido.
CREATE OR REPLACE VIEW vista_clientes_pedidos AS
SELECT CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo,
       p.fecha                           AS fecha_pedido,
       p.total                           AS total_pedido
FROM clientes c
INNER JOIN pedidos p ON p.id_cliente = c.id_cliente;

-- Uso de la vista:
SELECT * FROM vista_clientes_pedidos ORDER BY fecha_pedido DESC;


-- =====================================================================
-- COPIA DE SEGURIDAD (se ejecuta desde la terminal, no desde el cliente SQL):
--   mysqldump -u root -p tienda_ropa > respaldo_tienda_ropa.sql
-- Restaurar:
--   mysql -u root -p tienda_ropa < respaldo_tienda_ropa.sql
-- =====================================================================
