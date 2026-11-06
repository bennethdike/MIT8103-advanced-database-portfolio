-- Table: public.roomtype

-- DROP TABLE IF EXISTS public.roomtype;

CREATE TABLE IF NOT EXISTS public.roomtype
(
    room_type_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    type_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    nightly_rate numeric(12,2) NOT NULL,
    description text COLLATE pg_catalog."default",
    CONSTRAINT roomtype_pkey PRIMARY KEY (room_type_id),
    CONSTRAINT roomtype_type_name_key UNIQUE (type_name),
    CONSTRAINT roomtype_nightly_rate_check CHECK (nightly_rate > 0::numeric)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.roomtype
    OWNER to postgres;