
# Portfolio 5 Distributed and Cloud Database Exercise

**Student:** Dadung Rwang Pam
**Student ID:** 301921911
**Course:** MIT 8103 – Advanced Database Systems
**Case Study:** E-commerce Platform Database

## Current setup

This portfolio uses the discussion option to examine a proposed distributed database design for the e-commerce platform. The practical work uses PostgreSQL 16 and MongoDB 8.0.38 locally within the same Ubuntu Codespace. MongoDB contains the `ecommerce_nosql` database and `payment_events` collection, with four sample event documents. No separate database servers, MongoDB replica set, sharding or failover test have been configured. Running the databases in Codespaces does not mean that multiple database copies exist across separate servers.

## Proposed replication

A proposed MongoDB replica set would use three voting, data-bearing members on separate hosts and failure zones. The primary accepts writes, while the secondary members maintain copies of the event records through asynchronous replication.

| Member | Starting role | Location |
|---|---|---|
| A | Primary | Host 1 – Zone A |
| B | Secondary | Host 2 – Zone B |
| C | Secondary | Host 3 – Zone C |

For example, when payment event `PE001` is recorded for Ada James, the primary receives the write and the secondary members copy the change. Secondary copies may briefly lag behind the primary.

Reference: [MongoDB Replication](https://www.mongodb.com/docs/manual/replication/).

## Failure and consistency

If the primary server fails, the remaining eligible members can hold an election to select a new primary. Writes may pause during the election. A majority of voting members must be reachable for a new primary to be elected. If only one of the three members remains available, the replica set cannot elect a primary or accept normal writes.

For important payment events, the proposed design uses majority write acknowledgement, requiring a majority of data-bearing voting members to acknowledge the write. This improves write durability but can increase waiting time when members are unavailable. Secondary reads may also return older data because replication is asynchronous. Recent payment checks should therefore use the primary. PostgreSQL remains responsible for authoritative order and payment relationships and transaction controls. MongoDB replication does not synchronise the two databases.

References: [Replica Set Elections](https://www.mongodb.com/docs/v8.0/core/replica-set-elections/) and [Write Concern](https://www.mongodb.com/docs/v8.0/reference/write-concern/).

## Sharding and cloud deployment

Replication creates copies of the same data, while sharding divides data across multiple servers. The four sample payment events do not justify sharding. If the platform grows substantially and one server cannot handle its storage or workload, sharding could be considered after reviewing query patterns and selecting a suitable shard key.

A future cloud deployment could use a managed MongoDB service such as MongoDB Atlas. It should include database authentication, encrypted connections, restricted network access, scheduled backups and tested restoration procedures. Cloud hosting, backup features and replication options would need to be evaluated against operational requirements and cost.

Replication does not replace backups, and MongoDB replication alone does not protect the PostgreSQL database. The two databases would also require a separate integration or synchronisation process if shared updates were needed.

References: [MongoDB Sharding](https://www.mongodb.com/docs/manual/sharding/) and [Atlas Backup and Restore](https://www.mongodb.com/docs/atlas/backup-restore-cluster/).
