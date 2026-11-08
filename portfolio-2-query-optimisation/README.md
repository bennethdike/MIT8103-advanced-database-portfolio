# Portfolio 2: Query Processing and Optimisation

**Course:** MIT 8103 – Advanced Database Systems  
**Case Study:** Munchiba Hotel & Suites Reservation System  
**Database:** PostgreSQL  
**Tool:** pgAdmin 4

## 1. Overview

This portfolio investigates SQL query processing and optimisation using the Munchiba Hotel & Suites Reservation System, a fictional hotel database developed in Portfolio 1.

The practical activities are based on Study Session Four, *Query Optimisation in Database*, from the MIT 8103 course material.

The portfolio demonstrates the use of SQL queries, PostgreSQL execution plans, table statistics and B-tree indexes.

## 2. Query Processing and Execution Plans

SQL queries were developed to retrieve information about hotel rooms and guest reservations.

PostgreSQL's EXPLAIN and EXPLAIN ANALYZE commands were used to examine query execution plans, estimated costs, actual row counts and execution times.

## 3. Updating Database Statistics

The first experiment involved retrieving active rooms and their nightly rates.

Initially, PostgreSQL estimated 3 output rows, while the query actually returned 30.

After executing ANALYZE on the Room and RoomType tables, the estimated row count became 30.

This demonstrated the importance of accurate statistics in query planning.

## 4. Indexing Experiments

Two indexing experiments were conducted.

**Experiment 1: Small Reservation Table**

A B-tree index was created on the `guest_id` column of the Reservation table.

PostgreSQL continued using a sequential scan because the table contained only one record.

**Experiment 2: Larger Performance-Testing Table**

A separate table containing 10,000 fictional reservation records was created to investigate indexing performance.

A query searching for Guest ID 500 was executed before and after creating a B-tree index.

| Measurement | Before Indexing | After Indexing |
|---|---|---|
| Execution method | Sequential Scan | Bitmap Index Scan and Bitmap Heap Scan |
| Matching records | 10 | 10 |
| Execution time | 2.627 ms | 0.368 ms |

The observed execution time decreased by approximately 86% in this experiment. However, repeated measurements would be necessary to establish a reliable performance improvement.

## 5. Portfolio Evidence

The following files document the practical activities:

- `query_optimisation_results.md` – Explanation and comparison of the experiments.
- `guest_reservation_optimisation.sql` – SQL commands for the indexing experiment.
- `performance_test_setup.sql` – SQL used to create and populate the performance-testing table.
- `execution_plan_before_index.txt` – Original query execution plan.
- `execution_plan_after_index.txt` – Execution plan after creating the index.

## 6. Conclusion

The experiments demonstrated that PostgreSQL uses execution plans and estimated costs to select query-processing strategies.

Updating table statistics improved estimation accuracy, while creating a B-tree index enabled PostgreSQL to use an index-based scan when searching a larger dataset.

The results also demonstrated that indexes are not always beneficial for very small tables.

All hotel and performance-testing records used in this portfolio are fictional.
