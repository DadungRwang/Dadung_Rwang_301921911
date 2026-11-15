
# Portfolio 4 NoSQL and Advanced Data Models

**Student:** Dadung Rwang Pam
**Student ID:** 301921911
**Course:** MIT 8103 – Advanced Database Systems
**Case Study:** E-commerce Platform Database
**Database:** MongoDB 8.0.38

## 1. Document Model

The `ecommerce_nosql` database contains a `payment_events` collection. Each document represents an e-commerce activity, such as a payment being processed or an order being confirmed.

The documents share common fields, including `_id`, `event_type`, `occurred_at`, `customer` and `order`. Customer, order and payment information are stored as embedded documents. The `details` field varies according to the event type.

Two event types were implemented:

- `payment_processed`
- `order_confirmed`

Example payment event document:

```javascript
{
  _id: "PE003",
  event_type: "payment_processed",
  occurred_at: "2026-11-12 11:30:00",
  customer: {
    customer_id: 3,
    full_name: "Mary David"
  },
  order: {
    order_number: "ORD003",
    order_status: "Pending"
  },
  payment: {
    payment_id: 3,
    amount: 15000,
    currency: "NGN",
    payment_status: "Failed"
  },
  details: {
    payment_status: "Failed"
  }
}
```

## 2. Implementation and Results

MongoDB was implemented locally in the existing Ubuntu Codespace using MongoDB Server 8.0.38 and MongoDB Shell 2.14.2.

The `ecommerce_nosql` database and `payment_events` collection were created. Four sample documents were stored using MongoDB shell commands.

The following queries were executed:

| Query | Actual result |
|---|---|
| Count all documents | 4 |
| Retrieve ORD001 event history | PE001 and PE004 |
| Find failed payment events | PE003 – Mary David |

The ORD001 history query returned a payment-processed event followed by an order-confirmed event. The failed-payment query returned PE003, showing Mary David's failed payment of ₦15,000.

The documents were entered separately in MongoDB using sample records from the e-commerce case study. They are not automatically extracted from or synchronised with PostgreSQL.

## 3. Why MongoDB Fits

MongoDB is suitable for this e-commerce example because its document model allows related information, such as customer, order and payment details, to be stored together in one document.

Embedded documents make it easier to retrieve related information without requiring multiple table joins. Different event types can also contain different details without requiring every document to have exactly the same structure.

The event-based approach allows payment and order activities to be recorded as separate documents as the transaction history grows.

However, MongoDB does not automatically enforce PostgreSQL foreign-key relationships or synchronise changes between the two databases. PostgreSQL remains responsible for the relational database operations and transaction controls demonstrated in the earlier portfolios.

## 4. Files

| File | Description |
|---|---|
| `Dadung_Rwang_301921911_P4_MongoDB.js` | MongoDB database selection, document insertion and queries |
| `Dadung_Rwang_301921911_P4_Setup.md` | MongoDB installation and connection notes |
| `screenshots/` | MongoDB connection and query evidence |

## 5. Conclusion

This portfolio demonstrated how MongoDB can store and retrieve e-commerce activity records using a flexible document structure.

The implementation showed how embedded documents can group related customer, order and payment information, while different event types can contain different details. The exercise also demonstrated document insertion, counting, filtering and retrieving event histories using MongoDB queries.

## 6. References

- [MongoDB 8.0 Documentation](https://www.mongodb.com/docs/v8.0/)
- [MongoDB Query Documents](https://www.mongodb.com/docs/v8.0/tutorial/query-embedded-documents/)
- [MongoDB Insert Documents](https://www.mongodb.com/docs/v8.0/tutorial/insert-documents/)
