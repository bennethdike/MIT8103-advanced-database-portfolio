
CREATE TRIGGER trg_check_full_payment
BEFORE INSERT OR UPDATE
ON public.reservation
FOR EACH ROW
EXECUTE FUNCTION check_full_payment_before_confirmation();
