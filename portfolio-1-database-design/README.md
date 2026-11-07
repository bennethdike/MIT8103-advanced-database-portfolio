# Portfolio 1: Database Design and Modelling

**Course:** MIT 8103 — Advanced Database Systems

**Case Study:** Munchiba Hotel & Suites Reservation System

## Overview

This portfolio covers the design and modelling of a relational database for Munchiba Hotel & Suites, a fictional 30-room hotel located in Imo State, Nigeria.

The database was developed using PostgreSQL and pgAdmin 4 to manage hotel guests, room categories, staff, reservations and payments.

## Database Tables

The database, named `munchiba_hotel`, contains six main tables:

1. **Guest** — Stores guest personal and contact information.
2. **RoomType** — Stores room categories, descriptions and nightly rates.
3. **Staff** — Stores hotel employee information.
4. **Room** — Stores individual hotel rooms and their operational status.
5. **Reservation** — Stores guest bookings, reservation dates, charges and status.
6. **Payment** — Stores payment details for hotel reservations.

## Database Relationships

The database contains five foreign key relationships connecting the six tables.

These relationships support the management of reservations while maintaining referential integrity.

The Entity Relationship Diagram (ERD) provides a visual representation of the database structure.

## Database Constraints

The database implements:

- Primary keys for uniquely identifying records.
- Foreign keys for maintaining relationships between tables.
- UNIQUE constraints for preventing duplicate values in selected columns.
- CHECK constraints for validating values such as room rates, reservation dates, payment amounts and statuses.
- An exclusion constraint to prevent overlapping confirmed reservations for the same room.
- Triggers and functions to enforce payment validation and protect payment records associated with confirmed reservations.

## Database Normalisation

The database was designed using First Normal Form (1NF), Second Normal Form (2NF) and Third Normal Form (3NF) principles.

The normalisation analysis discusses the organisation of data into related tables, reduction of unnecessary duplication and maintenance of data consistency.

Detailed explanations are provided in `database_design_and_normalisation.md`.

## Sample Data

The database contains 50 fictional sample records.

| Table | Number of Records |
|---|---:|
| Guest | 10 |
| RoomType | 3 |
| Staff | 5 |
| Room | 30 |
| Reservation | 1 |
| Payment | 1 |
| **Total** | **50** |

The sample-data SQL scripts are included in this folder.

## Portfolio Evidence

This folder contains:

- Entity Relationship Diagram (ERD).
- SQL scripts for creating the six database tables.
- SQL scripts for implementing database constraints, functions and triggers.
- Database design, relational schema and normalisation documentation.
- Sample-data SQL scripts.
- Screenshots showing selected database integrity tests.

## Tools Used

- PostgreSQL
- pgAdmin 4
- SQL
- GitHub

## Conclusion

Portfolio 1 demonstrates the design and implementation of a relational database for Munchiba Hotel & Suites.

The database provides a foundation for managing hotel reservations, rooms, guests, staff and payments while applying relational database design principles and integrity constraints.

The completed database will support subsequent portfolio activities in the MIT 8103 Advanced Database Systems course.

**Note:** All guest, staff and hotel records used in this project are fictional and created for academic purposes.
