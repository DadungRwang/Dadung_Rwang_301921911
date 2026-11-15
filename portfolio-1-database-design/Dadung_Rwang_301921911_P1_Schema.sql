-- MIT 8103 Portfolio 1
-- E-commerce Platform Database Schema
-- PostgreSQL 16

BEGIN;

-- 1. Customer table
CREATE TABLE public.customer (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20)
);

-- 2. Product table
CREATE TABLE public.product (
    product_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    price NUMERIC(12,2) NOT NULL CHECK (price > 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0)
);

-- 3. Order table
CREATE TABLE public."Order" (
    order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_number VARCHAR(30) NOT NULL UNIQUE,
    customer_id BIGINT NOT NULL,
    order_date TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL,

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES public.customer(customer_id)
);

-- 4. OrderItem table
CREATE TABLE public.orderitem (
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL,

    PRIMARY KEY (order_id, product_id),

    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (order_id)
        REFERENCES public."Order"(order_id),

    CONSTRAINT fk_orderitem_product
        FOREIGN KEY (product_id)
        REFERENCES public.product(product_id)
);

-- 5. Payment table
CREATE TABLE public.payment (
    payment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL,
    amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    payment_status VARCHAR(20) NOT NULL
        CHECK (payment_status IN ('Pending', 'Successful', 'Failed')),
    payment_date TIMESTAMP,

    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id)
        REFERENCES public."Order"(order_id)
);

-- Additional rules requiring transaction logic or validation:
-- 1. Each order must contain at least one order item.
-- 2. Order dates must not be in the future.
-- 3. Ordered quantities must not exceed available stock.
-- 4. Stock is deducted only when an order is confirmed.
-- 5. Transactions must prevent conflicting stock updates.

COMMIT;