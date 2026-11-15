-- ConstraintTests.sql
-- Run after SampleData.sql. Each INSERT is an independent negative test.
-- Run with psql error-stopping disabled so all tests can be attempted.

-- REQUIRED: expected NOT NULL violation for customer.full_name.
INSERT INTO public.customer (full_name, email)
VALUES (NULL, 'null.name@example.com');

-- REQUIRED: expected NOT NULL violation for customer.email.
INSERT INTO public.customer (full_name, email)
VALUES ('Test Customer', NULL);

-- UNIQUE: expected duplicate customer email violation.
INSERT INTO public.customer (full_name, email)
VALUES ('Duplicate Email', 'amina.yusuf@example.com');

-- REQUIRED: expected NOT NULL violation for product.product_name.
INSERT INTO public.product (product_name, sku, price, stock_quantity)
VALUES (NULL, 'TEST-NULL-NAME', 100.00, 5);

-- REQUIRED: expected NOT NULL violation for product.sku.
INSERT INTO public.product (product_name, sku, price, stock_quantity)
VALUES ('Test Product', NULL, 100.00, 5);

-- REQUIRED: expected NOT NULL violation for product.price.
INSERT INTO public.product (product_name, sku, price, stock_quantity)
VALUES ('Test Product', 'TEST-NULL-PRICE', NULL, 5);

-- REQUIRED: expected NOT NULL violation for product.stock_quantity.
INSERT INTO public.product (product_name, sku, price, stock_quantity)
VALUES ('Test Product', 'TEST-NULL-STOCK', 100.00, NULL);

-- UNIQUE: expected duplicate product SKU violation.
INSERT INTO public.product (product_name, sku, price, stock_quantity)
VALUES ('Duplicate SKU', 'LAP-001', 100.00, 5);

-- CHECK: expected price greater-than-zero violation.
INSERT INTO public.product (product_name, sku, price, stock_quantity)
VALUES ('Zero Price Product', 'TEST-PRICE-0', 0.00, 5);

-- CHECK: expected non-negative stock violation.
INSERT INTO public.product (product_name, sku, price, stock_quantity)
VALUES ('Negative Stock Product', 'TEST-STOCK-NEG', 100.00, -1);

-- REQUIRED: expected NOT NULL violation for Order.order_number.
INSERT INTO public."Order" (order_number, customer_id, order_date, status)
VALUES (NULL,
        (SELECT customer_id FROM public.customer WHERE email = 'amina.yusuf@example.com'),
        '2026-11-12 09:00:00', 'Pending');

-- REQUIRED: expected NOT NULL violation for Order.customer_id.
INSERT INTO public."Order" (order_number, customer_id, order_date, status)
VALUES ('ORD-TEST-NULL-CUSTOMER', NULL, '2026-11-12 09:00:00', 'Pending');

-- REQUIRED: expected NOT NULL violation for Order.order_date.
INSERT INTO public."Order" (order_number, customer_id, order_date, status)
VALUES ('ORD-TEST-NULL-DATE',
        (SELECT customer_id FROM public.customer WHERE email = 'amina.yusuf@example.com'),
        NULL, 'Pending');

-- REQUIRED: expected NOT NULL violation for Order.status.
INSERT INTO public."Order" (order_number, customer_id, order_date, status)
VALUES ('ORD-TEST-NULL-STATUS',
        (SELECT customer_id FROM public.customer WHERE email = 'amina.yusuf@example.com'),
        '2026-11-12 09:00:00', NULL);

-- UNIQUE: expected duplicate order_number violation.
INSERT INTO public."Order" (order_number, customer_id, order_date, status)
VALUES ('ORD-2026-001',
        (SELECT customer_id FROM public.customer WHERE email = 'amina.yusuf@example.com'),
        '2026-11-12 09:00:00', 'Pending');

-- FOREIGN KEY: expected missing customer reference violation.
INSERT INTO public."Order" (order_number, customer_id, order_date, status)
VALUES ('ORD-TEST-BAD-CUSTOMER', -999999, '2026-11-12 09:00:00', 'Pending');

-- REQUIRED: expected NOT NULL violation for orderitem.order_id.
INSERT INTO public.orderitem (order_id, product_id, quantity, unit_price)
VALUES (NULL,
        (SELECT product_id FROM public.product WHERE sku = 'LAP-001'),
        1, 450000.00);

-- REQUIRED: expected NOT NULL violation for orderitem.product_id.
INSERT INTO public.orderitem (order_id, product_id, quantity, unit_price)
VALUES ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-001'),
        NULL, 1, 450000.00);

-- REQUIRED: expected NOT NULL violation for orderitem.quantity.
INSERT INTO public.orderitem (order_id, product_id, quantity, unit_price)
VALUES ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-001'),
        (SELECT product_id FROM public.product WHERE sku = 'KEY-001'),
        NULL, 25000.00);

-- REQUIRED: expected NOT NULL violation for orderitem.unit_price.
INSERT INTO public.orderitem (order_id, product_id, quantity, unit_price)
VALUES ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-001'),
        (SELECT product_id FROM public.product WHERE sku = 'KEY-001'),
        1, NULL);

-- CHECK: expected quantity greater-than-zero violation.
INSERT INTO public.orderitem (order_id, product_id, quantity, unit_price)
VALUES ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-001'),
        (SELECT product_id FROM public.product WHERE sku = 'KEY-001'),
        0, 25000.00);

-- PRIMARY KEY: expected duplicate order_id/product_id pair violation.
INSERT INTO public.orderitem (order_id, product_id, quantity, unit_price)
VALUES ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-001'),
        (SELECT product_id FROM public.product WHERE sku = 'LAP-001'),
        1, 450000.00);

-- FOREIGN KEY: expected missing order reference violation.
INSERT INTO public.orderitem (order_id, product_id, quantity, unit_price)
VALUES (-999999,
        (SELECT product_id FROM public.product WHERE sku = 'KEY-001'),
        1, 25000.00);

-- FOREIGN KEY: expected missing product reference violation.
INSERT INTO public.orderitem (order_id, product_id, quantity, unit_price)
VALUES ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-001'),
        -999999, 1, 25000.00);

-- REQUIRED: expected NOT NULL violation for payment.order_id.
INSERT INTO public.payment (order_id, amount, payment_status)
VALUES (NULL, 100.00, 'Pending');

-- REQUIRED: expected NOT NULL violation for payment.amount.
INSERT INTO public.payment (order_id, amount, payment_status)
VALUES ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-001'),
        NULL, 'Pending');

-- REQUIRED: expected NOT NULL violation for payment.payment_status.
INSERT INTO public.payment (order_id, amount, payment_status)
VALUES ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-001'),
        100.00, NULL);

-- CHECK: expected positive payment amount violation.
INSERT INTO public.payment (order_id, amount, payment_status)
VALUES ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-001'),
        0.00, 'Pending');

-- CHECK: expected invalid payment_status violation.
INSERT INTO public.payment (order_id, amount, payment_status)
VALUES ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-001'),
        100.00, 'Refunded');

-- FOREIGN KEY: expected missing order reference violation.
INSERT INTO public.payment (order_id, amount, payment_status)
VALUES (-999999, 100.00, 'Pending');

-- Expected counts if SampleData.sql succeeds and every invalid INSERT fails:
-- customer: 2, product: 3, Order: 2, orderitem: 3, payment: 3.

SELECT 'customer' AS table_name, COUNT(*) AS row_count
FROM public.customer
UNION ALL
SELECT 'product', COUNT(*) FROM public.product
UNION ALL
SELECT 'Order', COUNT(*) FROM public."Order"
UNION ALL
SELECT 'orderitem', COUNT(*) FROM public.orderitem
UNION ALL
SELECT 'payment', COUNT(*) FROM public.payment
ORDER BY table_name;
