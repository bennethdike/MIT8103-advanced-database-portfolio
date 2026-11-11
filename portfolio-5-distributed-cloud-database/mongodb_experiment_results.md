# MongoDB Replica Set Experiment Results

**Course:** MIT 8103 – Advanced Database Systems  
**Portfolio:** 5 – Distributed and Cloud Database Exercise  
**Case Study:** Munchiba Hotel & Suites Reservation System

## 1. Objective

The purpose of this experiment was to investigate how MongoDB replication supports database availability, automatic failover and recovery after a server failure.

I configured three MongoDB instances on my Windows computer and tested how they behaved when the primary server became unavailable.

## 2. Initial Replica Set Configuration

I created a replica set named `munchibaRS` using three MongoDB instances.

| Node | Port | Initial State |
|---|---|---|
| Node 1 | 27018 | PRIMARY |
| Node 2 | 27019 | SECONDARY |
| Node 3 | 27020 | SECONDARY |

The `rs.status()` command confirmed that all three nodes were healthy.

**Result:** Successful.

## 3. Initial Data Replication

I inserted Reservation 101 for Chinedu Okeke into Node 1.

I then queried Nodes 2 and 3 separately and confirmed that both contained the same reservation document, including its MongoDB `_id`.

**Result:** Successful replication from the primary to both secondary nodes.

## 4. Primary Server Failure

I shut down Node 1 to simulate a database server failure.

A Windows network check showed that port 27018 was no longer listening for connections.

I then checked the replica set status from Node 2.

| Node | Health | State |
|---|---|---|
| Node 1 | 0 | Not reachable |
| Node 2 | 1 | PRIMARY |
| Node 3 | 1 | SECONDARY |

**Result:** MongoDB automatically elected Node 2 as the new primary.

## 5. Database Availability After Failover

While Node 1 was offline, I inserted Reservation 102 for Amaka Nwosu into Node 2.

MongoDB returned:

```javascript
{
  acknowledged: true,
  insertedId: ObjectId('6af3af474b6268b2440112fd')
}
```

This confirmed that the new primary could accept a database write after the original primary failed.

**Result:** Successful.

## 6. Replication After Failover

I connected to Node 3 and queried Reservation 102.

The reservation was available on Node 3 with the same MongoDB `_id`, guest details and reservation information.

**Result:** Replication continued after the primary changed.

## 7. Failed Node Recovery

I restarted Node 1 using its original MongoDB server configuration.

The replica set status showed:

| Node | Health | State |
|---|---|---|
| Node 1 | 1 | SECONDARY |
| Node 2 | 1 | PRIMARY |
| Node 3 | 1 | SECONDARY |

I queried Node 1 for Reservation 102 and confirmed that it contained the reservation created during its downtime.

**Result:** Node 1 successfully rejoined the replica set and synchronised the missing data.

## 8. Discussion of Findings

The experiment demonstrated several important distributed database concepts.

**Replication:** MongoDB maintained copies of reservation data across the replica set members.

**Availability:** The database continued accepting writes after the original primary failed because the two remaining voting members could form a majority and elect a new primary.

**Consistency:** The replicated documents matched when I checked them. However, MongoDB uses asynchronous replication, so this experiment does not prove that secondary reads are always immediately up to date.

**Fault tolerance:** The replica set tolerated the shutdown of one MongoDB process. However, all three instances ran on one computer, so the experiment did not test failure of an entire physical machine.

**Recovery:** The restarted node rejoined the replica set and received data written while it was unavailable.

## 9. Cloud Database and Sharding Considerations

This experiment was performed locally rather than on a cloud platform.

In a production environment, MongoDB replica set members could be deployed across separate servers or cloud availability zones to reduce the risk of a single machine failure affecting all replicas.

Sharding is another MongoDB feature that distributes data across multiple shards to support larger datasets and workloads. I did not implement sharding in this exercise because the practical experiment focused on replication, failover and recovery.

## 10. Conclusion

This exercise improved my understanding of how MongoDB replica sets support database availability and recovery.

For Munchiba Hotel & Suites, these concepts are relevant because a reservation system should remain available and preserve booking information when an individual database server becomes unavailable.

The experiment demonstrated that a new primary could be elected, new reservations could be accepted, and a recovering node could synchronise data created during its downtime.
