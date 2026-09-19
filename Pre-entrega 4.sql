-- Pre-entrega: Consultas SQL de negocio — Módulo 4
-- Autor: Joshua Maldonado
-- Motor objetivo: MySQL Workbench


USE Ventas_Tech_DB;

-- ============================================================
-- Consulta 1 — Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio, por mes.
-- ============================================================
SELECT
    MONTH(fecha_venta)                                   AS mes,
    SUM(cantidad * precio_unitario)                       AS total_facturado,
    COUNT(*)                                              AS cantidad_pedidos,
    ROUND(SUM(cantidad * precio_unitario) / COUNT(*), 2)  AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- ============================================================
-- Consulta 2 — Ranking de productos
-- Top 5 de id_producto por total facturado, con unidades vendidas.
-- ============================================================
SELECT
    id_producto,
    SUM(cantidad)                     AS unidades_vendidas,
    SUM(cantidad * precio_unitario)    AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;

-- ============================================================
-- Consulta 3 — Clientes recurrentes
-- Clientes con más de un pedido, con su cantidad de pedidos y total gastado.
-- ============================================================
SELECT
    id_cliente,
    COUNT(*)                          AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)   AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- ============================================================
-- Consulta 4 — Meses por encima/por debajo del promedio
-- Total facturado por mes, comparado contra el promedio mensual general.
-- ============================================================
WITH totales_mes AS (
    SELECT
        MONTH(fecha_venta)              AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM totales_mes) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM totales_mes
ORDER BY mes;

==== Hallazgos del ejercicio =====
-- 1) El producto 1 concentra el 55.9% de la facturación total
--    ($3,600 de $6,444), a pesar de venderse en solo 3 unidades. Su
--    precio unitario alto ($1,200) es lo que lo posiciona como el
--    producto más rentable, muy por delante del producto 3 (20.9%),
--    que es el segundo lugar del ranking.

-- 2) Los 5 clientes de la base son recurrentes: cada uno hizo
--    exactamente 2 pedidos. El cliente 1 es el que más gastó en total
--    ($2,640), seguido del cliente 5 ($2,100) — juntos concentran casi
--    el 74% de todo lo facturado.

-- 3) Las 10 ventas registradas caen todas en marzo de 2024, así que la
--    Consulta 4 (por encima/por debajo del promedio) todavía no es
--    representativa: al haber un solo mes, ese mes siempre "empata"
--    con el promedio general.