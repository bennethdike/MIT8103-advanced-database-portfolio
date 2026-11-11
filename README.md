# MIT 8103 – Advanced Database Systems Portfolio

**Case Study:** Munchiba Hotel & Suites Reservation System  
**Academic Session:** 2026/2027  
**Database Technologies:** PostgreSQL and MongoDB

## About This Repository

This repository contains the SQL scripts, MongoDB commands, experimental results, screenshots and documentation I produced for my MIT 8103 Advanced Database Systems portfolio assessment.

I used a fictional hotel, Munchiba Hotel & Suites, as a consistent case study across five practical activities.

## Repository Structure

| Portfolio | Folder | Main Activities |
|---|---|---|
| 1 – Database Design and Modelling | [portfolio-1-database-design](portfolio-1-database-design/) | Relational schema, ERD, tables, keys and constraints |
| 2 – Query Processing and Optimisation | [portfolio-2-query-optimisation](portfolio-2-query-optimisation/) | SQL queries, execution plans and indexing |
| 3 – Transactions and Concurrency | [portfolio-3-transactions-concurrency](portfolio-3-transactions-concurrency/) | COMMIT, ROLLBACK, isolation and locking |
| 4 – NoSQL and Advanced Data Models | [portfolio-4-nosql-advanced-data-models](portfolio-4-nosql-advanced-data-models/) | MongoDB documents, queries and updates |
| 5 – Distributed and Cloud Database | [portfolio-5-distributed-cloud-database](portfolio-5-distributed-cloud-database/) | Replication, failover and node recovery |

Each folder contains its own README with more detailed explanations of the practical activity.

## Software and Tools

| Tool | Purpose |
|---|---|
| PostgreSQL | Relational database implementation |
| pgAdmin 4 | SQL execution and database administration |
| MongoDB Community Server 9.0 | Document database and replica set experiments |
| MongoDB Compass | MongoDB connections, queries and data inspection |
| MongoDB Shell | Replica set administration and testing |
| GitHub | Version control and evidence documentation |

## How to Review My Portfolio

### Portfolio 1 – Database Design

Open the Portfolio 1 folder to review the database design, SQL scripts, relationships and implementation screenshots.

The relational database contains six main tables: Guest, RoomType, Staff, Room, Reservation and Payment.

### Portfolio 2 – Query Optimisation

Open the Portfolio 2 folder to examine the SQL queries, indexing experiments and execution plan comparisons.

The documented results include a performance experiment using approximately 10,000 test records.

### Portfolio 3 – Transactions and Concurrency

Open the Portfolio 3 folder to review transaction experiments involving COMMIT, ROLLBACK, constraint enforcement, concurrent sessions and locking.

The supporting files contain the commands, observed results and screenshots.

### Portfolio 4 – MongoDB NoSQL Implementation

Open the Portfolio 4 folder to inspect the exported JSON reservation documents, MongoDB query experiments and screenshots.

The MongoDB implementation uses a document-oriented representation of hotel reservation information.

### Portfolio 5 – Distributed Database Experiment

Open the Portfolio 5 folder to review the local MongoDB replica set experiment.

The main supporting files are:

- `mongodb_replica_set_commands.js` – commands used to configure and test the replica set.
- `mongodb_experiment_results.md` – recorded experiment results and observations.
- `screenshots/` – visual evidence of the practical tests.
- `README.md` – detailed explanation of the implementation.

The experiment used three local MongoDB nodes:

| Node | Address | Final State |
|---|---|---|
| Node 1 | 127.0.0.1:27018 | SECONDARY |
| Node 2 | 127.0.0.1:27019 | PRIMARY |
| Node 3 | 127.0.0.1:27020 | SECONDARY |

I tested primary failure, automatic election of a replacement primary, successful insertion after failover, replication to another secondary and recovery of the failed node.

**Note:** This was a local replica set simulation on one Windows computer, not a cloud deployment. Sharding was discussed but not implemented.

## Running the Experiments

The PostgreSQL experiments require a PostgreSQL server and a SQL client such as pgAdmin 4.

The MongoDB experiments require MongoDB Community Server and MongoDB Shell or Compass.

To review or reproduce an activity:

1. Open the relevant portfolio folder.
2. Read its README for context.
3. Review the SQL scripts or MongoDB commands.
4. Follow the documented sequence where appropriate.
5. Compare the results with the screenshots and experiment records.

Some scripts represent different stages of an experiment and should not be executed together without reviewing the instructions. In particular, MongoDB replica set initialisation should only be performed when configuring a new replica set.

## Evidence and Documentation

I organised the repository to make the practical work traceable. The supporting materials include database commands, saved query results, screenshots, exported data and explanatory README files.

All guest and reservation records used in the assessment are fictional.

## AI Assistance

I used ChatGPT for explanations, technical guidance, troubleshooting and documentation support. I performed the practical experiments and reviewed the results.

## Project Summary

This repository provides supporting evidence for my MIT 8103 Advanced Database Systems portfolio assessment. The accompanying final portfolio report discusses the activities, findings, challenges and personal learning outcomes in greater detail.
