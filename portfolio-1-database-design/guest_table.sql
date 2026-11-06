-- Table: public.guest

-- DROP TABLE IF EXISTS public.guest;

CREATE TABLE IF NOT EXISTS public.guest
(
    guest_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    first_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    last_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    email character varying(100) COLLATE pg_catalog."default",
    phone_number character varying(20) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT guest_pkey PRIMARY KEY (guest_id),
    CONSTRAINT guest_email_key UNIQUE (email)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.guest
    OWNER to postgres;