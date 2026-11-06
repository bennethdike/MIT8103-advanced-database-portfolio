-- Table: public.room

-- DROP TABLE IF EXISTS public.room;

CREATE TABLE IF NOT EXISTS public.room
(
    room_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    room_number character varying(10) COLLATE pg_catalog."default" NOT NULL,
    room_type_id integer NOT NULL,
    room_status character varying(20) COLLATE pg_catalog."default" NOT NULL DEFAULT 'Active'::character varying,
    CONSTRAINT room_pkey PRIMARY KEY (room_id),
    CONSTRAINT room_room_number_key UNIQUE (room_number),
    CONSTRAINT fk_room_type FOREIGN KEY (room_type_id)
        REFERENCES public.roomtype (room_type_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT chk_room_status CHECK (room_status::text = ANY (ARRAY['Active'::character varying, 'Maintenance'::character varying, 'Inactive'::character varying]::text[]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.room
    OWNER to postgres;