# Missing Indexes

## Problem

`SELECT * FROM users WHERE email = ?` without an index causes a **sequential scan** over the whole table (100k+ rows).

## Solution

```sql
CREATE INDEX idx_users_email ON users(email);
```

After adding the index, the same query uses an **Index Scan** and is orders of magnitude faster.

## How to benchmark before/after

1. Drop the index (in Rails console or SQL):  
   `ActiveRecord::Base.connection.execute("DROP INDEX IF EXISTS idx_users_email;")`
2. Run: `./scripts/run_benchmarks.sh missing_indexes`
3. Re-add the index:  
   `ActiveRecord::Base.connection.execute("CREATE INDEX idx_users_email ON users(email);")`
4. Run the benchmark again and compare iterations/sec.

## Inspect query plan

```bash
./scripts/explain_query.sh "SELECT * FROM users WHERE email = 'user1@example.com'"
```

With index you should see `Index Scan using idx_users_email`.
