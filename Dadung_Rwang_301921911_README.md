# Dadung Rwang Pam – MIT 8103 Advanced Database Systems Portfolio

**Student Name:** Dadung Rwang Pam
**Student ID:** 301921911
**Course:** MIT 8103 – Advanced Database Systems
**Case Study:** E-commerce Platform Database
**Database Technologies:** PostgreSQL 16 and MongoDB 8.0.38

---

## Project Overview

This repository contains my practical work for the MIT 8103 Advanced Database Systems course.

The project uses an e-commerce platform as its case study to explore relational database design, query processing and optimisation, transaction management, NoSQL data modelling, and distributed and cloud database concepts.

The work demonstrates how database technologies can support important e-commerce operations, including customer management, product inventory, order processing, payment tracking and event recording.

PostgreSQL was used to design and manage the relational database, while MongoDB was used to implement a document-based model for e-commerce payment and order events.

The project also includes SQL scripts, MongoDB scripts, documentation, performance measurements, execution screenshots and a final portfolio summary.

## Portfolio Activities

### Portfolio 1: Database Design and Modelling

[Open Portfolio 1 – Database Design](portfolio-1-database-design/)

This portfolio covers the design and implementation of the e-commerce relational database using PostgreSQL 16.

The database consists of five main tables:

- Customer
- Product
- Order
- OrderItem
- Payment

Primary keys, foreign keys, unique constraints and CHECK constraints were implemented to maintain data integrity and establish relationships between the tables.

Supporting materials include the database schema, sample data, normalisation explanation, ER diagram and constraint tests.

### Portfolio 2: Query Processing and Optimisation

[Open Portfolio 2 – Query Optimisation](portfolio-2-query-optimisation/)

This portfolio demonstrates SQL queries using joins, aggregation and filtering to retrieve e-commerce information and analyse sales and payment records.

It also examines query performance using a synthetic dataset of 100,000 order-history records.

An index was created on the order date column, and execution plans and timings were compared before and after indexing. The results demonstrated a significant reduction in execution time for the tested query.

### Portfolio 3: Transactions and Concurrency

[Open Portfolio 3 – Transactions and Concurrency](portfolio-3-transactions-concurrency/)

This portfolio explores PostgreSQL transaction management and concurrency control.

The practical exercises demonstrate:

- COMMIT to permanently save database changes.
- ROLLBACK to reverse uncommitted operations.
- CHECK constraint enforcement during payment processing.
- Concurrent database sessions and locking behaviour.
- Stock updates and transaction verification.

The exercises demonstrate how transaction controls and concurrency mechanisms help maintain database consistency during simultaneous operations.

### Portfolio 4: NoSQL and Advanced Data Models

[Open Portfolio 4 – NoSQL](portfolio-4-nosql/)

This portfolio introduces MongoDB 8.0.38 as a document-oriented database for recording e-commerce events.

The `ecommerce_nosql` database contains a `payment_events` collection. Each document represents an activity such as a payment being processed or an order being confirmed.

The implementation uses embedded documents to group customer, order and payment information. Four sample event documents were inserted and queried using MongoDB Shell (`mongosh`).

The portfolio also discusses MongoDB's suitability for flexible event-based data storage and its limitations when used separately from the PostgreSQL database.

### Portfolio 5: Distributed and Cloud Database Exercise

[Open Portfolio 5 – Distributed and Cloud](portfolio-5-distributed-cloud/)

This portfolio takes the discussion approach to distributed and cloud database concepts.

It examines a proposed MongoDB replica-set design with three voting, data-bearing members distributed across separate hosts or failure zones.

The discussion covers:

- Database replication and availability.
- Primary and secondary members.
- Failover and replica-set elections.
- Majority write acknowledgement and consistency.
- Sharding and cloud database deployment.
- Security, backup and recovery considerations.

**Implementation note:** The proposed replica set and sharding design were not deployed or tested. The practical PostgreSQL and MongoDB work was carried out within the existing GitHub Codespace.

---

## Final Portfolio Summary

The final document brings together the five portfolio activities, their main results, supporting evidence, individual reflection and references.

[View or download the MIT 8103 Final Portfolio Summary (PDF)](Dadung_Rwang_301921911_FinalSummary.pdf)

## Repository Structure

```text
Dadung_Rwang_301921911/
│
├── portfolio-1-database-design/
│   ├── screenshots/
│   ├── SQL scripts
│   ├── database design documentation
│   └── ER diagram
│
├── portfolio-2-query-optimisation/
│   ├── screenshots/
│   ├── SQL queries
│   ├── optimisation scripts
│   └── performance analysis
│
├── portfolio-3-transactions-concurrency/
│   ├── screenshot/
│   ├── transaction SQL scripts
│   └── concurrency exercises
│
├── portfolio-4-nosql/
│   ├── screenshots/
│   ├── MongoDB JavaScript script
│   ├── MongoDB setup notes
│   └── MongoDB documentation
│
├── portfolio-5-distributed-cloud/
│   ├── screenshots/
│   └── distributed database discussion
│
├── Dadung_Rwang_301921911_FinalSummary.pdf
└── Dadung_Rwang_301921911_README.md
```

*The structure above summarises the main project folders and files.*

## Technologies Used

| Technology | Purpose |
|---|---|
| PostgreSQL 16 | Relational database design, queries and transaction management |
| MongoDB 8.0.38 | NoSQL document modelling and event storage |
| MongoDB Shell (mongosh) | MongoDB database interaction and queries |
| SQL | Relational database operations |
| JavaScript | MongoDB shell scripts |
| Git and GitHub | Version control, repository management and documentation |
| GitHub Codespaces | Cloud-based development environment |

## Conclusion

This project provided practical experience in relational and NoSQL database technologies, query optimisation, transaction management and distributed database concepts.

It also strengthened my understanding of how database design decisions affect data integrity, performance, availability and consistency in an e-commerce environment.

The repository documents the development process and provides access to the scripts, results and supporting evidence for each portfolio activity.

---

**Student:** Dadung Rwang Pam  
**Student ID:** 301921911  
**Course:** MIT 8103 – Advanced Database Systems