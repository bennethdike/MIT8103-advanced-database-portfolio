// MIT 8103 - Portfolio 5
// Munchiba Hotel & Suites Reservation System
// MongoDB Replica Set Experiment
//
// NOTE: This is a reference record of commands used in different
// terminals and at different stages. Do not execute as one script.
//
// STEP 1: Start three MongoDB instances in separate Windows terminals.
//
// Node 1:
// "C:\Program Files\MongoDB\Server\9.0\bin\mongod.exe" --replSet munchibaRS --port 27018 --dbpath "C:\MongoDBReplicaSet\node1" --bind_ip 127.0.0.1
//
// Node 2:
// "C:\Program Files\MongoDB\Server\9.0\bin\mongod.exe" --replSet munchibaRS --port 27019 --dbpath "C:\MongoDBReplicaSet\node2" --bind_ip 127.0.0.1
//
// Node 3:
// "C:\Program Files\MongoDB\Server\9.0\bin\mongod.exe" --replSet munchibaRS --port 27020 --dbpath "C:\MongoDBReplicaSet\node3" --bind_ip 127.0.0.1

// STEP 2: Initialise the replica set on Node 1.
// Run once only.
/*
rs.initiate({
  _id: "munchibaRS",
  members: [
    { _id: 0, host: "127.0.0.1:27018" },
    { _id: 1, host: "127.0.0.1:27019" },
    { _id: 2, host: "127.0.0.1:27020" }
  ]
})
*/

// STEP 3: Check replica set status.
// rs.status()

// STEP 4: Insert the initial test reservation on Node 1.
/*
db.getSiblingDB("munchiba_replication_test").reservations.insertOne({
  reservation_id: 101,
  guest_name: "Chinedu Okeke",
  room_number: "301",
  room_type: "Executive Suite",
  check_in_date: "2026-12-20",
  check_out_date: "2026-12-22",
  total_amount: 130000,
  reservation_status: "Confirmed"
})
*/

// STEP 5: Verify replication on Nodes 2 and 3.
// db.getSiblingDB("munchiba_replication_test").reservations.findOne({ reservation_id: 101 })

// STEP 6: Shut down Node 1 using its own shell.
// db.getSiblingDB("admin").shutdownServer()

// STEP 7: Check automatic failover from Node 2.
// rs.status()

// STEP 8: Insert a new reservation on the elected primary (Node 2).
/*
db.getSiblingDB("munchiba_replication_test").reservations.insertOne({
  reservation_id: 102,
  guest_name: "Amaka Nwosu",
  room_number: "202",
  room_type: "Deluxe",
  check_in_date: "2026-12-24",
  check_out_date: "2026-12-26",
  total_amount: 80000,
  reservation_status: "Confirmed"
})
*/

// STEP 9: Verify replication on Node 3.
// db.getSiblingDB("munchiba_replication_test").reservations.findOne({ reservation_id: 102 })

// STEP 10: Restart Node 1 using the original Windows command.
// Check that Node 1 rejoins as SECONDARY.
// rs.status()

// STEP 11: Verify recovery on Node 1.
// db.getSiblingDB("munchiba_replication_test").reservations.findOne({ reservation_id: 102 })
