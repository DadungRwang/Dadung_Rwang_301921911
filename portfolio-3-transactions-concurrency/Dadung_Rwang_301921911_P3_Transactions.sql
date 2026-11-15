
-- MIT 8103 Advanced Database Systems
-- Portfolio 3: Transaction Management
-- Student: Dadung Rwang
-- Student ID: 301921911
-- Case Study: E-commerce Platform
-- Database: e_commerce_portfolio
-- PostgreSQL 16

-- =====================================================
-- 1. CHECK INITIAL ORDER AND PAYMENT RECORDS
-- =====================================================
-- Review existing orders and their payment information.

SELECT
    o.order_number,
    o.status AS order_status,
    p.payment_id,
    p.amount,
    p.payment_status,
    p.payment_date
FROM public."Order" o
LEFT JOIN public.payment p
    ON o.order_id = p.order_id
ORDER BY o.order_number, p.payment_id;


-- =====================================================
-- 2. COMMIT TRANSACTION
-- =====================================================
-- Confirm the pending payment for ORD002 and update
-- its associated order status within one transaction.

BEGIN;

UPDATE public.payment
SET
    payment_status = 'Successful',
    payment_date = TIMESTAMP '2026-11-15 16:00:00'
WHERE order_id = (
    SELECT order_id
    FROM public."Order"
    WHERE order_number = 'ORD002'
)
AND payment_status = 'Pending';

UPDATE public."Order"
SET status = 'Confirmed'
WHERE order_number = 'ORD002'
AND status = 'Pending';

COMMIT;


-- =====================================================
-- 3. TEST REPEATED PAYMENT CONFIRMATION
-- =====================================================
-- Check that an already successful payment cannot
-- be confirmed again by this conditional update.

UPDATE public.payment
SET
    payment_status = 'Successful',
    payment_date = TIMESTAMP '2026-11-16 10:00:00'
WHERE order_id = (
    SELECT order_id
    FROM public."Order"
    WHERE order_number = 'ORD002'
)
AND payment_status = 'Pending';


-- =====================================================
-- 4. ROLLBACK TRANSACTION
-- =====================================================
-- Insert a temporary valid payment for ORD003.
-- The change remains uncommitted at this stage.

BEGIN;

INSERT INTO public.payment
    (order_id, amount, payment_status, payment_date)
SELECT
    order_id,
    100.00,
    'Pending',
    TIMESTAMP '2026-11-15 17:00:00'
FROM public."Order"
WHERE order_number = 'ORD003';


-- =====================================================
-- 5. DELIBERATELY ATTEMPT AN INVALID PAYMENT
-- =====================================================
-- A zero payment amount violates the existing
-- payment_amount_check constraint.

INSERT INTO public.payment
    (order_id, amount, payment_status, payment_date)
SELECT
    order_id,
    0.00,
    'Pending',
    TIMESTAMP '2026-11-15 17:05:00'
FROM public."Order"
WHERE order_number = 'ORD003';


-- =====================================================
-- 6. ROLLBACK THE TRANSACTION
-- =====================================================
-- Undo the temporary valid payment and the failed
-- transaction changes.

ROLLBACK;


-- =====================================================
-- 7. VERIFY THE COMMITTED PAYMENT
-- =====================================================
-- Confirm that ORD002 remains successfully updated.

SELECT
    o.order_number,
    o.status AS order_status,
    p.payment_status,
    p.payment_date
FROM public."Order" o
JOIN public.payment p
    ON o.order_id = p.order_id
WHERE o.order_number = 'ORD002';


-- =====================================================
-- 8. VERIFY THE ROLLED-BACK PAYMENT
-- =====================================================
-- Confirm that the temporary payment for ORD003
-- was removed by the rollback.

SELECT COUNT(*) AS rolled_back_payment_count
FROM public.payment p
JOIN public."Order" o
    ON p.order_id = o.order_id
WHERE o.order_number = 'ORD003'
AND p.amount = 100.00;
