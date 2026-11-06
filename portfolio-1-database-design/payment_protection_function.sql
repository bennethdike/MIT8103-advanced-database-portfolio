CREATE OR REPLACE FUNCTION public.protect_confirmed_payment()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM reservation r
        WHERE r.reservation_id = OLD.reservation_id
          AND r.reservation_status = 'Confirmed'
    ) THEN
        RAISE EXCEPTION
            'Cannot change or delete payment for a confirmed reservation';
    END IF;

    RETURN OLD;
END;
$function$
