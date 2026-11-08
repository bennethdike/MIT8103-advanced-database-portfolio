
-- MIT 8103: Advanced Database Systems
-- Portfolio 2: Query Processing and Optimisation
-- Case Study: Munchiba Hotel & Suites
--
-- Purpose: Create a separate table containing
-- 10,000 fictional reservation records for testing.
--
-- IMPORTANT:
-- Run this setup only on a fresh database without
-- the performance test table.
-- Do not rerun it on the existing populated table.

-- Step 1: Create the performance-testing table

CREATE TABLE IF NOT EXISTS reservation_performance_test (
    test_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    guest_id INTEGER NOT NULL,
    room_id INTEGER NOT NULL,
    reservation_date DATE NOT NULL,
    total_amount NUMERIC(10,2) NOT NULL
);

-- Step 2: Generate 10,000 fictional records

INSERT INTO reservation_performance_test
    (guest_id, room_id, reservation_date, total_amount)
SELECT
    (gs % 1000) + 1,
    (gs % 30) + 1,
    DATE '2026-01-01' + (gs % 365),
    ((gs % 10) + 1) * 25000.00
FROM generate_series(1, 10000) AS gs;

-- Step 3: Verify the number of records

SELECT COUNT(*) AS total_test_records
FROM reservation_performance_test;

-- Expected result: 10000

-- Step 4: Collect statistics for query planning

ANALYZE reservation_performance_test;
