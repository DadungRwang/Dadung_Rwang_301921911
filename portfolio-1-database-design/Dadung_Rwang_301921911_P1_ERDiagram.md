# E-commerce Platform ER Diagram

``` mermaid
erDiagram
    direction LR

    Customer {
        BIGINT customer_id PK
        VARCHAR(100) full_name
        VARCHAR(150) email UK
        VARCHAR(20) phone
    }

    Product {
        BIGINT product_id PK
        VARCHAR(150) product_name
        VARCHAR(50) sku UK
        NUMERIC(12,2) price
        INTEGER stock_quantity
    }

    Order {
        BIGINT order_id PK
        VARCHAR(30) order_number UK
        BIGINT customer_id FK
        TIMESTAMP order_date
        VARCHAR(20) status
    }

    OrderItem {
        BIGINT order_id PK,FK
        BIGINT product_id PK,FK
        INTEGER quantity
        NUMERIC(12,2) unit_price
    }

    Payment {
        BIGINT payment_id PK
        BIGINT order_id FK
        NUMERIC(12,2) amount
        VARCHAR(20) payment_status
        TIMESTAMP payment_date
    }

    Customer ||--o{ Order : places
    Order ||--|{ OrderItem : contains
    Product ||--o{ OrderItem : appears_in
    Order ||--o{ Payment : has
```

## Keys and relationship symbols

-   **PK (Primary Key):** Uniquely identifies each record in a table.
-   **FK (Foreign Key):** Connects a record to an existing record in
    another table.
-   **UK (Unique Key):** Prevents duplicate values in a field, such as
    customer email addresses or product SKUs.
-   **`||` (Exactly one):** Each related record must belong to exactly
    one record.
-   **`o|` (Zero or one):** A related record is optional, but no more
    than one is allowed.
-   **`o{` (Zero or many):** A record can have no related records or
    several.
-   **`|{` (One or many):** At least one related record is required.

## Relationship example

A customer places an order containing two products. The Order table
stores the order details, while OrderItem contains two records
connecting the order to the purchased products.

Each OrderItem refers to exactly one Order and one Product. A product
can appear in several orders, while a customer can place multiple
orders.

## Optional fields

-   **Customer.phone:** Optional because a customer can register without
    providing a phone number.
-   **Payment.payment_date:** Optional because a payment can remain
    pending without a completed payment date.

All other fields are required.

## Additional constraints and transaction logic

The database design includes the following rules that require additional
validation or transaction logic:

1.  Product prices and payment amounts must be positive, while stock
    quantities cannot be negative.
2.  Each order must contain at least one order item. This requires
    validation when creating an order.
3.  Ordered quantities must be positive whole numbers and cannot exceed
    available stock.
4.  Order dates cannot be in the future. This requires validation or a
    database trigger.
5.  Payment statuses are restricted to Pending, Successful or Failed.
6.  Stock quantities decrease only when orders are confirmed.
    Transactions must prevent conflicting orders from purchasing more
    stock than is available.
