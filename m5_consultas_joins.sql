-- ============================================================
-- Pre-entrega: Consultas con JOINs para el proyecto — Módulo 5
-- Autor: Joshua Maldonado
-- Motor objetivo: MySQL (probado en MySQL Workbench)

-- ============================================================

USE Ventas_Tech_DB;

-- ============================================================
-- Consulta 1 — Vista base del proyecto (INNER JOIN)
-- Una sola fila por venta, con fecha, cliente, producto, cantidad,
-- precio unitario, total, y las columnas descriptivas del esquema
-- (categoría del producto y región del cliente).
-- ============================================================
SELECT
    v.fecha_venta,
    v.id_cliente,
    c.nombre                          AS nombre_cliente,
    p.nombre_producto                 AS descripcion_producto,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario)  AS total_venta,
    cat.nombre_categoria              AS categoria_producto,
    r.nombre_region                   AS region_cliente
FROM ventas v
INNER JOIN clientes c    ON v.id_cliente   = c.id_cliente
INNER JOIN productos p   ON v.id_producto  = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
INNER JOIN regiones r    ON c.id_region    = r.id_region
ORDER BY v.fecha_venta;

-- ============================================================
-- Consulta 2 — Clientes sin ventas (LEFT JOIN)
-- Clientes registrados que todavía no hicieron ninguna compra.
-- ============================================================
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- ============================================================
-- Consulta 3 — Productos sin ventas (LEFT JOIN)
-- Productos del catálogo que no tienen ninguna venta registrada.
-- ============================================================
SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
LEFT JOIN ventas v      ON p.id_producto  = v.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;

-- ============================================================
-- Consulta 4 — Consolidado por canal (UNION ALL)
-- La columna "canal" no existe en ninguna tabla: se crea como valor
-- literal dentro de cada SELECT. Se separan las ventas en dos
-- períodos (antes y después del 10 de marzo de 2024, que es donde
-- se parte naturalmente el rango de fechas de la tabla ventas) y se
-- etiqueta cada mitad con su propio canal.
-- ============================================================
SELECT
    canal,
    SUM(total) AS total_por_canal
FROM (
    SELECT fecha_venta AS fecha, (cantidad * precio_unitario) AS total,
           'Primera quincena' AS canal
    FROM ventas
    WHERE fecha_venta < '2024-03-10'

    UNION ALL

    SELECT fecha_venta AS fecha, (cantidad * precio_unitario) AS total,
           'Segunda quincena' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-10'
) AS consolidado
GROUP BY canal;
