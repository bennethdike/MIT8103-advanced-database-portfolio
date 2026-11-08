
-- MIT 8103: Advanced Database Systems
-- Portfolio 2: Query Processing and Optimisation
-- Munchiba Hotel & Suites

-- EXPERIMENT 1: Active rooms and nightly rates

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    r.room_number,
    rt.type_name,
    rt.nightly_rate,
    r.room_status
FROM room AS r
JOIN roomtype AS rt
    ON r.room_type_id = rt.room_type_id
WHERE r.room_status = 'Active'
ORDER BY r.room_number;

-- Update table statistics
ANALYZE room;
ANALYZE roomtype;

-- Repeat the query to examine the updated plan
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    r.room_number,
    rt.type_name,
    rt.nightly_rate,
    r.room_status
FROM room AS r
JOIN roomtype AS rt
    ON r.room_type_id = rt.room_type_id
WHERE r.room_status = 'Active'
ORDER BY r.room_number;

-- EXPERIMENT 2: Guest reservation lookup

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    reservation_id,
    guest_id,
    room_id,
    check_in_date,
    check_out_date,
    reservation_status
FROM reservation
WHERE guest_id = 1;

-- Create a B-tree index
CREATE INDEX IF NOT EXISTS idx_reservation_guest_id
ON reservation (guest_id);

-- Repeat the reservation lookup
EXPLAIN (ANALYZE, BUFFERS)
SELECT
    reservation_id,
    guest_id,
    room_id,
    check_in_date,
    check_out_date,
    reservation_status
FROM reservation
WHERE guest_id = 1;
