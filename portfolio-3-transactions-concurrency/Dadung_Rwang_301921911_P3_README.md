
# Portfolio 3: Transactions and Concurrency Control

**Student:** Dadung Rwang
**Student ID:** 301921911
**Course:** MIT 8103 – Advanced Database Systems
**Case Study:** E-commerce Platform Database
**Database:** PostgreSQL 16

## 1. Introduction

This portfolio demonstrates transaction management in an e-commerce database using PostgreSQL. It focuses on saving database changes with COMMIT and reversing uncommitted changes with ROLLBACK.

The practical exercise uses payment processing and order confirmation to demonstrate transaction control, constraint enforcement and transaction atomicity.

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

The PostgreSQL terminal returned:

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

Screenshot filename:

`Dadung_Rwang_301921911_P3_COMMIT.png`

The screenshot shows the successful transaction, update results and verification of the confirmed payment.

---

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

The following query was used to check whether the temporary payment remained in the database:

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

Screenshot filename:

`Dadung_Rwang_301921911_P3_ROLLBACK.png`

The screenshot shows the temporary payment insertion, invalid payment error, ROLLBACK command and final verification.

---

## 4. Transaction Management Analysis

The exercise demonstrates how PostgreSQL transaction control helps maintain consistency during e-commerce payment processing.

COMMIT permanently saves successful database operations. In the first transaction, the pending payment for ORD002 and its associated order status were updated together.

ROLLBACK reverses uncommitted operations when an error occurs. In the second transaction, the invalid zero payment amount violated the `payment_amount_check` constraint. The rollback also removed the valid temporary payment inserted earlier in the same transaction.

This demonstrates transaction atomicity: changes within a transaction are committed together or rolled back together. The database CHECK constraint also helps prevent invalid payment amounts from being stored.

## 5. Files and Evidence

| File or Evidence | Description |
|---|---|
| `Dadung_Rwang_301921911_P3_README.md` | Portfolio 3 transaction documentation |
| `screenshots/` | Screenshots showing COMMIT and ROLLBACK operations |

## 6. Conclusion

The practical exercise demonstrated the use of COMMIT and ROLLBACK in PostgreSQL within an e-commerce payment-processing scenario. These transaction controls help maintain database consistency by saving successful operations and reversing incomplete or invalid operations.
