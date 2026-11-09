# PostgreSQL Error Evidence

**Course:** MIT 8103 – Advanced Database Systems  
**Portfolio:** 3 – Transactions and Concurrency  
**Case Study:** Munchiba Hotel & Suites Reservation System

## Experiment 1: Consistency Constraint

The following error was recorded when I attempted to insert a NULL value into the `guest_name` column of the `transaction_test` table.

```text
ERROR: null value in column "guest_name" of relation "transaction_test" violates not-null constraint
Failing row contains (7, null).

SQL state: 23502
Detail: Failing row contains (7, null).
```

**Interpretation:** PostgreSQL rejected the invalid record because the `guest_name` column has a NOT NULL constraint.

A subsequent verification query confirmed that the previously committed guest record remained unchanged.

## Experiment 2: Concurrent Update and Lock Timeout

The following error was recorded when Session B attempted to update a record that was already locked by an uncommitted transaction in Session A.

```text
ERROR: canceling statement due to lock timeout
CONTEXT: while updating tuple (0,7) in relation "transaction_test"

SQL state: 55P03
```

**Interpretation:** PostgreSQL prevented Session B from completing its conflicting update while Session A held the row lock.

The five-second lock timeout ended the waiting statement. Both transactions were subsequently rolled back, and a verification query confirmed that the previously committed guest information remained unchanged.

## Conclusion

These recorded PostgreSQL errors provide practical evidence of constraint enforcement and concurrency control.

They demonstrate how PostgreSQL helps maintain data integrity and coordinates conflicting database operations.
