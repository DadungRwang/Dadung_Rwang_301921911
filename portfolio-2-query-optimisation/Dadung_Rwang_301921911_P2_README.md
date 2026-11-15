
# Portfolio 2 Query Processing and Optimisation

**Student:** Dadung Rwang
**Student ID:** 301921911
**Course:** MIT 8103 – Advanced Database Systems
**Case Study:** E-commerce Platform Database
**Database:** PostgreSQL 16

## Queries and results

Three SQL queries were developed and executed against the e-commerce database.

1. **Customer order details:** Joined the customer, Order, orderitem and product tables to retrieve customer names, order numbers, dates, statuses, products, quantities, unit prices and line totals. The query returned four order-item records across three orders:
   - Ada James – ORD001: HP Laptop (₦450,000) and Wireless Mouse (₦30,000).
   - Ben Cole – ORD002: Mechanical Keyboard (₦25,000).
   - Mary David – ORD003: Wireless Mouse (₦15,000).

2. **Product sales and inventory:** Summarised available stock, quantities sold and sales values for three products:

   | Product | Available stock | Quantity sold | Sales value |
   |---|---:|---:|---:|
   | HP Laptop | 10 | 1 | ₦450,000 |
   | Wireless Mouse | 25 | 3 | ₦45,000 |
   | Mechanical Keyboard | 15 | 1 | ₦25,000 |

3. **Payment summary:** Grouped payment transactions by order and payment status. The results showed:

   | Order | Status | Payment records | Successful | Pending | Failed |
   |---|---|---:|---:|---:|---:|
   | ORD001 | Confirmed | 1 | ₦480,000 | ₦0 | ₦0 |
   | ORD002 | Pending | 1 | ₦0 | ₦25,000 | ₦0 |
   | ORD003 | Pending | 1 | ₦0 | ₦0 | ₦15,000 |

The three queries successfully returned the expected records from the database.

## Index comparison

A separate benchmark table, `p2_benchmark.order_history`, containing 100,000 synthetic e-commerce order records was created for the performance experiment. The same date-range query was executed before and after creating a B-tree index on the `order_date` column.

The index created was `order_history_order_date_idx`.

The query counted orders placed on 1 January 2005 and returned 24 records both before and after indexing.

| Measurement | Before index | After index |
|---|---:|---:|
| Scan type | Sequential Scan | Index Only Scan |
| Three execution times (ms) | 6.431, 6.015, 6.577 | 0.061, 0.049, 0.049 |
| Median time (ms) | 6.431 | 0.049 |
| Shared buffer hits, third run | 1,024 | 3 |

The first execution in each phase was used as a warm-up and excluded from the three measured runs.

## Performance analysis

Before indexing, PostgreSQL used a Sequential Scan to examine all 100,000 records and removed 99,976 rows that did not match the date filter. After creating the B-tree index, PostgreSQL used an Index Only Scan through `order_history_order_date_idx` to retrieve the 24 matching records. The median execution time decreased from 6.431 ms to 0.049 ms, representing an improvement of approximately 99.2% in this experiment. Shared buffer hits also decreased from 1,024 to 3 in the third measured run. However, the experiment used synthetic data in a Codespaces environment, so the results may differ in a production e-commerce system. Indexes also require additional storage and introduce maintenance overhead during data insertion, updates and deletion.

## Files

- [Portfolio 2 SQL Queries](Dadung_Rwang_301921911_P2_Queries.sql)
- [Portfolio 2 SQL Optimisation](Dadung_Rwang_301921911_P2_Optimisation.sql)
- [Screenshots and execution evidence](screenshots/)

## Reference

- [PostgreSQL 16 Documentation – Using EXPLAIN](https://www.postgresql.org/docs/16/using-explain.html)
