# Portfolio 3: Transactions and Concurrency

**Course:** MIT 8103 – Advanced Database Systems  
**Case Study:** Munchiba Hotel & Suites Reservation System  
**Database Management System:** PostgreSQL  
**Tool:** pgAdmin 4

## Overview

This portfolio investigates transaction management and concurrency control in PostgreSQL using the Munchiba Hotel & Suites Reservation System.

The practical experiments demonstrate the use of COMMIT, ROLLBACK, ACID properties, transaction isolation and row-level locking.

A separate `transaction_test` table was used to conduct the experiments without changing the hotel's reservation and payment records.

## Practical Experiments

The experiments carried out include:

1. Demonstrating ROLLBACK to cancel an uncommitted insertion.
2. Demonstrating COMMIT to save a guest record.
3. Demonstrating Atomicity by rolling back two insertions together.
4. Demonstrating Consistency through a NOT NULL constraint violation.
5. Demonstrating Isolation using two database sessions.
6. Checking committed data persistence in a new database session.
7. Demonstrating concurrency control through row-level locking and a lock timeout.

## Key Findings

The experiments showed that PostgreSQL supports reliable transaction processing through COMMIT and ROLLBACK.

The database enforced integrity constraints, prevented dirty reads under the default READ COMMITTED isolation level, and used row-level locking to coordinate conflicting updates.

The durability exercise confirmed that committed data remained accessible after reopening the Query Tool. A database server restart was not tested.

## Conclusion

Transaction management and concurrency control are important for maintaining accurate and reliable hotel reservation information.

These PostgreSQL features help protect data when multiple staff members access or modify database records.
