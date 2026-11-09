
-- MIT 8103: Advanced Database Systems
-- Portfolio 3: Transactions and Concurrency
-- Case Study: Munchiba Hotel & Suites
-- Database: PostgreSQL

-- =========================================
-- EXPERIMENT 1: CREATE THE TEST TABLE
-- =========================================

-- Execute this separately before the experiments.

CREATE TABLE IF NOT EXISTS transaction_test (
    test_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    guest_name VARCHAR(100) NOT NULL
);

-- =========================================
-- EXPERIMENT 2: ROLLBACK
-- =========================================

BEGIN;

INSERT INTO transaction_test (guest_name)
VALUES ('John Test Guest');

ROLLBACK;

-- Verify that the insertion was cancelled.
SELECT * FROM transaction_test;


-- =========================================
-- EXPERIMENT 3: COMMIT
-- =========================================

BEGIN;

INSERT INTO transaction_test (guest_name)
VALUES ('Mary Test Guest');

COMMIT;

-- Verify that the insertion was saved.
SELECT * FROM transaction_test
WHERE guest_name = 'Mary Test Guest';


-- =========================================
-- EXPERIMENT 4: ATOMICITY
-- =========================================

BEGIN;

INSERT INTO transaction_test (guest_name)
VALUES ('Peter Atomicity Test');

INSERT INTO transaction_test (guest_name)
VALUES ('Grace Atomicity Test');

ROLLBACK;

-- Neither insertion should remain.
SELECT *
FROM transaction_test
WHERE guest_name IN (
    'Peter Atomicity Test',
    'Grace Atomicity Test'
);


-- =========================================
-- EXPERIMENT 5: CONSISTENCY
-- =========================================

-- Execute this statement separately.
-- An error is expected because guest_name
-- has a NOT NULL constraint.

INSERT INTO transaction_test (guest_name)
VALUES (NULL);

-- Expected SQLSTATE: 23502
-- NOT NULL constraint violation.

-- Run this verification separately after
-- the failed INSERT.

SELECT test_id, guest_name
FROM transaction_test
ORDER BY test_id;
