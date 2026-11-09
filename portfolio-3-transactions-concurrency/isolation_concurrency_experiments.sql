
-- MIT 8103: Advanced Database Systems
-- Portfolio 3: Transactions and Concurrency
-- Case Study: Munchiba Hotel & Suites
--
-- These experiments use two separate
-- PostgreSQL Query Tool sessions.
--
-- Execute each section separately and
-- follow the instructions in the comments.


-- =========================================
-- EXPERIMENT 1: TRANSACTION ISOLATION
-- =========================================

-- SESSION A:
-- Start a transaction and update Mary's name.
-- Do not commit immediately.

BEGIN;

UPDATE transaction_test
SET guest_name = 'Mary Updated Guest'
WHERE test_id = 2;


-- SESSION B:
-- Run in a separate Query Tool connection.
-- The original committed name should be visible
-- while Session A's transaction remains open.

SELECT test_id, guest_name
FROM transaction_test
WHERE test_id = 2;

-- Observed result before Session A committed:
-- 2 | Mary Test Guest


-- SESSION A:
-- Return to Session A and save the update.

COMMIT;


-- SESSION B:
-- Run the query again after Session A commits.

SELECT test_id, guest_name
FROM transaction_test
WHERE test_id = 2;

-- Observed result after Session A committed:
-- 2 | Mary Updated Guest


-- =========================================
-- EXPERIMENT 2: DURABILITY VERIFICATION
-- =========================================

-- Close the original Query Tool sessions.
-- Open a fresh connection and run:

SELECT test_id, guest_name
FROM transaction_test
WHERE test_id = 2;

-- Observed result:
-- 2 | Mary Updated Guest
--
-- This confirms persistence across sessions.
-- A PostgreSQL server restart was not tested.


-- =========================================
-- EXPERIMENT 3: ROW-LEVEL LOCKING
-- =========================================

-- SESSION A:
-- Begin a transaction and update the record.
-- Keep this transaction open.

BEGIN;

UPDATE transaction_test
SET guest_name = 'Mary Receptionist A'
WHERE test_id = 2;


-- SESSION B:
-- In a separate Query Tool connection,
-- attempt to update the same record.

BEGIN;

SET LOCAL lock_timeout = '5s';

UPDATE transaction_test
SET guest_name = 'Mary Receptionist B'
WHERE test_id = 2;

-- Observed result:
-- ERROR: canceling statement due to lock timeout
-- SQLSTATE: 55P03
--
-- Session B could not update the locked row.


-- SESSION B:
-- Cancel the failed transaction.

ROLLBACK;


-- SESSION A:
-- Cancel the uncommitted update and
-- release the row-level lock.

ROLLBACK;


-- FINAL VERIFICATION:
-- Run in either session after both rollbacks.

SELECT test_id, guest_name
FROM transaction_test
WHERE test_id = 2;

-- Observed result:
-- 2 | Mary Updated Guest
