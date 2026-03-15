# Rails Performance Lab

A **hands-on Rails performance playground** to reproduce slow queries and apply fixes. Run benchmarks and use PostgreSQL analysis tools to see the impact of each optimization.

## Stack

- **Ruby** 3.3  
- **Rails** 7.x  
- **PostgreSQL** (with `pg_stat_statements`)  
- **Docker** + **docker-compose**  
- **benchmark-ips** for Ruby benchmarks  
- **ActiveRecord** + raw SQL examples  

---

## Quick Start

### With Docker

```bash
cd rails-performance-lab
docker-compose -f docker/docker-compose.yml up -d db
# Wait for DB to be healthy, then:
export DB_HOST=127.0.0.1 DB_USERNAME=postgres DB_PASSWORD=postgres
bundle install
bin/rails db:create db:migrate
./scripts/load_dataset.sh   # 100k users, 1M posts, 3M comments, 500k orders (takes a while)
./scripts/run_benchmarks.sh n_plus_one
```

### Without Docker (local PostgreSQL)

1. Create a database and set `DB_*` if needed.  
2. `bundle install`  
3. `bin/rails db:create db:migrate`  
4. Load data: `./scripts/load_dataset.sh` (or `bin/rails db:seed` for full dataset)  
5. Run benchmarks: `./scripts/run_benchmarks.sh [example_name]`  

---

## Project Structure

```
rails-performance-lab/
├── examples/                    # Performance problems and fixes
│   ├── n_plus_one/              # N+1 → includes, preload, eager_load, counter_cache
│   ├── missing_indexes/         # Sequential scan → index
│   ├── slow_queries/            # Heavy aggregation → group/counter_cache
│   ├── bad_joins/               # Large joins → select columns, EXISTS
│   ├── pagination_problems/    # OFFSET → keyset (cursor) pagination
│   ├── counter_cache/          # N+1 count → counter cache column
│   ├── select_vs_select_all/   # SELECT * → select(:id, :email) / pluck
│   ├── pluck_vs_map/           # .map(&:attr) → .pluck(:attr)
│   ├── cte_optimization/       # Repeated subqueries → WITH ... AS
│   ├── materialized_views/     # Heavy aggregation → materialized view
│   └── advanced/               # find_each, raw SQL, partial/covering indexes
├── benchmarks/
│   ├── query_benchmarks.rb      # Run all example benchmarks
│   └── before_after/
├── queries/
│   ├── explain_examples.sql     # EXPLAIN / EXPLAIN ANALYZE / BUFFERS
│   ├── index_examples.sql       # B-tree, partial, GIN, covering
│   ├── cte_examples.sql        # WITH ... AS examples
│   └── materialized_view_examples.sql
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml      # postgres + app, pg_stat_statements, tuning
├── db/
│   ├── schema.rb
│   └── seeds.rb                 # Batch inserts (Faker + activerecord-import)
└── scripts/
    ├── run_benchmarks.sh        # Run one or all benchmarks
    ├── load_dataset.sh         # db:create, migrate, seed
    ├── explain_query.sh         # EXPLAIN ANALYZE for a query
    └── generate_test_data.rb   # Smaller dataset for quick runs
```

Each folder under `examples/` has:

- **bad_example.rb** – slow pattern  
- **good_example.rb** – optimized pattern  
- **benchmark.rb** – benchmark-ips comparison  
- **README.md** – short explanation  

---

## How to Run Benchmarks

- **All examples:**  
  `./scripts/run_benchmarks.sh`  

- **One example:**  
  `./scripts/run_benchmarks.sh n_plus_one`  
  `./scripts/run_benchmarks.sh pluck_vs_map`  
  etc.  

- **From project root (with Rails loaded):**  
  `ruby -r ./config/environment examples/n_plus_one/benchmark.rb`  

Example output:

```
N+1 (bad):
  3.1 i/s

includes (good):
  1200 i/s
```

---

## How to Analyze Queries

### EXPLAIN / EXPLAIN ANALYZE

- **Script:**  
  `./scripts/explain_query.sh "SELECT * FROM users WHERE email = 'user1@example.com'"`  

- **SQL file:**  
  See `queries/explain_examples.sql` for:
  - `EXPLAIN` (estimated plan)  
  - `EXPLAIN ANALYZE` (actual time, rows)  
  - `EXPLAIN (ANALYZE, BUFFERS)` (cache vs disk)  

### Reading the plan

| Plan node           | Meaning |
|---------------------|--------|
| **Seq Scan**        | Full table scan – consider an index. |
| **Index Scan**      | Uses index – good for lookups. |
| **Index Only Scan** | Index contains needed columns – best. |
| **Nested Loop**     | Join by looping – watch row counts. |
| **Hash Join**       | Join via in-memory hash – good for larger sets. |
| **actual time**     | Real execution time (ms). |
| **Buffers: shared hit** | Pages from cache; **read** = from disk. |

### Inspect indexes

```bash
bin/rails runner "puts ActiveRecord::Base.connection.indexes(:users).map(&:name)"
```

Or in `psql`: `\di` and `\d users`.  

Index definitions and examples: `queries/index_examples.sql` (B-tree, partial, GIN, covering).

---

## Dataset (Seeds)

Seeds use **batch inserts** (e.g. `activerecord-import`) for speed.

| Table    | Target count |
|----------|----------------|
| Users    | 100,000        |
| Posts    | 1,000,000      |
| Comments | 3,000,000      |
| Orders   | 500,000        |
| Payments / Invoices | Subset of orders |

Smaller dataset for quick tests: `ruby -r ./config/environment scripts/generate_test_data.rb`.

---

## Docker Environment

- **PostgreSQL** with:
  - `shared_preload_libraries=pg_stat_statements`
  - `pg_stat_statements.track=all`
  - `shared_buffers=256MB`, `work_mem=16MB`, `maintenance_work_mem=128MB`  

- **App** service (optional) for running the lab inside the container.

Commands:

```bash
docker-compose -f docker/docker-compose.yml up -d
docker-compose -f docker/docker-compose.yml exec app bin/rails db:create db:migrate db:seed
```

---

## Performance Comparisons (What to Expect)

| Topic            | Bad (typical)     | Good (typical)   |
|-----------------|-------------------|------------------|
| N+1             | Few ips, 1000+ Q  | 100s–1000s ips, 2 Q |
| Missing index   | Seq scan, slow    | Index scan, 10–100x faster |
| OFFSET pagination | Slower as page ↑ | Keyset: constant time |
| pluck vs map    | Load AR, high memory | One query, array, low memory |
| SELECT *        | More I/O, more memory | select/pluck: less of both |

Exact numbers depend on hardware and data size; the lab is for **relative** before/after comparison.

---

## Code Quality

- **RuboCop:** `bundle exec rubocop`  

Config: `.rubocop.yml`. Code is commented for teaching.

---

## Optional: pg_stat_statements

To inspect the top queries by total time (with extension enabled):

```sql
SELECT query, calls, total_exec_time::numeric(10,2)
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 20;
```

---

## License

MIT. Use and adapt for learning and training.
