
-- SampleData.sql
-- Fictional e-commerce records for MIT 8103 Portfolio 1.

BEGIN;

-- Customers
INSERT INTO public.customer (full_name, email, phone)
VALUES
    ('Amina Yusuf', 'amina.yusuf@example.com', '08030000001'),
    ('Musa Bello', 'musa.bello@example.com', NULL),
    ('Fatima Ibrahim', 'fatima.ibrahim@example.com', '08030000003');

-- Products
INSERT INTO public.product (product_name, sku, price, stock_quantity)
VALUES
    ('Laptop', 'LAP-001', 450000.00, 10),
    ('Wireless Mouse', 'MOU-001', 15000.00, 25),
    ('Keyboard', 'KEY-001', 25000.00, 15);

-- Orders
INSERT INTO public."Order" (order_number, customer_id, order_date, status)
VALUES
    ('ORD-2026-001',
     (SELECT customer_id FROM public.customer WHERE email = 'amina.yusuf@example.com'),
     '2026-11-10 10:00:00', 'Confirmed'),
    ('ORD-2026-002',
     (SELECT customer_id FROM public.customer WHERE email = 'musa.bello@example.com'),
     '2026-11-11 14:30:00', 'Pending'),
    ('ORD-2026-003',
     (SELECT customer_id FROM public.customer WHERE email = 'fatima.ibrahim@example.com'),
     '2026-11-12 09:00:00', 'Confirmed');

-- Order items
INSERT INTO public.orderitem (order_id, product_id, quantity, unit_price)
VALUES
    ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-001'),
     (SELECT product_id FROM public.product WHERE sku = 'LAP-001'), 2, 450000.00),
    ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-001'),
     (SELECT product_id FROM public.product WHERE sku = 'MOU-001'), 1, 15000.00),
    ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-002'),
     (SELECT product_id FROM public.product WHERE sku = 'KEY-001'), 1, 25000.00),
    ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-003'),
     (SELECT product_id FROM public.product WHERE sku = 'MOU-001'), 2, 15000.00);

-- Payment records cover Successful, Pending and Failed states.
INSERT INTO public.payment (order_id, amount, payment_status, payment_date)
VALUES
    ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-001'),
     915000.00, 'Successful', '2026-11-10 10:15:00'),
    ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-002'),
     25000.00, 'Pending', NULL),
    ((SELECT order_id FROM public."Order" WHERE order_number = 'ORD-2026-002'),
     25000.00, 'Failed', '2026-11-11 14:45:00');

COMMIT;
