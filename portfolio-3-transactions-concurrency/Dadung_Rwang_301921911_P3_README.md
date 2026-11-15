
# Portfolio 3: Transactions and Concurrency Control

**Student:** Dadung Rwang Pam
**Student ID:** 301921911
**Course:** MIT 8103 – Advanced Database Systems
**Case Study:** E-commerce Platform Database
**Database:** PostgreSQL 16

## 1. Introduction

This portfolio demonstrates transaction management and concurrency control in an e-commerce database using PostgreSQL. It focuses on saving database changes with COMMIT, reversing uncommitted changes with ROLLBACK, and managing simultaneous database operations.

The practical exercises use payment processing, order confirmation and product stock management to demonstrate transaction control, constraint enforcement, transaction atomicity and concurrency handling.

## 2. COMMIT Transaction: Confirming a Payment

### 2.1 Objective

The first transaction demonstrates how a pending payment can be confirmed and its associated order status updated within a single transaction.

### 2.2 Initial Database Records

The initial query returned the following payment records:

| Order Number | Order Status | Payment ID | Amount (₦) | Payment Status |
|---|---|---:|---:|---|
| ORD001 | Confirmed | 1 | 480,000.00 | Successful |
| ORD002 | Pending | 2 | 25,000.00 | Pending |
| ORD003 | Pending | 3 | 15,000.00 | Failed |

### 2.3 SQL Implementation

```sql
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
```

### 2.4 Execution Results

PostgreSQL returned:

```text
BEGIN
UPDATE 1
UPDATE 1
COMMIT
```

Both updates were successfully executed and permanently saved.

### 2.5 Verification

The verification query confirmed the updated records:

| Order Number | Order Status | Payment Status | Payment Date |
|---|---|---|---|
| ORD002 | Confirmed | Successful | 2026-11-15 16:00:00 |

A second attempt to update the payment returned:

```text
UPDATE 0
```

This confirmed that the condition `payment_status = 'Pending'` prevented an already successful payment from being updated again.

### 2.6 Screenshot Evidence – COMMIT

The screenshots showing the successful transaction, update results and verification are saved in the `screenshots/` folder.

## 3. ROLLBACK Transaction: Reversing an Invalid Payment Operation

### 3.1 Objective

The second transaction demonstrates how PostgreSQL reverses uncommitted changes when an error occurs during payment processing.

A temporary payment record was inserted before an invalid payment amount was attempted.

### 3.2 SQL Implementation: Temporary Payment

```sql
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
```

### 3.3 Execution Results

PostgreSQL returned:

```text
BEGIN
INSERT 0 1
```

One temporary payment record was inserted inside the transaction but had not yet been committed.

### 3.4 Invalid Payment Attempt

The following SQL attempted to insert a payment with an amount of zero:

```sql
INSERT INTO public.payment
    (order_id, amount, payment_status, payment_date)
SELECT
    order_id,
    0.00,
    'Pending',
    TIMESTAMP '2026-11-15 17:05:00'
FROM public."Order"
WHERE order_number = 'ORD003';
```

PostgreSQL rejected the operation and returned:

```text
ERROR: new row for relation "payment" violates check constraint "payment_amount_check"
```

This demonstrated that the database CHECK constraint prevents payment amounts of zero or less.

### 3.5 Execute ROLLBACK

```sql
ROLLBACK;
```

PostgreSQL returned:

```text
ROLLBACK
```

The rollback cancelled the entire uncommitted transaction, including the temporary ₦100 payment inserted earlier.

### 3.6 Verification of Rolled-Back Changes

The following query checked whether the temporary payment remained in the database:

```sql
SELECT COUNT(*) AS rolled_back_payment_count
FROM public.payment p
JOIN public."Order" o
    ON p.order_id = o.order_id
WHERE o.order_number = 'ORD003'
AND p.amount = 100.00;
```

Actual PostgreSQL result:

```text
rolled_back_payment_count
---------------------------
                         0
(1 row)
```

The result confirmed that the temporary payment record was successfully removed.

### 3.7 Screenshot Evidence – ROLLBACK

The screenshots showing the temporary payment insertion, invalid payment error, ROLLBACK command and final verification are saved in the `screenshots/` folder.

## 4. Isolation and Concurrency Control

### 4.1 Objective

This exercise demonstrates how PostgreSQL handles two customers attempting to purchase the last available Wireless Mouse at the same time using two independent database sessions.

### 4.2 Transaction Isolation

Both sessions used the READ COMMITTED isolation level.

Session A started a transaction and reduced the Wireless Mouse stock from one unit to zero without immediately committing the change.

Session B attempted to purchase the same product. Its update waited while Session A held the row lock. The activity check in Session A showed that the other session was waiting, with `wait_event_type` displayed as `Lock`.

### 4.3 Execution Results

After Session A committed, Session B's update completed with:

```text
UPDATE 0
```

This happened because the condition `stock_quantity > 0` was no longer satisfied after Session A purchased the last available unit.

Session B was rolled back, and the original product stock was restored to 25 after the test.

### 4.4 Concurrency Analysis

The exercise demonstrated how PostgreSQL row-level locking coordinates simultaneous updates to the same product record.

The conditional stock update prevented the second session from reducing stock below zero. This helps prevent overselling when multiple customers attempt to purchase the last available unit.

The test also showed that READ COMMITTED does not allow a session to see another session's uncommitted changes. The row lock ensures that the second update waits for the first transaction to finish before evaluating the updated record.

### 4.5 Screenshot Evidence – Concurrency

The concurrency screenshots are saved in the `screenshots/` folder. They show the two database sessions, the lock wait, Session A's COMMIT and Session B's `UPDATE 0` result.

## 5. Transaction Management Analysis

The exercises demonstrate how PostgreSQL transaction control helps maintain consistency during e-commerce payment processing and product stock management.

COMMIT permanently saves successful database operations. In the first transaction, the pending payment for ORD002 and its associated order status were updated together.

ROLLBACK reverses uncommitted operations when an error occurs. In the second transaction, the invalid zero payment amount violated the `payment_amount_check` constraint. The rollback also removed the valid temporary payment inserted earlier in the same transaction.

The concurrency exercise demonstrated how row-level locking and conditional stock updates help prevent overselling when two sessions attempt to purchase the same last unit.

These mechanisms support transaction atomicity and database consistency when correctly applied in application workflows.

## 6. Files and Evidence

| File or Evidence | Description |
|---|---|
| `Dadung_Rwang_301921911_P3_README.md` | Portfolio 3 documentation |
| `Dadung_Rwang_301921911_P3_Transactions.sql` | COMMIT and ROLLBACK SQL commands |
| `Dadung_Rwang_301921911_P3_SessionA.sql` | Session A concurrency commands |
| `Dadung_Rwang_301921911_P3_SessionB.sql` | Session B concurrency commands |
| `screenshots/` | Screenshots showing COMMIT, ROLLBACK and concurrency operations |

## 7. Conclusion

The practical exercises demonstrated the use of COMMIT, ROLLBACK and transaction isolation in PostgreSQL within an e-commerce database.

The payment-processing exercise showed how successful operations can be saved together and how invalid operations can be reversed. The concurrency exercise demonstrated how PostgreSQL locking and conditional stock updates can prevent two simultaneous purchases from reducing product stock below zero.

Overall, the portfolio provided practical experience in transaction management, constraint enforcement, isolation and concurrency control.

## 8. References

- [PostgreSQL 16 – Transactions](https://www.postgresql.org/docs/16/tutorial-transactions.html)
- [PostgreSQL 16 – Transaction Isolation](https://www.postgresql.org/docs/16/transaction-iso.html)
