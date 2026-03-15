# Advanced Topics

Optional examples you can run from the lab:

- **Partial indexes**: `queries/index_examples.sql` – `WHERE active = true`
- **Covering indexes**: `CREATE INDEX ... INCLUDE (name)` – avoid heap fetch
- **JSONB indexing**: GIN on `users.metadata` – see schema and `index_examples.sql`
- **GIN vs BTREE**: GIN for containment/JSONB; BTREE for equality/range
- **Query caching**: `ActiveRecord::Base.connection.query_cache` or Rails fragment caching
- **Connection pool**: `config/database.yml` – `pool: 20`, `checkout_timeout`, `reaping_frequency`
- **Batch processing**: `find_each` / `find_in_batches` – see `find_each_vs_each`
- **find_each vs each**: `find_each` uses batches and avoids loading all rows
- **ActiveRecord vs raw SQL**: Raw SQL for complex queries; AR for simple CRUD

Run benchmarks for base examples; inspect `queries/*.sql` and schema for advanced patterns.
