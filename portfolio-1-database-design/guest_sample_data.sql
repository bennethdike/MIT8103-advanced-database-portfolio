
-- Munchiba Hotel & Suites Reservation System
-- Portfolio 1: Database Design and Modelling
-- Sample Data: 10 Fictional Guests

INSERT INTO public.guest
SELECT * FROM json_populate_record(
    NULL::public.guest,
    '{"guest_id":1,"first_name":"Ada","last_name":"Okafor","email":"ada.okafor@example.com","phone_number":"08000000001"}'::json
);

INSERT INTO public.guest
SELECT * FROM json_populate_record(
    NULL::public.guest,
    '{"guest_id":2,"first_name":"Tunde","last_name":"Adebayo","email":"tunde.adebayo@example.com","phone_number":"08000000002"}'::json
);

INSERT INTO public.guest
SELECT * FROM json_populate_record(
    NULL::public.guest,
    '{"guest_id":3,"first_name":"Aisha","last_name":"Bello","email":"aisha.bello@example.com","phone_number":"08000000003"}'::json
);

INSERT INTO public.guest
SELECT * FROM json_populate_record(
    NULL::public.guest,
    '{"guest_id":4,"first_name":"Grace","last_name":"Johnson","email":"grace.johnson@example.com","phone_number":"08000000004"}'::json
);

INSERT INTO public.guest
SELECT * FROM json_populate_record(
    NULL::public.guest,
    '{"guest_id":5,"first_name":"Osas","last_name":"Omoregie","email":"osas.omoregie@example.com","phone_number":"08000000005"}'::json
);

INSERT INTO public.guest
SELECT * FROM json_populate_record(
    NULL::public.guest,
    '{"guest_id":6,"first_name":"Daniel","last_name":"Okon","email":"daniel.okon@example.com","phone_number":"08000000006"}'::json
);

INSERT INTO public.guest
SELECT * FROM json_populate_record(
    NULL::public.guest,
    '{"guest_id":7,"first_name":"Fatima","last_name":"Musa","email":"fatima.musa@example.com","phone_number":"08000000007"}'::json
);

INSERT INTO public.guest
SELECT * FROM json_populate_record(
    NULL::public.guest,
    '{"guest_id":8,"first_name":"Blessing","last_name":"Ekanem","email":"blessing.ekanem@example.com","phone_number":"08000000008"}'::json
);

INSERT INTO public.guest
SELECT * FROM json_populate_record(
    NULL::public.guest,
    '{"guest_id":9,"first_name":"David","last_name":"Adeyemi","email":"david.adeyemi@example.com","phone_number":"08000000009"}'::json
);

INSERT INTO public.guest
SELECT * FROM json_populate_record(
    NULL::public.guest,
    '{"guest_id":10,"first_name":"Mary","last_name":"Nwankwo","email":"mary.nwankwo@example.com","phone_number":"08000000010"}'::json
);
