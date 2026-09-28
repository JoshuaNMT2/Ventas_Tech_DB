-- Ventas_Tech_DB — versión MySQL Workbench
-- Autor: Joshua Maldonado

-- ============================================================
-- Paso 1: Crear la base de datos
-- ============================================================
CREATE DATABASE Ventas_Tech_DB;

USE Ventas_Tech_DB;

-- ============================================================
-- Paso 2a: DROP TABLES
-- ============================================================
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS regiones;

-- ============================================================
-- Paso 2b: CREATE TABLES
-- ============================================================
CREATE TABLE categorias (
    id_categoria     INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion      VARCHAR(200)
);

-- Tabla regiones — agregada en el Módulo 5: dimensión geográfica que
-- faltaba en el esquema, para poder mostrar una columna descriptiva
-- extra al hacer JOIN en la pre-entrega de M5.
CREATE TABLE regiones (
    id_region     INT PRIMARY KEY,
    nombre_region VARCHAR(50) NOT NULL
);

CREATE TABLE clientes (
    id_cliente     INT PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    email          VARCHAR(100) UNIQUE,
    ciudad         VARCHAR(50),
    fecha_registro DATE NOT NULL,
    id_region      INT,
    FOREIGN KEY (id_region) REFERENCES regiones(id_region)
);

CREATE TABLE productos (
    id_producto     INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria    INT,
    precio          DECIMAL(10,2) NOT NULL,
    stock           INT DEFAULT 0,
    activo          TINYINT(1) DEFAULT 1,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE ventas (
    id_venta        INT PRIMARY KEY,
    id_cliente      INT,
    id_producto     INT,
    cantidad        INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta     DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- ============================================================
-- Paso 2c: INSERT DATA
-- ============================================================

-- categorias (4 registros)
INSERT INTO categorias VALUES (1, 'Computación', 'Laptops, PCs y monitores');
INSERT INTO categorias VALUES (2, 'Accesorios', 'Periféricos y complementos');
INSERT INTO categorias VALUES (3, 'Audio', 'Auriculares y parlantes');
INSERT INTO categorias VALUES (4, 'Almacenamiento', 'Discos y memorias');

-- regiones (4 registros, agregados en M5)
INSERT INTO regiones VALUES (1, 'Centro');
INSERT INTO regiones VALUES (2, 'Litoral');
INSERT INTO regiones VALUES (3, 'Cuyo');
INSERT INTO regiones VALUES (4, 'Noroeste');

-- clientes (6 registros: los 5 originales + 1 nuevo sin ventas, para
-- poder probar la Consulta 2 de M5 con un resultado real)
INSERT INTO clientes VALUES (1, 'María López',  'maria@mail.com',  'Buenos Aires', '2024-01-05', 1);
INSERT INTO clientes VALUES (2, 'Carlos Ruiz',  'carlos@mail.com', 'Córdoba',      '2024-01-10', 1);
INSERT INTO clientes VALUES (3, 'Ana Gómez',    'ana@mail.com',    'Rosario',      '2024-02-01', 2);
INSERT INTO clientes VALUES (4, 'Pedro Sanz',   'pedro@mail.com',  'Mendoza',      '2024-02-15', 3);
INSERT INTO clientes VALUES (5, 'Laura Torres', 'laura@mail.com',  'Tucumán',      '2024-03-01', 4);
INSERT INTO clientes VALUES (6, 'Roberto Díaz', 'roberto@mail.com','Salta',        '2024-03-20', 4);

-- productos (7 registros: los 6 originales + 1 nuevo sin ventas, para
-- poder probar la Consulta 3 de M5 con un resultado real)
INSERT INTO productos VALUES (1, 'Laptop Pro 15',      1, 1200.00, 15, 1);
INSERT INTO productos VALUES (2, 'Mouse Inalámbrico',  2,   28.00, 80, 1);
INSERT INTO productos VALUES (3, 'Monitor 4K 27"',     1,  450.00, 12, 1);
INSERT INTO productos VALUES (4, 'Auriculares BT Pro', 3,  120.00, 35, 1);
INSERT INTO productos VALUES (5, 'SSD Externo 1TB',    4,  130.00, 18, 1);
INSERT INTO productos VALUES (6, 'Teclado Mecánico',   2,   95.00, 40, 1);
INSERT INTO productos VALUES (7, 'Cargador USB-C',     2,   45.00, 60, 1);

-- ventas (10 registros) 
INSERT INTO ventas VALUES (1,  1, 1, 2, 1200.00, '2024-03-05');
INSERT INTO ventas VALUES (2,  2, 2, 5,   28.00, '2024-03-06');
INSERT INTO ventas VALUES (3,  3, 3, 1,  450.00, '2024-03-07');
INSERT INTO ventas VALUES (4,  1, 4, 2,  120.00, '2024-03-08');
INSERT INTO ventas VALUES (5,  4, 5, 3,  130.00, '2024-03-10');
INSERT INTO ventas VALUES (6,  2, 6, 4,   95.00, '2024-03-11');
INSERT INTO ventas VALUES (7,  5, 1, 1, 1200.00, '2024-03-12');
INSERT INTO ventas VALUES (8,  3, 2, 8,   28.00, '2024-03-13');
INSERT INTO ventas VALUES (9,  4, 4, 1,  120.00, '2024-03-14');
INSERT INTO ventas VALUES (10, 5, 3, 2,  450.00, '2024-03-15');

-- ============================================================
-- Paso 3: Verificación de integridad
-- ============================================================
SELECT * FROM categorias;
SELECT * FROM regiones;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;
