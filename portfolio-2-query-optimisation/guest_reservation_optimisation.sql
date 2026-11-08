
-- MIT 8103: Advanced Database Systems
-- Portfolio 2: Query Processing and Optimisation
-- Case Study: Munchiba Hotel & Suites
--
-- Experiment: Guest Reservation Lookup
-- Using a separate table with 10,000 fictional records

-- Step 1: Examine performance before indexing
-- Run this before creating the index

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    test_id,
    guest_id,
    room_id,
    reservation_date,
    total_amount
FROM reservation_performance_test
WHERE guest_id = 500;

-- Step 2: Create the B-tree index
-- Run only after recording the baseline results

CREATE INDEX IF NOT EXISTS idx_performance_guest_id
ON reservation_performance_test (guest_id);

-- Step 3: Examine performance after indexing
-- Run the same query again

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    test_id,
    guest_id,
    room_id,
    reservation_date,
    total_amount
FROM reservation_performance_test
WHERE guest_id = 500;
