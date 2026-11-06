-- Table: public.payment

-- DROP TABLE IF EXISTS public.payment;

CREATE TABLE IF NOT EXISTS public.payment
(
    payment_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    reservation_id integer NOT NULL,
    amount numeric(12,2) NOT NULL,
    payment_date timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_method character varying(30) COLLATE pg_catalog."default" NOT NULL,
    payment_status character varying(20) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT payment_pkey PRIMARY KEY (payment_id),
    CONSTRAINT payment_reservation_id_key UNIQUE (reservation_id),
    CONSTRAINT fk_payment_reservation FOREIGN KEY (reservation_id)
        REFERENCES public.reservation (reservation_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT chk_payment_amount CHECK (amount > 0::numeric),
    CONSTRAINT chk_payment_method CHECK (payment_method::text = ANY (ARRAY['Cash'::character varying, 'Card'::character varying, 'Bank Transfer'::character varying]::text[])),
    CONSTRAINT chk_payment_status CHECK (payment_status::text = ANY (ARRAY['Successful'::character varying, 'Failed'::character varying, 'Refunded'::character varying]::text[]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.payment
    OWNER to postgres;

-- Trigger: trg_protect_confirmed_payment

-- DROP TRIGGER IF EXISTS trg_protect_confirmed_payment ON public.payment;

CREATE OR REPLACE TRIGGER trg_protect_confirmed_payment
    BEFORE DELETE OR UPDATE 
    ON public.payment
    FOR EACH ROW
    EXECUTE FUNCTION public.protect_confirmed_payment();