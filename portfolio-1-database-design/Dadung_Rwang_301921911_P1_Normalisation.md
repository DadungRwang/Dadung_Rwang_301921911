# E-commerce Platform Normalisation

Normalisation is the process of organising database tables to reduce
repeated information, prevent data inconsistencies and make records
easier to maintain. The e-commerce database uses three stages: First
Normal Form (1NF), Second Normal Form (2NF) and Third Normal Form (3NF).

## Starting Record (Unnormalised Form)

Initially, customer, order and product details appear together in one
record. An order can contain several products, creating a repeated list
of product details.

  -----------------------------------------------------------------------------
  Order No.      Customer       Email             Order Date     Products
  -------------- -------------- ----------------- -------------- --------------
  ORD001         Amina Yusuf    amina@email.com   2026-10-10     Laptop (2,
                                                                 ₦450,000),
                                                                 Mouse (1,
                                                                 ₦15,000)

  ORD002         Musa Bello     musa@email.com    2026-10-11     Mouse (2,
                                                                 ₦15,000)
  -----------------------------------------------------------------------------

**Problem:** The Products field contains multiple values in one cell.
This makes it difficult to search, update or manage individual products
and their quantities.

## 1. First Normal Form (1NF)

A table is in 1NF when each field contains only one value and there are
no repeating groups.

The product list is separated into individual rows, with one product per
order item.

**OrderItem (1NF)**

  ---------------------------------------------------------------------------------------
  Order No. Customer   Email             Order Date   Product       Quantity   Unit Price
  --------- ---------- ----------------- ------------ --------- ------------ ------------
  ORD001    Amina      amina@email.com   2026-10-10   Laptop               2     ₦450,000
            Yusuf                                                            

  ORD001    Amina      amina@email.com   2026-10-10   Mouse                1      ₦15,000
            Yusuf                                                            

  ORD002    Musa Bello musa@email.com    2026-10-11   Mouse                2      ₦15,000
  ---------------------------------------------------------------------------------------

**Primary Key:** (Order No. + Product)

The combined key identifies each product within an order. This example
assumes that the same product appears only once in an order.

**What changes:** Each product now occupies a separate row. This removes
repeating product lists and allows individual order items to be
retrieved and updated.

## 2. Second Normal Form (2NF)

A table is in 2NF when it is already in 1NF and every non-key field
depends on the whole primary key, not just part of it.

In the 1NF table, the primary key consists of Order No. and Product.
Some fields depend on only part of this combined key:

-   Customer, Email and Order Date depend on Order No.
-   Product price and other product details depend on Product.
-   Quantity depends on both Order No. and Product.

These partial dependencies create repeated information. For example,
Amina's email appears twice because her order contains two products.

The information is therefore separated into three tables.

**Orders**

  Order No. (PK)   Customer      Email             Order Date
  ---------------- ------------- ----------------- ------------
  ORD001           Amina Yusuf   amina@email.com   2026-10-10
  ORD002           Musa Bello    musa@email.com    2026-10-11

**Products**

  Product (PK)     Unit Price
  -------------- ------------
  Laptop             ₦450,000
  Mouse               ₦15,000

**OrderItem**

  Order No. (PK, FK)   Product (PK, FK)     Quantity
  -------------------- ------------------ ----------
  ORD001               Laptop                      2
  ORD001               Mouse                       1
  ORD002               Mouse                       2

**What changes:** Order information moves into Orders, product
information moves into Products, and OrderItem retains the quantity
purchased. This removes partial dependencies and reduces repeated
customer and product information.

## 3. Third Normal Form (3NF)

A table is in 3NF when it is already in 2NF and non-key fields depend
directly on the primary key, not on another non-key field.

In the Orders table, customer information such as the customer's name
and email depends on the customer, not directly on the order number. To
remove this transitive dependency, customer information is stored
separately and linked to orders using customer_id.

Product information is also stored in its own table and linked to order
items using product_id.

**Customer**

  customer_id (PK)   full_name     email
  ------------------ ------------- -----------------
  101                Amina Yusuf   amina@email.com
  102                Musa Bello    musa@email.com

**Product**

  product_id (PK)   product_name        price
  ----------------- -------------- ----------
  201               Laptop           ₦450,000
  202               Mouse             ₦15,000

**Order**

  order_id (PK)   order_number   customer_id (FK)   order_date
  --------------- -------------- ------------------ ------------
  301             ORD001         101                2026-10-10
  302             ORD002         102                2026-10-11

**OrderItem**

  order_id (PK, FK)   product_id (PK, FK)     quantity   unit_price
  ------------------- --------------------- ---------- ------------
  301                 201                            2     ₦450,000
  301                 202                            1      ₦15,000
  302                 202                            2      ₦15,000

**Payment**

  payment_id (PK)   order_id (FK)       amount payment_status
  ----------------- --------------- ---------- ----------------
  401               301               ₦915,000 Successful
  402               302                ₦30,000 Pending

**What changes:** Customer details are stored once in Customer, while
Product stores product information independently. The Order table uses
customer_id to identify the customer, and OrderItem uses product_id and
order_id to connect products with their orders. Payment stores payment
information separately.

This removes transitive dependencies and reduces unnecessary repetition
when customer or product details change.

## Final Database Design

The final database contains five entities:

1.  **Customer:** Stores customer registration and contact details.
2.  **Product:** Stores product information, prices and stock
    quantities.
3.  **Order:** Stores customer orders, order dates and statuses.
4.  **OrderItem:** Connects orders to products and records quantities
    and purchase prices.
5.  **Payment:** Stores payment amounts, statuses and payment dates.

The final design uses automatically generated IDs for customers,
products, orders and payments. OrderItem retains a combined primary key
consisting of order_id and product_id to prevent the same product from
appearing more than once in an order.

The IDs replace descriptive values as linking fields but do not
independently guarantee 3NF. The separation of information and removal
of partial and transitive dependencies establish the normalised
structure.

**Fields omitted from the example tables:** Customer.phone, Product.sku,
Product.stock_quantity, Order.status and Payment.payment_date. These
remain part of the agreed database design but are not needed to
demonstrate the normalisation process.
