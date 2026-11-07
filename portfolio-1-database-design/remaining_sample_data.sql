-- Munchiba Hotel & Suites - PostgreSQL Portfolio 1
-- Remaining sample data: 3 room types, 5 staff, 30 rooms,
-- 1 reservation and 1 payment. All original IDs and timestamps are preserved.
--
-- PREREQUISITES:
-- 1. Create the Portfolio 1 schema, constraints and triggers first.
-- 2. Load guest sample data first; guest_id = 1 must already exist.
-- 3. Run ONLY against fresh, empty roomtype, staff, room, reservation and
--    payment tables. Do not run against the existing populated database.
--    This script does not delete records or skip duplicate records.
-- 4. Use the search_path for the intended Portfolio 1 schema.
--
-- Confirmation is deliberately performed AFTER successful payment because
-- the existing reservation trigger requires full successful payment.

BEGIN;

-- Prevent concurrent inserts while validating and loading the empty tables.
LOCK TABLE roomtype, staff, room, reservation, payment
    IN SHARE ROW EXCLUSIVE MODE;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM roomtype)
       OR EXISTS (SELECT 1 FROM staff)
       OR EXISTS (SELECT 1 FROM room)
       OR EXISTS (SELECT 1 FROM reservation)
       OR EXISTS (SELECT 1 FROM payment) THEN
        RAISE EXCEPTION 'Sample data requires empty roomtype, staff, room, reservation and payment tables.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM guest WHERE guest_id = 1) THEN
        RAISE EXCEPTION 'Load guest sample data first: guest_id = 1 is required.';
    END IF;
END;
$$;

-- Room categories and nightly rates.
INSERT INTO roomtype (room_type_id, type_name, nightly_rate, description)
VALUES
    (1, 'Standard', 25000.00, 'Basic accommodation with essential facilities'),
    (2, 'Deluxe', 40000.00, 'Larger accommodation with additional comfort'),
    (3, 'Executive Suite', 65000.00, 'Premium accommodation with additional space and amenities');

-- Staff IDs are preserved so reservation 1 references Chika Okoro.
INSERT INTO staff (staff_id, first_name, last_name, job_role, email)
VALUES
    (1, 'Chika', 'Okoro', 'Receptionist', 'chika.okoro@example.com'),
    (2, 'Emeka', 'Nwosu', 'Manager', 'emeka.nwosu@example.com'),
    (3, 'Adaeze', 'Iheanacho', 'Receptionist', 'adaeze.iheanacho@example.com'),
    (4, 'Obinna', 'Eze', 'Accountant', 'obinna.eze@example.com'),
    (5, 'Ngozi', 'Uche', 'Housekeeper', 'ngozi.uche@example.com');

-- Exact room-ID mapping: room_id 15 is room 101.
INSERT INTO room (room_id, room_number, room_type_id, room_status)
VALUES
    (1, '115', 1, 'Active'),
    (2, '114', 1, 'Active'),
    (3, '113', 1, 'Active'),
    (4, '112', 1, 'Active'),
    (5, '111', 1, 'Active'),
    (6, '110', 1, 'Active'),
    (7, '109', 1, 'Active'),
    (8, '108', 1, 'Active'),
    (9, '107', 1, 'Active'),
    (10, '106', 1, 'Active'),
    (11, '105', 1, 'Active'),
    (12, '104', 1, 'Active'),
    (13, '103', 1, 'Active'),
    (14, '102', 1, 'Active'),
    (15, '101', 1, 'Active'),
    (16, '210', 2, 'Active'),
    (17, '209', 2, 'Active'),
    (18, '208', 2, 'Active'),
    (19, '207', 2, 'Active'),
    (20, '206', 2, 'Active'),
    (21, '205', 2, 'Active'),
    (22, '204', 2, 'Active'),
    (23, '203', 2, 'Active'),
    (24, '202', 2, 'Active'),
    (25, '201', 2, 'Active'),
    (26, '305', 3, 'Active'),
    (27, '304', 3, 'Active'),
    (28, '303', 3, 'Active'),
    (29, '302', 3, 'Active'),
    (30, '301', 3, 'Active');

-- Temporarily Pending: confirmation requires the payment below.
INSERT INTO reservation (
    reservation_id, guest_id, room_id, processed_by_staff_id,
    check_in_date, check_out_date, booked_nightly_rate, total_amount,
    reservation_status, created_at
)
VALUES (
    1, 1, 15, 1,
    DATE '2026-12-10', DATE '2026-12-13', 25000.00, 75000.00,
    'Pending', TIMESTAMP '2026-11-03 13:43:15.50144'
);

-- Full successful payment for the three-night reservation.
INSERT INTO payment (
    payment_id, reservation_id, amount, payment_date,
    payment_method, payment_status
)
VALUES (
    1, 1, 75000.00, TIMESTAMP '2026-11-03 14:00:48.189621',
    'Bank Transfer', 'Successful'
);

-- The payment-validation trigger can now permit confirmation.
UPDATE reservation
SET reservation_status = 'Confirmed'
WHERE reservation_id = 1;

-- Explicit IDs do not advance SERIAL sequences. Synchronize each owned
-- sequence to its table's maximum ID; true makes nextval return max + 1.
-- pg_get_serial_sequence resolves the sequence without assuming its name.
-- Guest's sequence is managed by the separate guest sample-data script.
-- PostgreSQL sequence changes are not rolled back if a later error occurs.
SELECT setval(pg_get_serial_sequence('roomtype', 'room_type_id'),
              (SELECT MAX(room_type_id) FROM roomtype), true);
SELECT setval(pg_get_serial_sequence('staff', 'staff_id'),
              (SELECT MAX(staff_id) FROM staff), true);
SELECT setval(pg_get_serial_sequence('room', 'room_id'),
              (SELECT MAX(room_id) FROM room), true);
SELECT setval(pg_get_serial_sequence('reservation', 'reservation_id'),
              (SELECT MAX(reservation_id) FROM reservation), true);
SELECT setval(pg_get_serial_sequence('payment', 'payment_id'),
              (SELECT MAX(payment_id) FROM payment), true);

COMMIT;
