
// MIT 8103 - Portfolio 4
// Student: Dadung Rwang Pam
// Student ID: 301921911
// Case Study: E-commerce Platform
// MongoDB Database: ecommerce_nosql
// Collection: payment_events

// 1. Select the database
db = db.getSiblingDB("ecommerce_nosql");

// 2. Check existing documents before inserting
const existingCount = db.payment_events.countDocuments();

if (existingCount === 0) {

  // Insert four sample e-commerce events
  db.payment_events.insertMany([
    {
      _id: "PE001",
      event_type: "payment_processed",
      occurred_at: "2026-11-10 09:30:00",
      customer: { customer_id: 1, full_name: "Ada James" },
      order: { order_number: "ORD001", order_status: "Confirmed" },
      payment: {
        payment_id: 1,
        amount: 480000,
        currency: "NGN",
        payment_status: "Successful"
      },
      details: { payment_status: "Successful" }
    },
    {
      _id: "PE002",
      event_type: "payment_processed",
      occurred_at: "2026-11-15 16:00:00",
      customer: { customer_id: 2, full_name: "Ben Cole" },
      order: { order_number: "ORD002", order_status: "Confirmed" },
      payment: {
        payment_id: 2,
        amount: 25000,
        currency: "NGN",
        payment_status: "Successful"
      },
      details: { payment_status: "Successful" }
    },
    {
      _id: "PE003",
      event_type: "payment_processed",
      occurred_at: "2026-11-12 11:30:00",
      customer: { customer_id: 3, full_name: "Mary David" },
      order: { order_number: "ORD003", order_status: "Pending" },
      payment: {
        payment_id: 3,
        amount: 15000,
        currency: "NGN",
        payment_status: "Failed"
      },
      details: { payment_status: "Failed" }
    },
    {
      _id: "PE004",
      event_type: "order_confirmed",
      occurred_at: "2026-11-10 09:31:00",
      customer: { customer_id: 1, full_name: "Ada James" },
      order: { order_number: "ORD001", order_status: "Confirmed" },
      details: {
        confirmation_note: "Order confirmed after successful payment"
      }
    }
  ]);

} else if (
  existingCount === 3 &&
  !db.payment_events.findOne({ _id: "PE004" })
) {

  // Preserve the three existing payment documents.
  // Add event-specific details to them.
  db.payment_events.updateMany(
    { event_type: "payment_processed" },
    [
      {
        $set: {
          "details.payment_status": "$payment.payment_status"
        }
      }
    ]
  );

  // Add the fourth order confirmation event.
  db.payment_events.insertOne({
    _id: "PE004",
    event_type: "order_confirmed",
    occurred_at: "2026-11-10 09:31:00",
    customer: { customer_id: 1, full_name: "Ada James" },
    order: { order_number: "ORD001", order_status: "Confirmed" },
    details: {
      confirmation_note: "Order confirmed after successful payment"
    }
  });

} else {
  print("Existing records detected. No documents inserted.");
}

// 3. Count all event documents
print("Total event documents:");
printjson(db.payment_events.countDocuments());

// 4. Retrieve the ordered event history for ORD001
print("ORD001 event history:");
printjson(
  db.payment_events.find(
    { "order.order_number": "ORD001" },
    { _id: 1, event_type: 1, occurred_at: 1, details: 1 }
  ).sort({ occurred_at: 1, _id: 1 }).toArray()
);

// 5. Find failed payment events
print("Failed payment events:");
printjson(
  db.payment_events.find(
    { "details.payment_status": "Failed" }
  ).toArray()
);
