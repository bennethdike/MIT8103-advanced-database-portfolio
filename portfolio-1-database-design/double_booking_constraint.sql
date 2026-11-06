
ALTER TABLE public.reservation
ADD CONSTRAINT no_overlapping_confirmed_reservations
EXCLUDE USING gist (
    room_id WITH =,
    daterange(check_in_date, check_out_date, '[)'::text) WITH &&
)
WHERE (((reservation_status)::text = 'Confirmed'::text));
