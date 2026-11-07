# MIT 8103 — Portfolio 1: Database Design and Modelling

## Munchiba Hotel & Suites Reservation System

**Document:** Database Design and Normalisation  
**Platform:** PostgreSQL  
**Scope:** Six relational schemas, keys, integrity constraints, functional dependencies and 1NF–3NF analysis.

## 1. Case study and design objectives

Munchiba Hotel & Suites requires a reservation database that connects guests, rooms, room categories, staff and payments. A guest can reserve a room for a defined stay, with the agreed nightly price recorded when the booking is made. A staff member may process the reservation, and a payment record can be associated with it.

The design separates reusable information from transaction records. Guest contact information is maintained independently of bookings; room categories hold standard rates and descriptions; individual rooms have operational statuses; staff details are maintained separately; and reservations and payments record the transactions. This reduces unnecessary repetition and supports referential integrity.

The implemented reservation model assigns one room to each reservation. It also permits at most one payment record per reservation. Multiple rooms in one booking, instalments and multiple payment attempts are therefore outside the current model unless represented through additional structures or separate reservations.

### Evidence and scope of verification

This document consolidates the PostgreSQL schema and constraint results discussed in the referenced assessment conversation. The five UNIQUE column mappings were additionally confirmed by the author while preparing this document. The evidence establishes six tables, six primary keys, five foreign keys, five UNIQUE constraints and nine CHECK constraints.

The document does not claim a fresh inspection of a live database. Exact data types, lengths, defaults, complete NOT NULL declarations, constraint names for keys, and foreign-key update/delete actions are not reproduced where they were unavailable in the accessible evidence. Functional dependencies beyond declared keys are business-rule analysis, rather than facts proved by observing sample records.

## 2. Relational schema

**Notation:** PK = primary key; FK = foreign key; UQ = UNIQUE constraint. Attribute names match the verified schemas.

```text
GUEST (
    guest_id PK,
    first_name,
    last_name,
    email UQ,
    phone_number
)

ROOMTYPE (
    room_type_id PK,
    type_name UQ,
    nightly_rate,
    description
)

ROOM (
    room_id PK,
    room_number UQ,
    room_type_id FK -> ROOMTYPE.room_type_id,
    room_status
)

STAFF (
    staff_id PK,
    first_name,
    last_name,
    job_role,
    email UQ
)

RESERVATION (
    reservation_id PK,
    guest_id FK -> GUEST.guest_id,
    room_id FK -> ROOM.room_id,
    processed_by_staff_id FK -> STAFF.staff_id,
    check_in_date,
    check_out_date,
    booked_nightly_rate,
    total_amount,
    reservation_status,
    created_at
)

PAYMENT (
    payment_id PK,
    reservation_id FK -> RESERVATION.reservation_id UQ,
    amount,
    payment_date,
    payment_method,
    payment_status
)
```

### Primary keys

| Table | Primary key |
|---|---|
| `guest` | `guest_id` |
| `roomtype` | `room_type_id` |
| `room` | `room_id` |
| `staff` | `staff_id` |
| `reservation` | `reservation_id` |
| `payment` | `payment_id` |

Each primary key uniquely identifies a row and cannot be NULL. All six declared primary keys consist of one attribute.

### Five foreign keys and relationship cardinalities

| Child attribute | Referenced parent attribute | Relationship |
|---|---|---|
| `reservation.guest_id` | `guest.guest_id` | One guest can have many reservations. |
| `reservation.room_id` | `room.room_id` | One room can have many reservations over time. |
| `reservation.processed_by_staff_id` | `staff.staff_id` | One staff member can process many reservations. |
| `room.room_type_id` | `roomtype.room_type_id` | One room type can describe many rooms. |
| `payment.reservation_id` | `reservation.reservation_id` | A reservation can have at most one linked payment. |

A non-NULL foreign-key value must reference an existing parent row. `processed_by_staff_id` is nullable, so a reservation may have no assigned staff member. Other mandatory participation requirements depend on the corresponding NOT NULL declarations; a foreign key alone does not require a value. A parent row need not have any child rows.

The UNIQUE constraint on `payment.reservation_id` makes the payment relationship optional one-to-one from the reservation side: a reservation can exist without a payment and cannot have two payment rows linked by the same non-NULL reservation ID. This does not, by itself, require every payment to have a non-NULL reservation ID.

### Five UNIQUE constraints

| Table | Unique attribute | Purpose |
|---|---|---|
| `guest` | `email` | Prevent duplicate non-NULL guest email values. |
| `roomtype` | `type_name` | Prevent duplicate non-NULL room category names. |
| `room` | `room_number` | Prevent duplicate non-NULL room numbers. |
| `staff` | `email` | Prevent duplicate non-NULL staff email values. |
| `payment` | `reservation_id` | Permit at most one payment record for each linked reservation. |

These are five UNIQUE constraints in addition to primary-key uniqueness. A UNIQUE column is a potential alternate candidate key only if the applicable nullability and business semantics also support that interpretation. Ordinary PostgreSQL UNIQUE constraints can allow multiple NULL values unless configured otherwise; no unverified NULL treatment is assumed here. Guest and staff email uniqueness is enforced separately within their respective tables.

## 3. Nine CHECK constraints

The following expressions present the verified predicates in readable SQL, omitting PostgreSQL's display casts and extra parentheses without changing their intended meaning.

| Table | Constraint name | Predicate |
|---|---|---|
| `payment` | `chk_payment_amount` | `amount > 0` |
| `payment` | `chk_payment_method` | `payment_method IN ('Cash', 'Card', 'Bank Transfer')` |
| `payment` | `chk_payment_status` | `payment_status IN ('Successful', 'Failed', 'Refunded')` |
| `reservation` | `chk_booked_rate` | `booked_nightly_rate > 0` |
| `reservation` | `chk_reservation_dates` | `check_out_date > check_in_date` |
| `reservation` | `chk_reservation_status` | `reservation_status IN ('Pending', 'Confirmed', 'Cancelled', 'Completed', 'Expired')` |
| `reservation` | `chk_total_amount` | `total_amount > 0` |
| `room` | `chk_room_status` | `room_status IN ('Active', 'Maintenance', 'Inactive')` |
| `roomtype` | `roomtype_nightly_rate_check` | `nightly_rate > 0` |

The distribution is three payment checks, four reservation checks, one room check and one room-type check, for a total of nine.

CHECK constraints reject expressions that evaluate to FALSE. They do not independently reject NULL values, because an UNKNOWN result is permitted; mandatory values require NOT NULL or another appropriate rule.

`room_status` describes operational availability, rather than occupancy. A room marked `Active` is not necessarily vacant for a requested date range. Occupancy and booking availability must also consider reservation dates and relevant statuses.

### Limits of the listed constraints

- Positive `total_amount` does not establish that it equals the calculated stay charge.
- Positive payment `amount` does not establish that it matches the reservation total.
- Valid reservation dates do not independently prevent overlapping bookings for the same room.
- Permitted status values do not define or enforce valid transitions between statuses.

The prior conversation reported separate implementation and testing of double-booking prevention and payment-validation mechanisms. Their definitions and complete test evidence are not reproduced here, so they are not counted among these nine CHECK constraints or independently certified by this document.

## 4. Functional dependencies

A functional dependency `X -> Y` means that, across all valid states of a relation, agreement on X requires agreement on Y. It is a rule about permitted data, not merely a pattern in one sample.

### Dependencies established by primary keys

```text
guest_id -> first_name, last_name, email, phone_number

room_type_id -> type_name, nightly_rate, description

room_id -> room_number, room_type_id, room_status

staff_id -> first_name, last_name, job_role, email

reservation_id -> guest_id, room_id, processed_by_staff_id,
                  check_in_date, check_out_date, booked_nightly_rate,
                  total_amount, reservation_status, created_at

payment_id -> reservation_id, amount, payment_date,
              payment_method, payment_status
```

If the UNIQUE attributes are mandatory, they also provide alternate-key dependencies: `guest.email`, `roomtype.type_name`, `room.room_number` and `staff.email` determine their respective complete rows. A non-NULL `payment.reservation_id` likewise identifies at most one payment row; treating it as a relational candidate key requires the appropriate NOT NULL guarantee.

Foreign keys express referential inclusion, rather than automatically establishing additional within-table functional dependencies. For example, a guest can have multiple reservations, so `guest_id` does not determine a single `reservation_id`. A room can have multiple reservations over time, so `room_id` does not determine reservation dates or the booked rate.

### Dependency implied by the charging rule

The selected case-study rule is:

```text
total_amount = (check_out_date - check_in_date) * booked_nightly_rate
```

Under that exact rule, excluding additional charges, discounts and adjustments:

```text
(check_in_date, check_out_date, booked_nightly_rate) -> total_amount
```

This is a semantic dependency implied by the agreed calculation. The nine listed CHECK constraints do not enforce it. Its implications for 3NF are addressed below.

## 5. First Normal Form (1NF)

A relation is in 1NF when each attribute holds a single value from its domain and repeating groups are absent. The six schemas represent individual guests, room types, rooms, staff members, reservations and payments as separate rows. They do not introduce columns such as `room_1`, `room_2` or `payment_1`, `payment_2`.

Names are represented as first and last name attributes. Each email and phone-number field should hold one contact value, rather than a list of contacts. A descriptive text field remains a single domain value; free text does not inherently violate 1NF.

The structures are consistent with 1NF, assuming actual values follow these intended domains. The schema listing alone is not a complete audit of stored values.

## 6. Second Normal Form (2NF)

A relation is in 2NF if it is in 1NF and no non-prime attribute depends on a proper subset of any candidate key. A prime attribute belongs to at least one candidate key.

All six declared primary keys are single attributes. Consequently, there can be no partial dependency on part of those primary keys. The identified alternate-key attributes, when they qualify as candidate keys, are also single attributes.

The six relations are therefore consistent with 2NF under the identified key set. A full proof would also require ruling out additional composite candidate keys and partial dependencies arising from further business rules. Single-column surrogate primary keys alone do not prove 2NF for every possible dependency set.

## 7. Third Normal Form (3NF)

Formally, for every non-trivial functional dependency `X -> A`, 3NF requires that X be a superkey or A be a prime attribute. The familiar description of removing transitive dependencies of non-key attributes is useful, but the formal condition is the basis of the assessment.

### Separation of entity information

| Relation | Assessment under the identified dependencies |
|---|---|
| `guest` | Contact and name attributes describe the guest identified by the key; no further non-key determinant has been established. |
| `roomtype` | Category name, current standard rate and description belong to the room type. |
| `room` | The room stores a category reference, avoiding repetition of category description and standard rate. |
| `staff` | Staff identity and role are held independently of reservations; no dependency from role to a specific person is assumed. |
| `payment` | Payment attributes describe one payment record; no additional non-key dependency has been established beyond a qualifying unique reservation reference. |
| `reservation` | References separate guest, room and staff information, but the stored derived total requires the qualification below. |

These separations reduce update anomalies. For example, changing a room-category description requires changing its `roomtype` row rather than every room or reservation. Updating a guest's contact information does not require updating every reservation.

### Stored total and the formal qualification

Storing a value that can be calculated does not automatically establish a 3NF violation: the relevant functional dependencies and candidate keys must first be specified. However, under the exact charging rule adopted here, the three attributes `(check_in_date, check_out_date, booked_nightly_rate)` determine `total_amount`.

That determinant is not a superkey: different reservations can share the same dates and rate. `total_amount` is not identified as a prime attribute. Therefore, **if the exact charging rule is treated as a required semantic dependency, the current reservation relation does not satisfy strict 3NF with respect to that dependency**. The fact that `reservation_id` also determines the total does not remove this additional dependency.

The balanced conclusion is that the database uses 3NF principles in its entity separation, while retaining a derived amount as controlled redundancy. An unconditional claim that all six tables are formally in 3NF is not justified under the stated formula. If the total instead represented an independently agreed charge including adjustments, the dependency analysis would change, but that is not the selected rule for this case study.

## 8. Derived total: evidence and consistency caveat

The conversation supplied the following query result:

| Reservation ID | Check-in | Check-out | Booked nightly rate | Stored total | Calculated total |
|---|---|---|---:|---:|---:|
| 1 | 2026-12-10 | 2026-12-13 | ₦25,000.00 | ₦75,000.00 | ₦75,000.00 |

The stay lasts three nights, and `3 × ₦25,000.00 = ₦75,000.00`. This verifies consistency for the supplied record only. It does not prove that all future inserts or updates will preserve the rule.

For example, extending the check-out date without recalculating the stored total could leave a positive but incorrect amount. Both the date check and the positive-total check could still pass.

Possible improvements, subject to reviewing the existing payment mechanisms, include:

1. Derive the charge in a query or view and avoid storing an independently editable total.
2. Use an appropriate generated column if the actual column types and PostgreSQL expression requirements permit it.
3. Retain the stored total and enforce the formula with a database CHECK or suitable trigger, alongside mandatory-value rules.

Enforcing the formula protects consistency; retaining the derived attribute still leaves the semantic dependency discussed in the formal 3NF assessment. These are recommendations, not changes made to the database for this document.

A reusable read-only comparison is:

```sql
SELECT
    reservation_id,
    check_in_date,
    check_out_date,
    booked_nightly_rate,
    total_amount,
    (check_out_date - check_in_date) * booked_nightly_rate
        AS calculated_total
FROM reservation;
```

## 9. Booking rate history

`roomtype.nightly_rate` represents the current standard category rate. `reservation.booked_nightly_rate` records the agreed rate for a particular booking. They describe different facts at different times.

For example, a reservation agreed at ₦25,000 per night should retain that rate even if the category's standard rate later rises to ₦30,000. Recalculating a historical reservation using the current category rate would incorrectly change its agreed price.

Consequently, the current room-type rate does not determine every historical booked rate, and `room_id` alone does not determine `booked_nightly_rate`. Keeping the booking rate is a purposeful historical snapshot, rather than simply duplicating the current category rate. The schema provides a place to preserve this value; immutability after booking would require an additional policy or enforcement mechanism that is not established by the listed constraints.

The snapshot supports historical booking charges but does not provide a complete history of all category price changes. A separate effective-dated rate-history relation would be needed if that broader requirement arose.

## 10. Conclusion

The Munchiba Hotel & Suites Reservation System comprises six related tables with six primary keys, five foreign keys, five UNIQUE constraints and nine CHECK constraints. Its separation of guests, room types, rooms, staff, reservations and payments reduces repeated entity data and supports consistent references and valid attribute values.

The schemas are consistent with 1NF and, under the identified candidate keys, 2NF. They apply 3NF design principles through entity separation, but the stored reservation total introduces a formal qualification: under the exact dates-times-booked-rate rule, it depends on a non-superkey determinant and prevents an unconditional strict-3NF claim for `reservation`.

The supplied reservation total is correct, and the booked nightly rate preserves historical pricing. Future reliability requires maintaining the total calculation and recognising the limits of the listed constraints, especially for overlapping bookings, payment validation and status transitions. This document records the verified design and its limitations without claiming that proposed improvements have already been implemented.
