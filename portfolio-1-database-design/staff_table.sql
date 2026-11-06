-- Table: public.staff

-- DROP TABLE IF EXISTS public.staff;

CREATE TABLE IF NOT EXISTS public.staff
(
    staff_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    first_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    last_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    job_role character varying(50) COLLATE pg_catalog."default" NOT NULL,
    email character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT staff_pkey PRIMARY KEY (staff_id),
    CONSTRAINT staff_email_key UNIQUE (email)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.staff
    OWNER to postgres;