# Portfolio 1 Database Design and Modelling

## Case study

An e-commerce platform manages online sales of products by storing
customer records, product information, orders, order items, payment
records and inventory quantities. Customers browse products and place
orders, while store administrators manage product listings, stock levels
and order processing.

## Users

Customers register accounts, browse available products, place orders and
make payments. Store administrators register products, update product
details and manage inventory, while order fulfilment staff review
orders, confirm payments and update delivery statuses.

## Main operations

Register a customer; add and update product listings; view available
products and stock quantities; place an order containing one or more
products; record payment details; update inventory after a confirmed
order; and view customer order history and order statuses.

## Business rules

1.  Each customer has a unique customer ID and email address.
2.  Each product has a unique product ID and SKU (Stock Keeping Unit).
    Product prices must be greater than zero, and stock quantities
    cannot be negative.
3.  Each order belongs to one existing customer. A customer can place
    multiple orders.
4.  Each order must contain at least one order item, and each order item
    refers to one existing product.
5.  The quantity ordered must be a positive whole number and cannot
    exceed the available stock.
6.  Each order has a unique order number and a valid order date. The
    order date cannot be in the future.
7.  Each payment belongs to one existing order. Payment amounts must be
    positive and payment statuses must be Pending, Successful or Failed.
8.  A product's stock quantity is reduced only when its order is
    confirmed. An order cannot be confirmed if the requested quantity
    exceeds available stock.

## Scope

The system covers one fictional online retail store, customer
registration, product catalogue management, inventory tracking, order
placement, simulated payment records and basic order status management.
Product reviews, discount codes, refunds, multiple warehouses, real
payment gateway integration, shipping logistics and user authentication
are excluded.
