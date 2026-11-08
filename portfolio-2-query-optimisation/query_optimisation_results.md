# Query Optimisation Results

## Case Study
Munchiba Hotel & Suites Reservation System

## Objective
To investigate how PostgreSQL processes SQL queries and how indexing affects query performance.

## Experiment 1: Updating Table Statistics

A query retrieving active rooms and their nightly rates was analysed using EXPLAIN ANALYZE.

Before updating statistics, PostgreSQL estimated 3 rows, whereas the query actually returned 30 rows.

After executing ANALYZE on the Room and RoomType tables, the estimated row count improved to 30.

The execution time changed from 0.282 ms to 0.182 ms. This demonstrates improved estimation accuracy, although the timing difference alone does not establish a reliable performance improvement.

## Experiment 2: Indexing a Small Table

A B-tree index named `idx_reservation_guest_id` was created on the Reservation table's guest_id column.

PostgreSQL continued using a sequential scan because the table contained only one reservation.

The execution time changed from 0.068 ms to 0.065 ms.

This demonstrates that indexes are not always beneficial for very small tables.

## Experiment 3: Indexing a Larger Testing Table

A separate table containing 10,000 fictional reservation records was created for performance testing.

A query was executed to retrieve records belonging to Guest ID 500.

### Results

| Measurement | Before Index | After Index |
|---|---|---|
| Execution method | Sequential Scan | Bitmap Heap Scan and Bitmap Index Scan |
| Index used | None | idx_performance_guest_id |
| Estimated rows | 10 | 10 |
| Actual rows | 10 | 10 |
| Execution time | 2.627 ms | 0.368 ms |
| Planning time | 0.196 ms | 4.706 ms |

The observed execution time decreased by approximately 86.0%.

## Conclusion

The experiments demonstrated that PostgreSQL uses execution plans and cost estimates to select query-processing methods. Accurate table statistics improved row-count estimates, while indexing helped PostgreSQL retrieve selected records from a larger dataset.

The results also showed that an index may not be selected when a table is very small. Performance measurements should be interpreted carefully because execution times can vary between runs.

All records used for performance testing were fictional.
