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

## Design and implementation files

The following files document the database design, implementation and
testing activities for this project:

- `Dadung_Rwang_301921911_P1_Design.md` – Database design documentation,
  including the entities, attributes, primary keys and relationships.
- `Dadung_Rwang_301921911_P1_ERDiagram.md` – Entity Relationship Diagram
  illustrating the database structure and relationships.
- `Dadung_Rwang_301921911_P1_Normalisation.md` – Database normalisation
  documentation showing the normalisation process.
- `Dadung_Rwang_301921911_P1_Schema.sql` – SQL script for creating the
  database tables, defining columns, keys and constraints.
- `Dadung_Rwang_301921911_P1_SampleData.sql` – SQL script containing
  fictional sample records for populating the database.
- `Dadung_Rwang_301921911_P1_ConstraintTests.sql` – SQL statements used
  to test database constraints and data integrity.
- `screenshots/` – Supporting screenshots showing table structures,
  sample data insertion, constraint tests and database record counts.

## Implementation

The database was implemented using PostgreSQL. It consists of five
relational tables:

1. `customer` – Stores customer information and registration details.
2. `product` – Stores product information, prices, SKU details and
   available stock quantities.
3. `Order` – Stores customer orders, including order numbers, dates
   and order statuses.
4. `orderitem` – Stores the individual products and quantities
   associated with each order.
5. `payment` – Stores payment records, amounts, payment statuses
   and payment dates.

Primary keys were implemented to uniquely identify records, while
foreign keys establish relationships between the tables and maintain
referential integrity.

Additional constraints were implemented to enforce business rules,
including NOT NULL, UNIQUE and CHECK constraints. These help prevent
invalid records, duplicate values, negative prices, invalid stock
quantities and unacceptable payment statuses.

Fictional sample data was inserted into the five tables to demonstrate
the database structure, relationships and operations. SQL queries were
also executed to inspect table structures, retrieve records and verify
the number of records stored in each table.

## Test results

The database was tested using SQL statements to verify that the
implemented constraints enforce the defined business rules.

The tests covered the following areas:

- Required fields: Tested that mandatory fields do not accept NULL
  values.
- Unique email addresses: Tested that duplicate customer email
  addresses are rejected.
- Product SKU uniqueness: Tested that duplicate SKU values are
  rejected.
- Product prices: Tested that product prices must be greater than zero.
- Product stock quantities: Tested that negative stock quantities
  are rejected.
- Order item quantities: Tested that invalid or non-positive
  quantities are rejected.
- Order item product references: Tested that order items reference
  existing products.
- Customer order references: Tested that orders reference existing
  customers.
- Payment amounts: Tested that payment amounts must be greater than
  zero.
- Payment statuses: Tested that only Pending, Successful and Failed
  payment statuses are accepted.

The sample data insertion and record-count verification produced the
following results:

| Table | Number of Records |
|---|---:|
| customer | 3 |
| product | 3 |
| Order | 3 |
| orderitem | 4 |
| payment | 3 |
| **Total** | **16** |

The record-count query confirmed that all five tables contained the
expected sample records, with a total of 16 records across the database.

The constraint tests demonstrated how PostgreSQL enforces data
integrity by rejecting invalid values and maintaining the defined
relationships between tables.

Supporting screenshots of the implementation, sample data, constraint
tests and record-count verification are available in the `screenshots/`
directory.