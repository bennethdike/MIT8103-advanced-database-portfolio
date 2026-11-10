// MIT 8103 - Portfolio 4
// Munchiba Hotel & Suites Reservation System
// MongoDB NoSQL Query Experiments

// Select the hotel database
use("munchiba_hotel_nosql");

// Experiment 1: Retrieve all reservations
db.reservations.find();

// Experiment 2: Find Reservation 1
db.reservations.find({ reservation_id: 1 });

// Experiment 3: Find pending reservations
db.reservations.find({ reservation_status: "Pending" });

// Experiment 4: Query an embedded payment field
db.reservations.find({
  "payment.payment_status": "Successful"
});

// Experiment 5: Find cancelled reservations
db.reservations.find({ reservation_status: "Cancelled" });

// Experiment 6: Add a cancellation reason
db.reservations.updateOne(
  { reservation_id: 2 },
  {
    $set: {
      cancellation_reason: "Guest requested cancellation"
    }
  }
);

// Experiment 7: Verify the updated reservation
db.reservations.findOne({ reservation_id: 2 });
