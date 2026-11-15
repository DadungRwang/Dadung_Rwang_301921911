
-- MIT 8103 Portfolio 3
-- Session B: E-commerce stock concurrency test
-- Database: e_commerce_portfolio

-- 1. Identify Session B
SET application_name = 'p3_session_b';

-- 2. Start a READ COMMITTED transaction.
BEGIN ISOLATION LEVEL READ COMMITTED;

SHOW transaction_isolation;

-- 3. Check the stock before attempting purchase.
SELECT product_name, stock_quantity
FROM public.product
WHERE product_name = 'Wireless Mouse';

-- EXPECTED: stock_quantity = 1
-- Session A's uncommitted update is not visible here.

-- 4. Attempt to purchase the same last unit.
UPDATE public.product
SET stock_quantity = stock_quantity - 1
WHERE product_name = 'Wireless Mouse'
AND stock_quantity > 0;

-- EXPECTED: This command waits while Session A holds the row lock.
-- STOP HERE. Switch to Session A and commit.
-- After Session A commits, this update should return UPDATE 0.

-- 5. Roll back Session B.
ROLLBACK;

-- 6. Verify the final stock after the test.
SELECT product_name, stock_quantity
FROM public.product
WHERE product_name = 'Wireless Mouse';

-- EXPECTED: stock_quantity = 0 before Session A restores it.
