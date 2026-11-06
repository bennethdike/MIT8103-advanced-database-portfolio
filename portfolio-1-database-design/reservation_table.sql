-- Table: public.reservation

-- DROP TABLE IF EXISTS public.reservation;

CREATE TABLE IF NOT EXISTS public.reservation
(
    reservation_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    guest_id integer NOT NULL,
    room_id integer NOT NULL,
    processed_by_staff_id integer,
    check_in_date date NOT NULL,
    check_out_date date NOT NULL,
    booked_nightly_rate numeric(12,2) NOT NULL,
    total_amount numeric(12,2) NOT NULL,
    reservation_status character varying(20) COLLATE pg_catalog."default" NOT NULL DEFAULT 'Pending'::character varying,
    created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT reservation_pkey PRIMARY KEY (reservation_id),
    CONSTRAINT fk_reservation_guest FOREIGN KEY (guest_id)
        REFERENCES public.guest (guest_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_reservation_room FOREIGN KEY (room_id)
        REFERENCES public.room (room_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_reservation_staff FOREIGN KEY (processed_by_staff_id)
        REFERENCES public.staff (staff_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT chk_booked_rate CHECK (booked_nightly_rate > 0::numeric),
    CONSTRAINT chk_reservation_dates CHECK (check_out_date > check_in_date),
    CONSTRAINT chk_reservation_status CHECK (reservation_status::text = ANY (ARRAY['Pending'::character varying, 'Confirmed'::character varying, 'Cancelled'::character varying, 'Completed'::character varying, 'Expired'::character varying]::text[])),
    CONSTRAINT chk_total_amount CHECK (total_amount > 0::numeric),
    CONSTRAINT no_overlapping_confirmed_reservations EXCLUDE USING gist (
        room_id WITH =,
        daterange(check_in_date, check_out_date, '[)'::text) WITH &&)

        WHERE (reservation_status::text = 'Confirmed'::text)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.reservation
    OWNER to postgres;

-- Trigger: trg_check_full_payment

-- DROP TRIGGER IF EXISTS trg_check_full_payment ON public.reservation;

CREATE OR REPLACE TRIGGER trg_check_full_payment
    BEFORE INSERT OR UPDATE 
    ON public.reservation
    FOR EACH ROW
    EXECUTE FUNCTION public.check_full_payment_before_confirmation();