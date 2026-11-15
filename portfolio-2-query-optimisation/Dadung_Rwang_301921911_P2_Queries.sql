
-- MIT 8103 Advanced Database Systems
-- Portfolio 2: SQL Queries
-- Student: Dadung Rwang
-- Student ID: 301921911
-- Case Study: E-commerce Platform Database
-- Database: PostgreSQL 16

-- =====================================================
-- Q1: Retrieve detailed customer order information.
-- =====================================================

SELECT
    c.full_name,
    o.order_number,
    o.order_date::date AS order_date,
    o.status AS order_status,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total
FROM public."Order" o
JOIN public.customer c
    ON o.customer_id = c.customer_id
JOIN public.orderitem oi
    ON o.order_id = oi.order_id
JOIN public.product p
    ON oi.product_id = p.product_id
ORDER BY o.order_date, o.order_number;


-- =====================================================
-- Q2: Analyse product sales and available inventory.
-- =====================================================

SELECT
    p.product_name,
    p.sku,
    p.stock_quantity AS available_stock,
    COALESCE(SUM(oi.quantity), 0) AS total_quantity_sold,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_sales_value
FROM public.product p
LEFT JOIN public.orderitem oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.sku,
    p.stock_quantity
ORDER BY total_sales_value DESC;


-- =====================================================
-- Q3: Summarise payment transactions for each order.
-- =====================================================

SELECT
    o.order_number,
    o.status AS order_status,
    COUNT(p.payment_id) AS total_payment_records,
    COALESCE(
        SUM(p.amount) FILTER (WHERE p.payment_status = 'Successful'),
        0
    ) AS successful_payment_amount,
    COALESCE(
        SUM(p.amount) FILTER (WHERE p.payment_status = 'Pending'),
        0
    ) AS pending_payment_amount,
    COALESCE(
        SUM(p.amount) FILTER (WHERE p.payment_status = 'Failed'),
        0
    ) AS failed_payment_amount
FROM public."Order" o
LEFT JOIN public.payment p
    ON o.order_id = p.order_id
GROUP BY
    o.order_id,
    o.order_number,
    o.status
ORDER BY o.order_number;
