
-- MIT 8103 Portfolio 3
-- Session A: E-commerce stock concurrency test
-- Database: e_commerce_portfolio

-- 1. Check the starting stock
SELECT product_name, stock_quantity
FROM public.product
WHERE product_name = 'Wireless Mouse';

-- 2. Prepare the test: set stock to one unit.
-- Run this preparation before starting the two-session test.
UPDATE public.product
SET stock_quantity = 1
WHERE product_name = 'Wireless Mouse';

COMMIT;

-- 3. Start Session A
SET application_name = 'p3_session_a';

BEGIN ISOLATION LEVEL READ COMMITTED;

SHOW transaction_isolation;

-- 4. Purchase the last available unit.
UPDATE public.product
SET stock_quantity = stock_quantity - 1
WHERE product_name = 'Wireless Mouse'
AND stock_quantity > 0;

-- EXPECTED: UPDATE 1
-- STOP HERE. DO NOT COMMIT YET.
-- Switch to Session B and attempt its purchase.

-- 5. After Session B starts waiting, check its lock.
SELECT
    application_name,
    state,
    wait_event_type,
    query
FROM pg_stat_activity
WHERE datname = current_database()
AND pid <> pg_backend_pid()
AND state = 'active';

-- EXPECTED: The other session shows wait_event_type = Lock.

-- 6. Commit Session A to release the lock.
COMMIT;

-- 7. Check the stock after the concurrent test.
SELECT product_name, stock_quantity
FROM public.product
WHERE product_name = 'Wireless Mouse';

-- EXPECTED: stock_quantity = 0

-- 8. Restore the original stock after the test.
UPDATE public.product
SET stock_quantity = 25
WHERE product_name = 'Wireless Mouse';

COMMIT;

-- 9. Verify restored stock.
SELECT product_name, stock_quantity
FROM public.product
WHERE product_name = 'Wireless Mouse';

-- EXPECTED: stock_quantity = 25
