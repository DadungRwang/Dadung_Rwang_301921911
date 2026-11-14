# E-commerce Platform Database Design

## 1. Entities

The database contains five main entities:

1.  **Customer:** Stores customer registration and contact information.
2.  **Product:** Stores product details, prices, stock quantities and
    product identification.
3.  **Order:** Records customer purchases, order dates and order
    statuses.
4.  **OrderItem:** Links products to orders and records the quantity of
    each product purchased.
5.  **Payment:** Stores simulated payment transactions and their
    statuses.

Five entities are sufficient because an order can contain several
products, and the OrderItem entity manages this many-to-many
relationship between orders and products.

## 2. Attributes and keys

  -----------------------------------------------------------------------
  Entity                              Main attributes and PostgreSQL
                                      types
  ----------------------------------- -----------------------------------
  Customer                            customer_id BIGINT (PK), full_name
                                      VARCHAR(100) NOT NULL, email
                                      VARCHAR(150) UNIQUE NOT NULL, phone
                                      VARCHAR(20) NULL

  Product                             product_id BIGINT (PK),
                                      product_name VARCHAR(150) NOT NULL,
                                      sku VARCHAR(50) UNIQUE NOT NULL,
                                      price NUMERIC(12,2) NOT NULL,
                                      stock_quantity INTEGER NOT NULL

  Order                               order_id BIGINT (PK), order_number
                                      VARCHAR(30) UNIQUE NOT NULL,
                                      customer_id BIGINT (FK), order_date
                                      TIMESTAMP NOT NULL, status
                                      VARCHAR(20) NOT NULL

  OrderItem                           order_id BIGINT (PK, FK),
                                      product_id BIGINT (PK, FK),
                                      quantity INTEGER NOT NULL,
                                      unit_price NUMERIC(12,2) NOT NULL

  Payment                             payment_id BIGINT (PK), order_id
                                      BIGINT (FK), amount NUMERIC(12,2)
                                      NOT NULL, payment_status
                                      VARCHAR(20) NOT NULL, payment_date
                                      TIMESTAMP NULL
  -----------------------------------------------------------------------

**PK** means Primary Key, a field that uniquely identifies a record.
**FK** means Foreign Key, a field that connects one table to another.
NOT NULL means a value is required, while NULL means it is optional.

The OrderItem table uses a composite primary key consisting of order_id
and product_id. This prevents the same product from appearing more than
once in the same order.

## 3. Relationships

-   **Customer to Order:** One customer can have zero or many orders.
    Each order belongs to exactly one customer.
-   **Order to OrderItem:** One order contains one or more order items.
    Each order item belongs to exactly one order.
-   **Product to OrderItem:** One product can appear in zero or many
    order items. Each order item refers to exactly one product.
-   **Order to Payment:** One order can have zero or many payment
    records. Each payment belongs to exactly one order.

The OrderItem entity connects Orders and Products, allowing customers to
purchase multiple products in one order and products to appear in
different orders.

## 4. Business rules and constraints

1.  **Customer identification:** Primary key on customer_id and UNIQUE
    constraint on email.
2.  **Product identification and values:** Primary key on product_id,
    UNIQUE constraint on sku, CHECK constraints requiring price greater
    than zero and stock_quantity greater than or equal to zero.
3.  **Order ownership:** Foreign key on customer_id ensures every order
    belongs to an existing customer.
4.  **Order contents:** Foreign keys connect order items to existing
    orders and products. An order must contain at least one item,
    enforced through order-creation validation.
5.  **Ordered quantity:** A CHECK constraint requires quantity greater
    than zero. Available stock is checked during ordering and
    confirmation because this rule involves another table.
6.  **Order identification and date:** UNIQUE constraint on
    order_number. An operation or database trigger validates that
    order_date is not in the future.
7.  **Payment validity:** Foreign key on order_id, CHECK constraint
    requiring amount greater than zero, and CHECK constraint limiting
    payment_status to Pending, Successful or Failed.
8.  **Inventory control:** A transaction checks available stock before
    confirmation and reduces stock only when confirmation succeeds. This
    prevents conflicting orders from selling the same available stock.

## 5. Design assumptions

1.  Each product appears only once in an order, with its purchased
    quantity recorded in OrderItem.
2.  The unit_price in OrderItem preserves the product price at the time
    of purchase, even if the catalogue price changes later.
3.  Payments are simulated records, and an order can have multiple
    payment attempts.
