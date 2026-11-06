CREATE OR REPLACE FUNCTION public.check_full_payment_before_confirmation()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    IF NEW.reservation_status = 'Confirmed' THEN

        IF NOT EXISTS (
            SELECT 1
            FROM payment p
            WHERE p.reservation_id = NEW.reservation_id
              AND p.payment_status = 'Successful'
              AND p.amount = NEW.total_amount
        ) THEN
            RAISE EXCEPTION
                'Reservation cannot be confirmed without successful full payment';
        END IF;

    END IF;

    RETURN NEW;
END;
$function$
