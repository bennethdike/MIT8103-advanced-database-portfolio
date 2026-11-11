# Portfolio 5: Distributed and Cloud Database Exercise

## Case Study
Munchiba Hotel & Suites Reservation System

## Objective
The objective of this exercise was to explore distributed database concepts through a practical MongoDB replication experiment. I configured a local three-node replica set to investigate data replication, primary election, availability, and recovery after a server failure.

## Technology Used
- MongoDB Community Server 9.0
- MongoDB Compass and MongoDB Shell
- Windows operating system

## Replica Set Configuration
Replica set name: munchibaRS

| Node | Address | Initial Role |
|------|---------|--------------|
| Node 1 | 127.0.0.1:27018 | PRIMARY |
| Node 2 | 127.0.0.1:27019 | SECONDARY |
| Node 3 | 127.0.0.1:27020 | SECONDARY |

All three MongoDB instances were configured on the same computer, using separate data directories.

## Practical Experiments

### 1. Replica Set Initialisation
I configured and initiated the three-member replica set. I used rs.status() to verify that Node 1 became the primary while Nodes 2 and 3 operated as secondary members.

### 2. Data Replication
I inserted a fictional hotel reservation for Chinedu Okeke (Reservation 101) into the primary database. I then queried Nodes 2 and 3 and confirmed that the same reservation was available on both secondary members.

### 3. Primary Node Failure
I shut down Node 1 to simulate a database server failure. The replica set detected that the original primary was unavailable.

### 4. Automatic Failover
I checked the replica set status and confirmed that Node 2 was automatically elected as the new primary. Node 3 remained a secondary member.

### 5. Continued Write Availability
While Node 1 was offline, I inserted another fictional reservation for Amaka Nwosu (Reservation 102) into Node 2. MongoDB acknowledged the insert successfully, demonstrating that the remaining replica set members could continue processing writes.

### 6. Replication After Failover
I queried Node 3 and verified that Reservation 102 had been replicated from the new primary.

### 7. Node Recovery
I restarted Node 1 and confirmed that it rejoined the replica set as a secondary member. I also queried Node 1 and found Reservation 102, demonstrating that it had synchronised the data created during its downtime.

## Findings
The experiment demonstrated MongoDB's ability to replicate data across replica set members, elect a new primary when the original primary fails, continue accepting writes when a majority remains available, and synchronise a recovering member.

## Availability and Consistency
A three-member replica set can continue electing a primary when two voting members remain available. MongoDB replication is asynchronous, so secondary members may temporarily lag behind the primary. The observed successful replication does not establish that all reads are always immediately consistent.

## Limitations
This was a local simulation rather than a cloud deployment. All three nodes ran on one Windows computer, so the setup would not survive failure of the entire computer. Sharding was not implemented; the experiment focused on replication and failover.

## Conclusion
This practical exercise helped me understand how distributed database replication supports availability and recovery. The results are relevant to the Munchiba Hotel & Suites Reservation System because a reservation service needs reliable access to booking information, including during individual database server failures.
