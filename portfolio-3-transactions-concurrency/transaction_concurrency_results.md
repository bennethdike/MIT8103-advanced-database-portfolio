# Portfolio 3: Transaction and Concurrency Results

**Course:** MIT 8103 – Advanced Database Systems  
**Case Study:** Munchiba Hotel & Suites Reservation System  
**Database:** PostgreSQL  
**Tool:** pgAdmin 4

## 1. Introduction

This practical exercise examined how PostgreSQL manages database transactions and concurrent operations.

I used the Munchiba Hotel & Suites Reservation System as my case study and created a separate `transaction_test` table for the experiments. This allowed me to investigate transaction behaviour without changing the existing hotel reservation and payment records.

The experiments focused on COMMIT, ROLLBACK, the ACID properties, transaction isolation and row-level locking.

## 2. COMMIT and ROLLBACK

I first investigated how PostgreSQL saves and cancels transactions.

In the ROLLBACK experiment, I inserted a fictional guest named John Test Guest and then executed ROLLBACK. A subsequent query confirmed that the record was not saved.

For the COMMIT experiment, I inserted Mary Test Guest and executed COMMIT. PostgreSQL saved the record successfully, returning Guest ID 2.

These experiments demonstrated the difference between saving a completed transaction and cancelling an uncommitted operation.

## 3. Demonstrating ACID Properties

### 3.1 Atomicity

I inserted two fictional guests, Peter Atomicity Test and Grace Atomicity Test, within one transaction.

After executing ROLLBACK, neither record remained in the table.

This demonstrated the all-or-nothing principle of Atomicity.

### 3.2 Consistency

I attempted to insert a guest record with a NULL value in the `guest_name` column.

PostgreSQL rejected the insertion because the column had a NOT NULL constraint.

The database returned SQLSTATE `23502`, confirming that the invalid record was not accepted.

A verification query showed that the previously committed Mary Test Guest record was still available.

This demonstrated how database constraints help maintain consistency.

### 3.3 Isolation

I opened two separate PostgreSQL Query Tool sessions.

In Session A, I updated Mary's name from Mary Test Guest to Mary Updated Guest without committing the transaction.

When I queried the record from Session B, PostgreSQL still returned Mary Test Guest.

After committing the transaction in Session A, Session B returned Mary Updated Guest.

This demonstrated that PostgreSQL's default READ COMMITTED isolation level prevents dirty reads.

### 3.4 Durability

After committing Mary's updated name, I closed the original Query Tool sessions and opened a new database connection.

The query still returned Mary Updated Guest.

This confirmed that the committed information remained accessible across database sessions. A PostgreSQL server restart or failure-recovery test was not performed.

## 4. Concurrency and Row-Level Locking

I investigated what happens when two database sessions attempt to update the same record.

In Session A, I started a transaction and updated Mary's record without committing.

In Session B, I attempted to update the same record using a lock timeout of five seconds.

PostgreSQL returned the following error:

`ERROR: canceling statement due to lock timeout`

The SQLSTATE was `55P03`.

This occurred because Session A was holding a row-level lock, preventing Session B from completing its conflicting update.

I then executed ROLLBACK in both sessions to cancel the uncommitted changes and release the lock.

A final verification query returned Mary Updated Guest, confirming that the previously committed information remained unchanged.

## 5. Summary of Results

| Experiment | Observed Result | Lesson Learned |
|---|---|---|
| ROLLBACK | Uncommitted insertion cancelled | Transactions can be reversed before commit |
| COMMIT | Mary's record saved | Transactions can be saved permanently |
| Atomicity | Two insertions rolled back together | Transactions follow the all-or-nothing principle |
| Consistency | NULL insertion rejected | Constraints protect data integrity |
| Isolation | Session B could not see an uncommitted update | PostgreSQL prevents dirty reads under READ COMMITTED |
| Durability | Committed data visible in a new session | Saved data persists across connections |
| Concurrency | Conflicting update produced a lock timeout | Row-level locking coordinates concurrent updates |

## 6. Relevance to Munchiba Hotel & Suites

Transaction management is important for a hotel reservation system because multiple staff members may access guest and reservation information simultaneously.

COMMIT and ROLLBACK help ensure that completed operations are saved and incomplete operations can be cancelled.

Database constraints help prevent invalid information, while transaction isolation and row-level locking help manage concurrent updates.

These features contribute to the reliability and integrity of the hotel's database.

## 7. Conclusion

Through these practical experiments, I gained a better understanding of how PostgreSQL manages transactions and concurrency.

The results demonstrated the importance of ACID properties, transaction isolation and locking mechanisms in maintaining reliable database operations.

All guest records used in these experiments were fictional.
