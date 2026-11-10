# MongoDB NoSQL Experiment Results

## MIT 8103 – Portfolio 4: NoSQL and Advanced Data Models

**Case Study:** Munchiba Hotel & Suites Reservation System

### 1. Introduction

In this portfolio, I implemented a document-oriented NoSQL database using MongoDB Community Server and MongoDB Compass. The purpose was to explore how hotel reservation information could be stored and retrieved using documents instead of the relational tables used in PostgreSQL.

I created a database named `munchiba_hotel_nosql` and a collection named `reservations`.

### 2. Document Model Implementation

I inserted two fictional hotel reservation documents.

The first reservation belonged to John Okafor, who booked Standard Room 101 for three nights at ₦25,000 per night. The total amount was ₦75,000, and the reservation and payment were confirmed and successful.

The second reservation belonged to Ada Eze, who booked Deluxe Room 201 for two nights at ₦40,000 per night, giving a total of ₦80,000. This reservation initially had a Pending status and no payment.

Each MongoDB document contained embedded objects for guest details, room information and payment information.

### 3. Query Experiments and Results

**Experiment 1: Retrieve a reservation by ID**

I used the MongoDB Compass filter:

`{ "reservation_id": 1 }`

The query successfully returned Reservation 1.

**Experiment 2: Retrieve pending reservations**

I used:

`{ "reservation_status": "Pending" }`

Before changing the reservation status, the query returned Reservation 2. This demonstrated how MongoDB filters documents based on field values.

**Experiment 3: Query an embedded field**

I used:

`{ "payment.payment_status": "Successful" }`

The query returned Reservation 1, demonstrating that MongoDB supports queries inside embedded documents using dot notation.

**Experiment 4: Update a reservation**

Using MongoDB Compass, I changed Reservation 2 from Pending to Cancelled.

I then used the MongoDB Shell to add a cancellation reason:

```javascript
db.reservations.updateOne(
  { reservation_id: 2 },
  {
    $set: {
      cancellation_reason: "Guest requested cancellation"
    }
  }
)
```

MongoDB returned `acknowledged: true`, `matchedCount: 1` and `modifiedCount: 1`, confirming that one document was successfully updated.

**Experiment 5: Verify the update**

I used:

`db.reservations.findOne({ reservation_id: 2 })`

The result showed that Reservation 2 had the status `Cancelled` and the cancellation reason `Guest requested cancellation`. Its other reservation and payment details remained available.

### 4. Suitability of MongoDB for Hotel Reservations

MongoDB is suitable for representing hotel reservations because related information can be stored together in one document. For example, guest details, room information, booking dates and payment information can be retrieved without joining multiple tables.

Another advantage is flexibility. When I added the `cancellation_reason` field, MongoDB accepted the new field without requiring a change to a fixed table structure.

However, MongoDB also has limitations. Embedding guest or room details in multiple reservation documents may duplicate information and create inconsistencies when those details change. Important booking rules, such as preventing overlapping confirmed reservations and ensuring payment before confirmation, also require deliberate enforcement in the application or database design.

For Munchiba Hotel & Suites, PostgreSQL remains a strong choice for core booking and payment transactions because of the relational constraints implemented in Portfolio 1. MongoDB offers a useful alternative for storing and retrieving complete reservation documents.

### 5. Conclusion

These experiments helped me understand the practical differences between relational and document-oriented databases. I successfully created MongoDB documents, retrieved information using filters, queried embedded fields and updated an existing reservation.

The work demonstrated that MongoDB provides a flexible way to represent hotel reservation information, although careful data modelling and consistency controls remain necessary.
