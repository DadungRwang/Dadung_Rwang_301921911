
-- MIT 8103 Advanced Database Systems
-- Portfolio 2: Query Optimisation and Indexing
-- Student: Dadung Rwang
-- Student ID: 301921911
-- Case Study: E-commerce Platform
-- Database: PostgreSQL 16

-- =====================================================
-- 1. BENCHMARK SETUP
-- =====================================================
-- Run this setup only once.
-- Creates a separate schema for synthetic test records.
-- Does not modify the original Portfolio 1 tables.

CREATE SCHEMA p2_benchmark;

-- Generate 100,000 fictional e-commerce order records.

CREATE TABLE p2_benchmark.order_history AS
SELECT
    g AS benchmark_order_id,
    'BENCH-' || LPAD(g::text, 6, '0') AS order_number,
    ((g - 1) % 3) + 1 AS customer_id,
    TIMESTAMPTZ '2000-01-01 00:00:00+00'
        + g * INTERVAL '1 hour' AS order_date,
    (10000 + (g % 50) * 500)::NUMERIC(12,2) AS order_total,
    CASE
        WHEN g % 3 = 0 THEN 'Confirmed'
        WHEN g % 3 = 1 THEN 'Pending'
        ELSE 'Cancelled'
    END AS order_status
FROM generate_series(1, 100000) AS g;

-- Refresh table statistics and verify the record count.

ANALYZE p2_benchmark.order_history;

SELECT COUNT(*) AS total_test_orders
FROM p2_benchmark.order_history;


-- =====================================================
-- 2. COUNT ORDERS ON A PARTICULAR DATE
-- =====================================================
-- Count orders placed on 1 January 2005.
-- Expected result: 24.

SELECT COUNT(*) AS orders_on_day
FROM p2_benchmark.order_history
WHERE order_date >= TIMESTAMPTZ '2005-01-01 00:00:00+00'
  AND order_date < TIMESTAMPTZ '2005-01-02 00:00:00+00';


-- =====================================================
-- 3. EXECUTION PLAN BEFORE INDEXING
-- =====================================================
-- Run once as a warm-up; do not record this execution time.
-- Then run the same EXPLAIN statement three more times.
-- Record each Execution Time and the top-level shared
-- buffer hits from the third measured execution.

EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*) AS orders_on_day
FROM p2_benchmark.order_history
WHERE order_date >= TIMESTAMPTZ '2005-01-01 00:00:00+00'
  AND order_date < TIMESTAMPTZ '2005-01-02 00:00:00+00';


-- =====================================================
-- 4. CREATE INDEX
-- =====================================================
-- Create a B-tree index on the order_date column.
-- This supports the date-range filter used in the query.

CREATE INDEX order_history_order_date_idx
ON p2_benchmark.order_history (order_date);

-- Refresh statistics after creating the index.

ANALYZE p2_benchmark.order_history;


-- =====================================================
-- 5. EXECUTION PLAN AFTER INDEXING
-- =====================================================
-- Run once as a warm-up; do not record this execution time.
-- Then run the identical EXPLAIN statement three more times.
-- Record each Execution Time and the top-level shared
-- buffer hits from the third measured execution.

EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*) AS orders_on_day
FROM p2_benchmark.order_history
WHERE order_date >= TIMESTAMPTZ '2005-01-01 00:00:00+00'
  AND order_date < TIMESTAMPTZ '2005-01-02 00:00:00+00';


-- =====================================================
-- 6. VERIFY THE QUERY RESULT AFTER INDEXING
-- =====================================================
-- The count should remain unchanged at 24.

SELECT COUNT(*) AS orders_on_day
FROM p2_benchmark.order_history
WHERE order_date >= TIMESTAMPTZ '2005-01-01 00:00:00+00'
  AND order_date < TIMESTAMPTZ '2005-01-02 00:00:00+00';
